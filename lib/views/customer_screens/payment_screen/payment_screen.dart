import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:sterling/services/services.dart';

class PaymentWebViewScreen extends StatefulWidget {
  PaymentWebViewScreen(
      {required this.amount,
      required this.customerEmail,
      required this.customerName,
      required this.customerPhone,
      required this.invoiceUrl,
      required this.tripId,
      super.key});
  String customerName;
  String customerEmail;
  String customerPhone;
  String amount;
  String tripId;
  String invoiceUrl;
  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  double _progress = 0;
  Timer? timer;
  Services services = Services();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  startTimer() {
    timer = Timer.periodic(Duration(seconds: 3), (timer) async {
      var responseData = await services.paymentResponse(widget.tripId);
      if (responseData['status'].toString() == 'true' &&
          responseData['tripId'].toString() == widget.tripId.toString()) {
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
                responseData['message'],
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  late InAppWebViewController inAppWebViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: Uri.parse(
                'https://dev.labgex.com/sterling/backend/api/payment?tripId=${widget.tripId}&&amount=${widget.amount.substring(2)}&&customer_name=${widget.customerName}&&customer_phone=${widget.customerPhone}&&customer_email=${widget.customerEmail}',
              ),
            ),
            onWebViewCreated: (InAppWebViewController controller) {
              inAppWebViewController = controller;
            },
            onProgressChanged:
                (InAppWebViewController controller, int progress) {
              _progress = progress / 100;
              setState(() {});
            },
          ),
          _progress < 1
              ? LinearProgressIndicator(
                  value: _progress,
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
