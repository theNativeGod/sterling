import 'package:flutter/material.dart';
import 'package:sterling/models/payment_model.dart';
import 'package:sterling/services/services.dart';

class PaymentView with ChangeNotifier {
  List<Payment> _payments = [];
  Services services = Services();
  int _page = 0;
  bool _reverse = false;
  var _userId;

  get payments =>
      _reverse == true ? [..._payments.reversed.toList()] : [..._payments];

  set page(value) => _page = value;

  fetchAndSetPayments(userId) async {
    var response = await services.paymentHistory(userId, _page);
    _userId = userId;
    print('payment response');
    print(response.data);
    var paymentData = response.data['paymentDetails'];

    List<Payment> payments = [];
    if (response.data['status'] == true) {
      paymentData.forEach((pay) {
        payments.add(
          Payment(
            transactionNo: pay['transaction_no'],
            amount: pay['amount'],
            paymentDate: pay['payment_date'],
            paymentSource: pay['payment_source'],
            status: pay['status'],
            tripId: pay['tripId'],
          ),
        );
      });
    }

    _payments = payments;
    notifyListeners();
  }

  loadMore(context) async {
    _page = _page + 1;
    var l = _payments.length;
    var pays = _payments;
    await fetchAndSetPayments(_userId);
    _payments.addAll(pays);
    if (_payments.length == l) {
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

  oldestToLatest() {
    _reverse = true;
    notifyListeners();
  }

  latestToOldest() {
    _reverse = false;
    notifyListeners();
  }
}
