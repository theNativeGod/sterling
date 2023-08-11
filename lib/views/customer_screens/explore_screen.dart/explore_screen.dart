import 'package:flutter/material.dart';
import 'package:sterling/views/common_screens/login_screen/login_screen.dart';
import '../../global_utils/global_export.dart';
import 'utils/export.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/explore.png'),
            SizedBox(height: height * .08),
            Heading(headingText: 'Explore the app'),
            SizedBox(height: height * .02),
            SubHeading(
              subHeadingText:
                  'Now your finances are in one place and always under control',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: height * .08),
            ThemeButton(
              buttonText: 'Sign in',
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (ctx) => const LoginScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: height * .015),
            const CreateAccButton(),
          ],
        ),
      ),
    );
  }
}
