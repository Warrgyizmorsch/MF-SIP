import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/bindings/bindings.dart';
import 'package:my_sip/core/utils/theme/theme.dart';

import 'config/routes/app_pages.dart';
import 'features/onboarding/presentation/pages/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
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
        initialRoute: AppRoutes.splash,
        getPages: AppPages.pages(),
      
        // home: VerifyPanOtp(),
        // home: QuestionScreen(),
        // home: ComparisonScreen(),
        // home: NavigationMenuBar(),
        // home: FundComparisonScreen(),
        // home: FundDeatailsScreen(),
        // home: NipponFundDetailScreen(),
      ),
    );
  }
}
