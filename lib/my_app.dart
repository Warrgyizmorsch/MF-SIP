import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'config/routes/app_pages.dart';
import 'config/routes/app_routes.dart';
import 'core/bindings/bindings.dart';
import 'core/utils/theme/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'My SIP',
          theme: Utheme.lightTheme,
          initialBinding: UBinding(),
          getPages: AppPages.pages(),
          initialRoute: AppRoutes.splash,
          builder: (context, widget) {
            return ResponsiveBreakpoints.builder(
              child: Builder(
                builder: (innerContext) {
                  // Just return the widget directly to allow it to fill the screen
                  return widget!;

                  // OR, if you need a background color for the "scaffold" area:
                  // return Container(
                  //   color: const Color(0xffF5F5F5),
                  //   child: widget!,
                  // );
                },
              ),
              breakpoints: [
                const Breakpoint(start: 0, end: 450, name: MOBILE),
                const Breakpoint(start: 451, end: 800, name: TABLET),
                const Breakpoint(start: 801, end: 1920, name: DESKTOP),
                const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
              ],
            );
          },
        );
      },
    );
  }
}
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'My SIP',
//       theme: Utheme.lightTheme,
//       initialBinding: UBinding(),
//       getPages: AppPages.pages(),
//       initialRoute: AppRoutes.splash,

//       builder: (context, widget) {
//         return ScreenUtilInit(
//           designSize: const Size(390, 844),
//           minTextAdapt: true,
//           splitScreenMode: true,
//           builder: (_, __) {
//             return ResponsiveBreakpoints.builder(
//               child: ClampingScrollWrapper.builder(
//                 context,
//                 widget!,
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

// void main() {
//   runApp(const AppRoot());
// }

// class AppRoot extends StatelessWidget {
//   const AppRoot({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(390, 844),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       builder: (_, __) => const MyApp(),
//     );
//   }
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'My SIP',
//       theme: Utheme.lightTheme,
//       initialBinding: UBinding(),
//       getPages: AppPages.pages(),
//       initialRoute: AppRoutes.splash,

//       builder: (context, child) {
//         return ResponsiveBreakpoints.builder(
//           child: ClampingScrollWrapper.builder(context, child!),
//           breakpoints: const [
//             Breakpoint(start: 0, end: 450, name: MOBILE),
//             Breakpoint(start: 451, end: 800, name: TABLET),
//             Breakpoint(start: 801, end: 1920, name: DESKTOP),
//             Breakpoint(start: 1921, end: double.infinity, name: '4K'),
//           ],
//         );
//       },
//     );
//   }
// }
