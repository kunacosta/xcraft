import 'package:flutter/material.dart';

class SaveResultDialog extends StatefulWidget {
  final Function(String, String, String, String, String) onSave;

  const SaveResultDialog({super.key, required this.onSave});

  @override
  State<SaveResultDialog> createState() => _SaveResultDialogState();
}

class _SaveResultDialogState extends State<SaveResultDialog> {
  final TextEditingController strategyController = TextEditingController();
  final TextEditingController tradingPairController = TextEditingController();
  final TextEditingController timeframeController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  bool _isSaveEnabled = false;

  // Function to check if all fields are filled
  void _validateInputs() {
    setState(() {
      _isSaveEnabled = strategyController.text.isNotEmpty &&
          tradingPairController.text.isNotEmpty &&
          timeframeController.text.isNotEmpty &&
          startDateController.text.isNotEmpty &&
          endDateController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();

    // Add listeners to validate inputs when fields change
    strategyController.addListener(_validateInputs);
    tradingPairController.addListener(_validateInputs);
    timeframeController.addListener(_validateInputs);
    startDateController.addListener(_validateInputs);
    endDateController.addListener(_validateInputs);
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is removed from the tree
    strategyController.dispose();
    tradingPairController.dispose();
    timeframeController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Save Result'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: strategyController,
              decoration: const InputDecoration(labelText: 'Strategy Name'),
            ),
            TextField(
              controller: tradingPairController,
              decoration: const InputDecoration(labelText: 'Trading Pair'),
            ),
            TextField(
              controller: timeframeController,
              decoration: const InputDecoration(labelText: 'Timeframe'),
            ),
            TextField(
              controller: startDateController,
              decoration: const InputDecoration(labelText: 'Start Date'),
            ),
            TextField(
              controller: endDateController,
              decoration: const InputDecoration(labelText: 'End Date'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _isSaveEnabled
              ? () {
                  widget.onSave(
                    strategyController.text,
                    tradingPairController.text,
                    timeframeController.text,
                    startDateController.text,
                    endDateController.text,
                  );
                  Navigator.pop(context);
                }
              : null, // Disable the button if inputs are invalid
          child: const Text('Save'),
        ),
      ],
    );
  }
}
