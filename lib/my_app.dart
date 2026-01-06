import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/core/bindings/bindings.dart';
import 'package:my_sip/core/utils/theme/theme.dart';

import 'features/onboarding/presentation/pages/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'My SIP',
      // theme: ThemeData(
      //   bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.white),
      //   fontFamily: 'Geist',
      //   scaffoldBackgroundColor: Colors.white,
      //   appBarTheme: AppBarTheme(
      //     backgroundColor: Colors.white,
      //     surfaceTintColor: Colors.white,
      //   ),
      // ),
      theme: Utheme.lightTheme,
      initialBinding: UBinding(),
      home: SplashScreen(),

      // home: VerifyPanOtp(),
      // home: QuestionScreen(),
      // home: ComparisonScreen(),
      // home: NavigationMenuBar(),
      // home: FundComparisonScreen(),
      // home: FundDeatailsScreen(),
      // home: NipponFundDetailScreen(),
    );
  }
}
