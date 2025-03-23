import 'package:flutter/material.dart';
import 'package:planner_app/pages/event/event.dart';
import 'package:planner_app/pages/todo/today.dart';
import 'package:planner_app/pages/todo/tommorow.dart';
import 'package:planner_app/task_model.dart';

class Todo extends StatefulWidget {
  const Todo({super.key});

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  int _selectedIndexBottomNav = 0;

  final List<Widget> _pages = [Today(), Tomorrow()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text('Todo', style: Theme.of(context).textTheme.titleMedium),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Event()),
                );
              },
              icon: Icon(
                Icons.calendar_month,
                size: 30,
                color: Theme.of(context).colorScheme.surface,
              )),
          SizedBox(
            width: 10,
          ),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.add,
                size: 30,
                color: Theme.of(context).colorScheme.surface,
              ))
        ],
      ),
      body: _pages[_selectedIndexBottomNav],
      // floatingActionButton: FloatingActionButton(
      //     onPressed: () {},
      //     backgroundColor: Theme.of(context).colorScheme.secondary,
      //     child: Icon(Icons.add)),
      bottomNavigationBar: BottomNavigationBar(
          // backgroundColor: Theme.of(context).colorScheme.primary,
          onTap: _selectedBottomNav,
          currentIndex: _selectedIndexBottomNav,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.check,
                    size: 30, color: Theme.of(context).colorScheme.tertiary),
                label: 'Today'),
            BottomNavigationBarItem(
                icon: Icon(Icons.sunny,
                    size: 30, color: Theme.of(context).colorScheme.tertiary),
                label: 'Tomorrow'),
          ]),
    );
  }

  _selectedBottomNav(int index) {
    setState(() {
      _selectedIndexBottomNav = index;
    });
  }
}
