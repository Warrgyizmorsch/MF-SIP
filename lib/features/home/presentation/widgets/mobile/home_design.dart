import 'package:flutter/material.dart';

/// Figma measurements in logical pixels at the 430px reference width.
/// Widgets use width constraints to adapt these values to their layout.
abstract final class HomeMetrics {
  static const referenceWidth = 430.0;
  static const maxContentWidth = referenceWidth * 1.2;
  static const sectionWidth = 375.0;
  static const sectionInset = (referenceWidth - sectionWidth) / 2;
  static const compactHeaderHeight = 231.0;
  static const expandedHeaderHeight = 331.0;
  static const quickActionSize = 56.0;
  static const tickerHeight = 57.0;
  static const tickerCardWidth = 154.0;
  static const tickerGap = 10.0;
  static const collectionTileSize = 90.0;
  static const toolTileHeight = 50.0;
  static const goalTileHeight = 50.0;
  static const fundCardHeight = 150.0;
  static const popularCardHeight = 140.0;
  static const navigationHeight = 92.0;
}

/// Measures with the same inherited style, locale, and accessibility scaling as
/// Text so constrained reference cards can grow without disabling larger fonts.
abstract final class HomeTextLayout {
  static Size measure(
    BuildContext context,
    String text, {
    required TextStyle style,
    double maxWidth = double.infinity,
    int? maxLines,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: DefaultTextStyle.of(context).style.merge(style),
      ),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
      locale: Localizations.maybeLocaleOf(context),
      maxLines: maxLines,
      ellipsis: maxLines == null ? null : '…',
    )..layout(maxWidth: maxWidth.clamp(0.0, double.infinity).toDouble());
    final size = painter.size;
    painter.dispose();
    return size;
  }

  static double widestWord(
    BuildContext context,
    Iterable<String> labels, {
    required TextStyle style,
  }) {
    var width = 0.0;
    for (final word in labels.expand((label) => label.split(RegExp(r'\s+')))) {
      final measured = measure(context, word, style: style).width;
      if (measured > width) width = measured;
    }
    return width;
  }
}
