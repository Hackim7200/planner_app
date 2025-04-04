import 'package:flutter/material.dart';
import 'package:planner_app/database/Task.dart';
import 'package:planner_app/database/database_service.dart';
import 'package:planner_app/pages/components/custom_top_bar.dart';

class Today extends StatefulWidget {
  const Today({super.key});

  @override
  State<Today> createState() => _TodayState();
}

class _TodayState extends State<Today> {
  final DatabaseService _databaseService = DatabaseService.instance;

  List<String> timeLabels = ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTopBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: 1 == 1
                  ? Theme.of(context).colorScheme.secondary
                  : Color.fromARGB(30, 65, 100, 74),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(timeLabels[0],
                      style: Theme.of(context).textTheme.titleMedium),
                  Text("4:30 AM",
                      style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ),
            FutureBuilder(
              future: _databaseService.getTasksForTime("Fajr"),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("No tasks found"));
                } else {
                  return ReorderableListView.builder(
                    onReorder: (int oldIndex, int newIndex) async {
                      if (oldIndex < newIndex) {
                        newIndex -=
                            1; // Adjust index since the list shrinks temporarily
                      }

                      final movedTask = snapshot.data![oldIndex];

                      setState(() {
                        final updatedList = List.from(snapshot.data!);
                        updatedList.insert(
                            newIndex, updatedList.removeAt(oldIndex));
                        snapshot.data!.clear();
                        snapshot.data!.addAll(updatedList.cast<Task>());
                      });

                      await _databaseService.reorderTask(
                        movedTask.id,
                        oldIndex,
                        newIndex,
                      );
                    },
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Task task = snapshot.data![index];

                      return ListTile(
                        key: ValueKey(
                            task.id.hashCode), // Unique key for each list item
                        leading: Checkbox(
                          value: task.completed,
                          onChanged: (bool? newValue) {
                            setState(() {
                              task.completed = newValue ?? false;
                            });
                          },
                        ),
                        title: Text(task.title),
                        trailing: Text("${task.duration}h"),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
