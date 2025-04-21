import 'package:flutter/material.dart';
import 'package:planner_app/database/database_service.dart';

class AddBacklog extends StatefulWidget {
  final String timeline;
  final VoidCallback onAddTask;

  const AddBacklog({
    super.key,
    required this.timeline,
    required this.onAddTask,
  });

  @override
  State<AddBacklog> createState() => _AddBacklogState();
}

class _AddBacklogState extends State<AddBacklog> {
  final DatabaseService _databaseService = DatabaseService.instance;
  final TextEditingController titleController = TextEditingController();

  String? type;
  List<String> typesOfTask = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    titleController.dispose();

    super.dispose();
  }

  void _submitAndResetAllVariables() async {
    await _databaseService.addBacklog(
        title: titleController.text,
        description: "",
        timeline: widget.timeline);

    if (mounted) {
      Navigator.of(context).pop();
      titleController.clear();
    }
    widget.onAddTask();
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
                        "A future idea",
                        style: Theme.of(context).textTheme.titleLarge,
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
                                const InputDecoration(labelText: ' Title'),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a title';
                              }
                              if (value.length > 100) {
                                return 'Title is too long';
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
