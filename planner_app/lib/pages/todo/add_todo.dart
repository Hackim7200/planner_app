import 'package:flutter/material.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({super.key});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  // Function to handle form submission and resetting inputs
  void _submitAndResetAllVariables() async {
    if (mounted) {
      Navigator.of(context).pop(); // Close the dialog first
    }

    String title = titleController.text;
    String description = descriptionController.text;

    if (title.isNotEmpty) {
      // Perform the action with the task data, like saving it to a list or database
      // Example: Add to a task list, for now just print
      print('Task added: $title, Description: $description');

      // Reset the fields after submitting
      titleController.clear();
      descriptionController.clear();
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
            return AlertDialog(
              title: Center(
                child: const Text(
                  'ADD A NEW TASK',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              content: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title Input Field
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Task Title'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a task title';
                        }
                        return null;
                      },
                    ),
                    // Description Input Field
                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(labelText: 'Task Description'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a task description';
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
                )
              ],
            );
          },
        );
      },
    );
  }
}
