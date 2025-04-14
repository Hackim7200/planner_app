import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HabitInfo extends StatelessWidget {
  final bool isGood;
  final String title;

  final List<String> effects;

  const HabitInfo({
    super.key,
    required this.isGood,
    required this.title,
    required this.effects,
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
                    // _buildSignificanceIndicator(),
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
  // Widget _buildSignificanceIndicator() {
  // Determine if the habit is considered positive.

  // Choose color based on habit type.

  //   return CircleAvatar(
  //     radius: 25,
  //     backgroundColor: backgroundColor,
  //     child: Text(
  //       significance.toString(),
  //       style: const TextStyle(
  //         fontSize: 16,
  //         color: Colors.white,
  //         fontWeight: FontWeight.bold,
  //       ),
  //     ),
  //   );
  // }

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
