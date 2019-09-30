import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sw_quiz_app/ui/homepage.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.redAccent,
        child: Text(
          "Welcome to Sw_Quiz",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 30.0),
        ),
      ),
    );
  }
}
