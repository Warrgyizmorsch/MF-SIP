import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/features/onboarding/presentation/pages/welcome_page.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/services/session_manager.dart';
import 'package:my_sip/services/firebase_services.dart';

import '../../../../core/app_config/service/app_config_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  static const _logoNavy = Color(0xFF07315C);
  static const _logoBlue = Color(0xFF0280C0);
  late final AnimationController _entrance;
  late final AnimationController _ambient;
  late final Animation<double> _logoReveal;
  late final Animation<double> _logoScale;
  late final Animation<double> _textReveal;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _loaderReveal;
  bool _reduceMotion = false;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _ambient = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
    _logoReveal = _entrance.drive(
      CurveTween(curve: const Interval(0, 0.55, curve: Curves.easeOut)),
    );
    _logoScale = Tween<double>(begin: 0.86, end: 1).animate(
      _entrance.drive(
        CurveTween(curve: const Interval(0, 0.65, curve: Curves.easeOutCubic)),
      ),
    );
    _textReveal = _entrance.drive(
      CurveTween(curve: const Interval(0.3, 0.8, curve: Curves.easeOut)),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(_textReveal);
    _loaderReveal = _entrance.drive(
      CurveTween(curve: const Interval(0.6, 1, curve: Curves.easeOut)),
    );
    _checkAuthAndNavigate();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.disableAnimationsOf(context) || kIsWeb;
    if (_reduceMotion) {
      _entrance.stop();
      _entrance.value = 1;
      _ambient.stop();
      _ambient.value = 0;
    } else {
      if (!_entrance.isCompleted && !_entrance.isAnimating) _entrance.forward();
      if (!_ambient.isAnimating) _ambient.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _entrance.dispose();
    _ambient.dispose();
    super.dispose();
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

    // 2. Evaluate App Config & Runtime Gating
    await AppConfigService.instance.checkConfig();

    if (!mounted) return;

    // Maintenance Mode Guard
    if (AppConfigService.instance.isMaintenanceActive) {
      Get.offAllNamed(AppRoutes.maintenance);
      return;
    }

    // Mandatory Force Update Guard
    if (AppConfigService.instance.isForceUpdateRequired) {
      Get.offAllNamed(AppRoutes.updateRequired);
      return;
    }

    // 3. Only delay on Mobile
    if (!kIsWeb) {
      await Future.delayed(const Duration(seconds: 2));
    }

    if (!mounted) return;

    final bool loggedIn = SessionManager.instance.isAuthenticated();

    if (loggedIn) {
      // Sync FCM token on app launch / session restore
      if (Get.isRegistered<NotificationService>()) {
        Get.find<NotificationService>().syncTokenWithBackend();
      }
      // User is logged in -> Go Home
      // Get.offAllNamed(AppRoutes.navMenuBar);
      Get.offAllNamed(kIsWeb ? AppRoutes.home : AppRoutes.navMenuBar);
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

  // Future<void> _checkAuthAndNavigate() async {
  //   // 1. Initialize Session
  //   await SessionManager.instance.initialize();

  //   // 2. Only delay on Mobile
  //   if (!kIsWeb) {
  //     await Future.delayed(const Duration(seconds: 3));
  //   }

  //   if (!mounted) return;

  //   final bool loggedIn = SessionManager.instance.isAuthenticated();

  //   if (loggedIn) {
  //     Get.offAllNamed(AppRoutes.navMenuBar);

  //     if (kIsWeb) {
  //       Future.delayed(const Duration(milliseconds: 100), () {
  //         if (Get.isRegistered<NavigationBarController>()) {
  //           Get.find<NavigationBarController>().selectedIndex.value = 100;
  //         }
  //         Get.toNamed(AppRoutes.cart, id: 1);
  //       });
  //     }
  //   } else {
  //     if (kIsWeb) {
  //       // --- WEB SPECIFIC LOGIC ---
  //       Get.offAllNamed(AppRoutes.login);
  //     } else {
  //       // --- MOBILE LOGIC ---
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => const WelcomePageScreen()),
  //       );
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: _logoBlue)),
      );
    }
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFE),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Color(0xFFF0F8FD), Color(0xFFEAF3FA)],
              ),
            ),
          ),
          IgnorePointer(
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: _ambient,
                builder: (context, child) => Stack(
                  children: [
                    Positioned(
                      top: -110 + _ambient.value * 20,
                      right: -100 - _ambient.value * 12,
                      child: _glow(320, _logoBlue.withValues(alpha: 0.09)),
                    ),
                    Positioned(
                      bottom: -130 - _ambient.value * 16,
                      left: -110 + _ambient.value * 20,
                      child: _glow(340, _logoNavy.withValues(alpha: 0.07)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, bounds) {
                final logoWidth = (bounds.maxWidth * 0.40).clamp(110.0, 180.0);
                return Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FadeTransition(
                          opacity: _logoReveal,
                          child: ScaleTransition(
                            scale: _logoScale,
                            child: RepaintBoundary(
                              child: AnimatedBuilder(
                                animation: _ambient,
                                child: Image.asset(
                                  UImages.imp,
                                  width: logoWidth,
                                  height: logoWidth,
                                  fit: BoxFit.contain,
                                  semanticLabel: 'MF SIP logo',
                                ),
                                builder: (context, child) =>
                                    Transform.translate(
                                      offset: Offset(
                                        0,
                                        _reduceMotion ? 0 : -4 * _ambient.value,
                                      ),
                                      child: SizedBox(
                                        width: logoWidth + 64,
                                        height: logoWidth + 64,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              width:
                                                  logoWidth +
                                                  48 +
                                                  12 * _ambient.value,
                                              height:
                                                  logoWidth +
                                                  48 +
                                                  12 * _ambient.value,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: _logoBlue.withValues(
                                                    alpha:
                                                        0.05 +
                                                        0.03 * _ambient.value,
                                                  ),
                                                ),
                                                gradient: RadialGradient(
                                                  colors: [
                                                    _logoBlue.withValues(
                                                      alpha: 0.05,
                                                    ),
                                                    Colors.transparent,
                                                  ],
                                                ),
                                              ),
                                            ),
                                            child!,
                                          ],
                                        ),
                                      ),
                                    ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        FadeTransition(
                          opacity: _textReveal,
                          child: SlideTransition(
                            position: _textSlide,
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'MFSIP by ',
                                    style: TextStyle(
                                      color: _logoNavy,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Kriti Hinger',
                                    style: TextStyle(
                                      color: Ucolors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 18,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        FadeTransition(
                          opacity: _loaderReveal,
                          child: _reduceMotion
                              ? const SizedBox(
                                  width: 36,
                                  child: Divider(
                                    color: _logoBlue,
                                    thickness: 3,
                                  ),
                                )
                              : LoadingAnimationWidget.hexagonDots(
                                  color: _logoBlue,
                                  size: 36,
                                ),
                        ),
                        const SizedBox(height: 28),
                        // FadeTransition(
                        //   opacity: _loaderReveal,
                        //   child: Text.rich(
                        //     TextSpan(
                        //       children: [
                        //          TextSpan(
                        //           text: 'Developed by\n',
                        //           style: TextStyle(
                        //             fontSize: 11,
                        //             color: Colors.grey.withAlpha(90),
                        //           ),
                        //         ),
                        //         TextSpan(
                        //           text: 'Warrgyizmorsch Pvt Ltd',
                        //           style: TextStyle(
                        //             fontSize: 13,
                        //             color: Colors.grey.withAlpha(200),
                        //             fontWeight: FontWeight.w600,
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //     textAlign: TextAlign.center,
                        //     style: const TextStyle(
                        //       fontFamily: 'Plus Jakarta Sans',
                        //       height: 1.6,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _glow(double size, Color color) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
    ),
  );
}
