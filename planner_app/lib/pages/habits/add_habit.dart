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

  final TextEditingController habitTitleController = TextEditingController();

  String? _selectedHabitType; // Holds selected habit type

  @override
  void dispose() {
    addictionTitleController.dispose();

    habitTitleController.dispose();
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

      final String habitTitle = habitTitleController.text.trim();

      await _databaseService.addHabit(
          priority, partOfDay, addictionTitle, habitTitle, _selectedHabitType!);

      widget.onAddHabit();
      if (mounted) {
        Navigator.of(context).pop();
        addictionTitleController.clear();
        habitTitleController.clear();

        setState(() {
          _sliderPriority = 1;
          _selectedHabitType = null;
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
        final List<String> habitType = [
          "Psychological",
          "Behavioral",
          "Reflex",
          "Emotional",
          "Cognitive",
          "Social",
          "Physical",
          "Addictive",
          "Spiritual",
        ];

        List<bool> selectedPartsList = List.filled(parts.length, false);

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Center(
                child: Text(
                  'Exchange Habit',
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
                              //choice chip is better than toggle button when it comes to compact space
                              Wrap(
                                spacing: 8.0,
                                children: List.generate(parts.length, (index) {
                                  return ChoiceChip(
                                    label: Text(parts[index]),
                                    selected: selectedPartsList[index],
                                    onSelected: (bool selected) {
                                      setStateDialog(() {
                                        selectedPartsList[index] = selected;
                                      });
                                    },
                                  );
                                }),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // Habit Type Dropdown
                          DropdownButtonFormField<String>(
                            value: _selectedHabitType,
                            decoration: const InputDecoration(
                              labelText: 'Habit Type',
                            ),
                            items: habitType.map((String type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setStateDialog(() {
                                _selectedHabitType = newValue;
                              });
                            },
                            validator: (value) => value == null
                                ? 'Please select a habit type'
                                : null,
                          ),
                          const SizedBox(height: 10),

                          // Addiction Title input field
                          TextFormField(
                            controller: addictionTitleController,
                            decoration: const InputDecoration(
                              labelText: 'Old Habit',
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter habit title';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),

                          // Habit Title input field
                          TextFormField(
                            controller: habitTitleController,
                            decoration: const InputDecoration(
                              labelText: 'New Habit',
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter habit title';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),

                          // Habit Effects input field (Optional)
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
                      setState(() {
                        _sliderPriority = localSliderPriority;
                      });
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
