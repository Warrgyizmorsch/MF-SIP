import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:my_sip/features/personalization/domain/usecases/get_riskQuestion_use_cases.dart';
import 'package:my_sip/features/personalization/domain/usecases/personalisation_use_cases.dart';
import 'package:my_sip/features/personalization/domain/usecases/risk_submit_usecases.dart';
import 'package:my_sip/features/personalization/presentation/controllers/personalisation_controller.dart';

import '../../../../core/network/network_api_service.dart';
import '../../data/datasource/personalisation_remote_data_source.dart';
import '../../data/repository/personalisation_repository_impl.dart';
import '../../domain/repository/personalisation_repository.dart';

class PersonalisationBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Register the API Service first
    Get.lazyPut(() => NetworkServicesApi());

    // 2. Register the Data Source (it will "find" the API service)
    Get.lazyPut(() => PersonalisationRemoteDataSource(Get.find()));

    // 3. Register the Repository
    Get.lazyPut<PersonalisationRepository>(
      () => PersonalisationRepositoryImpl(Get.find()),
    );

    /// --
    Get.lazyPut(() => GetRiskquestionUseCases(Get.find()));
    Get.lazyPut(() => RiskSubmitUsecases(Get.find()));

    Get.lazyPut(
      () => PersonalisationUseCases(Get.find(), Get.find(), Get.find()),
    );

    // 4. Register the Use Case
    // Get.lazyPut(() => GetBankUseCases(Get.find()));

    // 5. Finally, register the Controller
    Get.lazyPut(
      () => PersonalisationController(Get.find<PersonalisationUseCases>()),
    );
  }
}
