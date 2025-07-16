import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:planner_app/pages/components/custom_top_bar.dart';

import 'package:planner_app/pages/todo/Tomorrow.dart';
import 'package:planner_app/pages/todo/today.dart';
import 'package:planner_app/providers/prayer_times_provider.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  int _selectedIndexBottomNav = 0;

  @override
  void initState() {
    super.initState();
    // Fetch prayer times when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PrayerTimesProvider>().fetchPrayerTimes('London', 'GB');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomTopBar(),
      body: Consumer<PrayerTimesProvider>(
        builder: (context, prayerTimesProvider, child) {
          if (prayerTimesProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (prayerTimesProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${prayerTimesProvider.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      prayerTimesProvider.clearError();
                      prayerTimesProvider.fetchPrayerTimes('London', 'GB');
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final prayerTimes = prayerTimesProvider.prayerTimes;
          if (prayerTimes == null) {
            return const Center(
              child: Text('No prayer times available'),
            );
          }

          final pages = [
            Today(prayerTimes: prayerTimes.toJson()),
            Tomorrow(prayerTimes: prayerTimes.toJson()),
          ];

          return pages[_selectedIndexBottomNav];
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectedBottomNav,
        currentIndex: _selectedIndexBottomNav,
        items: const [
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

  void _selectedBottomNav(int index) {
    setState(() {
      _selectedIndexBottomNav = index;
    });
  }
}
