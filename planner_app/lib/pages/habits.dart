import 'package:flutter/material.dart';

import 'package:planner_app/database/database_service.dart';


class Habits extends StatelessWidget {
  const Habits({super.key});

  @override
  Widget build(BuildContext context) {
    DatabaseService _databaseService = DatabaseService.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text('Habits'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _databaseService.addHabit('New Habit', "bad", 1.3, 'Fajr',
                  'your desc here', ["Monday", "Tuesday"]);

              // Add your action here
            },
          ),
           IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _databaseService.getAllHabits();

              // Add your action here
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Habits',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
