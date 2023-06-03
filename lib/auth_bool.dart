import 'package:injection_center_management/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:injection_center_management/screens/login_screen.dart';
import 'package:injection_center_management/screens/register_screen.dart';

class AuthBool extends StatefulWidget {
  _AuthBoolState createState() => _AuthBoolState();
}

class _AuthBoolState extends State<AuthBool> {
  bool showLoginScreen = true;

  void toggleScreens() {
    setState(() {
      showLoginScreen = !showLoginScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginScreen == true) {
      return LoginScreen(
        showRegisterPage: toggleScreens,
      );
    } else {
      return RegisterScreen(
        showLoginScreen: toggleScreens,
      );
    }
  }
}
