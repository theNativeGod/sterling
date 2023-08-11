import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sterling/models/user.dart';
import 'package:sterling/view_models/dashboard_view.dart';
import 'package:sterling/views/customer_screens/quick_request_modal/quick_request_modal.dart';
import 'package:sterling/views/customer_screens/request_ride_screen/quick_request_dialog.dart';
import 'package:sterling/views/customer_screens/user_profile_screen/user_profile_screen.dart';
import 'package:sterling/views/global_utils/ride_type_dialog.dart';

import '../../../../view_models/user_view.dart';
import 'export.dart';

class BookRideWidget extends StatefulWidget {
  BookRideWidget(
    this.cancelTimer,
    // this.user,
    // this.getDashboardData,
    // this.dashData,
    {
    super.key,
  });
  // final User user;
  // var getDashboardData;
  // var dashData;
  var cancelTimer;
  @override
  State<BookRideWidget> createState() => _BookRideWidgetState();
}

class _BookRideWidgetState extends State<BookRideWidget> {
  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    var dashDataProvider = Provider.of<DashboardView>(context);
    var currentRequestStatus = dashDataProvider.currentReqStatus;
    var overallStatus = dashDataProvider.overallStatus;
    var userProvider = Provider.of<UserView>(context);
    var user = userProvider.user;
    imageUrl = userProvider.imageUrl;
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * .45,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                  ),
                ],
              ),
              const SizedBox(height: 132),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'assets/images/home_img.png',
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 200,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: const Center(
              child: Text(
                'Book your ride now!!!',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 115,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: InkWell(
                onTap: () async {
                  var rideType = 'Personal';
                  if (overallStatus == true) {
                    if (currentRequestStatus == false) {
                      rideType = await showDialog(
                        context: context,
                        builder: (ctx) {
                          return RideTypeDialog();
                        },
                      );

                      print(rideType.toString());
                      // if (rideType != null) {
                      //   await showDialog(
                      //     context: context,
                      //     builder: (ctx) {
                      //       return QuickRequestDialog(
                      //         // widget.user.userId,
                      //         // widget.getDashboardData,
                      //         rideType,
                      //       );

                      //     },
                      //   );
                      // }
                      await showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          isScrollControlled: true,
                          builder: (ctx) {
                            return QuickRequestModal(rideType: rideType);
                          });

                      //await widget.getDashboardData();
                    } else {
                      await showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              content: Container(
                                height: 70,
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    Text(
                                        'Cancel this ride to request again!!!'),
                                    TextButton(
                                      child: Text('Ok'),
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    }
                  } else {
                    var rideType = await showDialog(
                      context: context,
                      builder: (ctx) {
                        return RideTypeDialog();
                      },
                    );

                    await showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        isScrollControlled: true,
                        builder: (ctx) {
                          return QuickRequestModal(rideType: rideType);
                        });
                    // await widget.getDashboardData();
                  }
                },
                child: Container(
                  height: 56,
                  width: 152,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(249, 57, 52, 1),
                    borderRadius: BorderRadius.circular(60),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Send Request',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 15,
          top: 50,
          child: ActionsWidget(widget.cancelTimer),
        ),
        Positioned(
          left: 15,
          top: 50,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => UserProfileScreen(widget.cancelTimer),
                ),
              );
            },
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage('assets/images/bitmoji.png'),
                  child: imageUrl == ''
                      ? Container()
                      : Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
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
        ),
      ],
    );
  }
}
