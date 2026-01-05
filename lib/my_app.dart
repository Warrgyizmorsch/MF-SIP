import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/binding/bindings.dart';
import 'package:my_sip/features/authentication/screen/onboarding/splash_screen.dart';
import 'package:my_sip/features/mf/screen/fund_details/fund_deatails.dart';
import 'package:my_sip/navigation_menu_bar.dart';
import 'package:my_sip/utils/theme/theme.dart';

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
