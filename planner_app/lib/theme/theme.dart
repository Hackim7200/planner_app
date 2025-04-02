import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    // canvasColor:
    // Colors.red, // sets the background color of bottom navigation bar
    colorScheme: ColorScheme.light(
      surface: Colors.white, // background color

      primary: Colors.teal, // appbar color
      secondary:
          Colors.orange, // this os for the bottom navigation bar icon color
      error: Colors.red,
    ),
    ////////////////////////////////AppBar Theme////////////////////////////////

    textTheme: TextTheme(
        //headline>title>body
        ),
    drawerTheme: DrawerThemeData(
      backgroundColor: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.teal,
      foregroundColor: Colors.white, // changes icon colors
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: Colors.orange,
      showUnselectedLabels: true,
      showSelectedLabels: true,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
    ));

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Colors.grey[900]!,
    primary: Colors.grey[800]!,
    secondary: Colors.grey[700]!,
  ),
);
