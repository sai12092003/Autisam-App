import 'package:flutter/material.dart';
import 'dart:async';

import 'intropage/authnaviagte.dart';
import 'loginoptions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay for 1.5 seconds and then navigate to the Video screen
    Timer(Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => AuthPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/splash.jpeg'), // Use the path to your image
            fit: BoxFit.cover, // You can adjust this property as needed
          ),
        ),
        child: Center(
          // You can add other widgets or content here
        ),
      ),
    );
  }
}


