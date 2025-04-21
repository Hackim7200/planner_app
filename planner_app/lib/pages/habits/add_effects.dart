import 'package:flutter/material.dart';
import 'package:planner_app/database/database_service.dart';

class AddEffect extends StatefulWidget {
  final VoidCallback onAddHabit;
  final bool isGood;
  final int id;
  final List<String> currentList; // Can be effects, triggers, or actions
  final String listType; // Can be 'effects', 'triggers', or 'actions'

  const AddEffect({
    Key? key,
    required this.onAddHabit,
    required this.isGood,
    required this.id,
    required this.currentList,
    required this.listType,
  }) : super(key: key);

  @override
  _AddEffectState createState() => _AddEffectState();
}

class _AddEffectState extends State<AddEffect> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _itemController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService.instance;

  @override
  void dispose() {
    _itemController.dispose();
    super.dispose();
  }

  // Function to handle adding effects, triggers, or actions based on listType
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final String newItem = _itemController.text.trim();

    // Combine the existing list with the new item
    List<String> updatedList = List.from(widget.currentList);
    updatedList.add(newItem);

    try {
      // Call the appropriate function based on listType
      if (widget.listType == "effects") {
        await _databaseService.addEffect(
          id: widget.id,
          isGood: widget.isGood,
          effect: updatedList.join(", "),
        );
      } else if (widget.listType == "triggers") {
        await _databaseService.addTrigger(
          id: widget.id,
          isGood: widget.isGood,
          trigger: updatedList.join(", "),
        );
      } else if (widget.listType == "actions") {
        await _databaseService.addAction(
          id: widget.id,
          isGood: widget.isGood,
          action: updatedList.join(", "),
        );
      }

      // Trigger callback to update the UI outside this widget if needed.
      widget.onAddHabit();

      // Close the dialog and clear the text field.
      Navigator.of(context).pop();
      _itemController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding ${widget.listType}: $e')),
      );
    }
  }

  // Opens the dialog for input
  void _openDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add ${widget.listType.capitalize()}'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: _itemController,
              decoration: InputDecoration(
                labelText: 'Enter ${widget.listType}',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a ${widget.listType}';
                }
                return null;
              },
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Display an icon that when tapped, opens the dialog.
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: _openDialog,
    );
  }
}

extension StringCasingExtension on String {
  String capitalize() {
    return this.isEmpty ? this : this[0].toUpperCase() + this.substring(1);
  }
}
