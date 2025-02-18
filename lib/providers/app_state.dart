import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/saved_result.dart';
import '../models/trade_result.dart';

class AppState extends ChangeNotifier {
  int riskPerPosition = 25;
  Map<String, int> calculatedValues = {};
  TradeResult? result;
  List<SavedResult> savedResults = [];

  AppState() {
    loadSavedResults(); // Load saved results on initialization
  }

  // Set risk per position
  void setRiskPerPosition(int risk) {
    riskPerPosition = risk;
    _calculateValues();
    notifyListeners();
  }

  // Calculate values based on risk per position
  void _calculateValues() {
    int totalLoss = -2 * riskPerPosition;
    calculatedValues = {
      '0': totalLoss,
      '1': riskPerPosition,
      '2': riskPerPosition + (2 * riskPerPosition),
      '3': riskPerPosition + (3 * riskPerPosition),
    };
  }

  // Calculate trading results based on a sequence
  void calculateTrading(String sequence) {
    if (calculatedValues.isEmpty) _calculateValues();

    int totalProfit = 0;
    int longestWinStreak = 0;
    int currentWinStreak = 0;
    int winStreakProfit = 0;
    int maxWinStreakProfit = 0;

    int longestLoseStreak = 0;
    int currentLoseStreak = 0;
    int loseStreakLoss = 0;
    int maxLoseStreakLoss = 0;

    for (var char in sequence.split('')) {
      if (!calculatedValues.containsKey(char)) continue;

      int profit = calculatedValues[char]!;
      totalProfit += profit;

      if (profit > 0) {
        currentWinStreak += 1;
        winStreakProfit += profit;
        currentLoseStreak = 0;
        loseStreakLoss = 0;

        if (currentWinStreak > longestWinStreak) {
          longestWinStreak = currentWinStreak;
          maxWinStreakProfit = winStreakProfit;
        }
      } else {
        currentLoseStreak += 1;
        loseStreakLoss += profit;
        currentWinStreak = 0;
        winStreakProfit = 0;

        if (currentLoseStreak > longestLoseStreak) {
          longestLoseStreak = currentLoseStreak;
          maxLoseStreakLoss = loseStreakLoss;
        }
      }
    }

    result = TradeResult(
      totalProfit: totalProfit,
      longestWinStreak: longestWinStreak,
      winStreakProfit: maxWinStreakProfit,
      longestLoseStreak: longestLoseStreak,
      loseStreakLoss: maxLoseStreakLoss,
    );
    notifyListeners();
  }

  // Save a result
  Future<void> saveResult(String strategyName, String tradingPair, String timeframe, String startDate, String endDate, String sequenceNumber, String riskSummary) async {
    if (result != null) {
      final savedResult = SavedResult(
        strategyName: strategyName,
        tradingPair: tradingPair,
        timeframe: timeframe,
        startDate: startDate,
        endDate: endDate,
        totalProfit: result!.totalProfit,
        longestWinStreak: result!.longestWinStreak,
        winStreakProfit: result!.winStreakProfit,
        longestLoseStreak: result!.longestLoseStreak,
        loseStreakLoss: result!.loseStreakLoss,
        risk0: riskPerPosition,
        risk1: riskPerPosition,
        risk2: riskPerPosition,
        risk3: riskPerPosition,
        sequenceNumber: sequenceNumber,
        riskSummary: riskSummary,
      );
      savedResults.add(savedResult);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> resultList = savedResults.map((e) => jsonEncode(e.toMap())).toList();
      await prefs.setStringList('savedResults', resultList);

      notifyListeners();
    }
  }

  // Delete a saved result
  Future<void> deleteResult(int index) async {
    savedResults.removeAt(index);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> resultList = savedResults.map((e) => jsonEncode(e.toMap())).toList();
    await prefs.setStringList('savedResults', resultList);

    notifyListeners();
  }

  // Load saved results from SharedPreferences
  Future<void> loadSavedResults() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? resultList = prefs.getStringList('savedResults');
    if (resultList != null) {
      savedResults = resultList.map((e) => SavedResult.fromMap(jsonDecode(e))).toList();
    }
    notifyListeners();
  }
}
