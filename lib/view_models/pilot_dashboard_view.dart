import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/pilot_trip.dart';
import '../services/services.dart';

class PilotDashboardView with ChangeNotifier {
  PilotTrip? _currentRequest = null;
  List<PilotTrip> _rideHistory = [];
  Services services = Services();
  bool _reverse = false;

  get currentRequest => _currentRequest;
  get rideHistory => _reverse == true
      ? [..._rideHistory.reversed.toList()]
      : [..._rideHistory];
  get currentReqStatus {
    return _currentRequest == null ? false : true;
  }

  get overallStatus {
    return _currentRequest == null && _rideHistory == [] ? false : true;
  }

  Future<void> fetchAndSetData(userId, userType) async {
    print('fetchAndSetData');

    try {
      var dashData = await services.getDashboardData(userId, userType);
      if (dashData['status'] == false) {
        _currentRequest = null;
      } else {
        // var currentRequestData = dashData['dashboardData']['currentrequest'];
        var rideHistoryData = dashData['dashboardData']['history']['ride'];

        // if (currentRequestData.isNotEmpty) {
        //   _currentRequest = PilotTrip(
        //     invoice: curre,
        //     customerEmail: currentRequestData['customer_email'].toString(),
        //     customerMobile: currentRequestData['customer_mobile'].toString(),
        //     customerName: currentRequestData['customer_name'].toString(),
        //     vehicleType: currentRequestData['vehicleType'].toString(),
        //     rideDate: currentRequestData['ride_date'].toString(),
        //     rideTime: currentRequestData['ride_time'].toString(),
        //     rideType: currentRequestData['ride_type'].toString(),
        //     destination: currentRequestData['destination'].toString(),
        //     pickupLocation: currentRequestData['pickup_location'].toString(),
        //     status: currentRequestData['status'].toString(),
        //     tripId: currentRequestData['tripId'].toString(),
        //     trip_id: currentRequestData['trip_id'].toString(),
        //   );
        // }
        // notifyListeners();
        print('here\'s ride history data');
        print(rideHistoryData);

        List<PilotTrip> rideHistoryDemi = [];
        if (rideHistoryData.length > 0) {
          for (int i = 0; i < rideHistoryData.length; i++) {
            var rideHist = rideHistoryData[i];

            rideHistoryDemi.add(
              PilotTrip(
                invoice: rideHist['invoice'] as String,
                price: rideHist['price'] as String,
                customerEmail: rideHist['customer_email'] as String,
                customerMobile: rideHist['customer_mobile'] as String,
                customerName: rideHist['customer_name'] as String,
                vehicleType: rideHist['vehicle_type'] as String,
                rideDate: rideHist['ride_date'] as String,
                rideTime: rideHist['ride_time'] as String,
                rideType: rideHist['ride_type'] as String,
                destination: rideHist['destination'] as String,
                pickupLocation: rideHist['pickup_location'] as String,
                status: rideHist['status'] as String,
                tripId: rideHist['tripId'] as String,
                trip_id: rideHist['trip_id'] as String,
              ),
            );
          }
        }

        _rideHistory = rideHistoryDemi;
      }
      print(_rideHistory);
      print('dashData provider is updated successfully');
      notifyListeners();
    } catch (e) {
      print('dashboard view error');
      print(e);
      //fetchAndSetData(userId, userType);
    }
  }

  newRequest(
    ridedate,
    ridetime,
    pickupLocation,
    destination,
    int? vehicleType,
    rideType,
    int? rideCategory,
  ) async {
    try {
      rideCategory = rideCategory! - 100;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var encodedMap = await prefs.getString('user-details');

      var decodeMap = json.decode(encodedMap!);
      var userId = decodeMap['user_id'];

      var responseData = await services.tripRequest(
        userId: userId,
        ridedate: ridedate,
        ridetime: ridetime,
        pickupLocation: pickupLocation,
        destination: destination,
        vehicleType: vehicleType,
        rideType: rideType,
        rideCategory: rideCategory,
      );

      var userType = decodeMap['userType'];

      if (responseData['status'] == true) {
        await fetchAndSetData(userId, userType);
      }

      notifyListeners();

      return responseData;
    } catch (e) {
      print(e);
    }
  }

  cancelRide() async {
    _rideHistory.insert(0, _currentRequest!);
    _currentRequest = null;
    notifyListeners();
  }

  oldestToLatest() {
    _reverse = true;
    notifyListeners();
  }

  latestToOldest() {
    _reverse = false;
    notifyListeners();
  }
}
