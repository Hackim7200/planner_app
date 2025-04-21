import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planner_app/ApiService/api_service.dart';
import 'package:planner_app/pages/components/custom_top_bar.dart';
import 'package:planner_app/pages/side_menu.dart';
import 'package:planner_app/pages/todo/Tomorrow.dart';
import 'package:planner_app/pages/todo/today.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  int _selectedIndexBottomNav = 0;

  late Future<Map<String, String>> _prayerTimes;

  @override
  void initState() {
    super.initState();

    // Fetch the prayer times for the current date
    _prayerTimes = ApiService().getPrayerTimes('London', 'GB');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTopBar(),
      drawer: SideMenu(),
      body: FutureBuilder<Map<String, String>>(
        future: _prayerTimes,
        builder: (context, snapshot) {
          // Handle loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // Handle error state
          else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // Handle data state
          else if (snapshot.hasData) {
            final prayerTimes = snapshot.data!;
            // Pass the prayer times to both pages
            final pages = [
              Today(prayerTimes: prayerTimes),
              Tomorrow(prayerTimes: prayerTimes),
            ];

            return pages[_selectedIndexBottomNav];
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectedBottomNav,
        currentIndex: _selectedIndexBottomNav,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'Today',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sunny),
            label: 'Tomorrow',
          ),
        ],
      ),
    );
  }

  _selectedBottomNav(int index) {
    setState(() {
      _selectedIndexBottomNav = index;
    });
  }
}
