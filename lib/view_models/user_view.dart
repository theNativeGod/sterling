import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sterling/models/user.dart';

import '../services/firebase_services.dart';
import '../services/services.dart';

class UserView with ChangeNotifier {
  FirebaseServices fireServices = FirebaseServices();
  Services services = Services();
  User _user = User(
    mobile: '',
    name: '',
    userId: 0,
    company: '',
    email: '',
    employeeId: '',
    userType: '',
  );
  String _imageUrl = '';
  String _email = '';

  setUser(user) async {
    _user = user;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var e = await prefs.getString('email');
    _email = e.toString();

    notifyListeners();
  }

  setImage(imageUrl) {
    _imageUrl = imageUrl;
    notifyListeners();
  }

  get user => _user;

  get userType => _user.userType;

  get imageUrl => _imageUrl;

  get email => _email;

  uploadImage(image) async {
    var imageUrl = await fireServices.uploadImageToStorage(_user.userId, image);
    _imageUrl = imageUrl;
    notifyListeners();
  }

  fetchAndSetImage() async {
    var imageUrl = await fireServices.getImageFromCloud(_user.userId);
    _imageUrl = imageUrl;

    notifyListeners();
  }

  updatePhoneNumber(phoneNumber, countryCode) async {
    try {
      var responseData =
          await services.mobileUpdate(_user.userId, phoneNumber, countryCode);
      notifyListeners();
      return responseData;
    } catch (e) {
      print('error updating phone number');
      print(e);
    }
  }

  updateEmail(email) async {
    try {
      print('there updating email');
      var responseData = await services.emailUpdate(_user.userId, email);

      if (responseData['status'] == true) {
        _email = email;
        print('here & there');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', '$email');
      }
      notifyListeners();
      return responseData;
    } catch (e) {
      print('error updating email');
      print(e);
    }
  }
}
