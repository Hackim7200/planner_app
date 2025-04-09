import 'package:flutter/material.dart';
import 'package:planner_app/pages/todo/todo_page.dart';
import 'package:planner_app/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme,
      home: TodoPage(),
    );
  }
}
