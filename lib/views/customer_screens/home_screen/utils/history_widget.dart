import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sterling/models/payment_model.dart';
import 'package:sterling/models/trip.dart';
import 'package:sterling/view_models/dashboard_view.dart';
import 'package:sterling/view_models/user_view.dart';
import 'package:sterling/views/common_screens/history_screen/history_screen.dart';
import '../../../global_utils/global_export.dart';

class HistoryWidget extends StatefulWidget {
  HistoryWidget(
      // this.rideHistoryList,
      // this.user,
      {
    super.key,
  });

  // var rideHistoryList;
  // var user;

  @override
  State<HistoryWidget> createState() => _HistoryWidgetState();
}

class _HistoryWidgetState extends State<HistoryWidget> {
  int index = 1;
  int paymentIndex = 1;
  Trip? singleRide;
  Payment? singlePay;
  int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    // print(widget.rideHistoryList);
    // if (widget.rideHistoryList.length > 0) {
    //   rideHistory = widget.rideHistoryList[index.toString()];
    // }
    var userProvider = Provider.of<UserView>(context);
    var dashboardProvider = Provider.of<DashboardView>(context);

    if (dashboardProvider.rideHistory.length > 0) {
      singleRide = dashboardProvider.rideHistory[index - 1];
    }

    if (dashboardProvider.payments.length > 0) {
      singlePay = dashboardProvider.payments[paymentIndex - 1];
    }
    return DefaultTabController(
      length: 2,
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
                        width: MediaQuery.of(context).size.width * .5,
                        padding: const EdgeInsets.only(top: 10),
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
                            Tab(
                              child: Text(
                                'Payment',
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
                              Provider.of<DashboardView>(context, listen: false)
                                  .latestToOldest();
                            }
                            if (value == 1) {
                              Provider.of<DashboardView>(context, listen: false)
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
                  height: 280 + 44,
                  color: Colors.white,
                  child: TabBarView(
                    children: [
                      //Ride History Tab View
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                        child: dashboardProvider.rideHistory.length > 0
                            ? Column(
                                children: [
                                  RideHistoryCard(
                                    isPaid: singleRide!.isPaid,
                                    price: singleRide!.price,
                                    vehicleNo: singleRide!.vehicleNo,
                                    vehicle_type: singleRide!.vehicleType,
                                    destination: singleRide!.destination,
                                    pickup_location: singleRide!.pickupLocation,
                                    pilot: singleRide!.pilot,
                                    pilotNo: singleRide!.pilotNo,
                                    ride_date: singleRide!.rideDate,
                                    ride_time: singleRide!.rideTime,
                                    ride_type: singleRide!.rideType,
                                    status: singleRide!.status,
                                    tripId: singleRide!.tripId,
                                    trip_id: singleRide!.trip_id,
                                    invoice: singleRide!.invoice,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (index > 1) {
                                              index--;
                                              setState(() {});
                                            }
                                          },
                                          child: CircleAvatar(
                                            backgroundColor:
                                                const Color(0xfff4f4f4),
                                            radius: 20,
                                            child: Icon(
                                              Icons.keyboard_arrow_left,
                                              color: index > 1
                                                  ? Colors.black
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'Page $index of ${dashboardProvider.rideHistory.length > 0 ? dashboardProvider.rideHistory.length : 1}',
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            if (index <
                                                dashboardProvider
                                                    .rideHistory.length) {
                                              index++;
                                              setState(() {});
                                            }
                                          },
                                          child: CircleAvatar(
                                            backgroundColor:
                                                const Color(0xfff4f4f4),
                                            radius: 20,
                                            child: Icon(
                                              Icons.keyboard_arrow_right,
                                              color: index <
                                                      dashboardProvider
                                                          .rideHistory.length
                                                  ? Colors.black
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Container(
                                child: Image.asset('assets/images/nodata.png'),
                              ),
                      ),
                      //Payment History
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 18,
                        ),
                        child: dashboardProvider.payments.isEmpty
                            ? Container(
                                child: Image.asset('assets/images/nodata.png'),
                              )
                            : Column(
                                children: [
                                  PaymentHistoryCard(
                                    transactionNo: singlePay!.transactionNo,
                                    amount: singlePay!.amount.toString(),
                                    paymentDate: singlePay!.paymentDate,
                                    paymentSource: singlePay!.paymentSource,
                                    status: singlePay!.status,
                                    tripId: singlePay!.tripId,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (paymentIndex > 1) {
                                              paymentIndex--;
                                              setState(() {});
                                            }
                                          },
                                          child: CircleAvatar(
                                            backgroundColor:
                                                const Color(0xffffedec),
                                            radius: 20,
                                            child: Icon(
                                              Icons.keyboard_arrow_left,
                                              color: paymentIndex > 1
                                                  ? Colors.black
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'Page $paymentIndex of ${dashboardProvider.payments.length > 0 ? dashboardProvider.payments.length : 1}',
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            if (paymentIndex <
                                                dashboardProvider
                                                    .payments.length) {
                                              paymentIndex++;
                                              setState(() {});
                                            }
                                          },
                                          child: CircleAvatar(
                                            backgroundColor:
                                                const Color(0xffffedec),
                                            radius: 20,
                                            child: Icon(
                                              Icons.keyboard_arrow_right,
                                              color: index <
                                                      dashboardProvider
                                                          .payments.length
                                                  ? Colors.black
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
