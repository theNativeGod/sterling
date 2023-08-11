import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sterling/views/common_screens/login_screen/login_screen.dart';

import 'global_export.dart';

class LogoutAlert extends StatelessWidget {
  LogoutAlert(
    this.cancelTimer, {
    super.key,
  });

  var cancelTimer;

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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  textAlign: TextAlign.center,
                  'Are you sure, Logout your account?',
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  ThemeButton(
                    buttonText: 'Logout',
                    width: 110,
                    onTap: () async {
                      try {
                        var prefs = await SharedPreferences.getInstance();
                        await prefs.setString('user-details', 'Data cleared');
                        await prefs.clear();
                        cancelTimer();
                        FirebaseAuth.instance.signOut();

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => const LoginScreen(),
                          ),
                        );
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                ],
              )
            ],
          )),
    );
  }
}
