import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_sip/features/authentication/controller/onboarding/onboarding_controller.dart';
import 'package:my_sip/features/authentication/screen/onboarding/widget/onboardingAnimation.dart';
import 'package:my_sip/features/authentication/screen/onboarding/widget/onboardingNextbutton.dart';
import 'package:my_sip/features/authentication/screen/onboarding/widget/onboardingskipbutton.dart';
import 'package:my_sip/utils/constant/images.dart';
import 'package:my_sip/utils/constant/text.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: controller.pagecontroller,
              onPageChanged: (value) => controller.updatePage(value),
              children: [
                OnboardignScroll(
                  animation: UImages.onboarding1,
                  title: UText.onboardingTitle1,
                  subtitle: UText.onboardingSubtitle1,
                ),
                OnboardignScroll(
                  animation: UImages.onboarding2,
                  title: UText.onboardingTitle2,
                  subtitle: UText.onboardingSubtitle2,
                ),
                OnboardignScroll(
                  animation: UImages.onboarding3,
                  title: UText.onboardingTitle3,
                  subtitle: UText.onboardingSubtitle3,
                ),
                OnboardignScroll(
                  animation: UImages.onboarding4,
                  title: UText.onboardingTitle4,
                  subtitle: UText.onboardingSubtitle4,
                ),
              ],
            ),
          ),

          SizedBox(height: 113.h),

          //Onboarding Next Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: OnBoardingNextButton(),
          ),
          SizedBox(height: 10.h),

          //Onboaring skip button
          OnBoardingSkipButton(),
          SizedBox(height: 37.h),
        ],
      ),
    );
  }
}
