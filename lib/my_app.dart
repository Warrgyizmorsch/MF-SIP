import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/bindings/bindings.dart';
import 'package:my_sip/core/utils/theme/theme.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'config/routes/app_pages.dart';

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
        initialRoute: AppRoutes.splash,
        builder: (context, widget) => ResponsiveBreakpoints.builder(
          child: ClampingScrollWrapper.builder(context, widget!),
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        ),
      ),
    );
  }
}
