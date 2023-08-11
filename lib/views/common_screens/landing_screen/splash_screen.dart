import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sterling/view_models/user_view.dart';
import 'package:sterling/views/customer_screens/explore_screen.dart/explore_screen.dart';
import 'package:sterling/views/customer_screens/home_screen/home_screen.dart';
import 'package:sterling/views/pilot_screens/pilot_home_screen/pilot_home_screen.dart';

import '../../../models/user.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  bool isInit = true;

  @override
  void didChangeDependencies() {
    if (isInit) {
      timeTicker(context);
      getString();
    }
    isInit = false;
    super.didChangeDependencies();
  }

  Timer? timeTick;
  bool prefsDone = false;
  bool userPresent = false;
  var decodedMap;

  void timeTicker(context) {
    timeTick = Timer.periodic(Duration(seconds: 1), (timer) {
      if (userPresent == true && prefsDone == true) {
        var user = User.fromJson(
          decodedMap,
        );

        Provider.of<UserView>(context, listen: false).setUser(user);
        if (user.userType == 'customer') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (ctx) => HomeScreen(user: user),
            ),
          );
        } else {
        
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (ctx) => PilotHomeScreen(user: user),
            ),
          );
        }
      } else if (timer.tick >= 3 && prefsDone == true) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) => const ExploreScreen(),
          ),
        );
      }
    });
  }

  void getString() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      var encodedMap = await prefs.getString('user-details');
      decodedMap = json.decode(encodedMap!);

      print(decodedMap);
      if (decodedMap['user_id'] > 0) {
        userPresent = true;
      }
      prefsDone = true;
    } catch (e) {
      print(e);
      prefsDone = true;
    }
  }

  @override
  void dispose() {
    timeTick!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffffffff),
        body: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
            Positioned(
              bottom: 0,
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset('assets/images/splash_img.png',
                      fit: BoxFit.fitWidth)),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * .25,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Image.asset('assets/images/logo_splash.png'),
                  const SizedBox(height: 10),
                  const Text(
                    'Sterling Tours & Travels Inc',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
