import 'package:flutter/material.dart';

class Ucolors {
  Ucolors._();

  static const Color primary = homeHeaderStart;
  static const Color indigo = homeSelectedNavigation;
  static const Color Orange = Color(0xffF28F33);
  static const Color textLight = homeOnboardingText;
  static const Color blue = homeHeaderEnd;
  static const Color darkBlue = blue;
  static const Color dark = Color(0xff0F0F0F);
  static const Color success = Color(0xff1EC756);
  static const Color light = Color(0xffFFFFFF);
  static const Color darkgrey = Color(0xff787878);
  static const Color textFormEnabled = primary;
  static const Color borderColor = Color(0xffDFDFDF);
  static const Color hometxtblue = primary;
  static const Color skyblue = homeSelectedNavigationFill;
  static const Color red = Color(0xffD03811);
  static const Color borderside = Color(0xffD0D0D0);
  static const Color skyblue1 = homeKycStart;
  static const Color secondary = primary;
  static const Color black = Color(0xff000000);
  static const Color white = Color(0xffFFFFFF);

  // Shared Home palette; the header endpoints also define the app brand colors.
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

  // Portfolio Details palette. Exact shared matches keep their existing names:
  // white, homeBackground, homePositive, homeHeaderEnd, goalPrimary,
  // homeTextSecondary, homeTileBorder and homePanelShadowFarColor.
  static const portfolioAccent = Color(0xFF441D9E);
  static const portfolioInk = Color(0xFF12121A);
  static const portfolioTextMuted = Color(0xFF8A8AA0);
  static const portfolioHeading = Color(0xFF1E293B);
  static const portfolioValueBlue = Color(0xFF2552E6);
  static const portfolioNegative = Color(0xFFFF383C);
  static const portfolioCardBorder = Color(0xFFE4E6EE);
  static const portfolioDivider = Color(0xFFD2D5DA);
  static const portfolioMetadataSurface = Color(0xFFFAFAFD);
  static const portfolioMetadataBorder = Color(0xFFEEF0F4);
  static const portfolioSelectedSurface = Color(0xFFEFEBF7);
  static const portfolioCountBadgeSurface = Color(0xFFE9EAF0);
  static const portfolioEmptyBackground = Color(0xFFF8FAFC);
  static const portfolioPositiveText = Color(0xFF16A34A);
  static const portfolioPendingText = Color(0xFFB45309);
  static const portfolioWarningText = Color(0xFFD97706);
  static const portfolioInfoSurface = Color(0xFFEFF6FF);
  static const portfolioInfoText = Color(0xFF2563EB);
  static const portfolioPayoutPendingSurface = Color(0xFFFFFBEB);
  static const portfolioPayoutPendingBorder = Color(0xFFFDE68A);
  static const portfolioPayoutSettledSurface = Color(0xFFF0FDF4);
  static const portfolioPayoutSettledBorder = Color(0xFFBBF7D0);
  static const portfolioCancelFill = Color(0x0FFF383C);
  static const portfolioCancelBorder = Color(0x33FF383C);
  static const portfolioRedeemShadow = Color(0x617C5CFF);
  static const portfolioHeaderGlow = Color(0x599D85FF);
  static const portfolioHeaderGlowTransparent = Color(0x009D85FF);

  // Preserve the existing Material shades used by legacy Portfolio states.
  static const portfolioBodyText = Colors.black87;
  static final portfolioSecondaryText = Colors.grey.shade600;
  static final portfolioSubtleText = Colors.grey.shade700;
  static final portfolioPlaceholder = Colors.grey.shade400;
  static const portfolioNeutralStatus = Colors.grey;
  static const portfolioSettledBanner = Colors.green;
  static const portfolioPendingBanner = Colors.amber;
  static const portfolioAllotmentBanner = Colors.blue;
  static final portfolioAuditGain = Colors.green.shade700;
  static final portfolioAuditGainStrong = Colors.green.shade800;
  static final portfolioAuditLoss = Colors.red.shade700;

  static const portfolioHeaderGradient = LinearGradient(
    begin: Alignment(-0.086, -1),
    end: Alignment(0.086, 1),
    colors: [homeHeaderEnd, portfolioAccent, goalPrimary],
    stops: [0.08, 0.54, 0.92],
  );
  static const portfolioHeaderGlowGradient = RadialGradient(
    center: Alignment(0.64, -0.7),
    radius: 0.22,
    colors: [portfolioHeaderGlow, portfolioHeaderGlowTransparent],
    stops: [0, 0.28],
  );
  static const portfolioRedeemGradient = LinearGradient(
    begin: Alignment(-0.168, -1.83),
    end: Alignment(0.168, 1.83),
    colors: [homeHeaderEnd, goalPrimary],
  );

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

  // Legacy brand identifiers stay available to existing callers.
  static const primary3 = blue;
  // Statement controls use this as a dark fill, unlike Material's light container.
  static const primaryContainer = blue;
  static const onPrimary = white;
  static const onPrimaryContainer = onPrimary;
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
  static const secondaryContainer = skyblue;
  static const infoBanner = Color(0xFFEAF3FF);
  static const infoBannerBorder = Color(0xFFD5E6FF);

  // Goal Planning Theme (Figma palette: #0E176F to #5B3FE0)
  static const Color goalDark = Color(0xFF0E176F);
  static const Color goalPrimary = Color(0xFF5B3FE0);

  static const LinearGradient goalGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0E176F), Color(0xFF5B3FE0)],
  );

  static const LinearGradient goalButtonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF0E176F), Color(0xFF5B3FE0)],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
    colors: [primary, blue],
  );

  static const LinearGradient icicibankGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFB3261E), Color(0xFFD84315)],
  );

  static const LinearGradient premiumDarkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [homeInk, blue],
  );

  static const LinearGradient modernFintechGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, blue],
  );

  static const LinearGradient deepOceanGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [indigo, blue, homeInk],
  );
  static const LinearGradient gradientBlue = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [blue, indigo, primary],
    stops: [0.0, 0.55, 1.0],
  );
}
