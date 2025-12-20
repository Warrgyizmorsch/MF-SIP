import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/utils/constant/colors.dart';

class OnboardignScroll extends StatelessWidget {
  const OnboardignScroll({
    super.key,
    required this.animation,
    required this.title,
    required this.subtitle,
  });

  final String animation;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // scrollDirection: Axis.vertical,
      child: Padding(
        padding: UPadding.screenPadding,
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          // mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Animation Image
            Center(
              child: Image.asset(animation, width: 335.w, height: 307.h),
            ),

            SizedBox(height: 52.h),

            //Title
            Text(
              textAlign: TextAlign.start,
              title,
              style: TextStyle(
                color: Ucolors.dark,
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 24.h),

            //Subtitle
            Text(
              textAlign: TextAlign.start,
              subtitle,
              style: TextStyle(
                color: Ucolors.darkgrey,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
