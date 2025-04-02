import 'package:flutter/material.dart';
import 'package:planner_app/pages/custom_bottom_drawer.dart';
import 'package:planner_app/pages/event/event.dart';
import 'package:planner_app/pages/todo/add_todo.dart';
import 'package:planner_app/pages/todo/today.dart';
import 'package:planner_app/pages/todo/tommorow.dart';

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
      appBar: AppBar(
        title: Text(
          'Todo',
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        Event(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return child; // No transition
                    },
                  ),
                );
              },
              icon: Icon(
                Icons.calendar_month,
              )),
          SizedBox(
            width: 10,
          ),
          AddTodo()
        ],
      ),
      drawer: CustomBottomDrawer(),
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
                icon: Icon(
                  Icons.check,
                ),
                label: 'Today'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.sunny,
                ),
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
