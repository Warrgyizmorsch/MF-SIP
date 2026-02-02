import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/features/onboarding/presentation/pages/welcome_page.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/services/session_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // 1. Load the session data from storage (SecureStorage/SharedPrefs)
    await SessionManager.instance.initialize();

    // 2. Wait for your animation/timer
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return; // specific check to prevent errors if user closes app

    // 3. Check authentication with correct logic
    if (SessionManager.instance.isAuthenticated()) {
      // User is logged in -> Go to Home
      // Get.offAllNamed removes the Splash from back stack so back button exits app
      Get.offAllNamed(AppRoutes.navMenuBar);
    } else {
      // User is NOT logged in -> Go to Welcome
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomePageScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Transform.translate(
              offset: Offset(10, -10),
              child: Image.asset(UImages.topright),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Transform.translate(
              offset: Offset(-10, 10),
              child: Image.asset(UImages.buttomleft),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(child: Image.asset(UImages.imp, width: 157, height: 133)),
              SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'MY SIP by ',
                      style: TextStyle(
                        color: Ucolors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    TextSpan(
                      text: 'Riddit Finworld',
                      style: TextStyle(color: Ucolors.primary, fontSize: 18),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              LoadingAnimationWidget.hexagonDots(
                color: Ucolors.primary,
                size: 50,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
