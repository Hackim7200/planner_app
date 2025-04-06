import 'package:flutter/material.dart';
import 'package:planner_app/pages/custom_bottom_drawer.dart';
import 'package:planner_app/pages/event/add_event.dart';
import 'package:planner_app/pages/event/past_evemts.dart';
import 'package:planner_app/pages/event/future_events.dart';
import 'package:planner_app/pages/todo/todo_page.dart';

class EventPage extends StatefulWidget {
  const EventPage({
    super.key,
  });

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  int _selectedIndexBottomNav = 0;

  final List<Widget> _pages = [FutureEvents(), PastEvents()];

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
                        TodoPage(),
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
          AddEvent(onAddEvent: () {
            setState(() {});
          }),
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
