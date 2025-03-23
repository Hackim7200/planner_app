import 'package:flutter/material.dart';
import 'package:planner_app/task_model.dart';

class Today extends StatefulWidget {
  const Today({super.key});

  @override
  State<Today> createState() => _TodayState();
}

class _TodayState extends State<Today> {
  List<List<Task>> timePeriod = [
    [
      Task("Work on the event tracker app", "2hrs", false),
      Task("Write project documentation", "1.5hrs", true),
    ],
    [
      Task("Design new UI layout", "3hrs", false),
      Task("Fix backend API bugs", "2hrs", true),
    ],
    [
      Task("Test mobile app features", "1hr", false),
      Task("Prepare for client meeting", "1hr", true),
    ],
    [
      Task("Update dependencies in the project", "45min", false),
      Task("Refactor authentication module", "2hrs", true),
    ],
    [
      Task("Research new UI frameworks", "1.5hrs", false),
      Task("Write unit tests for services", "2hrs", true),
    ],
  ];
  List<String> timeLabels = ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"];
  bool? value = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Iterate over time labels and their corresponding tasks
          for (int i = 0; i < timePeriod.length; i++) ...[
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.zero,
                  color: const Color.fromARGB(99, 148, 148, 148)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(timeLabels[i],
                          style: Theme.of(context).textTheme.headlineSmall),
                      Text("4:30AM",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall) // Placeholder for actual time if needed
                    ],
                  ),
                  Divider(),
                  // ReorderableListView for each time period to allow reordering of tasks
                  ReorderableListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true, // Prevent infinite height
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) {
                          newIndex -= 1;
                        }
                        final Task item = timePeriod[i].removeAt(oldIndex);
                        timePeriod[i].insert(newIndex, item);
                      });
                    },
                    children: [
                      for (int j = 0; j < timePeriod[i].length; j++)
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,

                          key: ValueKey(timePeriod[i][j]
                              .title), // Unique key for each list item
                          leading: Checkbox(
                            value: value,
                            onChanged: (bool? newValue) {
                              setState(() {
                                value = newValue;
                              });
                            },
                          ),
                          title: Text(timePeriod[i][j].title),
                          trailing: Text(timePeriod[i][j].duration),
                        ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ],
      ),
    );
  }
}
