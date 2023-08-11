import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Services {
  Dio dio = Dio();
  var response;
  List<String> vehicleType = [];
  List<String> rideCategory = [];
  getCompanyList() async {
    List<String> compList = [];
    response = await dio.post(
      'http://dev.labgex.com/sterling/backend/api/trip/settings',
    );

    response.data['companies'].map((e) {
      compList.add(
        e['company_name'],
      );
    }).toList();
    return compList;
  }

  checkUserRegistration(phoneNumber) async {
    try {
      bool exists;
      response = await dio.post(
        'http://dev.labgex.com/sterling/backend/api/user/checkduplicateuser',
        data: {
          "mobile": "91${phoneNumber}",
        },
      );

      print(response.data);

      final message = response.data['message'];
      if (message == 'Mobile already exists.') {
        exists = true;
      } else {
        exists = false;
      }

      return exists;
    } catch (e) {
      print('check error');
      print(e);
    }
  }

  registerUser(
    String? name,
    String? email,
    String? mobile,
    String? company,
    String? employeeId,
    String? counryCode,
  ) async {
    response = await dio
        .post('http://dev.labgex.com/sterling/backend/api/user/signup', data: {
      'name': name,
      'email': email,
      'mobile': '${counryCode!.substring(1)}${mobile}',
      'company': company,
      'employeeId': employeeId,
    });
    return response.data;
  }

  loginUser(mobile, uid, countryCode) async {
    try {
      print('HERE');
      response = await dio
          .post('http://dev.labgex.com/sterling/backend/api/user/login', data: {
        'mobile': '${countryCode.substring(1)}${mobile}',
        'deviceId': uid,
      });
      print(response.data);
      return response.data;
    } catch (e) {
      print('error login in');
      print(e);
    }
  }

  getDashboardData(userId, userType) async {
    try {
      response = await dio
          .post('http://dev.labgex.com/sterling/backend/api/dashboard', data: {
        'userId': userId,
        'userType': userType,
      });

      return response.data;
    } catch (e) {
      print(e);
    }
  }

  settingsAPI() async {
    try {
      response = await dio.post(
        'http://dev.labgex.com/sterling/backend/api/trip/settings',
      );

      response.data['vehicleType'].map((e) {
        vehicleType.add(e['vehicle_type']);
      }).toList();

      response.data['rideCategory'].map((e) {
        rideCategory.add(e['ride_type']);
      }).toList();
    } catch (e) {
      print('settings error');
      print(e);
    }
  }

  getApiKey() async {
    try {
      response = await dio.post(
        'http://dev.labgex.com/sterling/backend/api/trip/settings',
      );
      final String APIKEY = response.data['googleApk'];
      return APIKEY;
    } catch (e) {
      print('get API key error');
      print(e);
    }
  }

  getPlacesAutocompleteData(APIKEY, inputPlace) async {
    print('services started');
    String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputPlace&radius=1000&key=$APIKEY&components=country:in';
    var response = await dio.get(url);
    print(response.data['predictions']);
    var predictions = response.data['predictions'];
    List<String> places = [];
    predictions.forEach((e) {
      var correctedPlace = correctPlace(e['description']);
      places.add(correctedPlace);
    });

    print('service ended');
    return places;
  }

  correctPlace(String description) {
    String str = '';
    int comma = 0;
    for (int i = 0; i < description.length; i++) {
      if (description.substring(i, i + 1) == ',') {
        comma++;
      }
      if (comma == 2) {
        break;
      }
      str = str + description.substring(i, i + 1);
    }
    print(str);
    return str;
  }

  getSettings(setting) async {
    if (setting == 'vehicleType') {
      return vehicleType;
    } else {
      return rideCategory;
    }
  }

  tripRequest({
    userId,
    ridedate,
    ridetime,
    pickupLocation,
    destination,
    int? vehicleType,
    rideType,
    int? rideCategory,
  }) async {
    print('vehicle type: $vehicleType');
    print('rideCategory: $rideCategory');
    print('userId trip');
    print(userId);
    vehicleType = vehicleType! + 1;
    rideCategory = rideCategory! + 1;
    try {
      response = await dio.post(
          'http://dev.labgex.com/sterling/backend/api/trip/createrequest',
          data: {
            "userId": userId,
            "ridedate": ridedate,
            "ridetime": ridetime,
            "pickupLocation": pickupLocation,
            "destination": destination,
            "vehicleType": vehicleType,
            "rideType": rideType,
            "rideCategory": rideCategory,
            "comments": "Lorem Ipsum",
            "is_app": 1,
          });

      return response.data;
    } catch (e) {
      print('trip request error');
      print(e);
    }
  }

  tripHistory(userId, userType, page) async {
    try {
      response = await dio.post(
        'http://dev.labgex.com/sterling/backend/api/dashboard/triphistory',
        data: {
          'userId': userId,
          'userType': userType,
          'page': page,
        },
      );

      return response.data;
    } catch (e) {
      print(e);
    }
  }

  paymentHistory(userId, page) async {
    try {
      response = await dio.post(
          'http://dev.labgex.com/sterling/backend/api/dashboard/payment',
          data: {
            'userId': userId,
            'page': page,
          });
      return response;
    } catch (e) {
      print('paymentHistory error api');
      print(e);
    }
  }

  mobileUpdate(userId, mobile, countryCode) async {
    try {
      response = await dio.post(
        'http://dev.labgex.com/sterling/backend/api/user/updatemobile',
        data: {
          'user_id': userId,
          'mobile': '${countryCode.substring(1)}$mobile',
        },
      );
      return response.data;
    } catch (e) {
      print('error update mobile');
      print(e);
    }
  }

  emailUpdate(userId, email) async {
    try {
      response = await dio.post(
        'http://dev.labgex.com/sterling/backend/api/user/updateemail',
        data: {
          'user_id': userId,
          'email': email,
        },
      );
      print('here is response');
      print(response.data);
      return response.data;
    } catch (e) {
      print('error service update email');
      print(e);
    }
  }

  cancelRide(tripId, comments) async {
    try {
      response = await dio.post(
        'http://dev.labgex.com/sterling/backend/api/trip/cancelride',
        data: {
          'tripId': tripId,
          'comments': comments,
        },
      );
      return response.data;
    } catch (e) {
      print(e);
    }
  }

  documentUpload(dynamic data) async {
    try {
      response = await dio.post(
        'http://dev.labgex.com/sterling/backend/api/trip/documentupload',
        data: data,
      );
      return response.data;
    } catch (e) {
      print('document upload error');
      print(e);
    }
  }

  getNotifications(userId, page) async {
    response = await dio.post(
        'http://dev.labgex.com/sterling/backend/api/dashboard/notifications',
        data: {
          'userId': userId,
          'page': page,
        });
    return response.data;
  }

  sendDeviceId(deviceId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var encodedMap = await prefs.getString('user-details');
      var decodeMap = json.decode(encodedMap!);
      var userId = decodeMap['user_id'];
      response = await dio.post(
          'http://dev.labgex.com/sterling/backend/api/user/devicetoken',
          data: {
            'userId': userId,
            'deviceId': deviceId,
          });
      print('sending device id $response');
    } catch (e) {
      print('send device token error');
      print(e);
    }
  }

  paymentResponse(tripId) async {
    try {
      response = await dio.post(
          'http://dev.labgex.com/sterling/backend/api/payment/responsepayment',
          data: {
            'tripId': tripId,
          });
      print(response.data);
      return response.data;
    } catch (e) {
      print('payment response');
      print(e);
    }
  }

  notificationDelete(id) async {
    try {
      response = await dio.post(
          'http://dev.labgex.com/sterling/backend/api/dashboard/notifdelete',
          data: {
            'id': id,
          });
      print(response);
      return response;
    } catch (e) {
      print(e);
    }
  }
}
