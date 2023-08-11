import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sterling/models/notification_model.dart';
import 'package:sterling/view_models/notification_provider.dart';
import 'package:sterling/views/customer_screens/explore_screen.dart/utils/export.dart';
import 'package:sterling/views/global_utils/back_button.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool isInit = true;
  bool isLoading = false;

  @override
  didChangeDependencies() {
    if (isInit) {
      fetchNotifications();
    }
    isInit = false;
    super.didChangeDependencies();
  }

  fetchNotifications() async {
    isLoading = true;
    setState(() {});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var encodedMap = await prefs.getString('user-details');
    var decodedMap = json.decode(encodedMap!);
    var userId = decodedMap['user_id'];
    Provider.of<NotificationsProvider>(context, listen: false).page = 0;
    await Provider.of<NotificationsProvider>(context, listen: false)
        .fetchAndSetNotifications(userId);
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var _notificationsProvider = Provider.of<NotificationsProvider>(context);
    List<NotificationModel> notifications =
        _notificationsProvider.notifications;
    return Scaffold(
      backgroundColor: Color(0xfff4f4f4),
      appBar: AppBar(
        leading: BackButtonWidget(
          purpose: 'notifications',
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    notifications.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'No notifications yet!!!',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Center(
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .25,
                                  width: MediaQuery.of(context).size.width,
                                  child:
                                      Image.asset('assets/images/nodata.png'),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemCount: notifications.length,
                                itemBuilder: (ctx, i) {
                                  return Card(
                                    color: Colors.white,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              96,
                                          padding: EdgeInsets.all(16.0),
                                          margin: EdgeInsets.only(bottom: 16.0),
                                          child: Text(
                                            notifications[i].notification,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        PopupMenuButton(
                                          icon: Icon(Icons.more_vert,
                                              color: Colors.black),
                                          color: Colors.white,
                                          padding: EdgeInsets.zero,
                                          itemBuilder: (ctx) => [
                                            PopupMenuItem(
                                              onTap: () async {
                                                await Provider.of<
                                                            NotificationsProvider>(
                                                        context,
                                                        listen: false)
                                                    .deleteNotification(
                                                        notifications[i].id,
                                                        context);
                                              },
                                              child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      32,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Icon(
                                                        Icons.delete_outline,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            'Delete',
                                                            style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 4,
                                                          ),
                                                          Text(
                                                            'Delete this notification',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                          ],
                                        ),
                                        // IconButton(
                                        //   onPressed: () async {
                                        //     await Provider.of<
                                        //                 NotificationsProvider>(
                                        //             context,
                                        //             listen: false)
                                        //         .deleteNotification(
                                        //             notifications[i].id,
                                        //             context);
                                        //   },
                                        //   icon: Icon(Icons.delete,
                                        //       color: Theme.of(context)
                                        //           .primaryColor),
                                        // ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              ThemeButton(
                                buttonText: 'Load More',
                                onTap: () async {
                                  await Provider.of<NotificationsProvider>(
                                          context,
                                          listen: false)
                                      .loadMore(context);
                                },
                              )
                            ],
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}
