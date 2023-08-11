import 'package:country_code_picker/country_code_picker.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:sterling/services/services.dart';
import 'package:sterling/views/common_screens/enter_code_screen/enter_code_screen.dart';
import '../../global_utils/global_export.dart';

class UpdatePhoneNumberScreen extends StatefulWidget {
  const UpdatePhoneNumberScreen({super.key});

  static String verify = '';

  @override
  State<UpdatePhoneNumberScreen> createState() =>
      _UpdatePhoneNumberScreenState();
}

class _UpdatePhoneNumberScreenState extends State<UpdatePhoneNumberScreen> {
  TextEditingController phone = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();
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
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              )
            : Stack(
                clipBehavior: Clip.none,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset(
                      'assets/images/profdeg.png',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 10,
                    child: BackButtonWidget(),
                  ),
                  Positioned(
                    top: 0,
                    left: 21,
                    bottom: 0,
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Heading(headingText: 'Update Phone Number'),
                            const SizedBox(height: 80),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 42,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //country code
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Code*',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        width: 80,
                                        // height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: TextFormField(
                                          readOnly: true,
                                          onTap: () async {
                                            var code =
                                                await _countryPicker.showPicker(
                                              context: context,
                                              scrollToDeviceLocale: true,
                                              initialSelectedLocale: 'in',
                                              fullScreen: true,
                                            );

                                            countryCodeController.text =
                                                code!.dialCode;
                                          },
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          validator: (value) {
                                            if (value == null) {
                                              return 'This field cannot be empty';
                                            } else if (value.isEmpty) {
                                              return 'This field cannot be empty';
                                            }
                                          },
                                          controller: countryCodeController,
                                          keyboardType: TextInputType.phone,
                                          cursorColor:
                                              Theme.of(context).primaryColor,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
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
                                            //   initialSelection:
                                            //       "IN", //default is it
                                            //   showCountryOnly: true,
                                            //   showOnlyCountryWhenClosed: false,
                                            // ),
                                            hintText: '+00',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                color: Color(0xfff4f4f4),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Phone Number',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                42 -
                                                80 -
                                                10,
                                        height: 50,
                                        child: TextField(
                                          controller: phone,
                                          keyboardType: TextInputType.phone,
                                          cursorColor:
                                              Theme.of(context).primaryColor,
                                          decoration: InputDecoration(
                                            hintText: 'Your Phone Number',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                color: Color(0xfff4f4f4),
                                              ),
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 10),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                          onEditingComplete: () {
                                            if (phone.text.length < 7 ||
                                                phone.text.length > 15) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Center(
                                                    child: Text(
                                                        'Invalid Phone Number'),
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 50,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: ThemeButton(
                        buttonText: 'Get OTP Verification',
                        onTap: () async {
                          isLoading = true;
                          setState(() {});

                          if (phone.text.length != 10) {
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
                                    'Invalid phone number',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            await FirebaseAuth.instance.verifyPhoneNumber(
                              phoneNumber: '+91${phone.text}',
                              verificationCompleted:
                                  (PhoneAuthCredential credential) {},
                              verificationFailed: (FirebaseAuthException e) {},
                              codeSent:
                                  (String verificationId, int? resendToken) {
                                UpdatePhoneNumberScreen.verify = verificationId;
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: const Duration(seconds: 2),
                                    elevation: 6,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
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
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (ctx) => EnterCodeScreen(
                                      phone: phone.text,
                                      purpose: 'update mobile',
                                      mobile: phone.text,
                                      countryCode: countryCodeController.text,
                                    ),
                                  ),
                                );
                              },
                              codeAutoRetrievalTimeout:
                                  (String verificationId) {},
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
