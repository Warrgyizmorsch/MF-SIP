import 'package:get/get.dart';
import 'package:my_sip/features/onboarding/presentation/controller/onboarding_controller.dart';
import 'package:my_sip/features/authentication/presentation/controllers/questions/question_controller.dart';

import '../network/base_api_service.dart';
import '../network/network_api_service.dart';

class UBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(QuestionController());
    Get.put(OnboardingController());
    Get.lazyPut<BaseApiServices>(() => NetworkServicesApi());
  }
}
