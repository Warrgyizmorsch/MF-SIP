import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/features/authentication/controller/onboarding/onboarding_controller.dart';
import 'package:my_sip/utils/constant/colors.dart';

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingController.instance;
    return UElevatedBUtton(
      onPressed: controller.nextPage,
      child: Obx(
        () => Row(
          children: [
            Text(
              controller.currentIndex == 3 ? " Get Started" : 'Next',
              style: TextStyle(color: Ucolors.light),
            ),

            SizedBox(width: 10.w),

            controller.currentIndex == 3
                ? SizedBox()
                : Icon(Icons.arrow_forward, color: Ucolors.light),
          ],
        ),
      ),
    );
  }
}
