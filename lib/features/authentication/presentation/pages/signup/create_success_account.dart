import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:my_sip/common/widget/text/heading_section.dart';
import 'package:my_sip/common/widget/text/subtitle_section.dart';
import 'package:my_sip/common/widget/top_bottom_style/top_bottom_style.dart';
import 'package:my_sip/features/authentication/presentation/controllers/questions/question_controller.dart';
import 'package:my_sip/features/questions/presentation/pages/question1.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';

class CreateSuccessAccountScreen extends GetView<QuestionController> {
  const CreateSuccessAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () => Get.to(() => QuestionScreen()));

    return Scaffold(
      body: TopBottomDecoration(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                UImages.success,
                height: Get.height * (120 / 930),
                width: Get.width * (120 / 432),
              ),
              const HeadingText(title: 'Create Account Success'),
              const SubtitleText(
                subtitle: 'Let’s start to exploring your financial experience',
              ),
              LoadingAnimationWidget.hexagonDots(
                color: Ucolors.primary,
                size: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
