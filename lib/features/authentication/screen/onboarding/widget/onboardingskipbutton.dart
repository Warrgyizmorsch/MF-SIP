import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:my_sip/features/authentication/controller/onboarding/onboarding_controller.dart';
import 'package:my_sip/utils/constant/colors.dart';

class OnBoardingSkipButton extends StatelessWidget {
  const OnBoardingSkipButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingController.instance;
    return TextButton(
      onPressed: controller.skipPage,
      child: Obx(
        () => Text(
          controller.currentIndex.value == 3 ? '' : 'Skip',
          textAlign: TextAlign.center,
          style: TextStyle(color: Ucolors.dark),
        ),
      ),
    );
  }
}
