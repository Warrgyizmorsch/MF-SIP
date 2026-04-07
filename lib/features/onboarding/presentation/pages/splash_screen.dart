import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/helper/helpers.dart';
import 'package:my_sip/features/authentication/data/models/auth_model.dart';
import 'package:my_sip/features/onboarding/presentation/pages/welcome_page.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/services/session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // Future<void> _checkAuthAndNavigate() async {
  //   // 1. Initialize data (Must happen on both Web and Mobile)
  //   await SessionManager.instance.initialize();
  //
  //   // 2. CONDITIONAL DELAY: Only wait 3 seconds if it is NOT Web
  //   if (!kIsWeb) {
  //     await Future.delayed(const Duration(seconds: 3));
  //   }
  //
  //   if (!mounted) return;
  //
  //   final bool loggedIn = SessionManager.instance.isAuthenticated();
  //
  //   if (loggedIn) {
  //     Get.offAllNamed(AppRoutes.navMenuBar);
  //   } else {
  //     // On Web, this will happen almost instantly
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => const WelcomePageScreen()),
  //     );
  //   }
  // }

  Future<void> _checkAuthAndNavigate() async {
    // 1. Initialize Session
    await SessionManager.instance.initialize();

    // 2. Only delay on Mobile
    if (!kIsWeb) {
      await Future.delayed(const Duration(seconds: 3));
    }

    if (!mounted) return;

    // 🚀 --- WEB AUTO-LOGIN SYNC LOGIC --- 🚀
    // Flutter check karega ki local storage mein Next.js ne data rakha hai ya nahi
    // if (kIsWeb) {
    //   try {
    //     final prefs = await SharedPreferences.getInstance();

    //     // Flutter natively reads "flutter.jwtAccessToken" when you ask for "jwtAccessToken"
    //     final String? webToken = prefs.getString('jwtAccessToken');
    //     final String? webUserDataString = prefs.getString('userData');

    //     if (webToken != null && webToken.isNotEmpty && webUserDataString != null) {
    //       createLog("Web Sync: Token found, auto-logging in!");

    //       final Map<String, dynamic> webUserJson = jsonDecode(webUserDataString);

    //       // Force update the SessionManager with Next.js data
    //       // Ensure UserModel.fromJson() matches your actual model method
    //       await SessionManager.instance.setSession(
    //         jwtAccessToken: webToken,
    //         userData: UserModel.fromJson(webUserJson),
    //       );
    //     }
    //   } catch (e) {
    //     createLog("Web Auto-Login Sync Error: $e");
    //   }
    // }

    final bool loggedIn = SessionManager.instance.isAuthenticated();

    if (loggedIn) {
      // User is logged in -> Go Home
      Get.offAllNamed(AppRoutes.navMenuBar);
    } else {
      // User is NOT logged in
      if (kIsWeb) {
        // --- WEB SPECIFIC LOGIC ---
        // Skip 'WelcomePageScreen' entirely and go to Login
        Get.offAllNamed(AppRoutes.login);
      } else {
        // --- MOBILE LOGIC ---
        // Show the Welcome/Intro screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WelcomePageScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 3. CLEANER WEB UI:
    // If on Web, show a simple spinner to prevent the "Mobile Splash" images
    // from flashing for a split second before the redirect.
    if (kIsWeb) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(), // Or your custom loader
        ),
      );
    }

    // 4. EXISTING MOBILE UI
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Transform.translate(
              offset: const Offset(10, -10),
              child: Image.asset(UImages.topright),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Transform.translate(
              offset: const Offset(-10, 10),
              child: Image.asset(UImages.buttomleft),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(child: Image.asset(UImages.imp, width: 157, height: 133)),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'MF SIP by ',
                      style: TextStyle(
                        color: Ucolors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    TextSpan(
                      text: 'Ridit Finworld',
                      style: TextStyle(color: Ucolors.primary, fontSize: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
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
