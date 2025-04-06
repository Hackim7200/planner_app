import 'package:flutter/material.dart';
import 'package:planner_app/pages/event/event_page.dart';
import 'package:planner_app/pages/todo/add_todo.dart';

class CustomTopBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
                    EventPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return child; // No transition
                },
              ),
            );
          },
          icon: Icon(
            Icons.calendar_month,
          ),
        ),
        SizedBox(
          width: 10,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
