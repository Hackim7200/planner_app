import 'package:flutter/material.dart';
import 'package:planner_app/database/database_service.dart';

class AddEffect extends StatefulWidget {
  final VoidCallback onAddHabit;
  final bool isGood;
  final int id;
  final List<String> effects;

  const AddEffect({
    Key? key,
    required this.onAddHabit,
    required this.isGood,
    required this.id,
    required this.effects,
  }) : super(key: key);

  @override
  _AddEffectState createState() => _AddEffectState();
}

class _AddEffectState extends State<AddEffect> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _effectController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService.instance;

  @override
  void dispose() {
    _effectController.dispose();
    super.dispose();
  }

  Future<void> _submitEffect() async {
    if (!_formKey.currentState!.validate()) return;

    final String newEffect = _effectController.text.trim();

    // Combine the existing effects with the new effect.
    // You can adjust this logic as needed.
    List<String> updatedEffects = List.from(widget.effects);
    updatedEffects.add(newEffect);

    try {
      await _databaseService.updateHabitEffects(
        id: widget.id,
        isGood: widget.isGood,
        effects: updatedEffects.join(", "),
      );

      // Trigger callback to update the UI outside this widget if needed.
      widget.onAddHabit();

      // Close the dialog and clear the text field.
      Navigator.of(context).pop();
      _effectController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding effect: $e')),
      );
    }
  }

  void _openDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Effect'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: _effectController,
              decoration: const InputDecoration(
                labelText: 'Effect',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter an effect';
                }
                return null;
              },
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: _submitEffect,
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
