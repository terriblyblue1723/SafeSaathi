import 'dart:async';
import 'package:flutter/material.dart';
import 'package:women_safety_app/landingpage.dart';

class Splash extends StatefulWidget {
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => EmergencyPage(), // Replace with your landing page widget
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(239,242,249,255),
      body: Container(
        child: Center(
          child: Image.asset(
            'assets/images/splash.png',
            height: 150,
            width: 150,
          ),
        ),
      ),
    );
  }
}