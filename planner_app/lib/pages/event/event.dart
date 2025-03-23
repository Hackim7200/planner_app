import 'package:flutter/material.dart';
import 'package:planner_app/pages/event/past.dart';
import 'package:planner_app/pages/event/future.dart';
import 'package:planner_app/pages/todo/todo.dart';

class Event extends StatefulWidget {
  const Event({
    super.key,
  });

  @override
  State<Event> createState() => _EventState();
}

class _EventState extends State<Event> {
  int _selectedIndexBottomNav = 0;

  final List<Widget> _pages = [Future(), Past()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text('Event', style: Theme.of(context).textTheme.titleMedium),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Todo()),
                );
              },
              icon: Icon(
                Icons.toc,
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
      // floatingActionButton: FloatingActionButton(onPressed: () {}),
      bottomNavigationBar: BottomNavigationBar(
          onTap: _selectedBottomNav,
          currentIndex: _selectedIndexBottomNav,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.check), label: 'Future'),
            BottomNavigationBarItem(icon: Icon(Icons.sunny), label: 'Past'),
          ]),
    );
  }

  _selectedBottomNav(int index) {
    setState(() {
      _selectedIndexBottomNav = index;
    });
  }
}
