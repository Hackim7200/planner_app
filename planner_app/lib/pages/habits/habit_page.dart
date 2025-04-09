import 'package:flutter/material.dart';
import 'package:planner_app/pages/habits/habit_info.dart';

class HabitPage extends StatelessWidget {
  const HabitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Habit'),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.add))],
      ),
      body: Center(
          child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HabitInfo(
                    isGood: true,
                    title: 'Binge Yt all evening',
                    effects: [
                      "reduced productivity",
                      "poor sleep",
                      "anxiety",
                      "loss of motivation"
                    ],
                    significance: 10,
                    occurrence: [
                      "Fajr",
                      "Duhr",
                      "Asr",
                      "Maghrib",
                      "Isha",
                    ],
                    description: 'get stronger learn new skills and techniques',
                  ),
                )),
            child: Card(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.redAccent,
                        ),
                        child: ListTile(
                          title: Text(
                            'Binge Yt all evening',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          subtitle: Text(
                            'watch social media all day',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.greenAccent,
                          ),
                          child: ListTile(
                            title: Text(
                              'Go BJJ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            subtitle: Text(
                              'Get stronger learn new skills and techniques',
                              style: TextStyle(fontSize: 13),
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
