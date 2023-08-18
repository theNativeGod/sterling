import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:sterling/views/common_screens/login_screen/login_screen.dart';
import '../../../models/company.dart';
import '../../../services/services.dart';
import '../../global_utils/small_logo.dart';
import '../../global_utils/theme_button.dart';
import '../enter_code_screen/enter_code_screen.dart';
import 'utils/export.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  static var check = 0;

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController employeeIdController = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  bool isInit = true;
  List<Company> compList = [];
  List<DropdownMenuItem> compItemList = [];
  int selectedValue = 0;

  Services services = Services();

  getCompList() async {
    compList = await services.getCompanyList();
    print(compList);

    for (int i = 0; i < compList.length; i++) {
      compItemList.add(
        DropdownMenuItem(
          value: i,
          child: Text(
            compList[i].name,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ),
      );
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    countryCodeController.text = '+91';
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      getCompList();
    }
    isInit = false;
    super.didChangeDependencies();
  }

  _submitForm() async {
    if (_formKey.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      bool exists = await services.checkUserRegistration(phoneController.text);
      if (exists == true) {
        isLoading = false;
        setState(() {});
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
            content: const Center(
              child: Text(
                'The user already exists',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      } else {
        try {
          await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: '${countryCodeController.text}${phoneController.text}',
            verificationCompleted: (PhoneAuthCredential credential) {},
            verificationFailed: (FirebaseAuthException e) {
              isLoading = false;
              setState(() {});

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
                      e.toString(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
            codeSent: (String verificationId, int? resendToken) {
              LoginScreen.verify = verificationId;
              print('here');
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
                      'OTP sent',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
              isLoading = false;
              setState(() {});
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => EnterCodeScreen(
                    countryCode: countryCodeController.text,
                    phone: phoneController.text,
                    purpose: 'registration',
                    name: nameController.text,
                    email: emailController.text,
                    company: compList[selectedValue],
                    employeeId: employeeIdController.text,
                    mobile: '+91${phoneController.text}',
                  ),
                ),
              );
            },
            codeAutoRetrievalTimeout: (String verificationId) {},
          );
        } catch (e) {
          isLoading = false;
          setState(() {});
          print('error submiting form');
          print(e);
        }
      }
    }
  }

  final _countryPicker = const FlCountryCodePicker();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .1,
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SmallLogo(),
                    const Text(
                      'Create account',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 40),
                    TextFieldWidget(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Name is mandatory!!!';
                        }
                      },
                      controller: nameController,
                      headingText: 'Full Name*',
                      hintText: 'Your full name',
                      textInputType: TextInputType.name,
                    ),
                    SizedBox(
                      height: height * .02,
                    ),
                    TextFieldWidget(
                      validator: (value) {
                        if (value.isNotEmpty && !value.contains('@')) {
                          return 'This is not a valid email!!!';
                        }
                      },
                      controller: emailController,
                      headingText: 'Email',
                      hintText: 'Your Email',
                      textInputType: TextInputType.emailAddress,
                    ),
                    SizedBox(
                      height: height * .02,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 42,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 80,
                            child: TextFieldWidget(
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
                              controller: countryCodeController,
                              headingText: 'Code*',
                              hintText: '+00',
                              textInputType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Mandatory';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width -
                                42 -
                                80 -
                                10,
                            child: TextFieldWidget(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Phone Number is required!!!';
                                } else if (value.length < 7 ||
                                    value.length > 15) {
                                  return 'This is not a valid phone number!!!';
                                }
                              },
                              controller: phoneController,
                              headingText: 'Phone Number*',
                              hintText: 'Your phone number',
                              textInputType: TextInputType.phone,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * .02,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Company Name',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 42,
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: const Color.fromARGB(255, 140, 140, 140),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          child: DropdownButton(
                            hint: Text('Your Company Name'),
                            isExpanded: true,
                            onChanged: (value) {
                              selectedValue = value;
                              setState(() {});
                            },
                            borderRadius: BorderRadius.circular(10),
                            elevation: 2,
                            dropdownColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            underline: Container(),
                            value: selectedValue,
                            items: [...compItemList],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * .02,
                    ),
                    TextFieldWidget(
                      controller: employeeIdController,
                      headingText: 'Employee Id',
                      hintText: 'Your Employee Id',
                      textInputType: TextInputType.text,
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
                            buttonText: 'Create Account',
                            onTap: () async {
                              await _submitForm();
                            }),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      textAlign: TextAlign.center,
                      'Already have an account? ',
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (c) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        textAlign: TextAlign.center,
                        'Sign in',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
