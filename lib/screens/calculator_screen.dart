import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/gradient_button.dart';
import '../widgets/save_result_dialog.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController riskController = TextEditingController();
  final TextEditingController sequenceController = TextEditingController();

  @override
  void dispose() {
    riskController.dispose();
    sequenceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trading Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Risk Management',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: riskController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Risk per Position (%)',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  int? risk = int.tryParse(value);
                  if (risk != null && risk >= 1 && risk <= 100) {
                    appState.setRiskPerPosition(risk);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a value between 1 and 100.'),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: sequenceController,
                decoration: const InputDecoration(
                  labelText: 'Sequence of Trades (e.g., 0123)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GradientButton(
                    text: 'Calculate',
                    onPressed: () {
                      final sequence = sequenceController.text;
                      if (RegExp(r'^[0-3]+$').hasMatch(sequence)) {
                        appState.calculateTrading(sequence);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter digits only from 0 to 3.'),
                          ),
                        );
                      }
                    },
                  ),
                  GradientButton(
                    text: 'Reset',
                    onPressed: () {
                      riskController.clear();
                      sequenceController.clear();
                      appState.result = null;
                    },
                  ),
                  GradientButton(
                    text: 'Save',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => SaveResultDialog(
                          onSave: (strategyName, tradingPair, timeframe, startDate, endDate) {
                            if (appState.result != null) {
                              appState.saveResult(
                                strategyName,
                                tradingPair,
                                timeframe,
                                startDate,
                                endDate,
                                sequenceController.text, // Pass the sequence number
                                'Risk summary here', // Placeholder for risk summary
                              );
                              Navigator.pop(context);
                            }
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),
              appState.result != null
                  ? _buildResults(appState)
                  : const Center(
                      child: Text(
                        'Enter values and press Calculate!',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResults(AppState appState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Results:',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildResultRow('Total Profit', '\$${appState.result!.totalProfit}', appState.result!.totalProfit >= 0),
        _buildResultRow('Longest Win Streak', '${appState.result!.longestWinStreak}', true),
        _buildResultRow('Win Streak Profit', '\$${appState.result!.winStreakProfit}', true),
        _buildResultRow('Longest Lose Streak', '${appState.result!.longestLoseStreak}', false),
        _buildResultRow('Lose Streak Loss', '\$${appState.result!.loseStreakLoss}', false),
        const SizedBox(height: 32),
        const Text(
          'Risk Summary:',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildRiskRow('Risk', '${appState.calculatedValues['0'] ?? 0}'),
        _buildRiskRow('Reward 1', '${appState.calculatedValues['1'] ?? 0}'),
        _buildRiskRow('Reward 2', '${appState.calculatedValues['2'] ?? 0}'),
        _buildRiskRow('Reward 3', '${appState.calculatedValues['3'] ?? 0}'),
      ],
    );
  }

  Widget _buildResultRow(String label, String value, bool isPositive) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isPositive ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
