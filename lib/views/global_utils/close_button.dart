import 'package:flutter/material.dart';

class CloseButtonWidget extends StatelessWidget {
  const CloseButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: const CircleAvatar(
        radius: 12,
        backgroundColor: Colors.black,
        child: Icon(
          Icons.close_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}
