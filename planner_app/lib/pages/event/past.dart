import 'package:flutter/material.dart';

class Past extends StatelessWidget {
  const Past({super.key});

  @override
  Widget build(BuildContext context) {
    final List<List<dynamic>> events = [
      ["Job Interview", "An important meeting with a potential employer.", 2],
      ["Dentist Appointment", "Routine dental checkup for healthy teeth.", 3],
      ["Flight to New York", "Traveling for work or vacation.", 4],
      [
        "Community Cleanup",
        "Join hands to keep our neighborhood clean and green.",
        5
      ],
      ["Friend's Birthday Party", "Celebrate and have fun with friends!", 6],
      ["Doctor's Visit", "Annual health check-up with the physician.", 7],
      [
        "Art Exhibition",
        "Showcasing stunning artwork from local and international artists.",
        7
      ],
      [
        "Science Fair",
        "Engaging experiments and interactive STEM projects.",
        10
      ],
      ["Music Festival", "Live performances from top artists and bands.", 12],
      ["Final Exams", "Prepare well for the upcoming semester exams.", 14],
      ["Marathon", "Participate in a 5K run for fitness and fun.", 15],
      [
        "Food Carnival",
        "Taste a variety of delicious cuisines from around the world.",
        20
      ],
      ["Book Fair", "Explore new releases and meet your favorite authors.", 25],
      ["Tech Conference", "Discover the latest innovations in technology.", 30],
      [
        "Summer Vacation",
        "Relax and explore new places during the holidays.",
        45
      ],
      [
        "Winter Festival",
        "Experience ice skating, holiday markets, and warm treats.",
        90
      ],
    ];

    return ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          return ListTile(
              leading: Icon(
                Icons.surfing_sharp,
                size: 30,
              ),
              title: Text(events[index][0]),
              subtitle: Text(
                events[index][1],
                style: TextStyle(color: Colors.blueGrey, fontSize: 11),
              ),
              trailing: Text("${events[index][2]} days ago"));
        });
  }
}
