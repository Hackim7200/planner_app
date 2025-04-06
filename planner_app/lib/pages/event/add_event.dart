import 'package:flutter/material.dart';
import 'package:planner_app/database/database_service.dart';
import 'package:intl/intl.dart';

class AddEvent extends StatefulWidget {
  final VoidCallback onAddEvent;

  const AddEvent({super.key, required this.onAddEvent});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final DatabaseService _databaseService = DatabaseService.instance;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();

  final Map<String, String> colorOptions = {
    "Mango orange": "#FFA725",
    "milk tea": "#FFF5E4",
    "creamy pistacio": "#C1D8C3",
    "chalk green": "#6A9C89",
  };

  String? selectedColorHex;

  @override
  void initState() {
    super.initState();
    selectedColorHex = colorOptions.values.first;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _submitEvent() async {
    await _databaseService.addEvent(
      title: titleController.text,
      dueDate: selectedDate,
      description: descriptionController.text,
      color: selectedColorHex ?? "#000000", // fallback
      iconPath: "null",
    );

    widget.onAddEvent();

    if (mounted) {
      Navigator.of(context).pop();
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
              title: const Center(
                child: Text(
                  'Add Event',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              content: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration:
                            const InputDecoration(labelText: 'Event Title'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                            labelText: 'Event Description'),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Color'),
                        value: selectedColorHex,
                        items: colorOptions.entries.map((entry) {
                          return DropdownMenuItem<String>(
                            value: entry.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    color: Color(int.parse(
                                        entry.value.replaceFirst('#', '0xFF'))),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Text(entry.key),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedColorHex = value;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text("Date: "),
                          TextButton(
                            onPressed: _pickDate,
                            child: Text(
                                DateFormat("dd MMM yyyy").format(selectedDate)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                CircleAvatar(
                  child: IconButton(
                    icon: const Icon(Icons.save),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _submitEvent();
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
  }
}
