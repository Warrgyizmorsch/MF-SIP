import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'colors.dart';

class UTextStyles {
  static TextStyle heading1 = TextStyle(
    fontFamily: 'Geist',
    fontWeight: FontWeight.w700,
    // fontStyle: FontStyle.normal,
    fontSize: (Get.width * 0.07).clamp(26, 30),
    height: 45 / 30, // ≈ 1.5
    letterSpacing: 0,
    color: Ucolors.dark,
  );

  static TextStyle heading2 = TextStyle(
    fontFamily: 'Geist',
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    fontSize: (Get.width * 0.06).clamp(24, 30),
    // fontSize: 24,
    height: 36 / 24,
    letterSpacing: 0,
    color: Ucolors.dark,
  );

  static TextStyle subtitle1 = TextStyle(
    fontFamily: 'Geist',
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,

    fontSize: 16,
    color: Color(0xff787878),
  );

  static TextStyle subtitle2 = TextStyle(
    fontSize: 14,
    // fontSize: Get.width * 0.02,
    fontWeight: FontWeight.w400,
    color: Ucolors.darkgrey,
  );

  static TextStyle buttonText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Ucolors.light,
  );

  static TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Ucolors.darkgrey,
  );

  static TextStyle sectionHeading = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: Ucolors.dark,
    height: 20 / 113,
  );

  static TextStyle small_heading = TextStyle(
    // fontSize: (Get.width * 0.04).clamp(15, 20),  Section Heading
    // fontSize: (Get.width * 0.035).clamp(12, 14), title
    // fontSize: (Get.width * 0.03).clamp(8, 12),      subtitle
    // size: (Get.width * 0.04).clamp(8, 10), icon

    //
    //
  );

  static TextStyle large = TextStyle(
    fontSize: (Get.width * 0.04).clamp(15, 20), //heading
    color: Ucolors.dark,
    fontWeight: FontWeight.w700,
  );
  static TextStyle medium = TextStyle(
    fontSize: (Get.width * 0.035).clamp(12, 14), //title
    color: Color(0xff787878),
    fontWeight: FontWeight.w400,
  );
  static TextStyle small = TextStyle(
    fontSize: (Get.width * 0.03).clamp(8, 12), //subtitle
  );
}


class AppTextStyles extends TextStyle {
  AppTextStyles({
    double size = 14.0,
    FontWeight weight = FontWeight.w400,
    Color super.color = Colors.black,
    super.decoration,
    String fontFamily = 'Geist',
  }) : super(
    fontSize: size.sp,
    fontWeight: weight,
    fontFamily: fontFamily,

  );

  // -------------------------
  // HEADINGS
  // -------------------------
  AppTextStyles.h1({
    Color super.color = Colors.black,
    double size = 24.0,
    FontWeight weight = FontWeight.w700,
    super.decoration,
    String fontFamily = 'Geist',
  }) : super(
    fontSize: size.sp,
    fontWeight: weight,
    fontFamily: fontFamily,
  );

  AppTextStyles.h2({
    Color super.color = Colors.black,
    double size = 20.0,
    FontWeight weight = FontWeight.w600,
    super.decoration,
    String fontFamily = 'Geist',
  }) : super(
    fontSize: size.sp,
    fontWeight: weight,
    fontFamily: fontFamily,
  );

  AppTextStyles.h3({
    Color super.color = Colors.black,
    double size = 18.0,
    FontWeight weight = FontWeight.w600,
    super.decoration,
    String fontFamily = 'Geist',
  }) : super(
    fontSize: size.sp,
    fontWeight: weight,
    fontFamily: fontFamily,
  );

  // -------------------------
  // BODY SMALL
  // -------------------------
  AppTextStyles.bodySmall({
    Color super.color = Colors.black,
    double size = 12.0,
    FontWeight weight = FontWeight.w400,
    super.decoration,
    String fontFamily = 'Geist',
  }) : super(
    fontSize: size.sp,
    fontWeight: weight,
    fontFamily: fontFamily,
  );

  AppTextStyles.bodySmallW500({
    Color super.color = Colors.black,
    double size = 12.0,
    super.decoration,
    String fontFamily = 'Geist',
  }) : super(
    fontSize: size.sp,
    fontWeight: FontWeight.w500,
    fontFamily: fontFamily,
  );

  AppTextStyles.bodySmallSemiBold({
    Color super.color = Colors.black,
    double size = 12.0,
    super.decoration,
    String fontFamily = 'Geist',
  }) : super(
    fontSize: size.sp,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamily,
  );

  AppTextStyles.bodySmallBold({
    Color super.color = Colors.black,
    double size = 12.0,
    super.decoration,
    String fontFamily = 'Geist',
  }) : super(
    fontSize: size.sp,
    fontWeight: FontWeight.w700,
    fontFamily: fontFamily,
  );

  // -------------------------
  // BODY MEDIUM
  // -------------------------
  AppTextStyles.bodyMedium({
    Color super.color = Colors.black,
    double size = 14.0,
    FontWeight weight = FontWeight.w400,
    super.decoration,
    String fontFamily = 'Geist',
  }) : super(
    fontSize: size.sp,
    fontWeight: weight,
    fontFamily: fontFamily,
  );

  AppTextStyles.bodyMediumW500({
    Color super.color = Colors.black,
    double size = 14.0,
    super.decoration,
    String fontFamily = 'Geist',
  }) : super(
    fontSize: size.sp,
    fontWeight: FontWeight.w500,
    fontFamily: fontFamily,
  );

  AppTextStyles.bodyMediumSemiBold({
    Color super.color = Colors.black,
    double size = 14.0,
    super.decoration,
    String fontFamily = 'Geist',
  }) : super(
    fontSize: size.sp,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamily,
  );

  AppTextStyles.bodyMediumBold({
    Color super.color = Colors.black,
    double size = 14.0,
    super.decoration,
    String fontFamily = 'Geist',
  }) : super(
    fontSize: size.sp,
    fontWeight: FontWeight.w700,
    fontFamily: fontFamily,
  );

  // -------------------------
  // BODY LARGE
  // -------------------------
  AppTextStyles.bodyLarge({
    Color super.color = Colors.black,
    double size = 16.0,
    FontWeight weight = FontWeight.w400,
    super.decoration,
    String fontFamily = 'Geist',
  }) : super(
    fontSize: size.sp,
    fontWeight: weight,
    fontFamily: fontFamily,
  );

  AppTextStyles.bodyLargeW500({
    Color super.color = Colors.black,
    double size = 16.0,
    super.decoration,
    String fontFamily = 'Geist',
  }) : super(
    fontSize: size.sp,
    fontWeight: FontWeight.w500,
    fontFamily: fontFamily,
  );

  AppTextStyles.bodyLargeSemiBold({
    Color super.color = Colors.black,
    double size = 16.0,
    super.decoration,
    String fontFamily = 'Geist',
  }) : super(
    fontSize: size.sp,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamily,
  );

  AppTextStyles.bodyLargeBold({
    Color super.color = Colors.black,
    double size = 16.0,
    super.decoration,
    String fontFamily = 'Geist',
  }) : super(
    fontSize: size.sp,
    fontWeight: FontWeight.w700,
    fontFamily: fontFamily,
  );

  // -------------------------
  // CAPTION
  // -------------------------
  AppTextStyles.caption({
    Color super.color = Colors.grey,
    double size = 10.0,
    FontWeight weight = FontWeight.w500,
    super.decoration,
    String fontFamily = 'Geist',
  }) : super(
    fontSize: size.sp,
    fontWeight: weight,
    fontFamily: fontFamily,
  );

  // -------------------------
  // BUTTON
  // -------------------------
  AppTextStyles.button({
    Color super.color = Colors.blue,
    double size = 14.0,
    FontWeight weight = FontWeight.w700,
    super.decoration,
    String fontFamily = 'Geist',
  }) : super(
    fontSize: size.sp,
    fontWeight: weight,
    fontFamily: fontFamily,
  );

  // -------------------------
  // CHAT
  // -------------------------
  AppTextStyles.chatMessage({
    Color super.color = Colors.black,
    double size = 12.0,
    FontWeight weight = FontWeight.w400,
    super.decoration,
    String fontFamily = 'Geist',
  }) : super(
    fontSize: size.sp,
    fontWeight: weight,
    fontFamily: fontFamily,
  );

  AppTextStyles.chatMessageReceived({
    Color super.color = Colors.grey,
    double size = 12.0,
    FontWeight weight = FontWeight.w400,
    super.decoration,
    String fontFamily = 'Geist',
  }) : super(
    fontSize: size.sp,
    fontWeight: weight,
    fontFamily: fontFamily,
  );
}