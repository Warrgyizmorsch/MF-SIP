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
            // 1. Initialize ResponsiveBreakpoints FIRST (It must be the parent)
            return ResponsiveBreakpoints.builder(
              child: Builder(
                // 2. Use a Builder to get a context that is UNDER ResponsiveBreakpoints
                builder: (innerContext) {
                  return MaxWidthBox(
                    maxWidth: 1200,
                    backgroundColor: const Color(0xffF5F5F5),
                    child: ResponsiveScaledBox(
                      // 3. Now ResponsiveValue can find the breakpoints in 'innerContext'
                      width: ResponsiveValue<double>(
                        innerContext,
                        defaultValue: 450,
                        conditionalValues: [
                          const Condition.equals(name: MOBILE, value: 450),
                          const Condition.between(start: 451, end: 800, value: 800),
                          const Condition.between(start: 801, end: 1920, value: 1200),
                          const Condition.largerThan(name: DESKTOP, value: 2460),
                        ],
                      ).value,
                      child: widget!,
                    ),
                  );
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
