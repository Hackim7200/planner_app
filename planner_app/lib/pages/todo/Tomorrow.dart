import 'package:flutter/material.dart';

import 'package:planner_app/pages/components/list_of_todo.dart';

class Tomorrow extends StatefulWidget {
  const Tomorrow({super.key});

  @override
  State<Tomorrow> createState() => _TomorrowState();
}

class _TomorrowState extends State<Tomorrow> {
  List<String> timeLabels = ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListOfTodo(
            sectionOfDay: "Fajr",
            isActive: false,
            timeLabel: '10:30 PM',
            isToday: false,
          ),
          ListOfTodo(
            sectionOfDay: "Duhr",
            isActive: false,
            timeLabel: '10:30 PM',
            isToday: false,
          ),
          ListOfTodo(
            sectionOfDay: "Asr",
            isActive: false,
            timeLabel: '10:30 PM',
            isToday: false,
          ),
          ListOfTodo(
            sectionOfDay: "Maghrib",
            isActive: false,
            timeLabel: '10:30 PM',
            isToday: false,
          ),
          ListOfTodo(
            sectionOfDay: "Isha",
            isActive: false,
            timeLabel: '10:30 PM',
            isToday: false,
          ),
        ],
      ),
    );
  }
}
