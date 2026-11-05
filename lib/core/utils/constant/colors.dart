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

  // Home colors, available to any screen without changing the app theme.
  static const homeBackground = Color(0xFFF5F5F5);
  static const homeInk = Color(0xFF090E53);
  static const homeTextSecondary = Color(0xFF64748B);
  static const homeTextMuted = Color(0xFF8A8990);
  static const homeTile = Color(0xFFF5F5F7);
  static const homeTileBorder = Color(0xFFE2E8F0);
  static const homeCardBorder = Color(0xFFE5E7EB);
  static const homePanelBorder = Color(0x1A1B263B);
  static const homePanel = Color(0x4DFFFFFF);
  static const homePositive = Color(0xFF10B981);
  static const homeProgress = Color(0xFF22C474);
  static const homeProgressInk = Color(0xFF062A16);
  static const homeOnboardingText = Color(0xFFE9EAF2);
  static const homeOnboardingBadgeText = Color(0xFF2A2C3A);
  static const homeGoalHeading = Color(0xFF213C73);
  static const homeGoalBorder = Color(0xFFEEEEEE);
  static const homeTag = Color(0xFFF7F7FB);
  static const homeMoreFundBorder = Color(0xFFD1D1D1);
  static const homeNavigation = Color(0xFAF8F9FA);
  static const homeSelectedNavigation = Color(0xFF3129A2);
  static const homeNavigationText = Color(0xFF45556C);
  static const homeSelectedNavigationFill = Color(0xFFEEEDF9);
  static const homeSelectedNavigationStart = Color(0x144361EE);
  static const homeSelectedNavigationEnd = Color(0x0A4361EE);
  static const homeHeaderStart = Color(0xFF5B3FDF);
  static const homeHeaderEnd = Color(0xFF0E176F);
  static const homeOnboardingEnd = Color(0xFF5B3FDE);
  static const homeKycStart = Color(0xFFF2F1FB);
  static const homeKycEnd = Color(0xFF9E94EB);
  static const homeVideoBackground = Color(0xFF7BD2FF);
  static const homeVideoBorder = Color(0xFFEDE8FD);
  static const homeVideoOverlay = Color(0x66222222);
  static const homeSupportDescription = Color(0x66000000);
  static const homeSupportBackdropStart = Color(0xFFF3F7FF);
  static const homeSupportBackdropEnd = Color(0x00EDF3FF);
  static const homeSupportBackdropBorder = Color(0xFFEDEDED);
  static const homeTrustText = Color(0xFF7C7C7C);
  static const homeTrustTransparent = Color(0x00F5F5F5);
  static const homeTrustTint = Color(0x66F5F5F5);
  static const homePanelShadowNearColor = Color(0x05000000);
  static const homePanelShadowFarColor = Color(0x08000000);
  static const homeCardShadowColor = Color(0x1A000000);
  static const homeFeaturedFundShadowColor = Color(0x0A000000);
  static const homeGoalShadowColor = Color(0x0F000000);
  static const homeSearchShadowColor = Color(0x1A441D9E);
  static const homeSupportShadowColor = Color(0x40000000);
  static const homeSelectedNavigationShadowColor = Color(0x1F4361EE);

  static const homeHeaderGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [homeHeaderStart, homeHeaderEnd],
  );
  static const homeOnboardingGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [homeHeaderEnd, homeOnboardingEnd],
  );
  static const homeKycGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [homeKycStart, homeKycEnd],
  );
  static const homeSelectedNavigationGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [homeSelectedNavigationStart, homeSelectedNavigationEnd],
  );
  static const homeSupportBackdropGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [homeSupportBackdropStart, homeSupportBackdropEnd],
  );
  static const homeTrustHorizontalGradient = LinearGradient(
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
    colors: [homeBackground, homeTrustTint],
  );
  static const homeTrustVerticalGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [homeBackground, homeTrustTransparent, homeBackground],
    stops: [0, 0.5, 1],
  );

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

  // Goal Planning Theme (Figma palette: #0E176F to #5B3FE0)
  static const Color goalDark = Color(0xFF0E176F);
  static const Color goalPrimary = Color(0xFF5B3FE0);

  static const LinearGradient goalGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0E176F),
      Color(0xFF5B3FE0),
    ],
  );

  static const LinearGradient goalButtonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF0E176F),
      Color(0xFF5B3FE0),
    ],
  );

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
