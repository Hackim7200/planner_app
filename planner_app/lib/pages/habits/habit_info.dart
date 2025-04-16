import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:planner_app/database/database_service.dart';
import 'package:planner_app/database/habit.dart';
import 'package:planner_app/pages/habits/add_effects.dart';

class HabitInfo extends StatefulWidget {
  final bool isGood;
  final Habit habit;

  const HabitInfo({
    Key? key,
    required this.isGood,
    required this.habit,
  }) : super(key: key);

  @override
  _HabitInfoState createState() => _HabitInfoState();
}

class _HabitInfoState extends State<HabitInfo> {
  final DatabaseService _databaseService = DatabaseService.instance;

  // Initialize currentEffects as an empty list.
  List<String> currentEffects = [];

  @override
  void initState() {
    super.initState();
    _loadCurrentEffects();
  }

  /// Loads the current habit effects from the database asynchronously
  Future<void> _loadCurrentEffects() async {
    try {
      final effects = await _databaseService.getHabitEffects(
          widget.habit.id, widget.isGood);
      setState(() {
        currentEffects = effects;
      });
    } catch (e) {
      print("Error loading habit effects: $e");
    }
  }

  /// Updates the habit effects in the database using the values from currentEffects.
  Future<void> updateHabitEffects() async {
    setState(() {
      // For example purposes, add a fixed string to currentEffects.
      currentEffects.add("item added to list");
    });
    await _databaseService.updateHabitEffects(
      id: widget.habit.id,
      effects: currentEffects.join(", "),
      isGood: widget.isGood,
    );

    // Optionally, you could refresh the local list from the database:
    // await _loadCurrentEffects();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit.habitTitle),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            // Occurrence Detail Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(FontAwesomeIcons.clock, size: 20),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "When does it occur?",
                            style: textTheme.titleMedium,
                          ),
                          Text(widget.habit.partOfDay),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // Effects (Benefits or Side Effects) Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.isGood ? "Benefits of Habit" : "Harms of Habit",
                  style: textTheme.titleLarge,
                ),
                AddEffect(
                  onAddHabit: () {
                    setState(() {});
                  },
                  isGood: widget.isGood,
                  id: widget.habit.id,
                  effects: currentEffects,
                )
              ],
            ),
            const SizedBox(height: 8.0),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FutureBuilder<List<String>>(
                  future: _databaseService.getHabitEffects(
                      widget.habit.id, widget.isGood),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No effects available."));
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          String effect = snapshot.data![index];
                          return ListTile(
                            leading: Icon(
                              widget.isGood
                                  ? FontAwesomeIcons.circleCheck
                                  : FontAwesomeIcons.circleXmark,
                            ),
                            title: Text(effect),
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
