import 'package:flutter/material.dart';
import 'package:sterling/services/services.dart';
import '../models/notification_model.dart';

class NotificationsProvider with ChangeNotifier {
  List<NotificationModel> _notifications = [];
  int _pageNo = 0;
  bool _pageChanged = false;
  Services services = Services();
  int _userId = 0;

  get notifications => [..._notifications];

  set page(value) => _pageNo = value;

  fetchAndSetNotifications(userId) async {
    try {
      _userId = userId;
      List<NotificationModel> notifics = [];
      var responseData = await services.getNotifications(userId, _pageNo);
      var notificationsData = responseData['notifications'];

      if (notificationsData != null) {
        print(notificationsData);
        notificationsData.forEach((notification) {
          notifics.add(
            NotificationModel(
                id: notification['id'], notification: notification['content']),
          );
        });
        _notifications.addAll(notifics);
      }

      notifyListeners();
    } catch (e) {
      print('error in notification provider');
    }
  }

  loadMore(context) async {
    _pageNo++;

    var l = _notifications.length;
    try {
      await fetchAndSetNotifications(_userId);
    } catch (e) {}

    if (_notifications.length == l) {
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

  clearNotifications() {
    _notifications = [];
    notifyListeners();
  }

  deleteNotification(id, context) async {
    _notifications.removeWhere((notification) => notification.id == id);
    notifyListeners();
    var response = await services.notificationDelete(id);
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
        content: Center(
          child: Text(
            response.data['message'],
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
