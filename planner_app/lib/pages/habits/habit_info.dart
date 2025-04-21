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

  // Initialize currentEffects, currentTriggers, currentActions, and currentPleasures as empty lists.
  List<String> currentEffects = [];
  List<String> currentTriggers = [];
  List<String> currentActions = [];
  List<String> currentPleasures = [];

  @override
  void initState() {
    super.initState();
    _loadCurrentData();
  }

  /// Loads the current data (effects, triggers, actions, pleasures) from the database asynchronously
  Future<void> _loadCurrentData() async {
    try {
      currentEffects =
          await _databaseService.getEffects(widget.habit.id, widget.isGood);
      currentTriggers =
          await _databaseService.getTriggers(widget.habit.id, widget.isGood);
      currentActions =
          await _databaseService.getActions(widget.habit.id, widget.isGood);
      currentPleasures = await _databaseService.getEffects(widget.habit.id,
          widget.isGood); // Using effects for pleasures (adjust accordingly)

      setState(() {});
    } catch (e) {
      print("Error loading habit data: $e");
    }
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

            // Trigger Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Effect",
                  style: textTheme.titleLarge,
                ),
                AddEffect(
                  onAddHabit: () {
                    setState(() {});
                  },
                  isGood: widget.isGood,
                  id: widget.habit.id,
                  currentList: currentTriggers,
                  listType: 'effect', // Set the correct list type
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
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: currentTriggers.length,
                  itemBuilder: (context, index) {
                    String trigger = currentTriggers[index];
                    return ListTile(
                      leading: Icon(
                        widget.isGood
                            ? FontAwesomeIcons.circleCheck
                            : FontAwesomeIcons.circleXmark,
                      ),
                      title: Text(trigger),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // Action Sec
            // Trigger Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Trigger",
                  style: textTheme.titleLarge,
                ),
                AddEffect(
                  onAddHabit: () {
                    setState(() {});
                  },
                  isGood: widget.isGood,
                  id: widget.habit.id,
                  currentList: currentTriggers,
                  listType: 'triggers', // Set the correct list type
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
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: currentTriggers.length,
                  itemBuilder: (context, index) {
                    String trigger = currentTriggers[index];
                    return ListTile(
                      leading: Icon(
                        widget.isGood
                            ? FontAwesomeIcons.circleCheck
                            : FontAwesomeIcons.circleXmark,
                      ),
                      title: Text(trigger),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // Action Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Action",
                  style: textTheme.titleLarge,
                ),
                AddEffect(
                  onAddHabit: () {
                    setState(() {});
                  },
                  isGood: widget.isGood,
                  id: widget.habit.id,
                  currentList: currentActions,
                  listType: 'actions', // Set the correct list type
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
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: currentActions.length,
                  itemBuilder: (context, index) {
                    String action = currentActions[index];
                    return ListTile(
                      leading: Icon(
                        widget.isGood
                            ? FontAwesomeIcons.circleCheck
                            : FontAwesomeIcons.circleXmark,
                      ),
                      title: Text(action),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // Pleasure Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Pleasure",
                  style: textTheme.titleLarge,
                ),
                AddEffect(
                  onAddHabit: () {
                    setState(() {});
                  },
                  isGood: widget.isGood,
                  id: widget.habit.id,
                  currentList: currentPleasures,
                  listType: 'effects', // Assuming 'effects' for pleasures
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
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: currentPleasures.length,
                  itemBuilder: (context, index) {
                    String pleasure = currentPleasures[index];
                    return ListTile(
                      leading: Icon(
                        widget.isGood
                            ? FontAwesomeIcons.circleCheck
                            : FontAwesomeIcons.circleXmark,
                      ),
                      title: Text(pleasure),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    );
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
