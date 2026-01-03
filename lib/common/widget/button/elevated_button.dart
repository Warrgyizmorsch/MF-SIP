import 'package:flutter/material.dart';
import 'package:my_sip/utils/constant/colors.dart';

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
  });

  final VoidCallback? onPressed;
  final IconData? icon;
  final String? text;
  final Widget child;
  final double? height, width;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final heightt = MediaQuery.of(context).size.height;
    // final widthh = MediaQuery.of(context).size.width;
    return ElevatedButton(
      
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(14),
        ),
      ),
      onPressed: onPressed,
      child: Ink(
        // width: double.infinity,
        decoration: outlined
            ? BoxDecoration(
                color: Ucolors.light,
                border: Border.all(color: Color(0xffE7E7E7)),
                borderRadius: BorderRadius.circular(14),
              )
            : BoxDecoration(
                borderRadius: BorderRadius.circular(12),

                gradient: Ucolors.backgroundGradient,
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
