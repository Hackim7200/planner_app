import 'package:flutter/material.dart';
import 'package:planner_app/database/Task.dart';
import 'package:planner_app/database/database_service.dart';
import 'package:planner_app/pages/todo/add_todo.dart';

class ListOfTodo extends StatefulWidget {
  final String sectionOfDay;
  final bool isActive;
  final String timeLabel;
  final bool isToday;

  const ListOfTodo({
    super.key,
    required this.sectionOfDay,
    required this.isActive,
    required this.timeLabel,
    required this.isToday,
  });

  @override
  State<ListOfTodo> createState() => _ListOfTodoState();
}

class _ListOfTodoState extends State<ListOfTodo> {
  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService = DatabaseService.instance;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: widget.isActive
              ? Border.all(
                  color: Colors.orange,
                  width: 2,
                )
              : Border.all(color: Colors.blueGrey, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 0.0,
                left: 8.0,
                right: 0.0,
                bottom: 0.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.sectionOfDay,
                      style: Theme.of(context).textTheme.titleMedium),
                  Text(widget.timeLabel,
                      style: Theme.of(context).textTheme.titleMedium),
                  AddTodo(
                    sectionOfDay: widget.sectionOfDay,
                    onAddTask: () {
                      setState(() {});
                    },
                    isToday: widget.isToday,
                  )
                ],
              ),
            ),
            Divider(
              indent: 10,
              endIndent: 10,
            ),
            FutureBuilder(
              future: databaseService.getTasksForTime(
                  widget.sectionOfDay, widget.isToday),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text(""));
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

                      await databaseService.reorderTask(
                          movedTask.id, oldIndex, newIndex, widget.sectionOfDay
                          // Assuming the missing argument is the time label
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
                            databaseService.deleteTask(
                                task.id, widget.sectionOfDay);
                            setState(() {
                              snapshot.data!.removeAt(index);
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
            )
          ],
        ),
      ),
    );
  }
}
