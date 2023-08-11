import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sterling/models/user.dart';
import 'package:sterling/services/services.dart';
import 'package:sterling/view_models/payment_view.dart';
import '../../../view_models/history_view.dart';
import '../../../view_models/user_view.dart';
import '../../global_utils/global_export.dart';
import 'utils/export.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  //final User user;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Services services = Services();
  int tabIndex = 0;
  var isInit = true;
  bool isLoading = false;

  @override
  didChangeDependencies() {
    if (isInit) {
      tripHistory();
      paymentHistory();
    }
    isInit = false;

    super.didChangeDependencies();
  }

  //var tripData;

  tripHistory() async {
    isLoading = true;
    await Provider.of<HistoryView>(context, listen: false).fetchAndSetHistory();
    isLoading = false;
  }

  paymentHistory() async {
    print('here');
    isLoading = true;
    User user = Provider.of<UserView>(context).user;
    var userId = user.userId;
    Provider.of<PaymentView>(context, listen: false).page = 0;
    await Provider.of<PaymentView>(context, listen: false)
        .fetchAndSetPayments(userId);
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    var rideHistoryList = Provider.of<HistoryView>(context).rideHistoryList;
    var payments = Provider.of<PaymentView>(context).payments;
    var userType = Provider.of<UserView>(context).userType;
    return Scaffold(
      backgroundColor: const Color(0xfff4f4f4),
      appBar: AppBar(
        leading: BackButtonWidget(
          purpose: 'history',
        ),
      ),
      body: isLoading
          ? Center(
              child: SizedBox(
                height: 150,
                width: 150,
                child: CircularProgressIndicator(),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.5,
                vertical: 20,
              ),
              child: DefaultTabController(
                length: userType == 'customer' ? 2 : 1,
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'History',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
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
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: userType == 'customer'
                                        ? MediaQuery.of(context).size.width * .5
                                        : 52,
                                    padding: const EdgeInsets.only(top: 10),
                                    child: userType == 'customer'
                                        ? TabBar(
                                            onTap: (value) {
                                              tabIndex = value;
                                              print(tabIndex);
                                              setState(() {});
                                            },
                                            indicatorWeight: 3,
                                            indicatorColor:
                                                Color.fromRGBO(249, 57, 52, 1),
                                            indicatorSize:
                                                TabBarIndicatorSize.label,
                                            labelPadding: EdgeInsets.symmetric(
                                                horizontal: 10),
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
                                          )
                                        : TabBar(
                                            indicatorWeight: 3,
                                            indicatorColor:
                                                Color.fromRGBO(249, 57, 52, 1),
                                            indicatorSize:
                                                TabBarIndicatorSize.label,
                                            labelPadding: EdgeInsets.symmetric(
                                                horizontal: 10),
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
                                          Provider.of<HistoryView>(context,
                                                  listen: false)
                                              .latestToOldest();
                                          Provider.of<PaymentView>(context,
                                                  listen: false)
                                              .latestToOldest();
                                        }
                                        if (value == 1) {
                                          Provider.of<HistoryView>(context,
                                                  listen: false)
                                              .oldestToLatest();
                                          Provider.of<PaymentView>(context,
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
                            rideHistoryList.isEmpty
                                ? SizedBox(
                                    height: 200,
                                    width: 200,
                                    child: Image.asset(
                                      'assets/images/nodata.png',
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Container(
                                    //todo
                                    height: tabIndex == 0
                                        ? userType == 'customer'
                                            ? 250.0 * rideHistoryList.length +
                                                50 +
                                                80
                                            : 126.0 * rideHistoryList.length +
                                                50 +
                                                80
                                        : 250.0 * payments.length +
                                            (payments.length == 0 ? 200 : 90),
                                    color: Colors.white,
                                    child: userType == 'customer'
                                        ? TabBarView(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            children: [
                                              RideHistoryTabView(),
                                              const PaymentHistoryTabView(),
                                            ],
                                          )
                                        : TabBarView(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            children: [
                                              RideHistoryTabView(),
                                            ],
                                          ),
                                  ),
                          ],
                        ),
                      ),

                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: const [
                      //     CircleAvatar(
                      //       backgroundColor: Colors.white,
                      //       radius: 20,
                      //       child: Icon(
                      //         Icons.keyboard_arrow_left,
                      //         color: Colors.grey,
                      //       ),
                      //     ),
                      //     Text('Page 1 of 4'),
                      //     CircleAvatar(
                      //       backgroundColor: Colors.white,
                      //       radius: 20,
                      //       child: Icon(
                      //         Icons.keyboard_arrow_right,
                      //         color: Colors.grey,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
