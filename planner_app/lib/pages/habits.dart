import 'package:flutter/material.dart';

class Habits extends StatelessWidget {
  const Habits({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Habits'),
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
        child: Text(
          'Habits',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
