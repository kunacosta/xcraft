import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final List<Map<String, dynamic>> _tasks = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTasks(); // Load tasks from SharedPreferences
  }

  Future<void> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? taskList = prefs.getStringList('tasks');
    if (taskList != null) {
      setState(() {
        _tasks.addAll(taskList.map((task) => jsonDecode(task) as Map<String, dynamic>).toList());
      });
    }
  }

  Future<void> saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskList = _tasks.map((task) => jsonEncode(task)).toList();
    await prefs.setStringList('tasks', taskList);
  }

  void _addTask() async {
    if (_controller.text.isNotEmpty) {
      String? priority = await _showPriorityDialog();
      if (priority != null) {
        setState(() {
          _tasks.add({'title': _controller.text, 'completed': false, 'priority': priority});
          _controller.clear();
          saveTasks(); // Save tasks after adding a new one
        });
      }
    }
  }

  Future<String?> _showPriorityDialog() {
    String? selectedPriority;
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Priority'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Low'),
                onTap: () {
                  selectedPriority = 'low';
                  Navigator.of(context).pop(selectedPriority);
                },
              ),
              ListTile(
                title: const Text('Medium'),
                onTap: () {
                  selectedPriority = 'medium';
                  Navigator.of(context).pop(selectedPriority);
                },
              ),
              ListTile(
                title: const Text('High'),
                onTap: () {
                  selectedPriority = 'high';
                  Navigator.of(context).pop(selectedPriority);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _removeTask(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _tasks.removeAt(index);
                  saveTasks(); // Save tasks after removing one
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index]['completed'] = !_tasks[index]['completed'];
      saveTasks(); // Save tasks after toggling completion state
    });
  }

  @override
  Widget build(BuildContext context) {
    // Group tasks by priority
    Map<String, List<Map<String, dynamic>>> groupedTasks = {
      'low': [],
      'medium': [],
      'high': [],
    };

    for (var task in _tasks) {
      groupedTasks[task['priority']]?.add(task);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter a new task',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addTask,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ...groupedTasks.entries.map((entry) {
                  String priority = entry.key;
                  List<Map<String, dynamic>> tasks = entry.value;

                  // Only display the title if there are tasks in that category
                  if (tasks.isNotEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          child: Text(
                            priority[0].toUpperCase() + priority.substring(1) + ' Priority',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 166, 167, 169)),
                          ),
                        ),
                        ...tasks.map((task) {
                          return Card(
                            color: _getCardColor(task['priority']),
                            child: ListTile(
                              title: Text(
                                task['title'],
                                style: TextStyle(
                                  color: _getTextColor(task['priority']),
                                  decoration: task['completed']
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              trailing: Checkbox(
                                value: task['completed'],
                                onChanged: (bool? value) {
                                  _toggleTaskCompletion(_tasks.indexOf(task));
                                },
                              ),
                              onLongPress: () => _removeTask(_tasks.indexOf(task)),
                            ),
                          );
                        }).toList(),
                      ],
                    );
                  } else {
                    return Container(); // Return an empty container if no tasks
                  }
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getCardColor(String priority) {
    switch (priority) {
      case 'low':
        return Colors.white;
      case 'medium':
        return Colors.grey;
      case 'high':
        return Colors.black;
      default:
        return Colors.white;
    }
  }

  Color _getTextColor(String priority) {
    return priority == 'high' ? Colors.white : Colors.black;
  }
}
