import 'package:get/get.dart';
import 'package:my_sip/core/network/network_api_service.dart';
import 'package:my_sip/features/kyc/data/datasource/kyc_remote_data_source.dart';
import 'package:my_sip/features/kyc/data/repository/kyc_repository_impl.dart';
import 'package:my_sip/features/kyc/domain/repository/kyc_repository.dart';
import 'package:my_sip/features/kyc/domain/usecases/execute_penny_drop_use_case.dart';
import 'package:my_sip/features/kyc/domain/usecases/execute_poa_use_case.dart';
import 'package:my_sip/features/kyc/domain/usecases/get_all_banks_use_case.dart';
import 'package:my_sip/features/kyc/domain/usecases/get_captcha_use_case.dart';
import 'package:my_sip/features/kyc/domain/usecases/get_token_data_use_case.dart';
import 'package:my_sip/features/kyc/domain/usecases/kyc_use_cases.dart';
import 'package:my_sip/features/kyc/domain/usecases/update_form_use_case.dart';
import 'package:my_sip/features/kyc/domain/usecases/upload_to_signZy_use_case.dart';
import 'package:my_sip/features/kyc/presentation/controllers/kyc_controller.dart';

import '../../../../services/session_manager.dart';
import '../../domain/usecases/execute_poi_step1_use_case.dart';
import '../../domain/usecases/execute_poi_step2_use_case.dart';

class KycBindings extends Bindings {
  @override
  void dependencies() {
    // 1. Data Source (Missing in your code)
    // Note: Assuming you have NetworkServicesApi registered. If not, put it here too.
    Get.lazyPut(() => KycRemoteDataSource(
      Get.find<NetworkServicesApi>(),
      Get.find<SessionManager>(), // Finds the instance created in main.dart
    ));

    // 2. Repository
    Get.lazyPut(() => KycRepositoryImpl(Get.find<KycRemoteDataSource>()));

    // 3. Use Cases
    Get.lazyPut(() => GetAllBanksUseCases(Get.find<KycRepositoryImpl>()));
    Get.lazyPut(() => ExecutePoiStep1UseCase(kycRepository: Get.find<KycRepositoryImpl>()));
    Get.lazyPut(() => ExecutePoiStep2UseCase(Get.find<KycRepositoryImpl>()));
    Get.lazyPut(() => UpdateFormUseCase(kycRepository: Get.find<KycRepositoryImpl>()));
    Get.lazyPut(() => ExecutePoaUseCase(kycRepository: Get.find<KycRepositoryImpl>()));
    Get.lazyPut(() => ExecutePennyDropUseCase(kycRepository: Get.find<KycRepositoryImpl>()));
    Get.lazyPut(() => UploadToSignzyUseCase(kycRepository: Get.find<KycRepositoryImpl>()));
    Get.lazyPut(() => GetCaptchaUseCase(kycRepository: Get.find<KycRepositoryImpl>()));
    Get.lazyPut(() => GetTokenDataUseCase(kycRepository: Get.find<KycRepositoryImpl>()));

    // 4. Main UseCase Wrapper
    Get.lazyPut(() => KycUseCases(
      getAllBanksUseCases: Get.find<GetAllBanksUseCases>(),
      executePoiStep1UseCase: Get.find<ExecutePoiStep1UseCase>(),
      executePoiStep2UseCase: Get.find<ExecutePoiStep2UseCase>(),
      updateFormUseCase: Get.find<UpdateFormUseCase>(),
      executePoaUseCase: Get.find<ExecutePoaUseCase>(),
      executePennyDropUseCase: Get.find<ExecutePennyDropUseCase>(),
      uploadToSignzyUseCase: Get.find<UploadToSignzyUseCase>(),
      getCaptchaUseCase: Get.find<GetCaptchaUseCase>(),
      getTokenDataUseCase: Get.find<GetTokenDataUseCase>(),
    ));

    // 5. Controller
    Get.lazyPut(() => KycController(Get.find<KycUseCases>()));
  }
}