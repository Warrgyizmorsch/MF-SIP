import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:my_sip/core/network/network_api_service.dart';
import 'package:my_sip/features/personalization/controller/bank_list_controller.dart';
import 'package:my_sip/features/personalization/data/datasource/personalisation_remote_data_source.dart';
import 'package:my_sip/features/personalization/data/repository/personalisation_repository_impl.dart';
import 'package:my_sip/features/personalization/domain/repository/personalisation_repository.dart';
import 'package:my_sip/features/personalization/domain/usecases/get_bank_use_cases.dart';

class Bankbinding extends Bindings {
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

    // 4. Register the Use Case
    Get.lazyPut(() => GetBankUseCases(Get.find()));

    // 5. Finally, register the Controller
    Get.lazyPut(() => BankController(Get.find()));
  }
}
