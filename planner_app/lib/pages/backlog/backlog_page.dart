import 'package:flutter/material.dart';
import 'package:planner_app/pages/backlog/add_backlog.dart';
import 'package:planner_app/pages/backlog/backlog_items.dart';
import 'package:planner_app/pages/todo/add_todo.dart';

class BacklogPage extends StatefulWidget {
  const BacklogPage({super.key});

  @override
  State<BacklogPage> createState() => _BacklogPageState();
}

class _BacklogPageState extends State<BacklogPage> {
  @override
  Widget build(BuildContext context) {
    const headerStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
    const itemStyle = TextStyle(fontSize: 14);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Backlog'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Add functionality for adding tasks
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BacklogItems(
              timeline: 'week',
            ),
            BacklogItems(
              timeline: 'month',
            ),
            BacklogItems(
              timeline: 'year',
            ),
            BacklogItems(
              timeline: 'decade',
            )
          ],
        ),
      ),
    );
  }
}
