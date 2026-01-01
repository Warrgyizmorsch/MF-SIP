import 'package:get/get.dart';
import 'package:my_sip/features/authentication/controller/onboarding/onboarding_controller.dart';
import 'package:my_sip/features/authentication/controller/questions/question_controller.dart';

class UBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(QuestionController());
    Get.put(OnboardingController());
  }
}
