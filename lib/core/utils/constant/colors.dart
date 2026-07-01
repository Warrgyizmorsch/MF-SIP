import 'package:flutter/material.dart';

class Ucolors {
  Ucolors._();

  static const Color primary = Color(0xff0280C0);
  static const Color indigo = Color(0xff223ec8);
  static const Color Orange = Color(0xffF28F33);
  static const Color textLight = Color(0xffC9EAFB);
  static const Color blue = Color(0xff07315C);
  static const Color darkBlue = Color(0xFF141E30);
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
  static const Color secondary = Color(0xff2A7BBF);
  static const Color black = Color(0xff000000);
  static const Color white = Color(0xffFFFFFF);

  static const primary3 = Color(0xFF000B3C);
  static const primaryContainer = Color(0xFF0A1F63);
  static const onPrimary = Color(0xFFFFFFFF);
  static const onPrimaryContainer = Color(0xFF7989D2);
  static const surface = Color(0xFFF9F9FF);
  static const surfaceBright = Color(0xFFF9F9FF);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainerLow = Color(0xFFF0F3FF);
  static const surfaceContainer = Color(0xFFE7EEFE);
  static const surfaceContainerHigh = Color(0xFFE2E8F8);
  static const surfaceContainerHighest = Color(0xFFDCE2F3);
  static const surfaceVariant = Color(0xFFDCE2F3);
  static const onSurface = Color(0xFF151C27);
  static const onSurfaceVariant = Color(0xFF454650);
  static const outline = Color(0xFF757682);
  static const outlineVariant = Color(0xFFC5C5D2);
  static const onSecondaryContainer = Color(0xFF5C656F);
  static const secondaryContainer = Color(0xFFDAE3EF);
  static const infoBanner = Color(0xFFEAF3FF);
  static const infoBannerBorder = Color(0xFFD5E6FF);

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

  static const LinearGradient premiumDarkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF141E30), // Deep almost-black blue
      Color(0xFF243B55), // Smooth slate blue
    ],
  );

  static const LinearGradient modernFintechGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF4B6CB7), // Vibrant Indigo
      Color(0xFF182848), // Dark Navy
    ],
  );

  static const LinearGradient deepOceanGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [Color(0xFF2C5364), Color(0xFF203A43), Color(0xFF0F2027)],
  );
  static const LinearGradient gradientBlue = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E40AF), Color(0xFF2563EB), Color(0xFF0EA5E9)],
    stops: [0.0, 0.55, 1.0],
  );
}
