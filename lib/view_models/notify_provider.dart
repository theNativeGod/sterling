import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sterling/models/notification_model.dart';

class NotifyProvider with ChangeNotifier {
  List<NotificationModel> _notifications = [];

  get notifications => [..._notifications];

  fetchAndSetNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var encodedMap = prefs.getString('notifications');
    if (encodedMap != null) {
      var decodedMap = json.decode(encodedMap);
    }
  }
}
