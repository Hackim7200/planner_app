import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.level,
    required this.title,
    required this.duration,
    required this.color,
    required this.image,
    required this.textColor,
  });

  final String level;
  final String title;
  final String duration;
  final Color color;
  final Image image;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      padding: EdgeInsets.all(5),
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                height: 115,
                child: image,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(18, 93, 0, 0),
              child: Text(
                level,
                style: TextStyle(
                  fontSize: 14,
                  color: textColor,
                  fontFamily: 'MontserratBold',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 110, 0, 0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 28,
                  color: textColor,
                  fontFamily: 'MontserratLight',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 210, 0, 0),
              child: Text(
                duration,
                style: TextStyle(
                  fontSize: 12,
                  color: textColor,
                  fontFamily: 'MontserratSemiBold',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(95, 195, 0, 0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  "Start",
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HorizontalCard extends StatelessWidget {
  const HorizontalCard({
    super.key,
    required this.level,
    required this.title,
    required this.duration,
    required this.color,
    required this.image,
    required this.textColor,
  });

  final String level;
  final String title;
  final String duration;
  final Color color;
  final Image image;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: EdgeInsets.all(5),
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: image,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(28, 55, 0, 0),
              child: Text(
                level,
                style: TextStyle(
                  fontSize: 14,
                  color: textColor,
                  fontFamily: 'MontserratRegular',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(25, 24, 0, 0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 22,
                  color: textColor,
                  fontFamily: 'MontserratBold',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(275, 26, 0, 0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffEBEAEC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  "Start",
                  style: TextStyle(color: Color(0xffffffff)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
