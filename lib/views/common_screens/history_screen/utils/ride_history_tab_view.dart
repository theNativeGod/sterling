import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sterling/view_models/history_view.dart';
import 'package:sterling/view_models/user_view.dart';
import 'package:sterling/views/pilot_screens/pilot_home_screen/utils/pilot_ride_history_card.dart';

import '../../../../models/trip.dart';
import '../../../global_utils/global_export.dart';

class RideHistoryTabView extends StatelessWidget {
  RideHistoryTabView(
      //this.tripData,
      {
    super.key,
  });

//var tripData;

  @override
  Widget build(BuildContext context) {
    var historyProvider = Provider.of<HistoryView>(context);
    var rideHistoryList = historyProvider.rideHistoryList;
    print(rideHistoryList.length);
    var userProvider = Provider.of<UserView>(context);
    var userType = userProvider.userType;
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 18,
          ),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: rideHistoryList.length,
            itemExtent: userType == 'customer' ? 250 : 126,
            itemBuilder: (ctx, index) {
              var rideHistory = rideHistoryList[index];

              return userType == 'customer'
                  ? RideHistoryCard(
                      isPaid: rideHistory.isPaid.toString(),
                      invoice: rideHistory.invoice.toString(),
                      price: rideHistory.price.toString(),
                      vehicleNo: rideHistory.vehicleNo.toString(),
                      vehicle_type: rideHistory.vehicleType.toString(),
                      destination: rideHistory.destination.toString(),
                      pickup_location: rideHistory.pickupLocation.toString(),
                      pilot: rideHistory.pilot.toString(),
                      pilotNo: rideHistory.pilotNo.toString(),
                      ride_date: rideHistory.rideDate.toString(),
                      ride_time: rideHistory.rideTime.toString(),
                      ride_type: rideHistory.rideType.toString(),
                      status: rideHistory.status.toString(),
                      tripId: rideHistory.tripId.toString(),
                      trip_id: rideHistory.trip_id.toString(),
                    )
                  : PilotRideHistoryCard(
                      tripId: rideHistory.tripId.toString(),
                      customer_mobile: rideHistory.customerMobile.toString(),
                      customer_name: rideHistory.customerName.toString(),
                      destination: rideHistory.destination.toString(),
                      pickupLocation: rideHistory.pickupLocation.toString(),
                      rideDate: rideHistory.rideDate.toString(),
                    );
            },
          ),
        ),
        SizedBox(height: 20),
        ThemeButton(
          buttonText: 'Load More',
          onTap: () async {
            await Provider.of<HistoryView>(context, listen: false)
                .loadMore(context);
          },
        ),
      ],
    );
  }
}
