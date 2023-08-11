import 'package:flutter/material.dart';

class Heading extends StatelessWidget {
  Heading({
    required this.headingText,
    this.color = Colors.black,
    super.key,
  });

  final String headingText;
  Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      headingText,
      style: TextStyle(
        color: color,
        fontSize: 30,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}
