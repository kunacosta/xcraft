import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class SavedResultsScreen extends StatelessWidget {
  const SavedResultsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Results'),
      ),
      body: ListView.builder(
        itemCount: appState.savedResults.length,
        itemBuilder: (context, index) {
          final result = appState.savedResults[index];
          return GestureDetector(
            onLongPress: () {
              _showDeleteConfirmationDialog(context, index, appState);
            },
            child: Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text(result.strategyName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Trading Pair: ${result.tradingPair}'),
                    Text('Risk per Position: ${(result.risk0 + result.risk1 + result.risk2 + result.risk3) / 4}'),
                  ],
                ),
                onTap: () {
                  _showResultDetails(context, result);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  // Confirmation dialog to delete a result
  void _showDeleteConfirmationDialog(BuildContext context, int index, AppState appState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Result'),
        content: const Text('Are you sure you want to delete this result?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              appState.deleteResult(index); // Delete the result from AppState
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Show details of the selected result in a dialog
  void _showResultDetails(BuildContext context, dynamic result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(result.strategyName),
        content: Text(
          'Trading Pair: ${result.tradingPair}\n'
          'Timeframe: ${result.timeframe}\n'
          'Start Date: ${result.startDate}\n'
          'End Date: ${result.endDate}\n\n'
          'Total Profit: ${result.totalProfit}\n'
          'Longest Win Streak: ${result.longestWinStreak}\n'
          'Win Streak Profit: ${result.winStreakProfit}\n'
          'Longest Lose Streak: ${result.longestLoseStreak}\n'
          'Lose Streak Loss: ${result.loseStreakLoss}\n'
          'Risk per Position: ${(result.risk0 + result.risk1 + result.risk2 + result.risk3) / 4}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
