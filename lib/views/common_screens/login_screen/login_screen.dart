import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:sterling/services/services.dart';
import 'package:sterling/views/common_screens/enter_code_screen/enter_code_screen.dart';
import 'package:sterling/views/common_screens/signup_screen/signup_screen.dart';
import '../../global_utils/global_export.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static String verify = '';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phone = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Pattern pattern = r'/^\(?(\d{3})\)?[- ]?(\d{3})[- ]?(\d{4})$/';
  bool isLoading = false;
  final _countryPicker = const FlCountryCodePicker();
  @override
  void initState() {
    super.initState();
    countryCodeController.text = '+91';
  }

  Services services = Services();

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
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SmallLogo(),
                    Heading(headingText: 'Login in to account'),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 42,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //country code
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Code*',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: 80,
                                // height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),

                                child: TextFormField(
                                  readOnly: true,
                                  onTap: () async {
                                    var code = await _countryPicker.showPicker(
                                      context: context,
                                      scrollToDeviceLocale: true,
                                      initialSelectedLocale: 'in',
                                      fullScreen: true,
                                    );

                                    countryCodeController.text = code!.dialCode;
                                  },
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value == null) {
                                      return 'This field cannot be empty';
                                    } else if (value.isEmpty) {
                                      return 'This field cannot be empty';
                                    }
                                  },
                                  controller: countryCodeController,
                                  keyboardType: TextInputType.phone,
                                  cursorColor: Theme.of(context).primaryColor,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 0,
                                      vertical: 1,
                                    ),

                                    prefixIconConstraints:
                                        BoxConstraints(minWidth: 10),
                                    // prefixIcon: CountryCodePicker(
                                    //   //it is used to find country code and flage symbol
                                    //   padding: EdgeInsets.zero,
                                    //   alignLeft: true,
                                    //   hideMainText: true,
                                    //   onChanged: (country) {
                                    //     countryCodeController.text =
                                    //         country.dialCode!;
                                    //   },

                                    //   flagWidth: 30,
                                    //   initialSelection: "IN", //default is it
                                    //   showCountryOnly: true,
                                    //   showOnlyCountryWhenClosed: false,
                                    // ),
                                    hintText: '+00',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Color(0xfff4f4f4),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          //phone number
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Phone Number*',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width - 80 - 52,
                                // height: 50,
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value == null) {
                                      return 'This field cannot be empty';
                                    } else if (value.isEmpty) {
                                      return 'This field cannot be empty';
                                    } else if (value.length < 7 ||
                                        value.length > 15) {
                                      return 'Invalid Phone Number';
                                    }
                                  },
                                  controller: phone,
                                  keyboardType: TextInputType.phone,
                                  cursorColor: Theme.of(context).primaryColor,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 1,
                                    ),
                                    hintText: 'Your Phone Number',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Color(0xfff4f4f4),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    isLoading
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width - 42,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          )
                        : ThemeButton(
                            buttonText: 'Login',
                            onTap: () async {
                              try {
                                if (_formKey.currentState != null) {
                                  if (_formKey.currentState!.validate()) {
                                    print('form state validate');
                                    isLoading = true;
                                    setState(() {});
                                    print('checkuserregistration');
                                    bool exists = await services
                                        .checkUserRegistration(phone.text);
                                    print('checked');
                                    if (exists == false) {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          duration: const Duration(seconds: 2),
                                          elevation: 6,
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          content: const Center(
                                            child: Text(
                                              'The user does not exists. Signup instead',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                      isLoading = false;
                                      setState(() {});
                                    } else {
                                      print('user exists');
                                      try {
                                        print('verfying phone number');
                                        await FirebaseAuth.instance
                                            .verifyPhoneNumber(
                                          phoneNumber: '+91${phone.text}',
                                          verificationCompleted:
                                              (PhoneAuthCredential credential) {
                                            print('verification completed');
                                          },
                                          verificationFailed:
                                              (FirebaseAuthException e) {
                                            print('verification failed');
                                            ScaffoldMessenger.of(context)
                                                .hideCurrentSnackBar();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                duration:
                                                    const Duration(seconds: 2),
                                                elevation: 6,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .primaryColor,
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
                                            isLoading = false;
                                            setState(() {});
                                          },
                                          codeSent: (String verificationId,
                                              int? resendToken) {
                                            LoginScreen.verify = verificationId;
                                            ScaffoldMessenger.of(context)
                                                .hideCurrentSnackBar();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                duration:
                                                    const Duration(seconds: 2),
                                                elevation: 6,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .primaryColor,
                                                content: Center(
                                                  child: Text(
                                                    'OTP sent',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                builder: (ctx) =>
                                                    EnterCodeScreen(
                                                  phone: phone.text,
                                                  purpose: 'login',
                                                  mobile: phone.text,
                                                  countryCode:
                                                      countryCodeController
                                                          .text,
                                                ),
                                              ),
                                            );
                                          },
                                          codeAutoRetrievalTimeout:
                                              (String verificationId) {
                                            print('time out');
                                          },
                                        );
                                      } catch (e) {
                                        print('error firebase otp');
                                        print(e);
                                      }
                                    }
                                  }
                                }
                              } catch (e) {
                                print('print error login button');
                                print(e);
                                isLoading = false;
                                setState(() {});
                              }
                            },
                          ),
                    SizedBox(height: 50),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 42,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              textAlign: TextAlign.center,
                              'Don\'t have an account? ',
                              style: TextStyle(fontWeight: FontWeight.w300),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (c) => const SignupScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                textAlign: TextAlign.center,
                                'Sign up',
                                style: TextStyle(fontWeight: FontWeight.w900),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
