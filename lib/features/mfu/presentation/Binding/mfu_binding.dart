import 'package:get/get.dart';
import 'package:my_sip/core/network/network_api_service.dart';
import 'package:my_sip/features/mfu/data/datasource/mfu_remote_data_source.dart';
import 'package:my_sip/features/mfu/data/repository/mfu_repo_imple.dart';
import 'package:my_sip/features/mfu/domain/usecases/can_register_usecases.dart';
import 'package:my_sip/features/mfu/domain/usecases/can_status_usecases.dart';
import 'package:my_sip/features/mfu/domain/usecases/mfu_usecases.dart';
import 'package:my_sip/features/mfu/presentation/controller/mfu_controller.dart';

import 'package:my_sip/services/session_manager.dart';

class MfuBindings extends Bindings {
  @override
  void dependencies() {
    // 1. Data Source
    Get.lazyPut(
      () => MfuRemoteDataSource(
        Get.find<NetworkServicesApi>(),
        Get.find<SessionManager>(),
      ),
    );

    // 2. Repository
    Get.lazyPut(() => MfuRepositoryImpl(Get.find<MfuRemoteDataSource>()));

    // 3. Use Cases
    Get.lazyPut(
      () => CanRegisterUseCase(mfuRepository: Get.find<MfuRepositoryImpl>()),
    );
    Get.lazyPut(
      () => GetCanStatusUseCase(mfuRepository: Get.find<MfuRepositoryImpl>()),
    );

    // 4. Use Cases Wrapper
    Get.lazyPut(
      () => MfuUseCases(
        canRegisterUseCase: Get.find<CanRegisterUseCase>(),
        getCanStatusUseCase: Get.find<GetCanStatusUseCase>(), // 👈 add
      ),
    );

    // 5. Controller
    Get.lazyPut(() => MfuController(Get.find<MfuUseCases>()));
  }
}
