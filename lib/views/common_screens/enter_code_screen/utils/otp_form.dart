import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sterling/views/common_screens/enter_code_screen/utils/export.dart';
import 'package:sterling/views/common_screens/registration_success_screen/reg_success_screen.dart';
import 'package:sterling/views/common_screens/signup_screen/signup_screen.dart';
import 'package:sterling/views/common_screens/update_phone_number/update_phone_number.dart';
import '../../../../models/user.dart' as model;
import '../../../../services/services.dart';
import '../../../../view_models/user_view.dart';
import '../../../customer_screens/home_screen/home_screen.dart';
import '../../../pilot_screens/pilot_home_screen/pilot_home_screen.dart';
import '../../login_screen/login_screen.dart';

class OTPForm extends StatefulWidget {
  const OTPForm({
    this.purpose,
    this.name,
    this.email,
    this.mobile,
    this.company,
    this.employeeId,
    this.countryCode,
    super.key,
  });
  final String? countryCode;
  final String? purpose;
  final String? name;
  final String? mobile;
  final String? email;
  final String? company;
  final String? employeeId;

  @override
  State<OTPForm> createState() => _OTPFormState();
}

class _OTPFormState extends State<OTPForm> {
  Services services = Services();
  bool isLoading = false;
  bool sendAgain = false;
  int start = 30;
  String goBackText = '';
  String token = '';

  void startTimer() {
    const onsec = Duration(seconds: 1);
    Timer timer = Timer.periodic(onsec, (timer) {
      if (start == 0) {
        setState(() {
          sendAgain = true;
          timer.cancel();
        });
      } else {
        start--;
        sendAgain = false;
        setState(() {});
      }
    });
  }

  sendOTPAgain() async {
    try {
      isLoading = true;
      setState(() {});
      print('verfying phone number');
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '${widget.countryCode}${widget.mobile}',
        verificationCompleted: (PhoneAuthCredential credential) {
          print('verification completed');
        },
        verificationFailed: (FirebaseAuthException e) {
          print('verification failed');
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
                  'Invalid OTP',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
          isLoading = false;
          setState(() {});
        },
        codeSent: (String verificationId, int? resendToken) {
          LoginScreen.verify = verificationId;
          isLoading = false;
          startTimer();
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
                  'Code sent',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('time out');
        },
      );
    } catch (e) {
      isLoading = false;
      setState(() {});
      print('error firebase otp');
      print(e);
    }
  }

  registerUser() async {
    print('print reg user');
    print(widget.email);
    return await services.registerUser(
      widget.name,
      widget.email,
      widget.mobile,
      widget.company,
      widget.employeeId,
      widget.countryCode,
    );
  }

  loginUser(uid) async {
    final responseData = await services.loginUser(
      widget.mobile,
      uid,
      widget.countryCode,
    );
    print(responseData);
    return responseData;
  }

  updateMobile() async {
    var responseData = await Provider.of<UserView>(context, listen: false)
        .updatePhoneNumber(widget.mobile, widget.countryCode);
    print(responseData.toString());
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
            responseData['message'].toString(),
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
    if (responseData['status'] == 'true') {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    startTimer();
    if (widget.purpose == 'login') {
      goBackText = 'Go back to login screen';
    } else if (widget.purpose == 'registration') {
      goBackText = 'Go back to Registration Screen';
    } else {
      goBackText = 'Go back to udate phone screen';
    }
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserView>(context, listen: false);
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xffe7e8e9),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(
        color: Theme.of(context).primaryColor,
      ),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = focusedPinTheme;
    return SizedBox(
      width: MediaQuery.of(context).size.width * .9,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Pinput(
            cursor: Container(
              width: 1,
              height: 22,
              color: Theme.of(context).primaryColor,
            ),
            length: 6,
            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: focusedPinTheme,
            submittedPinTheme: submittedPinTheme,
            pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
            showCursor: true,
            onCompleted: (pin) async {
              var regUser;
              isLoading = true;
              setState(() {});

              try {
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: LoginScreen.verify, smsCode: pin);

                // Sign the user in (or link) with the credential
                if (widget.purpose != 'update mobile') {
                  await FirebaseAuth.instance.signInWithCredential(credential);
                }

                //registerUser
                if (widget.purpose == 'registration') {
                  regUser = await registerUser();
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
                          regUser['message']!,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                  isLoading = false;
                  setState(() {});
                  if (regUser['status'] == true) {
                    // var prefs = await SharedPreferences.getInstance();
                    // var userDetails = json.encode(regUser['details']);

                    // var encodedMap = await prefs.setString(
                    //   'user-details',
                    //   userDetails,
                    // );

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (ctx) => const RegSuccessScreen(),
                      ),
                    );
                  }
                }

                model.User? user;

                //loginUser
                var loginUserData;
                if (widget.purpose == 'login') {
                  var userId = FirebaseAuth.instance.currentUser!.uid;

                  loginUserData = await loginUser(token);
                  user = model.User.fromJson(
                    loginUserData['details'],
                  );
                  if (loginUserData['status'] == true) {
                    try {
                      var prefs = await SharedPreferences.getInstance();
                      var userDetails = json.encode(loginUserData['details']);
                      var fcm = FirebaseMessaging.instance;
                      if (user.userType == 'customer') {
                        fcm.subscribeToTopic('customer');
                      } else {
                        fcm.subscribeToTopic('pilot');
                      }
                      var encodedMap = await prefs.setString(
                        'user-details',
                        userDetails,
                      );

                      userProvider.setUser(user);
                      if (user.userType == 'customer') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => HomeScreen(user: user),
                          ),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => PilotHomeScreen(user: user),
                          ),
                        );
                      }
                    } catch (e) {
                      print(e);
                    }
                  } else {
                    isLoading = false;
                    setState(() {});
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
                            'Something went wrong. User was not authenticated.',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                }

                print(widget.purpose);

                //updateUser
                if (widget.purpose == 'update mobile') {
                  await updateMobile();
                  Navigator.pop(context);
                }
              } catch (e) {
                print(e);
                isLoading = false;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 4),
                    elevation: 6,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                    content: Center(
                      child: Text(
                        e.toString(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
          ),
          SizedBox(
            height: 10,
          ),
          const SizedBox(height: 50),
          //Send again
          TextButton(
            onPressed: () async => sendAgain ? sendOTPAgain() : null,
            style: TextButton.styleFrom(
              foregroundColor: sendAgain
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade500,
            ),
            child: Text.rich(
              textAlign: TextAlign.center,
              TextSpan(
                  text: 'Send code again in\t',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    TextSpan(
                      text: '00:${start.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: 'min',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ]),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          TextButton(
              onPressed: () {
                if (widget.purpose == 'login') {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (ctx) => LoginScreen(),
                    ),
                  );
                } else if (widget.purpose == 'registration') {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (ctx) => SignupScreen(),
                    ),
                  );
                } else {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (ctx) => UpdatePhoneNumberScreen(),
                    ),
                  );
                }
              },
              child: Text(goBackText)),
          SizedBox(
            height: 50,
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
