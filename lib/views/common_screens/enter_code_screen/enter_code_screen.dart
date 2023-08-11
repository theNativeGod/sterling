import 'package:flutter/material.dart';
import 'utils/export.dart';
import '../../global_utils/global_export.dart';

class EnterCodeScreen extends StatelessWidget {
  const EnterCodeScreen({
    required this.phone,
    required this.purpose,
    this.name,
    this.email,
    this.mobile,
    this.company,
    this.employeeId,
    required this.countryCode,
    super.key,
  });
  final String? countryCode;
  final String? phone;
  final String? purpose;
  final String? name;
  final String? mobile;
  final String? email;
  final String? company;
  final String? employeeId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
            Positioned(
              top: 102,
              left: 21,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SmallLogo(),
                  Heading(headingText: 'Enter Code'),
                  const SizedBox(height: 30),
                  SubHeadingWidget(mobile: phone),
                  const SizedBox(height: 30),
                  OTPForm(
                    purpose: purpose,
                    name: name,
                    email: email,
                    mobile: phone,
                    countryCode: countryCode,
                    company: company,
                    employeeId: employeeId,
                  ),
                  // const SizedBox(height: 100),
                  // const SendAgain(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
