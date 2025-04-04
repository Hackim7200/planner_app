import 'package:flutter/material.dart';
import 'package:planner_app/database/database_service.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({
    super.key,
  });

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final DatabaseService _databaseService = DatabaseService.instance;
  final TextEditingController titleController = TextEditingController();

  TextEditingController durationsController = TextEditingController();

  String prayerTime = "NULL";
  List<String> prayerTimes = [
    "NULL",
    "Fajr",
    "Duhr",
    "Asr",
    "Maghrib",
    "Isha",
  ];
  String type = "NULL";
  List<String> typesOfTask = [
    "NULL",
    "Worship",
    "Exercise",
    "Work",
    "Study",
    "Chores",
  ];

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    titleController.dispose();

    durationsController.dispose();

    super.dispose();
  }

  // Function to handle form submission and resetting inputs
  void _submitAndResetAllVariables() async {
    await _databaseService.addTask(
      titleController.text,
      type,
      double.parse(durationsController.text),
      prayerTime,
    );
    print("Task added to database");
    if (mounted) {
      Navigator.of(context).pop(); // Close the dialog first
    }

    if (mounted) {
      titleController.clear();
      durationsController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (context, setState) {
                // Add this
                return AlertDialog(
                  title: Center(
                    child: const Text(
                      'ADD A NEW TASK',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  content: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: titleController,
                          decoration:
                              const InputDecoration(labelText: 'Task Title'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a task title';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: durationsController,
                          decoration:
                              const InputDecoration(labelText: 'Duration'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a task duration';
                            }
                            return null;
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DropdownButton<String>(
                              value: prayerTime,
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    // Update only dialog UI
                                    prayerTime = newValue;
                                  });
                                }
                              },
                              items: prayerTimes.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            DropdownButton<String>(
                              value: type,
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    type = newValue;
                                  });
                                }
                              },
                              items: typesOfTask.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    CircleAvatar(
                      child: IconButton(
                        icon: const Icon(Icons.save),
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _submitAndResetAllVariables();
                          }
                        },
                      ),
                    )
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
