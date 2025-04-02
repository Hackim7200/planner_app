import 'package:flutter/material.dart';

class BucketList extends StatelessWidget {
  const BucketList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bucket List'),
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
          'My Bucket List',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
