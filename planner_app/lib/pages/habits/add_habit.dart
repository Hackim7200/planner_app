import 'package:flutter/material.dart';
import 'package:planner_app/database/database_service.dart';

/// Optional helper: Get a color based on importance
Color getImportanceColor(int importance) {
  int clampedImportance = importance.clamp(0, 10);
  double t = clampedImportance / 10.0;
  return Color.lerp(Colors.green, Colors.red, t)!;
}

class AddHabit extends StatefulWidget {
  final VoidCallback onAddHabit;

  const AddHabit({super.key, required this.onAddHabit});

  @override
  State<AddHabit> createState() => _AddHabitState();
}

class _AddHabitState extends State<AddHabit> {
  final DatabaseService _databaseService = DatabaseService.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Parent-level state variable for priority
  int _sliderPriority = 1;

  // Controllers for the text fields.
  final TextEditingController addictionTitleController =
      TextEditingController();
  final TextEditingController addictionEffectsController =
      TextEditingController();
  final TextEditingController habitTitleController = TextEditingController();
  final TextEditingController habitEffectsController = TextEditingController();

  @override
  void dispose() {
    addictionTitleController.dispose();
    addictionEffectsController.dispose();
    habitTitleController.dispose();
    habitEffectsController.dispose();
    super.dispose();
  }

  /// Converts the compact toggle selections into a comma-separated string.
  String _getSelectedPartsString(List<bool> selections, List<String> parts) {
    List<String> selected = [];
    for (int i = 0; i < selections.length; i++) {
      if (selections[i]) {
        selected.add(parts[i].toLowerCase());
      }
    }
    return selected.join(', ');
  }

  Future<void> _submitHabit(String partOfDay) async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final int priority = _sliderPriority;
      final String addictionTitle = addictionTitleController.text.trim();
      final String addictionEffects = addictionEffectsController.text;
      final String habitTitle = habitTitleController.text.trim();
      final String habitEffects = habitEffectsController.text;

      await _databaseService.addHabit(
        priority,
        partOfDay,
        addictionTitle,
        addictionEffects,
        habitTitle,
        habitEffects,
      );

      widget.onAddHabit();
      if (mounted) {
        Navigator.of(context).pop();
        addictionTitleController.clear();
        addictionEffectsController.clear();
        habitTitleController.clear();
        habitEffectsController.clear();
        setState(() {
          _sliderPriority = 1;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding habit: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        // Local state variables for the dialog.
        int localSliderPriority = _sliderPriority;
        final List<String> parts = ["Fajr", "Duhr", "Asr", "Meghreb", "Isha"];
        List<bool> selectedPartsList = List.filled(parts.length, false);

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Center(
                child: Text(
                  'Add Habit',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setStateDialog) {
                  return SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Priority Slider Section
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Priority ($localSliderPriority)'),
                                Slider(
                                  value: localSliderPriority.toDouble(),
                                  min: 1,
                                  max: 10,
                                  divisions: 9,
                                  label: localSliderPriority.toString(),
                                  onChanged: (double value) {
                                    setStateDialog(() {
                                      localSliderPriority = value.round();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          // Compact ToggleButtons for "Part of Day"
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Select Parts of Day',
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              ToggleButtons(
                                direction: Axis.vertical,
                                isSelected: selectedPartsList,
                                onPressed: (int index) {
                                  setStateDialog(() {
                                    selectedPartsList[index] =
                                        !selectedPartsList[index];
                                  });
                                },
                                children: parts
                                    .map(
                                      (part) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0),
                                        child: Text(part),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Addiction Title input field
                          TextFormField(
                            controller: addictionTitleController,
                            decoration: const InputDecoration(
                              labelText: 'Addiction Title',
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter addiction title';
                              }
                              return null;
                            },
                          ),
                          // Addiction Effects input field

                          // Habit Title input field
                          TextFormField(
                            controller: habitTitleController,
                            decoration: const InputDecoration(
                              labelText: 'Habit Title',
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter habit title';
                              }
                              return null;
                            },
                          ),
                          // Habit Effects input field
                        ],
                      ),
                    ),
                  );
                },
              ),
              actions: [
                CircleAvatar(
                  child: IconButton(
                    icon: const Icon(Icons.save),
                    onPressed: () {
                      // Update the parent's slider priority with the dialog's value.
                      setState(() {
                        _sliderPriority = localSliderPriority;
                      });
                      // Convert the selected toggle values to a concatenated string.
                      String partOfDayString =
                          _getSelectedPartsString(selectedPartsList, parts);
                      _submitHabit(partOfDayString);
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
