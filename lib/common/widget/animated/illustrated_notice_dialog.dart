import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';

/// Shared presentation only. Callers retain ownership of dismissal/navigation.
class IllustratedNoticeDialog extends StatelessWidget {
  const IllustratedNoticeDialog({
    super.key,
    required this.title,
    required this.message,
    required this.primaryButtonText,
    required this.onPrimaryTap,
    this.illustrationAsset,
    this.secondaryButtonText,
    this.onSecondaryTap,
    this.onDismiss,
    this.onClose,
    this.icon = Icons.info_outline_rounded,
    this.iconColor = Ucolors.primary,
  });

  final String title;
  final String message;
  final String primaryButtonText;
  final VoidCallback onPrimaryTap;
  final String? illustrationAsset;
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryTap;
  final VoidCallback? onDismiss;
  final VoidCallback? onClose;
  final IconData icon;
  final Color iconColor;

  static const _buttonStyle = TextStyle(
    fontFamily: FontFamily.medium,
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  Widget _fallbackIcon() => Center(
    child: Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.10),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 44, color: iconColor),
    ),
  );

  Widget _button(String text, VoidCallback onTap, {bool primary = false}) {
    final radius = BorderRadius.circular(100);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        color: primary ? null : Ucolors.homeTag,
        gradient: primary
            ? const LinearGradient(
                colors: [Ucolors.homeHeaderEnd, Ucolors.primary],
              )
            : null,
        border: primary
            ? null
            : Border.all(color: Ucolors.primary.withValues(alpha: 0.10)),
      ),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: primary ? Ucolors.white : Ucolors.homeInk,
          textStyle: _buttonStyle,
          minimumSize: const Size(0, 52),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: radius),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(text, textAlign: TextAlign.center),
      ),
    );
  }

  Widget _actions(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final primary = _button(primaryButtonText, onPrimaryTap, primary: true);
      if (secondaryButtonText == null || onSecondaryTap == null) {
        return SizedBox(width: double.infinity, child: primary);
      }
      final secondary = _button(secondaryButtonText!, onSecondaryTap!);
      final availableWidth = (constraints.maxWidth - 10) / 2;
      bool fits(String label) {
        final painter = TextPainter(
          text: TextSpan(text: label, style: _buttonStyle),
          textDirection: Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context),
        )..layout();
        final fits = painter.width + 32 <= availableWidth;
        painter.dispose();
        return fits;
      }

      if (!fits(primaryButtonText) || !fits(secondaryButtonText!)) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [secondary, const SizedBox(height: 10), primary],
        );
      }
      return Row(
        children: [
          Expanded(child: secondary),
          const SizedBox(width: 10),
          Expanded(child: primary),
        ],
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
      child: Dialog(
        backgroundColor: Ucolors.white,
        surfaceTintColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        constraints: const BoxConstraints(maxWidth: 400),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
          side: BorderSide(color: Ucolors.primary.withValues(alpha: 0.16)),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Ucolors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Ucolors.primary.withValues(alpha: 0.12),
                blurRadius: 22,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 176,
                      width: double.infinity,
                      child: illustrationAsset == null
                          ? _fallbackIcon()
                          : Image.asset(
                              illustrationAsset!,
                              fit: BoxFit.contain,
                              excludeFromSemantics: true,
                              errorBuilder: (_, _, _) => _fallbackIcon(),
                            ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: FontFamily.medium,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Ucolors.black,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: FontFamily.regular,
                        fontSize: 14,
                        height: 1.5,
                        color: Ucolors.homeTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 28),
                    _actions(context),
                    if (onDismiss != null) ...[
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: onDismiss,
                        style: TextButton.styleFrom(
                          foregroundColor: Ucolors.homeTextSecondary,
                          textStyle: _buttonStyle,
                        ),
                        child: const Text('Close'),
                      ),
                    ],
                  ],
                ),
              ),
              if (onClose != null && MediaQuery.sizeOf(context).width > 640)
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    tooltip: 'Close',
                    onPressed: onClose,
                    icon: const Icon(Icons.close_rounded, size: 20),
                    color: Ucolors.homeTextSecondary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
