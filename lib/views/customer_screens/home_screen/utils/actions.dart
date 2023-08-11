import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:sterling/views/common_screens/notification_screen/notification_screen.dart';
import 'package:sterling/views/global_utils/global_export.dart';

class ActionsWidget extends StatelessWidget {
  ActionsWidget(
    this.cancelTimer, {
    super.key,
  });

  var cancelTimer;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => NotificationsScreen(),
              ),
            );
          },
          child: Icon(
            Icons.notifications,
            color: Theme.of(context).primaryColor,
            size: 30,
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        InkWell(
          onTap: () async {
            await FlutterPhoneDirectCaller.callNumber('9945788600');
          },
          child: Container(
              height: 30,
              width: 30,
              padding: EdgeInsets.all(2),
              child: Image.asset(
                'assets/images/phone_icon.png',
              )),
        ),
        const SizedBox(
          width: 18,
        ),
        InkWell(
          onTap: () {
            showDialog(
                context: context,
                builder: (ctx) {
                  return LogoutAlert(cancelTimer);
                });
          },
          child: Container(
            height: 30,
            width: 30,
            padding: EdgeInsets.all(3),
            child: Image.asset('assets/images/logout_icon.png'),
          ),
        ),
      ],
    );
  }
}
