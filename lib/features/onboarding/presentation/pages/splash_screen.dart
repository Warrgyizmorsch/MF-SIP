import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/helper/helpers.dart';
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
    // 1. Initialize and WAIT for data to be read from disk
    await SessionManager.instance.initialize();

    // 2. Wait for your branding delay
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // 3. Use the manager's state directly
    final bool loggedIn = SessionManager.instance.isAuthenticated();

    createLog("Is User Authenticated: $loggedIn");

    if (loggedIn) {
      createLog("Navigating to Home");
      // If using GetX, ensure GetMaterialApp is used in main.dart
      Get.offAllNamed(AppRoutes.navMenuBar);
    } else {
      createLog("Navigating to Welcome");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomePageScreen()),
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
