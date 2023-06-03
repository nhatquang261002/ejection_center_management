import 'package:injection_center_management/auth_bool.dart';
import 'package:injection_center_management/screens/home_screen.dart';
import 'package:injection_center_management/auth_bool.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class logInApprove extends StatefulWidget {
  const logInApprove({super.key});

  @override
  State<logInApprove> createState() => _logInApproveState();
}

class _logInApproveState extends State<logInApprove> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomeScreen();
          } else {
            return AuthBool();
          }
        },
      ),
    );
  }
}
