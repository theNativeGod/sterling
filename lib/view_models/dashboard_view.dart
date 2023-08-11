import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sterling/models/payment_model.dart';
import 'package:sterling/models/pilot_trip.dart';
import 'package:sterling/models/trip.dart';
import 'package:sterling/services/services.dart';

class DashboardView with ChangeNotifier {
  String _tripCount = '0';
  Trip? _currentRequest = null;
  PilotTrip? _pilotCurrentRequest = null;
  List<Trip> _rideHistory = [];
  List<PilotTrip> _pilotRideHistory = [];
  Services services = Services();
  bool _reverse = false;
  List<String> _cancelReasons = [];
  List<Payment> _payments = [];

  get tripCount => _tripCount;
  get currentRequest => _currentRequest;
  get pilotCurrentRequest => _pilotCurrentRequest;
  get rideHistory => _reverse == true
      ? [..._rideHistory.reversed.toList()]
      : [..._rideHistory];
  get pilotRideHistory => _reverse == true
      ? [..._pilotRideHistory.reversed.toList()]
      : [..._pilotRideHistory];
  get currentReqStatus {
    return _currentRequest == null ? false : true;
  }

  get pilotCurrentReqStatus {
    return _pilotCurrentRequest == null ? false : true;
  }

  get overallStatus {
    return _currentRequest == null && _rideHistory == [] ? false : true;
  }

  get cancelReasons => [..._cancelReasons];

  get payments => _reverse ? [..._payments.reversed.toList()] : [..._payments];

  Future<void> fetchAndSetData(userId, userType) async {
    try {
      var dashData = await services.getDashboardData(userId, userType);

      if (dashData['status'] == false) {
        _currentRequest = null;
      } else {
        if (userType == 'customer') {
          List<String> cancelRes = [];
          var reasonsData = dashData['dashboardData']['cancel_reasons'];
          reasonsData.forEach((e) {
            cancelRes.add(e);
          });
          _cancelReasons = cancelRes;

          var currentRequestData = dashData['dashboardData']['currentrequest'];
          Trip? currReq = null;
          if (currentRequestData.isNotEmpty) {
            currReq = Trip(
              pilot: currentRequestData['pilot'].toString(),
              pilotNo: currentRequestData['pilotNo'].toString(),
              vehicleNo: currentRequestData['vehicleNo'].toString(),
              vehicleType: currentRequestData['vehicleType'].toString(),
              rideDate: currentRequestData['ride_date'].toString(),
              rideTime: currentRequestData['ride_time'].toString(),
              rideType: currentRequestData['ride_type'].toString(),
              destination: currentRequestData['destination'].toString(),
              pickupLocation: currentRequestData['pickup_location'].toString(),
              status: currentRequestData['status'].toString(),
              tripId: currentRequestData['tripId'].toString(),
              trip_id: currentRequestData['trip_id'].toString(),
            );
          }
          _currentRequest = currReq;
        } else {
          var currentRequestData = dashData['dashboardData']['currentrequest'];
          var tripCount = dashData['tripCount'].toString();
          _tripCount = tripCount;
          PilotTrip? pilotCurrReq = null;
          if (currentRequestData.isNotEmpty) {
            pilotCurrReq = PilotTrip(
              invoice: currentRequestData['invoice'],
              price: currentRequestData['price'],
              customerEmail: currentRequestData['customer_email'].toString(),
              customerMobile: currentRequestData['customer_mobile'].toString(),
              customerName: currentRequestData['customer_name'].toString(),
              vehicleType: currentRequestData['vehicle_type'].toString(),
              rideDate: currentRequestData['ride_date'].toString(),
              rideTime: currentRequestData['ride_time'].toString(),
              rideType: currentRequestData['ride_type'].toString(),
              destination: currentRequestData['destination'].toString(),
              pickupLocation: currentRequestData['pickup_location'].toString(),
              status: currentRequestData['status'].toString(),
              tripId: currentRequestData['tripId'].toString(),
              trip_id: currentRequestData['trip_id'].toString(),
            );
          }
          _pilotCurrentRequest = pilotCurrReq;
        }

        var rideHistoryData = dashData['dashboardData']['history']['ride'];
        var pilotHistoryData = dashData['dashboardData']['history']['ride'];

        List<Trip> rideHistoryDemi = [];
        List<PilotTrip> pilotRideHistoryDemi = [];
        List<Payment> tempPayments = [];
        if (userType == 'customer') {
          if (rideHistoryData.length > 0) {
            for (int i = 0; i < rideHistoryData.length; i++) {
              var rideHist = rideHistoryData[i];
              rideHistoryDemi.add(
                Trip(
                  isPaid: rideHist['isPaid'] as String,
                  invoice: rideHist['invoice'] as String,
                  price: rideHist['price'] as String,
                  pilot: rideHist['pilot'] as String?,
                  pilotNo: rideHist['pilotNo'] as String?,
                  vehicleNo: rideHist['vehicleNo'] as String?,
                  vehicleType: rideHist['vehicle_type'] as String?,
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
          var paymentData = dashData['dashboardData']['history']['payment'];

          paymentData.forEach((pay) {
            tempPayments.add(
              Payment(
                transactionNo: pay['transaction_no'],
                amount: pay['amount'],
                paymentDate: pay['payment_date'],
                paymentSource: pay['payment_source'],
                status: pay['status'],
                tripId: pay['tripId'],
              ),
            );
            _payments = tempPayments;
          });
        } else {
          for (int i = 0; i < pilotHistoryData.length; i++) {
            var pilotRideHist = pilotHistoryData[i];
            pilotRideHistoryDemi.add(
              PilotTrip(
                price: pilotRideHist['price'] as String,
                invoice: pilotRideHist['invoice'] as String,
                customerName: pilotRideHist['customer_name'] as String,
                customerEmail: pilotRideHist['customer_email'] as String,
                customerMobile: pilotRideHist['customer_mobile'] as String,
                vehicleType: pilotRideHist['vehicle_type'] as String,
                rideDate: pilotRideHist['ride_date'] as String,
                rideTime: pilotRideHist['ride_time'] as String,
                rideType: pilotRideHist['ride_type'] as String,
                destination: pilotRideHist['destination'] as String,
                pickupLocation: pilotRideHist['pickup_location'] as String,
                status: pilotRideHist['status'] as String,
                tripId: pilotRideHist['tripId'] as String,
                trip_id: pilotRideHist['trip_id'] as String,
              ),
            );
          }
          _pilotRideHistory = pilotRideHistoryDemi;
        }
      }

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
