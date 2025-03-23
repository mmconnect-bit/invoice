import 'dart:async';
import 'package:admin/controllers/menu_app_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'main_screen.dart'; // Update this with your actual import

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  double _scale = 0.5;

  @override
  void initState() {
    super.initState();

    // Start the logo scaling animation
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        _scale = 1.0;
      });
    });

    // After 3 seconds, go to MainScreen
    Future.delayed(Duration(seconds: 3), () {
      Get.off(() => MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => MenuAppController(),
              ),
            ],
            child: MainScreen(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Use your brand color if needed
      body: Center(
        child: AnimatedScale(
          scale: _scale,
          duration: Duration(seconds: 2),
          curve: Curves.easeOutBack,
          child: Image.asset(
            'assets/images/logo.png', // Replace with your logo asset
            width: 150,
            height: 150,
          ),
        ),
      ),
    );
  }
}
