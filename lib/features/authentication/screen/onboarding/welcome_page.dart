import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/features/authentication/screen/onboarding/onboarding.dart';
import 'package:my_sip/features/authentication/screen/onboarding/widget/imp_container.dart';
import 'package:my_sip/utils/constant/colors.dart';

class WelcomePageScreen extends StatelessWidget {
  WelcomePageScreen({super.key});

  final List<String> text = [
    'Smart Goal Tracking',
    'Auto SIP Calculator',
    'Flexible Investment Control',
    'Real-Time Portfolio Insights',
    'Risk-Based Fund Suggestions',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: UPadding.screenPadding,
        child: ListView(
          children: [
            //Imp container with titlw
            ImpContainer(),

            SizedBox(height: 127.h),

            Center(
              child: SizedBox(
                width: 0.66.sw,
                child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(height: 16.h),
                  shrinkWrap: true,
                  // physics: NeverScrollableScrollPhysics(),
                  itemCount: text.length,
                  itemBuilder: (context, index) => Center(
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        // SizedBox(width: 8.w),
                        Icon(
                          Icons.check_circle_rounded,
                          color: Ucolors.success,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),

                        Text(
                          // textAlign: TextAlign.center,
                          text[index],
                          style: TextStyle(
                            color: Ucolors.dark,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 127.h),
          ],
        ),
      ),

      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: UElevatedBUtton(
          onPressed: () => Get.to(() => OnboardingScreen()),
          child: Row(
            children: [
              Text('Let’s Get Started', style: TextStyle(color: Ucolors.light)),
              // Icon(Icons.arrow_forward_outlined, color: Ucl,),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
