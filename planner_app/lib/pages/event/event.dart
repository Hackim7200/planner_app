import 'package:flutter/material.dart';
import 'package:planner_app/pages/custom_bottom_drawer.dart';
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
      appBar: AppBar(
        title: Text('Event'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        Todo(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return child; // No transition
                    },
                  ),
                );
              },
              icon: Icon(
                Icons.toc,
              )),
          SizedBox(
            width: 10,
          ),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.add,
              ))
        ],
      ),
      drawer: CustomBottomDrawer(),

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
