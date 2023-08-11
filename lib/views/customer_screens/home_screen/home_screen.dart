import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sterling/services/services.dart';
import 'package:sterling/view_models/dashboard_view.dart';
import 'package:sterling/view_models/notification_provider.dart';

import '../../../services/firebase_api.dart';
import '../../../view_models/user_view.dart';
import 'utils/export.dart';
import '../../../models/user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.user});
  final User? user;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  var dashData;
  var status;
  var rideHistoryList;
  Services services = Services();

  bool isInit = true;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    if (isInit) {
      initNotification();
      sendDevId();
      setData();
      timeTicker(context);
      // setupPushNotifications();
    }
    isInit = false;

    super.didChangeDependencies();
  }

  initNotification() async {
    await FirebaseApi().initNotifications(context, widget.user!.userId);
  }

  // setupPushNotifications() async {
  //   print('setupPushNotifications');
  //   final fcm = FirebaseMessaging.instance;
  //   await fcm.requestPermission(
  //     sound: true,
  //   );
  //   final token = await fcm.getToken();
  //   await services.sendDeviceId(widget.user!.userId, token);
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     print('Got a message whilst in the foreground!');
  //     print('Message data: ${message.data}');

  //     if (message.notification != null) {
  //       print('Message also contained a notification: ${message.notification}');
  //     }
  //   });
  // }

  sendDevId() async {
    print('sending device id');
    var token = await FirebaseMessaging.instance.getToken();
    services.sendDeviceId(token);
  }

  setData() async {
    isLoading = true;
    setState(() {});
    await Provider.of<DashboardView>(context, listen: false).fetchAndSetData(
      widget.user!.userId,
      widget.user!.userType,
    );
    await Provider.of<UserView>(context, listen: false).fetchAndSetImage();
    isLoading = false;
    setState(() {});
  }

  Timer? timeTick;
  void timeTicker(context) {
    timeTick = Timer.periodic(Duration(seconds: 5), (timer) async {
      await Provider.of<DashboardView>(context, listen: false).fetchAndSetData(
        widget.user!.userId,
        widget.user!.userType,
      );
      // await Provider.of<NotificationsProvider>(context, listen: false)
      //     .fetchAndSetNotifications(widget.user!.userId);
    });
  }

  cancelTimer() {
    timeTick!.cancel();
  }

  @override
  void dispose() {
    timeTick!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xffffedec),
        body: isLoading
            ? Center(
                child: SizedBox(
                  height: 150,
                  width: 150,
                  child: CircularProgressIndicator(),
                ),
              )
            : SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  children: [
                    BookRideWidget(cancelTimer),
                    BottomSheetWidget(),
                  ],
                ),
              ),
      ),
    );
  }
}
