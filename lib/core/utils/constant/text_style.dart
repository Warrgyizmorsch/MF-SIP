import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'colors.dart';

class UTextStyles {
  UTextStyles._(); // private constructor
  static const double _h1 = 28;
  static const double _h2 = 24;
  static const double _h3 = 20;
  static const double _h4 = 18;
  static const double _body1 = 16;
  static const double _body2 = 12;
  static const double _caption = 14;
  static const double _small = 10;
  static const String _font = 'Roboto'; // ✅ single source of truth
  // ─────────────────────────────────────────
  // HEADINGS
  // ─────────────────────────────────────────
  static TextStyle heading1 = TextStyle(
    fontFamily: _font,
    fontSize:_h1,
    fontWeight: FontWeight.w700,
    height: 1.5,
    letterSpacing: 0,
    color: Ucolors.dark,
  );

  static TextStyle heading2 = TextStyle(
    fontFamily: _font,
    fontSize: _h2,
    fontWeight: FontWeight.w700,
    height: 1.5,
    letterSpacing: 0,
    color: Ucolors.dark,
  );

  static TextStyle sectionHeading = TextStyle(
    fontFamily: _font,
    fontSize: _caption,
    fontWeight: FontWeight.w500,
    color: Ucolors.dark,
  );

  static TextStyle bodyLarge = TextStyle(
    fontFamily: _font,
    fontSize: 16.sp.clamp(14, 18),
    fontWeight: FontWeight.w400,
    color: Ucolors.dark,
  );

  static TextStyle bodyLargeW500 = TextStyle(
    fontFamily: _font,
    fontSize: 16.sp.clamp(14, 18),
    fontWeight: FontWeight.w500,
    color: Ucolors.dark,
  );

  static TextStyle bodyLargeSemiBold = TextStyle(
    fontFamily: _font,
    fontSize: 16.sp.clamp(14, 18),
    fontWeight: FontWeight.w600,
    color: Ucolors.dark,
  );

  static TextStyle bodyLargeBold = TextStyle(
    fontFamily: _font,
    fontSize: 16.sp.clamp(14, 18),
    fontWeight: FontWeight.w700,
    color: Ucolors.dark,
  );

  // ─────────────────────────────────────────
  // BODY MEDIUM  (14sp)
  // ─────────────────────────────────────────
  static TextStyle bodyMedium = TextStyle(
    fontFamily: _font,
    fontSize: _body2,
    fontWeight: FontWeight.w400,
    color: Ucolors.darkgrey,
  );

  static TextStyle bodyMediumW500 = TextStyle(
    fontFamily: _font,
    fontSize:_body2 ,
    fontWeight: FontWeight.w500,
    color: Ucolors.darkgrey,
  );

  static TextStyle bodyMediumSemiBold = TextStyle(
fontFamily: _font,    fontSize: _body2,
    fontWeight: FontWeight.w600,
    color: Ucolors.dark,
  );

  static TextStyle bodyMediumBold = TextStyle(
fontFamily: _font,    fontSize: _body2,
    fontWeight: FontWeight.w700,
    color: Ucolors.dark,
  );

  // ─────────────────────────────────────────
  // BODY SMALL  (12sp)
  // ─────────────────────────────────────────
  static TextStyle bodySmall = TextStyle(
fontFamily: _font,    fontSize: _small,
    fontWeight: FontWeight.w400,
    color: Ucolors.darkgrey,
  );

  static TextStyle bodySmallW500 = TextStyle(
fontFamily: _font,    fontSize: _small,
    fontWeight: FontWeight.w500,
    color: Ucolors.darkgrey,
  );

  static TextStyle bodySmallSemiBold = TextStyle(
fontFamily: _font,    fontSize: _small,
    fontWeight: FontWeight.w600,
    color: Ucolors.dark,
  );

  static TextStyle bodySmallBold = TextStyle(
fontFamily: _font,    fontSize: _small,
    fontWeight: FontWeight.w700,
    color: Ucolors.dark,
  );

  // ─────────────────────────────────────────
  // CAPTION / LABEL  (10sp)
  // ─────────────────────────────────────────
  static TextStyle caption = TextStyle(
fontFamily: _font,    fontSize: _caption,
    fontWeight: FontWeight.w400,
    color: Ucolors.darkgrey,
  );

  static TextStyle captionW500 = TextStyle(
fontFamily: _font,    fontSize: _caption,
    fontWeight: FontWeight.w500,
    color: Ucolors.darkgrey,
  );

  // ─────────────────────────────────────────
  // BUTTON
  // ─────────────────────────────────────────
  static TextStyle button = TextStyle(
fontFamily: _font,    fontSize: _body2,
    fontWeight: FontWeight.w700,
    color: Ucolors.light,
  );
  // // ─────────────────────────────────────────
  // // HEADINGS
  // // ─────────────────────────────────────────
  // static TextStyle heading1 = TextStyle(
  //   fontFamily: _font,
  //   fontSize: 28.sp.clamp(26, 30),
  //   fontWeight: FontWeight.w700,
  //   height: 1.5,
  //   letterSpacing: 0,
  //   color: Ucolors.dark,
  // );
  //
  // static TextStyle heading2 = TextStyle(
  //   fontFamily: _font,
  //   fontSize: 26.sp.clamp(24, 30),
  //   fontWeight: FontWeight.w700,
  //   height: 1.5,
  //   letterSpacing: 0,
  //   color: Ucolors.dark,
  // );
  //
  // static TextStyle sectionHeading = TextStyle(
  //   fontFamily: _font,
  //   fontSize: 20.sp.clamp(18, 22),
  //   fontWeight: FontWeight.w500,
  //   color: Ucolors.dark,
  // );

  // ─────────────────────────────────────────
  // BODY LARGE  (16sp)
  // ─────────────────────────────────────────
  // static TextStyle bodyLarge = TextStyle(
  //   fontFamily: _font,
  //   fontSize: 16.sp.clamp(14, 18),
  //   fontWeight: FontWeight.w400,
  //   color: Ucolors.dark,
  // );
  //
  // static TextStyle bodyLargeW500 = TextStyle(
  //   fontFamily: _font,
  //   fontSize: 16.sp.clamp(14, 18),
  //   fontWeight: FontWeight.w500,
  //   color: Ucolors.dark,
  // );
  //
  // static TextStyle bodyLargeSemiBold = TextStyle(
  //   fontFamily: _font,
  //   fontSize: 16.sp.clamp(14, 18),
  //   fontWeight: FontWeight.w600,
  //   color: Ucolors.dark,
  // );
  //
  // static TextStyle bodyLargeBold = TextStyle(
  //   fontFamily: _font,
  //   fontSize: 16.sp.clamp(14, 18),
  //   fontWeight: FontWeight.w700,
  //   color: Ucolors.dark,
  // );
  //
  // // ─────────────────────────────────────────
  // // BODY MEDIUM  (14sp)
  // // ─────────────────────────────────────────
  // static TextStyle bodyMedium = TextStyle(
  //   fontFamily: _font,
  //   fontSize: 14.sp.clamp(12, 16),
  //   fontWeight: FontWeight.w400,
  //   color: Ucolors.darkgrey,
  // );
  //
  // static TextStyle bodyMediumW500 = TextStyle(
  //   fontFamily: _font,
  //   fontSize: 14.sp.clamp(12, 16),
  //   fontWeight: FontWeight.w500,
  //   color: Ucolors.darkgrey,
  // );
  //
  // static TextStyle bodyMediumSemiBold = TextStyle(
  //   fontFamily: _font,
  //   fontSize: 14.sp.clamp(12, 16),
  //   fontWeight: FontWeight.w600,
  //   color: Ucolors.dark,
  // );
  //
  // static TextStyle bodyMediumBold = TextStyle(
  //   fontFamily: _font,
  //   fontSize: 14.sp.clamp(12, 16),
  //   fontWeight: FontWeight.w700,
  //   color: Ucolors.dark,
  // );
  //
  // // ─────────────────────────────────────────
  // // BODY SMALL  (12sp)
  // // ─────────────────────────────────────────
  // static TextStyle bodySmall = TextStyle(
  //   fontFamily: _font,
  //   fontSize: 12.sp.clamp(10, 14),
  //   fontWeight: FontWeight.w400,
  //   color: Ucolors.darkgrey,
  // );
  //
  // static TextStyle bodySmallW500 = TextStyle(
  //   fontFamily: _font,
  //   fontSize: 12.sp.clamp(10, 14),
  //   fontWeight: FontWeight.w500,
  //   color: Ucolors.darkgrey,
  // );
  //
  // static TextStyle bodySmallSemiBold = TextStyle(
  //   fontFamily: _font,
  //   fontSize: 12.sp.clamp(10, 14),
  //   fontWeight: FontWeight.w600,
  //   color: Ucolors.dark,
  // );
  //
  // static TextStyle bodySmallBold = TextStyle(
  //   fontFamily: _font,
  //   fontSize: 12.sp.clamp(10, 14),
  //   fontWeight: FontWeight.w700,
  //   color: Ucolors.dark,
  // );
  //
  // // ─────────────────────────────────────────
  // // CAPTION / LABEL  (10sp)
  // // ─────────────────────────────────────────
  // static TextStyle caption = TextStyle(
  //   fontFamily: _font,
  //   fontSize: 10.sp.clamp(8, 12),
  //   fontWeight: FontWeight.w400,
  //   color: Ucolors.darkgrey,
  // );
  //
  // static TextStyle captionW500 = TextStyle(
  //   fontFamily: _font,
  //   fontSize: 10.sp.clamp(8, 12),
  //   fontWeight: FontWeight.w500,
  //   color: Ucolors.darkgrey,
  // );
  //
  // // ─────────────────────────────────────────
  // // BUTTON
  // // ─────────────────────────────────────────
  // static TextStyle button = TextStyle(
  //   fontFamily: _font,
  //   fontSize: 14.sp.clamp(12, 16),
  //   fontWeight: FontWeight.w700,
  //   color: Ucolors.light,
  // );

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

  static const String _font = 'Geist';

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
fontFamily: _font,    fontSize: _s(size),
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
    FontWeight weight = FontWeight.w700,
    TextDecoration? decoration,
  }) => TextStyle(
fontFamily: _font,    fontSize: _s(size),
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
fontFamily: _font,    fontSize: _s(size),
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
fontFamily: _font,    fontSize: _s(size),
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
fontFamily: _font,    fontSize: _s(size),
    fontWeight: weight,
    color: color,
    decoration: decoration,
  );

  static TextStyle bodySmallW500({
    Color color = Colors.black,
    double size = 12.0,
    TextDecoration? decoration,
  }) => TextStyle(
fontFamily: _font,    fontSize: _s(size),
    fontWeight: FontWeight.w500,
    color: color,
    decoration: decoration,
  );

  static TextStyle bodySmallSemiBold({
    Color color = Colors.black,
    double size = 12.0,
    TextDecoration? decoration,
  }) => TextStyle(
fontFamily: _font,    fontSize: _s(size),
    fontWeight: FontWeight.w600,
    color: color,
    decoration: decoration,
  );

  static TextStyle bodySmallBold({
    Color color = Colors.black,
    double size = 12.0,
    TextDecoration? decoration,
  }) => TextStyle(
fontFamily: _font,    fontSize: _s(size),
    fontWeight: FontWeight.w700,
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
fontFamily: _font,    fontSize: _s(size),
    fontWeight: weight,
    color: color,
    decoration: decoration,
  );

  static TextStyle bodyMediumW500({
    Color color = Colors.black,
    double size = 14.0,
    TextDecoration? decoration,
  }) => TextStyle(
fontFamily: _font,    fontSize: _s(size),
    fontWeight: FontWeight.w500,
    color: color,
    decoration: decoration,
  );

  static TextStyle bodyMediumSemiBold({
    Color color = Colors.black,
    double size = 14.0,
    TextDecoration? decoration,
  }) => TextStyle(
fontFamily: _font,    fontSize: _s(size),
    fontWeight: FontWeight.w600,
    color: color,
    decoration: decoration,
  );

  static TextStyle bodyMediumBold({
    Color color = Colors.black,
    double size = 14.0,
    TextDecoration? decoration,
  }) => TextStyle(
    fontFamily: _font,
    fontSize: _s(size),
    fontWeight: FontWeight.w700,
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
fontFamily: _font,    fontSize: _s(size),
    fontWeight: weight,
    color: color,
    decoration: decoration,
  );

  static TextStyle bodyLargeW500({
    Color color = Colors.black,
    double size = 16.0,
    TextDecoration? decoration,
  }) => TextStyle(
fontFamily: _font,    fontSize: _s(size),
    fontWeight: FontWeight.w500,
    color: color,
    decoration: decoration,
  );

  static TextStyle bodyLargeSemiBold({
    Color color = Colors.black,
    double size = 16.0,
    TextDecoration? decoration,
  }) => TextStyle(
fontFamily: _font,    fontSize: _s(size),
    fontWeight: FontWeight.w600,
    color: color,
    decoration: decoration,
  );

  static TextStyle bodyLargeBold({
    Color color = Colors.black,
    double size = 16.0,
    TextDecoration? decoration,
  }) => TextStyle(
fontFamily: _font,    fontSize: _s(size),
    fontWeight: FontWeight.w700,
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
fontFamily: _font,    fontSize: _s(size),
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
    FontWeight weight = FontWeight.w700,
    TextDecoration? decoration,
  }) => TextStyle(
fontFamily: _font,    fontSize: _s(size),
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
fontFamily: _font,    fontSize: _s(size),
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
fontFamily: _font,    fontSize: _s(size),
    fontWeight: weight,
    color: color,
    decoration: decoration,
  );
}

// class UTextStyles {
//   static TextStyle heading1 = TextStyle(
//     fontFamily: 'Geist',
//     fontWeight: FontWeight.w700,
//     // fontStyle: FontStyle.normal,
//     fontSize: (Get.width * 0.07).clamp(26, 30),
//     height: 45 / 30, // ≈ 1.5
//     letterSpacing: 0,
//     color: Ucolors.dark,
//   );

//   static TextStyle heading2 = TextStyle(
//     fontFamily: 'Geist',
//     fontWeight: FontWeight.w700,
//     fontStyle: FontStyle.normal,
//     fontSize: (Get.width * 0.06).clamp(24, 30),
//     // fontSize: 24,
//     height: 36 / 24,
//     letterSpacing: 0,
//     color: Ucolors.dark,
//   );

//   static TextStyle subtitle1 = TextStyle(
//     fontFamily: 'Geist',
//     fontWeight: FontWeight.w400,
//     fontStyle: FontStyle.normal,

//     fontSize: 16,
//     color: Color(0xff787878),
//   );

//   static TextStyle subtitle2 = TextStyle(
//     fontSize: 14,
//     // fontSize: Get.width * 0.02,
//     fontWeight: FontWeight.w400,
//     color: Ucolors.darkgrey,
//   );

//   static TextStyle buttonText = TextStyle(
//     fontSize: 14,
//     fontWeight: FontWeight.w500,
//     color: Ucolors.light,
//   );

//   static TextStyle caption = TextStyle(
//     fontSize: 12,
//     fontWeight: FontWeight.w400,
//     color: Ucolors.darkgrey,
//   );

//   static TextStyle sectionHeading = TextStyle(
//     fontSize: 20,
//     fontWeight: FontWeight.w500,
//     color: Ucolors.dark,
//     height: 20 / 113,
//   );

//   static TextStyle small_heading = TextStyle(
//     // fontSize: (Get.width * 0.04).clamp(15, 20),  Section Heading
//     // fontSize: (Get.width * 0.035).clamp(12, 14), title
//     // fontSize: (Get.width * 0.03).clamp(8, 12),      subtitle
//     // size: (Get.width * 0.04).clamp(8, 10), icon

//     //
//     //
//   );

//   static TextStyle large = TextStyle(
//     fontSize: (Get.width * 0.04).clamp(15, 20), //heading
//     color: Ucolors.dark,
//     fontWeight: FontWeight.w700,
//   );
//   static TextStyle medium = TextStyle(
//     fontSize: (Get.width * 0.035).clamp(12, 14), //title
//     color: Color(0xff787878),
//     fontWeight: FontWeight.w400,
//   );
//   static TextStyle small = TextStyle(
//     fontSize: (Get.width * 0.03).clamp(8, 12), //subtitle
//   );
// }

// class AppTextStyles extends TextStyle {
//   AppTextStyles({
//     double size = 14.0,
//     FontWeight weight = FontWeight.w400,
//     Color super.color = Colors.black,
//     super.decoration,
//     String fontFamily = 'Geist',
//   }) : super(
//          // Clamp to prevent drastic scaling
//          fontSize: size.sp.clamp(size * 0.8, size * 1.2),
//          fontWeight: weight,
//          fontFamily: fontFamily,
//        );

//   // -------------------------
//   // HEADINGS
//   // -------------------------
//   AppTextStyles.h1({
//     Color super.color = Colors.black,
//     double size = 24.0,
//     FontWeight weight = FontWeight.w700,
//     super.decoration,
//     String fontFamily = 'Geist',
//   }) : super(
//          fontSize: size.sp.clamp(size * 0.8, size * 1.2),
//          fontWeight: weight,
//          fontFamily: fontFamily,
//        );

//   AppTextStyles.h2({
//     Color super.color = Colors.black,
//     double size = 20.0,
//     FontWeight weight = FontWeight.w600,
//     super.decoration,
//     String fontFamily = 'Geist',
//   }) : super(
//          fontSize: size.sp.clamp(size * 0.8, size * 1.2),
//          fontWeight: weight,
//          fontFamily: fontFamily,
//        );

//   AppTextStyles.h3({
//     Color super.color = Colors.black,
//     double size = 18.0,
//     FontWeight weight = FontWeight.w600,
//     super.decoration,
//     String fontFamily = 'Geist',
//   }) : super(
//          fontSize: size.sp.clamp(size * 0.8, size * 1.2),
//          fontWeight: weight,
//          fontFamily: fontFamily,
//        );

//   // -------------------------
//   // BODY SMALL
//   // -------------------------
//   AppTextStyles.bodySmall({
//     Color super.color = Colors.black,
//     double size = 12.0,
//     FontWeight weight = FontWeight.w400,
//     super.decoration,
//     String fontFamily = 'Geist',
//   }) : super(
//          fontSize: size.sp.clamp(size * 0.8, size * 1.2),
//          fontWeight: weight,
//          fontFamily: fontFamily,
//        );

//   AppTextStyles.bodySmallW500({
//     Color super.color = Colors.black,
//     double size = 12.0,
//     super.decoration,
//     String fontFamily = 'Geist',
//   }) : super(
//          fontSize: size.sp.clamp(size * 0.8, size * 1.2),
//          fontWeight: FontWeight.w500,
//          fontFamily: fontFamily,
//        );

//   AppTextStyles.bodySmallSemiBold({
//     Color super.color = Colors.black,
//     double size = 12.0,
//     super.decoration,
//     String fontFamily = 'Geist',
//   }) : super(
//          fontSize: size.sp.clamp(size * 0.8, size * 1.2),
//          fontWeight: FontWeight.w600,
//          fontFamily: fontFamily,
//        );

//   AppTextStyles.bodySmallBold({
//     Color super.color = Colors.black,
//     double size = 12.0,
//     super.decoration,
//     String fontFamily = 'Geist',
//   }) : super(
//          fontSize: size.sp.clamp(size * 0.8, size * 1.2),
//          fontWeight: FontWeight.w700,
//          fontFamily: fontFamily,
//        );

//   // -------------------------
//   // BODY MEDIUM
//   // -------------------------
//   AppTextStyles.bodyMedium({
//     Color super.color = Colors.black,
//     double size = 14.0,
//     FontWeight weight = FontWeight.w400,
//     super.decoration,
//     String fontFamily = 'Geist',
//   }) : super(
//          fontSize: size.sp.clamp(size * 0.8, size * 1.2),
//          fontWeight: weight,
//          fontFamily: fontFamily,
//        );

//   AppTextStyles.bodyMediumW500({
//     Color super.color = Colors.black,
//     double size = 14.0,
//     super.decoration,
//     String fontFamily = 'Geist',
//   }) : super(
//          fontSize: size.sp.clamp(size * 0.8, size * 1.2),
//          fontWeight: FontWeight.w500,
//          fontFamily: fontFamily,
//        );

//   AppTextStyles.bodyMediumSemiBold({
//     Color super.color = Colors.black,
//     double size = 14.0,
//     super.decoration,
//     String fontFamily = 'Geist',
//   }) : super(
//          fontSize: size.sp.clamp(size * 0.8, size * 1.2),
//          fontWeight: FontWeight.w600,
//          fontFamily: fontFamily,
//        );

//   AppTextStyles.bodyMediumBold({
//     Color super.color = Colors.black,
//     double size = 14.0,
//     super.decoration,
//     String fontFamily = 'Geist',
//   }) : super(
//          fontSize: size.sp.clamp(size * 0.8, size * 1.2),
//          fontWeight: FontWeight.w700,
//          fontFamily: fontFamily,
//        );

//   // -------------------------
//   // BODY LARGE
//   // -------------------------
//   AppTextStyles.bodyLarge({
//     Color super.color = Colors.black,
//     double size = 16.0,
//     FontWeight weight = FontWeight.w400,
//     super.decoration,
//     String fontFamily = 'Geist',
//   }) : super(
//          fontSize: size.sp.clamp(size * 0.8, size * 1.2),
//          fontWeight: weight,
//          fontFamily: fontFamily,
//        );

//   AppTextStyles.bodyLargeW500({
//     Color super.color = Colors.black,
//     double size = 16.0,
//     super.decoration,
//     String fontFamily = 'Geist',
//   }) : super(
//          fontSize: size.sp.clamp(size * 0.8, size * 1.2),
//          fontWeight: FontWeight.w500,
//          fontFamily: fontFamily,
//        );

//   AppTextStyles.bodyLargeSemiBold({
//     Color super.color = Colors.black,
//     double size = 16.0,
//     super.decoration,
//     String fontFamily = 'Geist',
//   }) : super(
//          fontSize: size.sp.clamp(size * 0.8, size * 1.2),
//          fontWeight: FontWeight.w600,
//          fontFamily: fontFamily,
//        );

//   AppTextStyles.bodyLargeBold({
//     Color super.color = Colors.black,
//     double size = 16.0,
//     super.decoration,
//     String fontFamily = 'Geist',
//   }) : super(
//          fontSize: size.sp.clamp(size * 0.8, size * 1.2),
//          fontWeight: FontWeight.w700,
//          fontFamily: fontFamily,
//        );

//   // -------------------------
//   // CAPTION
//   // -------------------------
//   AppTextStyles.caption({
//     Color super.color = Colors.grey,
//     double size = 10.0,
//     FontWeight weight = FontWeight.w500,
//     super.decoration,
//     String fontFamily = 'Geist',
//   }) : super(
//          fontSize: size.sp.clamp(size * 0.8, size * 1.2),
//          fontWeight: weight,
//          fontFamily: fontFamily,
//        );

//   // -------------------------
//   // BUTTON
//   // -------------------------
//   AppTextStyles.button({
//     Color super.color = Colors.blue,
//     double size = 14.0,
//     FontWeight weight = FontWeight.w700,
//     super.decoration,
//     String fontFamily = 'Geist',
//   }) : super(
//          fontSize: size.sp.clamp(size * 0.8, size * 1.2),
//          fontWeight: weight,
//          fontFamily: fontFamily,
//        );

//   // -------------------------
//   // CHAT
//   // -------------------------
//   AppTextStyles.chatMessage({
//     Color super.color = Colors.black,
//     double size = 12.0,
//     FontWeight weight = FontWeight.w400,
//     super.decoration,
//     String fontFamily = 'Geist',
//   }) : super(
//          fontSize: size.sp.clamp(size * 0.8, size * 1.2),
//          fontWeight: weight,
//          fontFamily: fontFamily,
//        );

//   AppTextStyles.chatMessageReceived({
//     Color super.color = Colors.grey,
//     double size = 12.0,
//     FontWeight weight = FontWeight.w400,
//     super.decoration,
//     String fontFamily = 'Geist',
//   }) : super(
//          fontSize: size.sp.clamp(size * 0.8, size * 1.2),
//          fontWeight: weight,
//          fontFamily: fontFamily,
//        );
// }
