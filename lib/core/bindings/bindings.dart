import 'package:get/get.dart';
import 'package:my_sip/features/cart/presentation/controllers/cart_controller.dart';
import 'package:my_sip/features/explore/data/datasources/mutualfund_remote_ds.dart';
import 'package:my_sip/features/explore/data/repositories/mutual_fund_repo_implement.dart';
import 'package:my_sip/features/explore/domain/repositories/mutual_fund_repository.dart';
import 'package:my_sip/features/explore/domain/usecases/get_mutual_fund_list_usecases.dart';
import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';
import 'package:my_sip/features/onboarding/presentation/controller/onboarding_controller.dart';
import 'package:my_sip/features/authentication/presentation/controllers/questions/question_controller.dart';

import '../network/network_api_service.dart';

class UBinding extends Bindings {
  @override
  void dependencies() {
    // Get.put(QuestionController());
    // Get.put(OnboardingController());
    Get.lazyPut<QuestionController>(() => QuestionController(), fenix: true);
    Get.lazyPut<OnboardingController>(
      () => OnboardingController(),
      fenix: true,
    );

    // Get.lazyPut(() => NetworkServicesApi());
    // Get.put(NetworkServicesApi(), permanent: true);
    Get.lazyPut<NetworkServicesApi>(() => NetworkServicesApi(), fenix: true);

    ///Mutual Fund Repository

    Get.lazyPut(() => MutualfundRemoteDs(Get.find()));

    // 3. Register the Repository
    Get.lazyPut<MutualFundRepository>(
      () => MutualFundRepoImplement(Get.find()),
    );

    // 4. Register the Use Case
    Get.lazyPut(() => GetMutualFundListUsecases(Get.find()));

    // 5. Finally, register the Controller
    Get.lazyPut(() => MutualFundController(Get.find()), fenix: true);

    Get.put<CartController>(CartController(), permanent: true);

  }
}
