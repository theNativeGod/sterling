import 'package:flutter/material.dart';

import 'global_export.dart';

class RideTypeDialog extends StatefulWidget {
  RideTypeDialog({super.key});

  @override
  State<RideTypeDialog> createState() => _RideTypeDialogState();
}

class _RideTypeDialogState extends State<RideTypeDialog> {
  String rideType = 'Official';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: MediaQuery.of(context).size.width * .9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                rideType = 'Personal';
                setState(() {});
              },
              child: RadioMenu(
                menuText: 'Personal',
                isChosen: rideType == 'Personal' ? true : false,
              ),
            ),
            const SizedBox(height: 25),
            InkWell(
              onTap: () {
                rideType = 'Official';
                setState(() {});
              },
              child: RadioMenu(
                menuText: 'Official',
                isChosen: rideType == 'Official' ? true : false,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            ThemeButton(
              buttonText: 'Next',
              onTap: () {
                Navigator.pop(context, rideType);
              },
            ),
          ],
        ),
      ),
    );
  }
}
