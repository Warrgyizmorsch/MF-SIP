import 'package:flutter/material.dart';
import 'package:my_sip/core/utils/constant/colors.dart';

class UElevatedButton2 extends StatelessWidget {
  const UElevatedButton2({
    super.key,
    this.onPressed,
    required this.child,
    this.height,
    this.width,
    this.outlined = false,
    this.color,
    this.circular,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final double? height, width;
  final bool outlined;
  final Color? color;
  final double? circular;

  @override
  Widget build(BuildContext context) {
    final double borderRadiusValue = circular ?? 12.0;

    return IntrinsicWidth(
      child: Container(
        // Use width if provided, otherwise it wraps content or expands
        width: width,
        height: height ?? 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadiusValue),
          border: outlined
              ? Border.all(color: const Color(0xffE7E7E7), width: 1)
              : null,
          gradient: (!outlined && color == null)
              ? Ucolors.backgroundGradient
              : null,
          color: outlined ? Colors.white : color,
          boxShadow: outlined
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(borderRadiusValue),
            highlightColor: Colors.black.withValues(alpha: 0.05),
            splashColor: Colors.black.withValues(alpha: 0.1),
            child: Padding(
              // Professional buttons need horizontal breathing room
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Center(widthFactor: 1.0, heightFactor: 1.0, child: child),
            ),
          ),
        ),
      ),
    );
  }
}

class UElevatedBUtton extends StatelessWidget {
  const UElevatedBUtton({
    super.key,
    this.onPressed,
    this.icon,
    this.text,
    required this.child,
    this.height,
    this.width,
    this.outlined = false,
    this.color,
    this.circular,
  });

  final VoidCallback? onPressed;
  final IconData? icon;
  final String? text;
  final Widget child;
  final double? height, width;
  final bool outlined;
  final Color? color;
  final double? circular;

  @override
  Widget build(BuildContext context) {
    final heightt = MediaQuery.of(context).size.height;
    // final widthh = MediaQuery.of(context).size.width;
    return TextButton(
      style: ButtonStyle(
        // padding: EdgeInsets.zero,
        //
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadiusGeometry.circular(circular ?? 12),
        // ),
      ),
      onPressed: onPressed,
      child: Ink(
        // width: double.infinity,
        decoration: outlined
            ? BoxDecoration(
                color: Ucolors.light,
                border: Border.all(color: Color(0xffE7E7E7)),
                borderRadius: BorderRadius.circular(circular ?? 12),
              )
            : BoxDecoration(
                borderRadius: BorderRadius.circular(circular ?? 12),
                color: color,

                gradient: color != null ? null : Ucolors.backgroundGradient,
              ),
        child: SizedBox(
          height: height ?? heightt * 0.045,
          // width: double.infinity,
          child: child,
        ),
      ),
    );
  }
}
class UElevatedButtonWeb extends StatelessWidget {
  const UElevatedButtonWeb({
    super.key,
    this.onPressed,
    this.icon,
    this.text,
    required this.child,
    this.height = 48, // 🚀 Fixed default height for Web (Standard desktop size)
    this.width,
    this.outlined = false,
    this.color,
    this.circular = 12,
  });

  final VoidCallback? onPressed;
  final IconData? icon;
  final String? text;
  final Widget child;
  final double height;
  final double? width;
  final bool outlined;
  final Color? color;
  final double circular;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width, // If null, it will size to fit its parent/child perfectly
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero, // Removes default gap so Ink fills entirely
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(circular),
          ),
        ),
        // 🚀 Ink must be inside the button child so the ripple effect clips to the radius
        child: Ink(
          decoration: outlined
              ? BoxDecoration(
            color: Ucolors.light, // Make sure Ucolors is imported
            border: Border.all(color: const Color(0xffE7E7E7), width: 1.5),
            borderRadius: BorderRadius.circular(circular),
          )
              : BoxDecoration(
            borderRadius: BorderRadius.circular(circular),
            color: color,
            gradient: color != null ? null : Ucolors.backgroundGradient,
          ),
          child: Container(
            alignment: Alignment.center, // Perfectly centers the text/child
            child: child,
          ),
        ),
      ),
    );
  }
}