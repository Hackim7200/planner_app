import 'package:flutter/material.dart';
import 'package:planner_app/database/database_service.dart';

class AddTodo extends StatefulWidget {
  final String sectionOfDay;
  final VoidCallback onAddTask;
  final bool isToday;

  const AddTodo({
    super.key,
    required this.sectionOfDay,
    required this.onAddTask,
    required this.isToday,
  });

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final DatabaseService _databaseService = DatabaseService.instance;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController durationsController = TextEditingController();

  String? type;
  List<String> typesOfTask = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    switch (widget.sectionOfDay) {
      case "Fajr":
        typesOfTask = ["Deep work", "Worship", "Masjid"];
        break;
      case "Dhuhr":
        typesOfTask = ["Light work", "Eating", "Exercise"];
        break;
      case "Asr":
        typesOfTask = ["Light work", "Exercise", "Worship"];
        break;
      case "Maghrib":
        typesOfTask = [
          "Worship",
          "Socialise",
          "Exercise",
          "Family time",
          "Prepare for sleep",
        ];
        break;
      case "Isha":
        typesOfTask = [
          "Deep work",
          "Light work",
          "Worship",
          "Socialise",
          "Exercise",
          "Masjid"
        ];
        break;
    }

    if (typesOfTask.isNotEmpty) {
      type = typesOfTask.first;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    durationsController.dispose();
    super.dispose();
  }

  void _submitAndResetAllVariables() async {
    if (widget.isToday == true) {
      await _databaseService.addTask(
          titleController.text,
          type ?? "Unspecified",
          double.parse(durationsController.text),
          widget.sectionOfDay,
          true);
    } else {
      await _databaseService.addTask(
          titleController.text,
          type ?? "Unspecified",
          double.parse(durationsController.text),
          widget.sectionOfDay,
          false);
    }
    widget.onAddTask();

    if (mounted) {
      Navigator.of(context).pop();
      titleController.clear();
      durationsController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: IconButton(
        padding: const EdgeInsets.all(0),
        icon: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    title: Center(
                      child: Text(
                        widget.isToday
                            ? 'Add Task for Today'
                            : 'Add Task for Tomorrow',
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
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
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a task title';
                              }
                              if (value.length > 100) {
                                return 'Title is too long';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            controller: durationsController,
                            decoration: const InputDecoration(
                                labelText: 'Duration (in hours)'),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a task duration';
                              }
                              final duration = double.tryParse(value);
                              if (duration == null) {
                                return 'Please enter a valid number';
                              }
                              if (duration <= 0) {
                                return 'Duration must be greater than 0';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: type,
                            decoration: const InputDecoration(
                                labelText: 'Select Task Type'),
                            items: typesOfTask.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                type = newValue;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a task type';
                              }
                              return null;
                            },
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
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
