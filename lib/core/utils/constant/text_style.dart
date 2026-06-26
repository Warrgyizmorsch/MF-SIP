// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';
class FontFamily {
  FontFamily._();

  // Inter Font Family Individual Weights
  static const String thin = 'Inter-Thin';
  static const String extraLight = 'Inter-ExtraLight';
  static const String light = 'Inter-Light';
  static const String regular = 'Inter';
  static const String medium = 'Inter';
  static const String semiBold = 'Inter-SemiBold';
  static const String bold = 'Inter-Bold';
  static const String extraBold = 'Inter-ExtraBold';
  static const String black = 'Inter-Black';
}
// class FontFamily {
//   FontFamily._();
//
//   // Roboto Font Family
//   static const String black = 'Roboto-Black';
//   static const String bold = 'Roboto-Bold';
//   static const String medium = 'Roboto';
//   static const String regular = 'Roboto';
//   static const String light = 'Roboto-Light';
//   static const String thin = 'Roboto-Thin';
// }
class UTextStyles {
  UTextStyles._(); // private constructor
  static const double _h1 = 28;
  static const double _h2 = 24;
  static const double _body2 = 12;
  static const double _caption = 14;
  static const double _small = 10;
  // static const String font = 'Roboto';
  static const String font = 'Inter';
  // ─────────────────────────────────────────
  // ─────────────────────────────────────────
  // HEADINGS
  // ─────────────────────────────────────────
  static TextStyle heading1 = TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: _h1,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0,
    color: Ucolors.dark,
  );

  static TextStyle heading2 = TextStyle(
  fontFamily: FontFamily.medium,
    fontSize: _h2,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0,
    color: Ucolors.dark,
  );

  static TextStyle sectionHeading = TextStyle(
  fontFamily: FontFamily.medium,
    fontSize: _caption,
    fontWeight: FontWeight.w500,
    color: Ucolors.dark,
  );

  static TextStyle bodyLarge = TextStyle(
  fontFamily: FontFamily.medium,
    fontSize: 16.sp.clamp(14, 18),
    fontWeight: FontWeight.w400,
    color: Ucolors.dark,
  );

  static TextStyle bodyLargeW500 = TextStyle(
  fontFamily: FontFamily.medium,
    fontSize: 16.sp.clamp(14, 18),
    fontWeight: FontWeight.w500,
    color: Ucolors.dark,
  );

  static TextStyle bodyLargeSemiBold = TextStyle(
  fontFamily: FontFamily.medium,
    fontSize: 16.sp.clamp(14, 18),
    fontWeight: FontWeight.w600,
    color: Ucolors.dark,
  );

  static TextStyle bodyLargeBold = TextStyle(
  fontFamily: FontFamily.medium,
    fontSize: 16.sp.clamp(14, 18),
    fontWeight: FontWeight.w600,
    color: Ucolors.dark,
  );

  // ─────────────────────────────────────────
  // BODY MEDIUM  (14sp)
  // ─────────────────────────────────────────
  static TextStyle bodyMedium = TextStyle(
  fontFamily: FontFamily.medium,
    fontSize: _body2,
    fontWeight: FontWeight.w400,
    color: Ucolors.darkgrey,
  );

  static TextStyle bodyMediumW500 = TextStyle(
  fontFamily: FontFamily.medium,
    fontSize: _body2,
    fontWeight: FontWeight.w500,
    color: Ucolors.darkgrey,
  );

  static TextStyle bodyMediumSemiBold = TextStyle(
  fontFamily: FontFamily.medium,
    fontSize: _body2,
    fontWeight: FontWeight.w600,
    color: Ucolors.dark,
  );

  static TextStyle bodyMediumBold = TextStyle(
  fontFamily: FontFamily.medium,
    fontSize: _body2,
    fontWeight: FontWeight.w600,
    color: Ucolors.dark,
  );

  // ─────────────────────────────────────────
  // BODY SMALL  (12sp)
  // ─────────────────────────────────────────
  static TextStyle bodySmall = TextStyle(
  fontFamily: FontFamily.medium,
    fontSize: _small,
    fontWeight: FontWeight.w400,
    color: Ucolors.darkgrey,
  );

  static TextStyle bodySmallW500 = TextStyle(
  fontFamily: FontFamily.medium,
    fontSize: _small,
    fontWeight: FontWeight.w500,
    color: Ucolors.darkgrey,
  );

  static TextStyle bodySmallSemiBold = TextStyle(
  fontFamily: FontFamily.medium,
    fontSize: _small,
    fontWeight: FontWeight.w600,
    color: Ucolors.dark,
  );

  static TextStyle bodySmallBold = TextStyle(
  fontFamily: FontFamily.medium,
    fontSize: _small,
    fontWeight: FontWeight.w600,
    color: Ucolors.dark,
  );

  // ─────────────────────────────────────────
  // CAPTION / LABEL  (10sp)
  // ─────────────────────────────────────────
  static TextStyle caption = TextStyle(
  fontFamily: FontFamily.medium,
    fontSize: _caption,
    fontWeight: FontWeight.w400,
    color: Ucolors.darkgrey,
  );

  static TextStyle captionW500 = TextStyle(
  fontFamily: FontFamily.medium,
    fontSize: _caption,
    fontWeight: FontWeight.w500,
    color: Ucolors.darkgrey,
  );

  // ─────────────────────────────────────────
  // BUTTON
  // ─────────────────────────────────────────
  static TextStyle button = TextStyle(
  fontFamily: FontFamily.medium,
    fontSize: _body2,
    fontWeight: FontWeight.w600,
    color: Ucolors.light,
  );

  // ─────────────────────────────────────────
  // SUBTITLE (kept for backward compatibility)
  // ─────────────────────────────────────────
  static TextStyle get subtitle1 => bodyLarge; // alias
  static TextStyle get subtitle2 => bodyMedium; // alias
  static TextStyle get buttonText => button; // alias
  static TextStyle get large => bodyLargeBold; // alias
  static TextStyle get medium => bodyMedium; // alias
  static TextStyle get small => bodySmall; // alias
}

class AppTextStyles {
  AppTextStyles._(); // private constructor — no instantiation

  static const String font = 'Roboto';

  // helper to avoid repeating clamp logic
  static double _s(double size) => size.sp.clamp(size * 0.8, size * 1.2);

  // ─────────────────────────────────────────
  // DEFAULT
  // ─────────────────────────────────────────
  static TextStyle base({
    double size = 14.0,
    FontWeight weight = FontWeight.w400,
    Color color = Colors.black,
    TextDecoration? decoration,
  }) => TextStyle(
  fontFamily: FontFamily.medium,
    fontSize: _s(size),
    fontWeight: weight,
    color: color,
    decoration: decoration,
  );

  // ─────────────────────────────────────────
  // HEADINGS
  // ─────────────────────────────────────────
  static TextStyle h1({
    Color color = Colors.black,
    double size = 24.0,
    FontWeight weight = FontWeight.w600,
    TextDecoration? decoration,
  }) => TextStyle(
  fontFamily: FontFamily.medium,
    fontSize: _s(size),
    fontWeight: weight,
    color: color,
    decoration: decoration,
  );

  static TextStyle h2({
    Color color = Colors.black,
    double size = 20.0,
    FontWeight weight = FontWeight.w600,
    TextDecoration? decoration,
  }) => TextStyle(
  fontFamily: FontFamily.medium,
    fontSize: _s(size),
    fontWeight: weight,
    color: color,
    decoration: decoration,
  );

  static TextStyle h3({
    Color color = Colors.black,
    double size = 18.0,
    FontWeight weight = FontWeight.w600,
    TextDecoration? decoration,
  }) => TextStyle(
  fontFamily: FontFamily.medium,
    fontSize: _s(size),
    fontWeight: weight,
    color: color,
    decoration: decoration,
  );

  // ─────────────────────────────────────────
  // BODY SMALL  (12sp)
  // ─────────────────────────────────────────
  static TextStyle bodySmall({
    Color color = Colors.black,
    double size = 12.0,
    FontWeight weight = FontWeight.w400,
    TextDecoration? decoration,
  }) => TextStyle(
  fontFamily: FontFamily.medium,
    fontSize: _s(size),
    fontWeight: weight,
    color: color,
    decoration: decoration,
  );

  static TextStyle bodySmallW500({
    Color color = Colors.black,
    double size = 12.0,
    TextDecoration? decoration,
  }) => TextStyle(
  fontFamily: FontFamily.medium,
    fontSize: _s(size),
    fontWeight: FontWeight.w500,
    color: color,
    decoration: decoration,
  );

  static TextStyle bodySmallSemiBold({
    Color color = Colors.black,
    double size = 12.0,
    TextDecoration? decoration,
  }) => TextStyle(
  fontFamily: FontFamily.medium,
    fontSize: _s(size),
    fontWeight: FontWeight.w600,
    color: color,
    decoration: decoration,
  );

  static TextStyle bodySmallBold({
    Color color = Colors.black,
    double size = 12.0,
    TextDecoration? decoration,
  }) => TextStyle(
  fontFamily: FontFamily.medium,
    fontSize: _s(size),
    fontWeight: FontWeight.w600,
    color: color,
    decoration: decoration,
  );

  // ─────────────────────────────────────────
  // BODY MEDIUM  (14sp)
  // ─────────────────────────────────────────
  static TextStyle bodyMedium({
    Color color = Colors.black,
    double size = 14.0,
    FontWeight weight = FontWeight.w400,
    TextDecoration? decoration,
  }) => TextStyle(
  fontFamily: FontFamily.medium,
    fontSize: _s(size),
    fontWeight: weight,
    color: color,
    decoration: decoration,
  );

  static TextStyle bodyMediumW500({
    Color color = Colors.black,
    double size = 14.0,
    TextDecoration? decoration,
  }) => TextStyle(
  fontFamily: FontFamily.medium,
    fontSize: _s(size),
    fontWeight: FontWeight.w500,
    color: color,
    decoration: decoration,
  );

  static TextStyle bodyMediumSemiBold({
    Color color = Colors.black,
    double size = 14.0,
    TextDecoration? decoration,
  }) => TextStyle(
  fontFamily: FontFamily.medium,
    fontSize: _s(size),
    fontWeight: FontWeight.w600,
    color: color,
    decoration: decoration,
  );

  static TextStyle bodyMediumBold({
    Color color = Colors.black,
    double size = 14.0,
    TextDecoration? decoration,
  }) => TextStyle(
  fontFamily: FontFamily.medium,
    fontSize: _s(size),
    fontWeight: FontWeight.w600,
    color: color,
    decoration: decoration,
  );

  // ─────────────────────────────────────────
  // BODY LARGE  (16sp)
  // ─────────────────────────────────────────
  static TextStyle bodyLarge({
    Color color = Colors.black,
    double size = 16.0,
    FontWeight weight = FontWeight.w400,
    TextDecoration? decoration,
  }) => TextStyle(
  fontFamily: FontFamily.medium,
    fontSize: _s(size),
    fontWeight: weight,
    color: color,
    decoration: decoration,
  );

  static TextStyle bodyLargeW500({
    Color color = Colors.black,
    double size = 16.0,
    TextDecoration? decoration,
  }) => TextStyle(
  fontFamily: FontFamily.medium,
    fontSize: _s(size),
    fontWeight: FontWeight.w500,
    color: color,
    decoration: decoration,
  );

  static TextStyle bodyLargeSemiBold({
    Color color = Colors.black,
    double size = 16.0,
    TextDecoration? decoration,
  }) => TextStyle(
  fontFamily: FontFamily.medium,
    fontSize: _s(size),
    fontWeight: FontWeight.w600,
    color: color,
    decoration: decoration,
  );

  static TextStyle bodyLargeBold({
    Color color = Colors.black,
    double size = 16.0,
    TextDecoration? decoration,
  }) => TextStyle(
  fontFamily: FontFamily.medium,
    fontSize: _s(size),
    fontWeight: FontWeight.w600,
    color: color,
    decoration: decoration,
  );

  // ─────────────────────────────────────────
  // CAPTION  (10sp)
  // ─────────────────────────────────────────
  static TextStyle caption({
    Color color = Colors.grey,
    double size = 10.0,
    FontWeight weight = FontWeight.w500,
    TextDecoration? decoration,
  }) => TextStyle(
  fontFamily: FontFamily.medium,
    fontSize: _s(size),
    fontWeight: weight,
    color: color,
    decoration: decoration,
  );

  // ─────────────────────────────────────────
  // BUTTON  (14sp)
  // ─────────────────────────────────────────
  static TextStyle button({
    Color color = Colors.blue,
    double size = 14.0,
    FontWeight weight = FontWeight.w600,
    TextDecoration? decoration,
  }) => TextStyle(
  fontFamily: FontFamily.medium,
    fontSize: _s(size),
    fontWeight: weight,
    color: color,
    decoration: decoration,
  );

  // ─────────────────────────────────────────
  // CHAT
  // ─────────────────────────────────────────
  static TextStyle chatMessage({
    Color color = Colors.black,
    double size = 12.0,
    FontWeight weight = FontWeight.w400,
    TextDecoration? decoration,
  }) => TextStyle(
  fontFamily: FontFamily.medium,
    fontSize: _s(size),
    fontWeight: weight,
    color: color,
    decoration: decoration,
  );

  static TextStyle chatMessageReceived({
    Color color = Colors.grey,
    double size = 12.0,
    FontWeight weight = FontWeight.w400,
    TextDecoration? decoration,
  }) => TextStyle(
  fontFamily: FontFamily.medium,
    fontSize: _s(size),
    fontWeight: weight,
    color: color,
    decoration: decoration,
  );
}
