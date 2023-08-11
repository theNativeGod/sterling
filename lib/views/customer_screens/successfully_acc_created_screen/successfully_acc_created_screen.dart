import 'package:flutter/material.dart';
import 'package:sterling/views/global_utils/global_export.dart';

class SuccessfullyAccountCreatedScreen extends StatelessWidget {
  const SuccessfullyAccountCreatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            Image.asset('assets/images/successful.png'),
            const SizedBox(height: 20),
            Heading(
              headingText: 'successfully created',
              color: const Color(0xff7a3737),
            ),
            const SizedBox(height: 20),
            SubHeading(
              subHeadingText: 'Your account has been successfully created',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 140),
            const ThemeButton(
              buttonText: 'Back to login',
            ),
          ],
        ),
      ),
    );
  }
}
