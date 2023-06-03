import 'package:injection_center_management/ad_screens/ad_home_screen.dart';
import 'package:injection_center_management/ad_screens/confirm_doctor.dart';

import 'package:injection_center_management/auth_bool.dart';
import 'package:injection_center_management/logIn_approve.dart';
import 'package:injection_center_management/screens/home_screen.dart';
import 'package:injection_center_management/screens/login_screen.dart';
import 'package:injection_center_management/screens/update_info_screen.dart';
import 'package:injection_center_management/screens/user_info_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future main(List<String> args) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      home: const logInApprove(),
      theme: ThemeData(
        textTheme: const TextTheme(
          headline1: TextStyle(
              fontSize: 24.0, fontWeight: FontWeight.w600, color: Colors.white),
          bodyText1: TextStyle(
              fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.black),
          bodyText2: TextStyle(
              fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      initialRoute: '/Login',
      routes: {
        '/Login': (context) => logInApprove(),
        '/Home': (context) => const HomeScreen(),
        '/UserInfo': (context) => const UserInfo(),
        '/UpdateInfo': (context) => const UpdateInfo(),
        '/AdminInfo': (context) => const ConfirmDocID(),
        '/AdminHome': (context) => AdminHomeScreen(i: 0),
      },
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
