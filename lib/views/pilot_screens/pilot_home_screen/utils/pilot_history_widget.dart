import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sterling/models/pilot_trip.dart';
import 'package:sterling/views/pilot_screens/pilot_home_screen/utils/pilot_ride_history_card.dart';

import '../../../../view_models/dashboard_view.dart';
import '../../../../view_models/user_view.dart';
import '../../../common_screens/history_screen/history_screen.dart';
import '../../../global_utils/global_export.dart';

class PilotHistoryWidget extends StatefulWidget {
  const PilotHistoryWidget({
    super.key,
  });

  @override
  State<PilotHistoryWidget> createState() => _PilotHistoryWidgetState();
}

class _PilotHistoryWidgetState extends State<PilotHistoryWidget> {
  int index = 1;
  PilotTrip? singleRide;
  @override
  Widget build(BuildContext context) {
    var dashboardProvider = Provider.of<DashboardView>(context);
    if (dashboardProvider.pilotRideHistory.length > 0) {
      singleRide = dashboardProvider.pilotRideHistory[index - 1];
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: DefaultTabController(
        length: 1,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'History',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => HistoryScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Container(
              width: MediaQuery.of(context).size.width - 30,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        border: Border(
                      bottom: BorderSide(
                        width: 3,
                        color: Color(0xfff4f4f4),
                        style: BorderStyle.solid,
                      ),
                    )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          //width: MediaQuery.of(context).size.width * .5,
                          width: 52,
                          padding: const EdgeInsets.only(top: 10),
                          alignment: Alignment.centerLeft,
                          child: const TabBar(
                            indicatorWeight: 3,
                            indicatorColor: Color.fromRGBO(249, 57, 52, 1),
                            indicatorSize: TabBarIndicatorSize.label,
                            labelPadding: EdgeInsets.symmetric(horizontal: 10),
                            padding: EdgeInsets.zero,
                            indicatorPadding: EdgeInsets.zero,
                            tabs: [
                              Tab(
                                child: Text(
                                  'Ride',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: PopupMenuButton(
                            child: Image.asset(
                              'assets/images/sortby_button.png',
                            ),
                            onSelected: (value) async {
                              if (value == 0) {
                                Provider.of<DashboardView>(context,
                                        listen: false)
                                    .latestToOldest();
                              }
                              if (value == 1) {
                                Provider.of<DashboardView>(context,
                                        listen: false)
                                    .oldestToLatest();
                              }
                            },
                            itemBuilder: (BuildContext bc) {
                              return const [
                                PopupMenuItem(
                                  value: 0,
                                  child: Text(
                                    'Lastest to Oldest',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 1,
                                  child: Text(
                                    'Oldest to Latest',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ];
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 160,
                    color: Colors.white,
                    child: TabBarView(
                      children: [
                        //Ride History
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 15,
                          ),
                          child: dashboardProvider.pilotRideHistory.length > 0
                              ? PilotRideHistoryCard(
                                  tripId: singleRide!.tripId,
                                  customer_mobile: singleRide!.customerMobile,
                                  customer_name: singleRide!.customerName,
                                  destination: singleRide!.destination,
                                  pickupLocation: singleRide!.pickupLocation,
                                  rideDate: singleRide!.rideDate,
                                )
                              : Container(
                                  child:
                                      Image.asset('assets/images/nodata.png'),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    if (index > 1) {
                      index--;
                      setState(() {});
                    }
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: Icon(
                      Icons.keyboard_arrow_left,
                      color: index > 1 ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
                Text(
                  'Page $index of ${dashboardProvider.pilotRideHistory.length > 0 ? dashboardProvider.pilotRideHistory.length : 1}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (index < dashboardProvider.pilotRideHistory.length) {
                      index++;
                      setState(() {});
                    }
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: Icon(
                      Icons.keyboard_arrow_right,
                      color: index < dashboardProvider.pilotRideHistory.length
                          ? Colors.black
                          : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
