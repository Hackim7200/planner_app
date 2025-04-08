import 'package:flutter/material.dart';
import 'package:planner_app/pages/habits/custom_card.dart';

class Habits extends StatelessWidget {
  const Habits({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'MontserratRegular'),
      home: Scaffold(
        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(10, 40, 0, 0),
              child: Text(
                "Coding step by step",
                style: TextStyle(
                    fontSize: 28,
                    color: Colors.blueGrey[800],
                    fontFamily: 'MontserratBold'),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 8, 0, 30),
              child: Text(
                "Programming is fun when it's learnt right",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.blueGrey[400],
                    fontFamily: 'MontserratRegular'),
              ),
            ),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: CustomCard(
                    level: "BASIC",
                    title: "Python",
                    duration: "7-30 Days",
                    color: Color(0xff8E97FD),
                    textColor: Color(0xffFFECCC),
                    image: Image.asset('assets/icons/python.png'),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: CustomCard(
                    level: "BASIC",
                    title: "JavaScript",
                    duration: "12-35 Days",
                    color: Color(0xffFFC97E),
                    textColor: Color(0xff3F414E),
                    image: Image.asset('assets/icons/js.png'),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: CustomCard(
                    level: "BASIC",
                    title: "CSS",
                    duration: "7-27 Days",
                    color: Color(0xffFA6E5A),
                    textColor: Color(0xffFFECCC),
                    image: Image.asset('assets/icons/css.png'),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: CustomCard(
                    level: "Crash Course",
                    title: "HTML",
                    duration: "1 Day",
                    color: Color(0xff6CB28E),
                    textColor: Color(0xffFFECCC),
                    image: Image.asset('assets/icons/html.png'),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: HorizontalCard(
                    level: "BASIC",
                    title: "CSS",
                    duration: "7-27 Days",
                    color: Color(0xff3B3A55),
                    textColor: Color(0xffFFECCC),
                    image: Image.asset('assets/icons/bottom-cloud.png'),
                  ),
                ),
              ],
            ),
            ...List.generate(
              6,
              (index) => ListTile(
                leading: Icon(Icons.map),
                title: Text('Map'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
