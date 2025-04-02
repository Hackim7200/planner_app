import 'package:flutter/material.dart';
import 'package:planner_app/pages/bucket_list.dart';
import 'package:planner_app/pages/habits.dart';
import 'package:planner_app/pages/how_to.dart';

class CustomBottomDrawer extends StatelessWidget {
  const CustomBottomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Column(
                children: [
                  Text(
                    'Planner',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(),
                  Text(
                    'Plan your future',
                  ),
                ],
              )),
          ListTile(
            leading: Icon(Icons.question_mark),
            title: const Text('How to use this app'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HowTo(),
                  ));
            },
          ),
          ListTile(
            leading: Icon(Icons.star_border_outlined),
            title: const Text('My bucket list'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BucketList(),
                  ));
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            leading: Icon(Icons.speed),
            title: const Text('Habbits i want to build'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Habits(),
                  ));
              // Update the state of the app.
              // ...
            },
          ),
        ],
      ),
    );
  }
}
