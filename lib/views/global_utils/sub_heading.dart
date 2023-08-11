import 'package:flutter/material.dart';

class SubHeading extends StatelessWidget {
  SubHeading({
    super.key,
    required this.subHeadingText,
    this.spanText = '',
    required this.textAlign,
  });

  final String subHeadingText;
  final TextAlign textAlign;
  String spanText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .8,
      child: Text.rich(
        textAlign: textAlign,
        TextSpan(
          children: [
            TextSpan(
              text: '$subHeadingText ',
              style: const TextStyle(color: Color(0xff848584), fontSize: 16),
            ),
            TextSpan(
              text: spanText,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
