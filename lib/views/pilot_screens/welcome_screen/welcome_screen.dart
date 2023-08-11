import 'package:flutter/material.dart';
import 'package:sterling/views/common_screens/enter_code_screen/utils/export.dart';

import '../../global_utils/global_export.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset('assets/images/successful.png'),
            const SizedBox(
              height: 50,
            ),
            Heading(
              headingText: 'Welcome',
              color: const Color(0xff7a3737),
            ),
          ],
        ),
      ),
    );
  }
}
