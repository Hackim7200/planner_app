import 'package:flutter/material.dart';
import 'package:planner_app/pages/backlog/backlog.dart';
import 'package:planner_app/pages/habits/habit_page.dart';

import 'package:planner_app/pages/how_to.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

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
            leading: Icon(Icons.speed),
            title: const Text('Habbits'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HabitPage(),
                  ));
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            leading: Icon(Icons.speed),
            title: const Text('Routine'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HabitPage(),
                  ));
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            leading: Icon(Icons.speed),
            title: const Text('Backlog'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Backlog(),
                  ));
              // Update the state of the app.
              // ...
            },
          ),
          SizedBox(height: 100),
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
        ],
      ),
    );
  }
}
