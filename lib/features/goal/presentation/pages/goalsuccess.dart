import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';

class GoalsuccessPage extends StatelessWidget {
  const GoalsuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final title = args?['title'] ?? 'Goal Create Success';
    final subtitle = args?['subtitle'] ?? 'Your goal is created';
    final textButton = args?['textButton'] ?? 'Continue';
    final String? nextRoute = args?['nextroute'];

    return Scaffold(
      backgroundColor: Color(0xffB0E3FD),
      body: Padding(
        padding: UPadding.screenPadding,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.verified, size: 50, color: Ucolors.blue),
              const Gap(10),
              Text(
                title ?? 'Goal Create Success',
                style: UTextStyles.medium.copyWith(
                  color: Ucolors.blue,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                textAlign: TextAlign.center,
                subtitle ??
                    'Lorem Ipsum issis simply dummy text of the printing and',
                style: UTextStyles.small.copyWith(color: Ucolors.dark),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: UElevatedBUtton(
          color: Ucolors.blue,
          onPressed: () => Get.toNamed( nextRoute ?? AppRoutes.comparefund),
          child: Center(
            child: Text(
              textButton ?? 'See Detail',
              style: UTextStyles.buttonText.copyWith(color: Ucolors.light),
            ),
          ),
        ),
      ),
    );
  }
}
