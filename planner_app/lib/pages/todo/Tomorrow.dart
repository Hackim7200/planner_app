import 'package:flutter/material.dart';
import 'package:planner_app/pages/components/list_of_todo.dart';

class Tomorrow extends StatelessWidget {
  final Map<String, String> prayerTimes;

  const Tomorrow(
      {super.key,
      required this.prayerTimes}); // Accept prayerTimes as a parameter

  // Helper function to convert prayer time strings to DateTime
  DateTime _parsePrayerTime(String time) {
    final tomorrow = DateTime.now()
        .add(Duration(days: 1)); // Add 1 day to get tomorrow's date
    final timeParts = time.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    return DateTime(tomorrow.year, tomorrow.month, tomorrow.day, hour, minute);
  }

  @override
  Widget build(BuildContext context) {
    // Define the prayer time labels
    List<String> timeLabels = ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"];

    // Get the current time for tomorrow
    DateTime now = DateTime.now()
        .add(Duration(days: 1)); // Current time on the next day (tomorrow)

    // Create a list to store the todos
    List<Widget> listOfTodos = [];

    // Manually calculate the differences between consecutive prayer times for tomorrow
    String fajrTime = prayerTimes["Fajr"] ?? '00:00';
    String dhuhrTime = prayerTimes["Dhuhr"] ?? '00:00';
    String asrTime = prayerTimes["Asr"] ?? '00:00';
    String maghribTime = prayerTimes["Maghrib"] ?? '00:00';
    String ishaTime = prayerTimes["Isha"] ?? '00:00';

    // Determine which prayer should be active based on tomorrow's time
    bool isFajrActive = _isCurrentTimeBetween(fajrTime, dhuhrTime, now);
    bool isDhuhrActive = _isCurrentTimeBetween(dhuhrTime, asrTime, now);
    bool isAsrActive = _isCurrentTimeBetween(asrTime, maghribTime, now);
    bool isMaghribActive = _isCurrentTimeBetween(maghribTime, ishaTime, now);
    bool isIshaActive = _isCurrentTimeBetween(ishaTime, fajrTime, now);

    // Add each prayer to the list of todos with the updated isActive status
    listOfTodos.add(ListOfTodo(
      sectionOfDay: "Fajr",
      isActive: isFajrActive,
      timeLabel: fajrTime,
      isToday: false, // This is for Tomorrow, so isToday is false
      hoursInSection: _calculateTimeDifference(fajrTime, dhuhrTime).inMinutes,
    ));
    listOfTodos.add(ListOfTodo(
      sectionOfDay: "Dhuhr",
      isActive: isDhuhrActive,
      timeLabel: dhuhrTime,
      isToday: false, // This is for Tomorrow, so isToday is false
      hoursInSection: _calculateTimeDifference(dhuhrTime, asrTime).inMinutes,
    ));
    listOfTodos.add(ListOfTodo(
      sectionOfDay: "Asr",
      isActive: isAsrActive,
      timeLabel: asrTime,
      isToday: false, // This is for Tomorrow, so isToday is false
      hoursInSection: _calculateTimeDifference(asrTime, maghribTime).inMinutes,
    ));
    listOfTodos.add(ListOfTodo(
      sectionOfDay: "Maghrib",
      isActive: isMaghribActive,
      timeLabel: maghribTime,
      isToday: false, // This is for Tomorrow, so isToday is false
      hoursInSection: _calculateTimeDifference(maghribTime, ishaTime).inMinutes,
    ));
    listOfTodos.add(ListOfTodo(
      sectionOfDay: "Isha",
      isActive: isIshaActive,
      timeLabel: ishaTime,
      isToday: false, // This is for Tomorrow, so isToday is false
      hoursInSection:
          _calculateTimeDifferenceNextDay(ishaTime, fajrTime).inMinutes,
    ));

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: listOfTodos,
      ),
    );
  }

  // Function to calculate time difference as Duration
  Duration _calculateTimeDifference(String startTime, String endTime) {
    DateTime start = _parsePrayerTime(startTime);
    DateTime end = _parsePrayerTime(endTime);

    // Handle crossing midnight, if needed
    if (end.isBefore(start)) {
      end = end.add(Duration(days: 1));
    }

    return end.difference(start);
  }

  // Function to calculate the difference between Isha and Fajr (next day)
  Duration _calculateTimeDifferenceNextDay(String ishaTime, String fajrTime) {
    DateTime isha = _parsePrayerTime(ishaTime);
    DateTime fajr = _parsePrayerTime(fajrTime);

    // Ensure that Fajr is on the next day (24-hour difference)
    if (fajr.isBefore(isha)) {
      fajr = fajr.add(Duration(days: 1)); // Add 1 day to Fajr
    }

    return fajr.difference(isha);
  }

  // Function to check if current time is between two prayer times for tomorrow
  bool _isCurrentTimeBetween(String startTime, String endTime, DateTime now) {
    DateTime start = _parsePrayerTime(startTime);
    DateTime end = _parsePrayerTime(endTime);

    // If the end time is before the start time, it means we cross midnight
    if (end.isBefore(start)) {
      end = end.add(Duration(days: 1)); // Add 1 day to end time
    }

    return now.isAfter(start) && now.isBefore(end);
  }
}
