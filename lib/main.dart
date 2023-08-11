import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sterling/view_models/dashboard_view.dart';
import 'package:sterling/view_models/history_view.dart';
import 'package:sterling/view_models/notification_provider.dart';
import 'package:sterling/view_models/payment_view.dart';
import 'package:sterling/view_models/user_view.dart';
import 'package:sterling/views/common_screens/landing_screen/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
   
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => PaymentView(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => NotificationsProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => DashboardView(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => UserView(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => HistoryView(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sterling',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          appBarTheme: const AppBarTheme(
            color: Color.fromRGBO(249, 57, 52, 1),
            elevation: 0,
          ),
          fontFamily: 'Inter',
          scaffoldBackgroundColor: const Color(0xffffffff),
          primaryColor: const Color.fromRGBO(249, 57, 52, 1),
          dividerColor: Colors.black,
          cardColor: Color(0xffF4F4F4),
        ),
        home: SplashScreen(),
      ),
    );
  }
}
