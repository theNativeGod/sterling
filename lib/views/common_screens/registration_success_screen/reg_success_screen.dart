import 'package:flutter/material.dart';
import 'package:sterling/views/global_utils/global_export.dart';

import '../login_screen/login_screen.dart';

class RegSuccessScreen extends StatelessWidget {
  const RegSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SizedBox(
        width: MediaQuery.of(context).size.width * .9,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Image.asset(
                    'assets/images/regsuccess.png',
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: 10,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Heading(
                headingText: 'successfully created',
                color: const Color(0xff7A3737),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                textAlign: TextAlign.center,
                'Your account has been successfully created',
                style: TextStyle(
                  color: Color(0xff8D8D8D),
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // const Text(
              //   textAlign: TextAlign.center,
              //   'Please verify your email',
              //   style: TextStyle(
              //     color: Color(0xff585858),
              //     fontSize: 18,
              //   ),
              // ),
              const SizedBox(height: 80),
              ThemeButton(
                buttonText: 'Back to login',
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (ctx) => const LoginScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      )),
    );
  }
}
