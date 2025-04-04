import 'package:flutter/material.dart';

import 'package:planner_app/pages/components/list_of_todo.dart';

class Today extends StatefulWidget {
  const Today({super.key});

  @override
  State<Today> createState() => _TodayState();
}

class _TodayState extends State<Today> {
  List<String> timeLabels = ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListOfTodo(
            sectionOfDay: "Fajr",
            isActive: true,
            timeLabel: '10:30 PM',
            isToday: true,
          ),
          ListOfTodo(
            sectionOfDay: "Duhr",
            isActive: false,
            timeLabel: '10:30 PM',
            isToday: true,
          ),
          ListOfTodo(
            sectionOfDay: "Asr",
            isActive: false,
            timeLabel: '10:30 PM',
            isToday: true,
          ),
          ListOfTodo(
            isToday: true,
            sectionOfDay: "Maghrib",
            isActive: false,
            timeLabel: '10:30 PM',
          ),
          ListOfTodo(
            sectionOfDay: "Isha",
            isActive: false,
            timeLabel: '10:30 PM',
            isToday: true,
          ),
        ],
      ),
    );
  }
}
