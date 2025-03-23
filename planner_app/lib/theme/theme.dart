import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: Color(0xFF41644A), // app bar, buttons
      secondary: Color(0xFFE9762B), // floating action button, toggle
      tertiary: Color(0xFF0D4715),
      surface: Color(0xFFF1F0E9), // background

      error: Colors.red, // validation messages
    ),
    textTheme: TextTheme(
      headlineMedium: TextStyle(
          fontSize: 24, color: Colors.black), // for title for sections
      headlineSmall: TextStyle(
          fontSize: 15, color: Color(0xFF0D4715), fontWeight: FontWeight.bold),
      titleMedium: TextStyle(
          fontSize: 20, color: const Color(0xFFF1F0E9)), // for appbar title
      bodyMedium: TextStyle(fontSize: 15, color: Colors.black), // for body text
      // labelMedium: TextStyle(fontSize: 16, color: Colors.black), //for button text
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFF1F0E9),

        disabledBackgroundColor: Color(0xFF0D4715),
        // foregroundColor: ,
        disabledForegroundColor: Color(0xFFF1F0E9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ))

    // inputDecorationTheme: InputDecorationTheme(
    //   filled: true,
    //   fillColor: Colors.grey[200],
    //   border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    // ),
    );

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Colors.grey[900]!,
    primary: Colors.grey[800]!,
    secondary: Colors.grey[700]!,
  ),
);
