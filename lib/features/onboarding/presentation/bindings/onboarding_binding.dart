import 'package:get/get.dart';
import 'package:my_sip/features/onboarding/presentation/controller/onboarding_controller.dart';

class OnboardingBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => OnboardingController());
  }
}