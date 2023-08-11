import 'package:flutter/material.dart';

class QuestionDropDown extends StatelessWidget {
  const QuestionDropDown({
    super.key,
    required this.width,
    required this.heading,
    required this.dropText,
  });

  final double width;
  final String heading;
  final String dropText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: width - 25 - 25,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xffd2d3d6),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 12.5,
          ),
          child: DropdownButton(
            items: [
              DropdownMenuItem(
                child: Text(
                  dropText,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            underline: Container(),
            isExpanded: true,
            onChanged: (_) {},
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.black,
            ),
          ),
        )
      ],
    );
  }
}
