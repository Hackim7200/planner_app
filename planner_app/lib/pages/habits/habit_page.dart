import 'package:flutter/material.dart';
import 'package:planner_app/database/habit.dart';
import 'package:planner_app/database/database_service.dart';
import 'package:planner_app/pages/habits/add_habit.dart';
import 'package:planner_app/pages/habits/habit_info.dart';

// Ensure your Habit model is imported if defined in another file
// For example: import 'package:planner_app/models/habit.dart';

class HabitPage extends StatefulWidget {
  const HabitPage({super.key});

  @override
  State<HabitPage> createState() => _HabitPageState();
}

class _HabitPageState extends State<HabitPage> {
  @override
  Widget build(BuildContext context) {
    final _databaseService = DatabaseService.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Exchange'),
        actions: [
          AddHabit(onAddHabit: () {
            setState(() {});
          })
        ],
      ),
      body: FutureBuilder<List>(
        // Expecting a list of Habit objects.
        future: _databaseService.getAllHabits(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While the future is loading, display a spinner.
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If an error occurs, display an error message.
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final List<Habit> habits = snapshot.data!.cast<Habit>();
            if (habits.isEmpty) {
              return const Center(child: Text('No habits available'));
            }
            // Using ListView.builder for dynamic list rendering.
            return ListView.builder(
              itemCount: habits.length,
              itemBuilder: (context, index) {
                // Assuming each element in the list is a Habit object.
                final habit = habits[index];
                return Card(
                  color: getImportanceColor(habit.priority),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HabitInfo(
                                        habit: habit,
                                        isGood: false,
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(
                                          10), // Rounded corners
                                      border: Border.all(
                                          width: 1), // Optional border
                                    ),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Text(
                                            habit.addictionTitle,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HabitInfo(
                                        isGood: true,
                                        habit: habit,
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(
                                          10), // Rounded corners
                                      border: Border.all(
                                          width: 1), // Optional border
                                    ),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Text(
                                            habit.habitTitle,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Text(habit.partOfDay)
                      ],
                    ),
                  ),
                );
              },
            );
          }
          // Fallback if snapshot has no data and no error.
          return const Center(child: Text('No data available'));
        },
      ),
    );
  }

  Color getImportanceColor(int importance) {
    // Ensure the importance value is within 0 to 10.
    int clampedImportance = importance.clamp(0, 10);

    // Calculate the interpolation factor (t) as a value between 0.0 and 1.0.
    double t = clampedImportance / 10.0;

    // Interpolate from green (not important) to red (very important).
    Color color = Color.lerp(const Color.fromARGB(255, 240, 173, 159),
        const Color.fromARGB(255, 255, 57, 43), t)!;

    return color;
  }
}
