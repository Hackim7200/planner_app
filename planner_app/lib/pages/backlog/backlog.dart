import 'package:flutter/material.dart';

class Backlog extends StatelessWidget {
  const Backlog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks to be done'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Add your action here
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              'sorted by priority',
            ),
            Text(
              'Week',
            ),
            Text(
              'Month',
            ),
            Text(
              'Anual',
            ),
            Text(
              'Decade',
            ),
          ],
        ),
      ),
    );
  }
}
