import 'package:flutter/material.dart';

class Ucolors {
  Ucolors._();

  static const Color primary = Color(0xff0280C0);
  static const Color blue = Color(0xff07315C);
  static const Color dark = Color(0xff0F0F0F);
  static const Color success = Color(0xff1EC756);
  static const Color light = Color(0xffFFFFFF);
  static const Color darkgrey = Color(0xff787878);
  static const Color textFormEnabled = Color(0xff0280C0);
  static const Color borderColor = Color(0xffDFDFDF);
  static const Color hometxtblue = Color(0xff2A52CE);
  static const Color skyblue = Color(0xffD0EDFF);
  static const Color red = Color(0xffD03811);
  static const Color borderside = Color(0xffD0D0D0);
  static const Color skyblue1 = Color(0xffE8F4FF);



  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
    colors: [Color(0xff0280C0), Color(0xff07315C)],
  );

  static const LinearGradient icicibankGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFB3261E), Color(0xFFD84315)],
  );
}
