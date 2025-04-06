import 'package:flutter/material.dart';
import 'package:planner_app/database/database_service.dart';
import 'package:planner_app/pages/components/custom_top_bar.dart';

import 'package:planner_app/pages/custom_bottom_drawer.dart';
import 'package:planner_app/pages/todo/Tomorrow.dart';

import 'package:planner_app/pages/todo/today.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final DatabaseService _databaseService = DatabaseService.instance;

  int _selectedIndexBottomNav = 0;

  final List<Widget> _pages = [Today(), Tomorrow()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTopBar(),
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
