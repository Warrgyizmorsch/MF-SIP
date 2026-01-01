import 'package:flutter/material.dart';
import 'package:my_sip/utils/constant/colors.dart';
import 'package:my_sip/utils/theme/widget_theme/appbar_theme.dart';
import 'package:my_sip/utils/theme/widget_theme/text_theme.dart';

class Utheme {
  //private constructor
  Utheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Geist',
    // disabledColor: Ucolors.grey,
    // brightness: Brightness.light,
    // primaryColor: Ucolors.primary,
    textTheme: Utexttheme.lightTextTheme,
    // chipTheme: uChipTheme.lightChipTheme,
    scaffoldBackgroundColor: Ucolors.light,
    appBarTheme: uAppBarTheme.lightAppBarTheme,
    // checkboxTheme: uCheckBoxTheme.lightCheckboxTheme,
    // bottomSheetTheme: uBottomSheetTheme.lightBottomSheetTheme,
    // elevatedButtonTheme: uElevatedButtonTheme.lightElevatedButtonTheme,
    // outlinedButtonTheme: uOutlinedButtonTheme.lightOutlinedButtonTheme,
    // inputDecorationTheme: uTextFormFieldTheme.lightInputDecorationTheme,
  );

  // static ThemeData darkTheme = ThemeData(
  //   useMaterial3: true,
  //   fontFamily: 'Poppins',
  //   disabledColor: Ucolors.grey,
  //   brightness: Brightness.dark,
  //   primaryColor: Ucolors.primary,
  //   textTheme: Utexttheme.darkTextTheme,
  //   chipTheme: uChipTheme.darkChipTheme,
  //   scaffoldBackgroundColor: Ucolors.black,
  //   appBarTheme: uAppBarTheme.darkAppBarTheme,
  //   checkboxTheme: uCheckBoxTheme.darkCheckboxTheme,
  //   bottomSheetTheme: uBottomSheetTheme.darkBottomSheetTheme,
  //   elevatedButtonTheme: uElevatedButtonTheme.darkElevatedButtonTheme,
  //   outlinedButtonTheme: uOutlinedButtonTheme.darkOutlinedButtonTheme,
  //   inputDecorationTheme: uTextFormFieldTheme.darkInputDecorationTheme,
  // );
}
