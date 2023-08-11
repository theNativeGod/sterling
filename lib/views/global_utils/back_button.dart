import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sterling/view_models/notification_provider.dart';

import '../../view_models/history_view.dart';

class BackButtonWidget extends StatelessWidget {
  BackButtonWidget({
    this.purpose,
    super.key,
  });
  String? purpose = '';
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (purpose == 'history') {
          await Provider.of<HistoryView>(context, listen: false).clearData();
        }
        if (purpose == 'notifications') {
          await Provider.of<NotificationsProvider>(context, listen: false)
              .clearNotifications();
        }
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.all(12.5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xffe9eaeb),
          ),
        ),
        height: 30,
        width: 30,
        child: const Icon(
          Icons.keyboard_arrow_left,
          color: Colors.black,
        ),
      ),
    );
  }
}
