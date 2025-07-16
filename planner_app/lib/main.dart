import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:planner_app/pages/todo/todo_page.dart';
import 'package:planner_app/providers/prayer_times_provider.dart';
import 'package:planner_app/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PrayerTimesProvider()),
      ],
      child: MaterialApp(
        title: 'Planner App',
        theme: lightTheme,
        home: const TodoPage(),
      ),
    );
  }
}
