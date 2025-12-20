import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_sip/utils/constant/colors.dart';
import 'package:my_sip/utils/constant/images.dart';

class ImpContainer extends StatelessWidget {
  const ImpContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 262.h,
      // width: 398.w,
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 200.h),
      padding: EdgeInsets.symmetric(vertical: 20.h),

      // padding: EdgeInsets.symmetric(vertical: 24.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [
            Color.fromRGBO(228, 240, 252, 0.5),
            Color.fromRGBO(190, 224, 255, 0.7),
          ],
        ),
      ),
      child: FittedBox(
        // fit: BoxFit.scaleDown,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 57.h),
            Image.asset(
              UImages.imp,
              height: 90.h,
              width: 106.w,
              // fit: BoxFit.cover,
            ),
            Text(
              textAlign: TextAlign.center,
              'Your Smart Personal Finance AI',
              style: TextStyle(
                color: Ucolors.dark,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            Text(
              textAlign: TextAlign.center,
              'Companion UI Kit',
              style: TextStyle(
                color: Ucolors.dark,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 57.h),
          ],
        ),
      ),
    );
  }
}
