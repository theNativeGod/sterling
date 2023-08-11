import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:provider/provider.dart';
import 'package:sterling/services/services.dart';
import 'package:sterling/view_models/dashboard_view.dart';
import '../../../models/user.dart';
import '../../../services/firebase_api.dart';
import '../../../view_models/notification_provider.dart';
import '../../../view_models/user_view.dart';
import '../../common_screens/notification_screen/notification_screen.dart';
import '../../customer_screens/user_profile_screen/user_profile_screen.dart';
import '../../global_utils/global_export.dart';
import 'utils/export.dart';

class PilotHomeScreen extends StatefulWidget {
  const PilotHomeScreen({super.key, required this.user});
  final User? user;

  @override
  State<PilotHomeScreen> createState() => _PilotHomeScreenState();
}

class _PilotHomeScreenState extends State<PilotHomeScreen> {
  bool isInit = true;
  String imageUrl = '';
  bool isLoading = false;
  Services services = Services();
  @override
  void didChangeDependencies() {
    if (isInit) {
      initNotification();
      sendDevId();
      fetchAndSetData();
      timeTicker(context);
    }
    isInit = false;

    super.didChangeDependencies();
  }

  initState() {
    super.initState();
    // setupPushNotifications();
  }

  cancelTimer() {
    timeTick!.cancel();
  }

  sendDevId() async {
    print('sending device id');
    var token = await FirebaseMessaging.instance.getToken();
    services.sendDeviceId(token);
  }

  initNotification() async {
    await FirebaseApi().initNotifications(context, widget.user!.userId);
  }

  // setupPushNotifications() async {
  //   print('setupPushNotifications');
  //   final fcm = FirebaseMessaging.instance;
  //   await fcm.requestPermission();
  //   final token = await fcm.getToken();
  //   await services.sendDeviceId(widget.user!.userId, token);
  // }

  Timer? timeTick;
  void timeTicker(context) {
    timeTick = Timer.periodic(Duration(seconds: 5), (timer) async {
      await Provider.of<DashboardView>(context, listen: false).fetchAndSetData(
        widget.user!.userId,
        widget.user!.userType,
      );
    });
  }

  fetchAndSetData() async {
    isLoading = true;
    setState(() {});
    await Provider.of<DashboardView>(context, listen: false)
        .fetchAndSetData(widget.user!.userId, widget.user!.userType);
    isLoading = false;
    setState(() {});
  }

  @override
  void dispose() {
    timeTick!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _pageProvider = Provider.of<DashboardView>(context);
    var _currentRequest = _pageProvider.pilotCurrentRequest;
    var _currentRequestStatus = _pageProvider.pilotCurrentReqStatus;
    var _totalRides = _pageProvider.tripCount;
    var userProvider = Provider.of<UserView>(context);
    var user = userProvider.user;
    imageUrl = userProvider.imageUrl;
    return Scaffold(
      backgroundColor: const Color(0xfff4f4f4),
      body: isLoading
          ? Center(
              child: SizedBox(
                height: 200,
                width: 200,
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) =>
                                    UserProfileScreen(cancelTimer),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                backgroundImage:
                                    AssetImage('assets/images/bitmoji.png'),
                                child: imageUrl == ''
                                    ? Container()
                                    : Container(
                                        height: 120,
                                        width: 120,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(60),
                                          image: DecorationImage(
                                            image: NetworkImage(imageUrl),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Hi, ${user.name}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
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
                              // final Uri url = Uri(
                              //   scheme: 'tel',
                              //   // path: currentrequest.pilotNo.toString(),
                              //   path: '8170997368',
                              // );
                              // if (await canLaunchUrl(url)) {
                              //   await launchUrl(url);
                              // } else {
                              //   print('Cannot launch url');
                              // }
                              await FlutterPhoneDirectCaller.callNumber(
                                  '9945788600');
                            },
                            child: Container(
                                height: 30,
                                width: 30,
                                padding: EdgeInsets.all(2),
                                child: Image.asset(
                                    'assets/images/phone_icon.png'))),
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
                                child: Image.asset(
                                    'assets/images/logout_icon.png'))),
                      ],
                    ),
                  ),
                  const Divider(
                    color: Color(0xffeadbdb),
                    thickness: 1,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Image.asset(
                              'assets/images/pilot_home_img.png',
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          Positioned(
                            left: 40,
                            top: 50,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _totalRides.toString(),
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  'Total Rides Completed',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Ride Request',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      _currentRequestStatus == false
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'No Requests Yet!!!',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        .15,
                                    width:
                                        MediaQuery.of(context).size.width * .5,
                                    child:
                                        Image.asset('assets/images/nodata.png'),
                                  ),
                                ],
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Center(
                                child: SizedBox(
                                  // height: 210,
                                  child: AwaitingRequestCard(
                                    name: _currentRequest!.customerName,
                                    phoneNumber:
                                        _currentRequest!.customerMobile,
                                    pickUp: _currentRequest!.pickupLocation,
                                    destination: _currentRequest!.destination,
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(height: 20),
                      const PilotHistoryWidget(),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
