import 'package:flutter/material.dart';
import 'package:flutter_to_do_list/screen/sign_up.dart'; // Perbaikan typo dari "SingUP.dart"
import 'package:flutter_to_do_list/screen/login.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLoginScreen = true;

  void toggleScreen() {
    setState(() {
      isLoginScreen = !isLoginScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoginScreen ? LoginScreen(toggleScreen) : SignUpScreen(toggleScreen);
  }
}
