import 'dart:async';

import 'package:flutter/material.dart';
import 'package:news_watch/screens/main_screen.dart';
import 'package:news_watch/style/theme.dart' as style;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Image(
                  width: 200.0,
                  image: AssetImage("assets/icon.png")
              ),
            ),
          ],
        ),
      ),
    );
  }
}