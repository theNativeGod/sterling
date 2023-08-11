import 'package:flutter/material.dart';
import 'package:sterling/views/customer_screens/payment_screen/payment_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import 'global_export.dart';

class DownloadInvoiceAlert extends StatelessWidget {
  DownloadInvoiceAlert({
    required this.invoiceUrl,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.tripId,
    required this.amount,
    required this.isPaid,
    super.key,
  });
  var tripId;
  var amount;
  String isPaid;
  String invoiceUrl;
  String customerName;
  String customerPhone;
  String customerEmail;

  _launchUrl() async {
    final Uri uri = Uri.parse(invoiceUrl);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      print('Cannot launch URL');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
          width: MediaQuery.of(context).size.width * .9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: const [
                  CloseButtonWidget(),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                textAlign: TextAlign.center,
                isPaid == '0'
                    ? 'Download invoice and make payment'
                    : 'Download invoice',
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  InkWell(
                    onTap: () async {
                      await _launchUrl();
                    },
                    child: DownloadInvoiceLink(),
                  ),
                  const Spacer(),
                  isPaid == '0'
                      ? ThemeButton(
                          buttonText: 'Payment',
                          width: 90,
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => PaymentWebViewScreen(
                                  invoiceUrl: invoiceUrl,
                                  customerName: customerName,
                                  customerEmail: customerEmail,
                                  customerPhone: customerPhone,
                                  amount: amount,
                                  tripId: tripId,
                                ),
                              ),
                            );
                            Navigator.pop(context);
                          },
                        )
                      : Text(
                          'Payment done',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ],
              )
            ],
          )),
    );
  }
}

class DownloadInvoiceLink extends StatelessWidget {
  const DownloadInvoiceLink({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Download pdf',
          style: TextStyle(
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        SizedBox(
          width: 16,
          child: Image.asset(
            'assets/images/download.png',
          ),
        ),
      ],
    );
  }
}
