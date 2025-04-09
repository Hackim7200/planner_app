import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HabitInfo extends StatelessWidget {
  final bool isGood;
  final String title, description;
  final int significance;
  final List<String> effects;
  final List<String> occurrence; // Corrected spelling

  const HabitInfo({
    super.key,
    required this.isGood,
    required this.title,
    required this.effects,
    required this.significance,
    required this.occurrence,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "Habit Details",
                    style: textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Text(
                    description,
                    style: textTheme.bodyMedium,
                  ),
                ),
              ],
            ),

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
                          const SizedBox(height: 4.0),
                          Text(
                            occurrence.isNotEmpty
                                ? occurrence.join(', ')
                                : "No occurrences specified",
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // Impact / Destructiveness Detail Card with significance indicator.
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
                    _buildSignificanceIndicator(),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isGood
                                ? "Level of Impact"
                                : "Destructiveness of the Habit",
                            style: textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4.0),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            // Effects (Benefits or Side Effects) Section
            Text(
              isGood ? "Benefits of Habit Exchange" : "Destructiveness",
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: 8.0),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: _buildInfoList(effects),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a significance indicator widget with dynamic background color based on habit type and significance level.
  Widget _buildSignificanceIndicator() {
    // Determine if the habit is considered positive.

    // Map the significance value (1-10) to a valid shade (multiples of 100 between 100 and 900).
    // If significance is 10, use 900; otherwise use significance * 100.
    final int computedShade = significance < 10 ? significance * 100 : 900;

    // Choose color based on habit type.
    final Color backgroundColor =
        isGood ? Colors.green[computedShade]! : Colors.red[computedShade]!;

    return CircleAvatar(
      radius: 25,
      backgroundColor: backgroundColor,
      child: Text(
        significance.toString(),
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Helper method to build a list of ListTiles from a list of strings.
  List<Widget> _buildInfoList(List<String> items) {
    return items.map((item) {
      return ListTile(
        leading: Icon(isGood
            ? FontAwesomeIcons.circleCheck
            : FontAwesomeIcons.circleXmark),
        title: Text(item),
        contentPadding: EdgeInsets.zero,
        dense: true,
      );
    }).toList();
  }
}
