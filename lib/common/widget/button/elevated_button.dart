import 'package:flutter/material.dart';
import 'package:my_sip/core/utils/constant/colors.dart';

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
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(circular ?? 12),
        ),
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
          height: height ?? heightt * 0.065,
          width: double.infinity,
          child: child,
        ),
      ),
    );
  }
}
