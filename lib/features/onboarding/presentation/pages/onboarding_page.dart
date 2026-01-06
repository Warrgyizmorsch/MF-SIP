import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/features/onboarding/presentation/controller/onboarding_controller.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';

import '../../../../core/utils/constant/text.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingController.instance;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // backgroundColor: Colors.white,
      // appBar: AppBar(automaticallyImplyLeading: false),
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content: Image + Title + Subtitle
            PageView(
              controller: controller.pagecontroller,
              onPageChanged: controller.updatePage,
              children: [
                OnBoardingContent(
                  image: UImages.onboarding1,
                  title: UText.onboardingTitle1,
                  subtitle: UText.onboardingSubtitle1,
                ),
                OnBoardingContent(
                  image: UImages.onboarding2,
                  title: UText.onboardingTitle2,
                  subtitle: UText.onboardingSubtitle2,
                ),
                OnBoardingContent(
                  image: UImages.onboarding3,
                  title: UText.onboardingTitle3,
                  subtitle: UText.onboardingSubtitle3,
                ),
                OnBoardingContent(
                  image: UImages.onboarding4,
                  title: UText.onboardingTitle4,
                  subtitle: UText.onboardingSubtitle4,
                ),
              ],
            ),

            // Bottom Buttons (Next + Skip)
            Positioned(
              left: 16,
              right: 16,
              bottom:
                  size.height * 0.02, // Consistent from bottom on all devices
              child: Obx(() {
                final isLastPage = controller.currentIndex.value == 3;
                return Column(
                  children: [
                    // Next / Get Started Button
                    SizedBox(
                      width: double.infinity,
                      // height: 56,
                      child: UElevatedBUtton(
                        onPressed: controller.nextPage,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isLastPage ? 'Get Started' : 'Next',
                              style: UTextStyles.buttonText,
                            ),
                            if (!isLastPage) ...[
                              const SizedBox(width: 10),
                              const Icon(
                                Icons.arrow_forward,
                                color: Ucolors.light,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: Get.height * 0.013),
                    // Skip Button (hidden on last page)
                    if (!isLastPage)
                      TextButton(
                        onPressed: controller.skipPage,
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            color: Ucolors.dark,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class OnBoardingContent extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const OnBoardingContent({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: UPadding.screenPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image - Takes ~45% of screen height
          SizedBox(
            height: size.height * 0.3,
            width: size.height * 0.3,
            child: Image.asset(image, fit: BoxFit.cover),
          ),

          SizedBox(height: size.height * 0.03),

          // Title
          Text(
            title,
            style: UTextStyles.large.copyWith(fontSize: 20),
            textAlign: TextAlign.left,
          ),

          SizedBox(height: size.height * 0.01),

          // Subtitle (Description)
          Text(
            subtitle,
            // style: UTextStyles.subtitle1,
            style: UTextStyles.medium,
            // textAlign: TextAlign.justify
            textAlign: TextAlign.center,
          ),

          SizedBox(height: size.height * 0.15),
        ],
      ),
    );
  }
}
