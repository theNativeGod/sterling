import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sterling/services/services.dart';
import 'package:sterling/view_models/dashboard_view.dart';
import '../../../../models/user.dart';
import 'export.dart';

class BottomSheetWidget extends StatefulWidget {
  BottomSheetWidget(
      // this.status,
      // this.dashData,
      // this.rideHistoryList,
      // this.user,
      {
    super.key,
  });

  // var dashData;
  // var status;
  // var rideHistoryList;
  // var user;

  @override
  State<BottomSheetWidget> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    var dashDataProvider = Provider.of<DashboardView>(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: const Color(0xfff4f4f4),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 25,
      ),
      child: Column(
        children: [
          dashDataProvider.currentReqStatus == false
              ? Column(
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
                      height: MediaQuery.of(context).size.height * .15,
                      width: MediaQuery.of(context).size.width * .5,
                      child: Image.asset('assets/images/nodata.png'),
                    ),
                  ],
                )
              : RequestCard(
                  // widget.dashData['dashboardData']['currentrequest'],
                  ),
          const SizedBox(height: 20),
          dashDataProvider.rideHistory == []
              ? Container()
              : HistoryWidget(
                  // rideHistoryList,
                  // widget.user,
                  ),
        ],
      ),
    );
  }
}
