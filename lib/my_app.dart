// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get_navigation/src/root/get_material_app.dart';
// import 'package:responsive_framework/responsive_framework.dart';
// import 'config/routes/app_pages.dart';
// import 'config/routes/app_routes.dart';
// import 'core/bindings/bindings.dart';
// import 'core/utils/theme/theme.dart';

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(390, 844),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       builder: (context, child) {
//         return GetMaterialApp(
//           debugShowCheckedModeBanner: false,
//           title: 'My SIP',
//           theme: Utheme.lightTheme,
//           initialBinding: UBinding(),
//           getPages: AppPages.pages(),
//           initialRoute: AppRoutes.splash,
//           builder: (context, widget) {
//             return ResponsiveBreakpoints.builder(
//               child: Builder(
//                 builder: (innerContext) {
//                   // Just return the widget directly to allow it to fill the screen
//                   return widget!;

//                   // OR, if you need a background color for the "scaffold" area:
//                   // return Container(
//                   //   color: const Color(0xffF5F5F5),
//                   //   child: widget!,
//                   // );
//                 },
//               ),
//               breakpoints: [
//                 const Breakpoint(start: 0, end: 450, name: MOBILE),
//                 const Breakpoint(start: 451, end: 800, name: TABLET),
//                 const Breakpoint(start: 801, end: 1920, name: DESKTOP),
//                 const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/services/session_manager.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'config/routes/app_pages.dart';
import 'config/routes/app_routes.dart';
import 'core/bindings/bindings.dart';
import 'core/utils/theme/theme.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final LocalAuthentication auth = LocalAuthentication();

  bool _isAuthenticating = false;
  bool _hasUnlockedThisSession = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Initial launch authentication
    _authenticate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  final session = SessionManager.instance;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // When the app is fully hidden (paused), reset the session lock
    if (state == AppLifecycleState.paused) {
      _hasUnlockedThisSession = false;
    }

    // // Trigger auth when returning to the app if not already unlocked
    // if (state == AppLifecycleState.resumed && !_hasUnlockedThisSession) {
    //   _authenticate();
    // }

    // Trigger only if APP LOCK IS ENABLED in session
    if (state == AppLifecycleState.resumed &&
        session.isAppLockEnabled.value &&
        !_hasUnlockedThisSession) {
      _authenticate();
    }
  }

  Future<void> _authenticate() async {
    // Guard check: If lock is disabled, mark as unlocked and return
    if (!session.isAppLockEnabled.value) {
      setState(() => _hasUnlockedThisSession = true);
      return;
    }
    if (_isAuthenticating) return;

    try {
      setState(() => _isAuthenticating = true);

      // check hardware and enrollment status
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await auth.isDeviceSupported();

      if (!canAuthenticate) {
        setState(() {
          _isAuthenticating = false;
          _hasUnlockedThisSession = true; // Fallback so user isn't stuck
        });
        return;
      }

      // NEW 3.0.0 SYNTAX: Parameters are passed directly, not via AuthenticationOptions
      final bool authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to access My SIP',
        persistAcrossBackgrounding: true, // Renamed from stickyAuth
        biometricOnly: false, // Set to true to disable PIN/Passcode fallback
      );

      setState(() {
        _isAuthenticating = false;
        _hasUnlockedThisSession = authenticated;
      });
    } on LocalAuthException catch (e) {
      // Version 3.0.0 specific error handling
      debugPrint("Auth failed with code: ${e.code}");
      setState(() => _isAuthenticating = false);
    } catch (e) {
      debugPrint("Unexpected error: $e");
      setState(() => _isAuthenticating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: Utheme.lightTheme,
          initialBinding: UBinding(),
          getPages: AppPages.pages(),
          initialRoute: AppRoutes.splash,
          builder: (context, widget) {
            final mediaQueryData = MediaQuery.of(context);
            return MediaQuery(
              data: mediaQueryData.copyWith(
                textScaler: TextScaler.noScaling,
              ),
              child: ResponsiveBreakpoints.builder(
                child: Obx(
                  () => Stack(
                    children: [
                      // This is your background app
                      widget!,

                      // The system UI pop-up will appear over this blank screen
                      // if (!_hasUnlockedThisSession)
                      if (session.isAppLockEnabled.value &&
                          !_hasUnlockedThisSession)
                        Material(
                          color: Colors.transparent,
                          child: Container(
                            color: Colors.white,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    UImages.imp,
                                    alignment: Alignment.center,
                                    height: 100,
                                    width: 100,
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    "MF SIP Secured",
                                    style: TextStyle(


                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Ucolors.blue,
                                    ),
                                    onPressed: _authenticate,
                                    child: const Text(
                                      "Unlock with Biometrics",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                breakpoints: [
                  const Breakpoint(start: 0, end: 450, name: MOBILE),
                  const Breakpoint(start: 451, end: 800, name: TABLET),
                  const Breakpoint(start: 801, end: 1920, name: DESKTOP),
                  const Breakpoint(
                    start: 1921,
                    end: double.infinity,
                    name: '4K',
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
