import 'package:flutter/material.dart';
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
