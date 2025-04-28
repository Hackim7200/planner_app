import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:planner_app/database/database_service.dart';

class AddBacklogDesc extends StatefulWidget {
  final String description;
  final int id;
  final VoidCallback onAddTask;

  const AddBacklogDesc({
    super.key,
    required this.onAddTask,
    required this.description,
    required this.id,
  });

  @override
  State<AddBacklogDesc> createState() => _AddBacklogDescState();
}

class _AddBacklogDescState extends State<AddBacklogDesc> {
  final DatabaseService _databaseService = DatabaseService.instance;
  final TextEditingController descriptionController = TextEditingController();
  late List<String> items;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    try {
      items = jsonDecode(widget.description).cast<String>();  // Ensure correct type.
    } catch (e) {
      items = [];  // In case the description is not valid JSON.
    }

    // Optionally pre-fill the controller with the current description
    // descriptionController.text = widget.description;
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  void _submitAndResetAllVariables() async {
    if (descriptionController.text.trim().isEmpty) return;  // Don't add empty descriptions.

    // Add new item from the text field into the list
    items.add(descriptionController.text.trim());

    String serializedList = jsonEncode(items);

    // Update the description in the database
    await _databaseService.updateBacklogDesc(
      id: widget.id,
      description: serializedList, // Join the list into a string
    );

    if (mounted) {
      Navigator.of(context).pop(); // Close the dialog
      descriptionController.clear(); // Clear the text field
    }
    widget.onAddTask(); // Refresh the list of backlogs
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
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
                      "Add/Update Description", // Title of the dialog
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  content: SingleChildScrollView(  // To prevent overflow on smaller screens
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: descriptionController,
                            decoration: const InputDecoration(labelText: 'Description'),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a description';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: const Text('Save'),
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          _submitAndResetAllVariables(); // Submit the update
                        }
                      },
                    ),
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
