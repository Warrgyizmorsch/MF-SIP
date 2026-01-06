import 'package:flutter/material.dart';
import 'package:my_sip/core/utils/constant/colors.dart';

class uAppBarTheme {
  uAppBarTheme._();
  static const lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    // backgroundColor: Colors.transparent,
    backgroundColor: Ucolors.light,
    // surfaceTintColor: Colors.transparent,
    // iconTheme: IconThemeData(color: Ucolors.dark, size: Usizes.iconMd),
    // actionsIconTheme: IconThemeData(color: Ucolors.dark, size: Usizes.iconMd),
    titleTextStyle: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: Ucolors.dark,
    ),
  );
  // static const darkAppBarTheme = AppBarTheme(
  //   elevation: 0,
  //   centerTitle: false,
  //   scrolledUnderElevation: 0,
  //   backgroundColor: Colors.transparent,
  //   surfaceTintColor: Colors.transparent,
  //   iconTheme: IconThemeData(color: Ucolors.black, size: Usizes.iconMd),
  //   actionsIconTheme: IconThemeData(color: Ucolors.white, size: Usizes.iconMd),
  //   titleTextStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: Ucolors.white),
  // );
}
