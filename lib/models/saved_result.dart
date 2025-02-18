class SavedResult {
  final String strategyName;
  final String tradingPair;
  final String timeframe;
  final String startDate;
  final String endDate;
  final int totalProfit;
  final int longestWinStreak;
  final int winStreakProfit;
  final int longestLoseStreak;
  final int loseStreakLoss;
  final int risk0; // New field for risk level 0
  final int risk1; // New field for risk level 1
  final int risk2; // New field for risk level 2
  final int risk3; // New field for risk level 3
  final String sequenceNumber; // New field for sequence number
  final String riskSummary; // New field for risk summary

  SavedResult({
    required this.strategyName,
    required this.tradingPair,
    required this.timeframe,
    required this.startDate,
    required this.endDate,
    required this.totalProfit,
    required this.longestWinStreak,
    required this.winStreakProfit,
    required this.longestLoseStreak,
    required this.loseStreakLoss,
    required this.risk0,
    required this.risk1,
    required this.risk2,
    required this.risk3,
    required this.sequenceNumber,
    required this.riskSummary,
  });

  Map<String, dynamic> toMap() {
    return {
      'strategyName': strategyName,
      'tradingPair': tradingPair,
      'timeframe': timeframe,
      'startDate': startDate,
      'endDate': endDate,
      'totalProfit': totalProfit,
      'longestWinStreak': longestWinStreak,
      'winStreakProfit': winStreakProfit,
      'longestLoseStreak': longestLoseStreak,
      'loseStreakLoss': loseStreakLoss,
      'risk0': risk0,
      'risk1': risk1,
      'risk2': risk2,
      'risk3': risk3,
      'sequenceNumber': sequenceNumber,
      'riskSummary': riskSummary,
    };
  }

  factory SavedResult.fromMap(Map<String, dynamic> map) {
    return SavedResult(
      strategyName: map['strategyName'],
      tradingPair: map['tradingPair'],
      timeframe: map['timeframe'],
      startDate: map['startDate'],
      endDate: map['endDate'],
      totalProfit: map['totalProfit'],
      longestWinStreak: map['longestWinStreak'],
      winStreakProfit: map['winStreakProfit'],
      longestLoseStreak: map['longestLoseStreak'],
      loseStreakLoss: map['loseStreakLoss'],
      risk0: map['risk0'],
      risk1: map['risk1'],
      risk2: map['risk2'],
      risk3: map['risk3'],
      sequenceNumber: map['sequenceNumber'],
      riskSummary: map['riskSummary'],
    );
  }
}
