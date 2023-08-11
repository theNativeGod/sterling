import 'package:flutter/material.dart';

class RadioMenu extends StatelessWidget {
  const RadioMenu({
    required this.menuText,
    required this.isChosen,
    super.key,
  });

  final String menuText;
  final bool isChosen;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  isChosen ? Theme.of(context).primaryColor : Color(0xff3a3a3a),
            ),
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(3),
          child: Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
              color: isChosen
                  ? Theme.of(context).primaryColor
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          menuText,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
