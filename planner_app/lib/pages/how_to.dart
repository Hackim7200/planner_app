import 'package:flutter/material.dart';

class HowTo extends StatelessWidget {
  const HowTo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'How to use this app',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      appBar: AppBar(
        title: Text('How to use this app'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Add your action here
            },
          ),
        ],
      ),
    );
  }
}
