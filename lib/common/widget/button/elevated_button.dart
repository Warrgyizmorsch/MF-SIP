import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UElevatedBUtton extends StatelessWidget {
  const UElevatedBUtton({
    super.key,
    required this.onPressed,
    this.icon,
    this.text,
    this.child,
    this.height,
    this.width,
  });

  final VoidCallback onPressed;
  final IconData? icon;
  final String? text;
  final Widget? child;
  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(14.r),
        ),
      ),
      onPressed: onPressed,
      child: Ink(
        // width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          gradient: LinearGradient(
            // begin: ,
            colors: [Color(0xff07315C), Color(0xff0280C0)],
          ),
        ),
        child: SizedBox(
          height: height ?? 60.h,
          // width: width ?? 398.w,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              child!,
              //     Text(
              //       textAlign: TextAlign.center,
              //       text!,
              //       style: TextStyle(color: Ucolors.light),
              //     ),
              // SizedBox(width: 10),
              // Icon(icon, size: 24, color: Ucolors.light),
            ],
          ),
        ),
      ),
    );
  }
}
