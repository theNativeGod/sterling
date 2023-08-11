import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sterling/models/pilot_trip.dart';
import 'package:sterling/services/services.dart';

import '../models/trip.dart';

class HistoryView with ChangeNotifier {
  List<dynamic> _rideHistoryList = [];
  Services services = Services();
  int _pageNo = 0;
  bool _reverse = false;

  get rideHistoryList => _reverse == true
      ? [..._rideHistoryList.reversed.toList()]
      : [..._rideHistoryList];

  fetchAndSetHistory() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var encodedMap = await prefs.getString('user-details');
      var decodedMap = json.decode(encodedMap!);
      var userId = decodedMap['user_id'];
      var userType = decodedMap['userType'];

      var responseData = await services.tripHistory(userId, userType, _pageNo);
      print(responseData);
      if (responseData['status'] == true) {
        responseData['tripData'].forEach(
          (e) {
            if (userType == 'customer') {
              _rideHistoryList.add(
                Trip(
                  isPaid: e['isPaid'].toString(),
                  invoice: e['invoice'].toString(),
                  price: e['price'].toString(),
                  pilot: e['pilot'].toString(),
                  pilotNo: e['pilotNo'].toString(),
                  vehicleNo: e['vehicleNo'].toString(),
                  vehicleType: e['vehicleType'].toString(),
                  rideDate: e['ride_date'].toString(),
                  rideTime: e['ride_time'].toString(),
                  rideType: e['rideType'].toString(),
                  destination: e['destination'].toString(),
                  pickupLocation: e['pickup_location'].toString(),
                  status: e['status'].toString(),
                  tripId: e['tripId'].toString(),
                  trip_id: e['trip_id'].toString(),
                ),
              );
            } else {
              _rideHistoryList.add(
                PilotTrip(
                  customerMobile: e['customer_mobile'] as String,
                  vehicleType: e['vehicle_type'] as String,
                  price: e['price'] as String,
                  invoice: e['invoice'] as String,
                  customerName: e['customer_name'] as String,
                  customerEmail: e['customer_email'] as String,
                  rideDate: e['ride_date'] as String,
                  rideTime: e['ride_time'] as String,
                  rideType: e['ride_type'] as String,
                  destination: e['destination'] as String,
                  pickupLocation: e['pickup_location'] as String,
                  status: e['status'] as String,
                  tripId: e['tripId'] as String,
                  trip_id: e['trip_id'] as String,
                ),
              );
            }
          },
        );
      }

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  loadMore(context) async {
    _pageNo = _pageNo + 1;
    var l = _rideHistoryList.length;
    await fetchAndSetHistory();
    if (_rideHistoryList.length == l) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          elevation: 6,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          content: const Center(
            child: Text(
              'No more data available!!!',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }
    notifyListeners();
  }

  clearData() {
    _rideHistoryList = [];
    _pageNo = 0;
    print('clean');
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
