import 'package:flutter/material.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/theme/widget_theme/appbar_theme.dart';

// class Utheme {
//   //private constructor
//   Utheme._();

//     static const String _font = 'Geist'; // ✅ single source of truth





//   static ThemeData lightTheme = ThemeData(
//     useMaterial3: true,
//     fontFamily: _font,
//     // disabledColor: Ucolors.grey,
//     // brightness: Brightness.light,
//     // primaryColor: Ucolors.primary,
//     textTheme: Utexttheme.lightTextTheme,
//     // chipTheme: uChipTheme.lightChipTheme,
//     scaffoldBackgroundColor: Ucolors.light,
//     appBarTheme: uAppBarTheme.lightAppBarTheme,
//     // checkboxTheme: uCheckBoxTheme.lightCheckboxTheme,
//     // bottomSheetTheme: uBottomSheetTheme.lightBottomSheetTheme,
//     // elevatedButtonTheme: uElevatedButtonTheme.lightElevatedButtonTheme,
//     // outlinedButtonTheme: uOutlinedButtonTheme.lightOutlinedButtonTheme,
//     // inputDecorationTheme: uTextFormFieldTheme.lightInputDecorationTheme,
//   );

//   // static ThemeData darkTheme = ThemeData(
//   //   useMaterial3: true,
//   //   fontFamily: 'Poppins',
//   //   disabledColor: Ucolors.grey,
//   //   brightness: Brightness.dark,
//   //   primaryColor: Ucolors.primary,
//   //   textTheme: Utexttheme.darkTextTheme,
//   //   chipTheme: uChipTheme.darkChipTheme,
//   //   scaffoldBackgroundColor: Ucolors.black,
//   //   appBarTheme: uAppBarTheme.darkAppBarTheme,
//   //   checkboxTheme: uCheckBoxTheme.darkCheckboxTheme,
//   //   bottomSheetTheme: uBottomSheetTheme.darkBottomSheetTheme,
//   //   elevatedButtonTheme: uElevatedButtonTheme.darkElevatedButtonTheme,
//   //   outlinedButtonTheme: uOutlinedButtonTheme.darkOutlinedButtonTheme,
//   //   inputDecorationTheme: uTextFormFieldTheme.darkInputDecorationTheme,
//   // );
// }

class Utheme {
  Utheme._();

  static const String _font = 'Geist'; // ✅ single source of truth

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: _font,
    textTheme: lightTextTheme,
    scaffoldBackgroundColor: Ucolors.light,
    appBarTheme: uAppBarTheme.lightAppBarTheme,
  );

  static TextTheme lightTextTheme = TextTheme(
    headlineLarge:  TextStyle(fontFamily: _font, fontSize: 32.0, fontWeight: FontWeight.bold,    color: Ucolors.dark),
    headlineMedium: TextStyle(fontFamily: _font, fontSize: 24.0, fontWeight: FontWeight.w600,   color: Ucolors.dark),
    headlineSmall:  TextStyle(fontFamily: _font, fontSize: 18.0, fontWeight: FontWeight.w600,   color: Ucolors.dark),

    titleLarge:  TextStyle(fontFamily: _font, fontSize: 16.0, fontWeight: FontWeight.w600, color: Ucolors.dark),
    titleMedium: TextStyle(fontFamily: _font, fontSize: 16.0, fontWeight: FontWeight.w500, color: Ucolors.dark),
    titleSmall:  TextStyle(fontFamily: _font, fontSize: 16.0, fontWeight: FontWeight.w400, color: Ucolors.dark),

    bodyLarge:  TextStyle(fontFamily: _font, fontSize: 14.0, fontWeight: FontWeight.w500,   color: Ucolors.dark),
    bodyMedium: TextStyle(fontFamily: _font, fontSize: 14.0, fontWeight: FontWeight.normal, color: Ucolors.dark),
    bodySmall:  TextStyle(fontFamily: _font, fontSize: 14.0, fontWeight: FontWeight.w500,   color: Ucolors.dark.withOpacity(0.5)),

    labelLarge:  TextStyle(fontFamily: _font, fontSize: 12.0, fontWeight: FontWeight.normal, color: Ucolors.dark),
    labelMedium: TextStyle(fontFamily: _font, fontSize: 12.0, fontWeight: FontWeight.normal, color: Ucolors.dark.withOpacity(0.5)),



    
  );
}