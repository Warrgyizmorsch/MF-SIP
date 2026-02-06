import 'package:get/get.dart';
import 'package:my_sip/core/network/network_api_service.dart';
import 'package:my_sip/features/kyc/data/datasource/kyc_remote_data_source.dart';
import 'package:my_sip/features/kyc/data/repository/kyc_repository_impl.dart';
import 'package:my_sip/features/kyc/domain/repository/kyc_repository.dart';
import 'package:my_sip/features/kyc/domain/usecases/get_all_banks_use_case.dart';
import 'package:my_sip/features/kyc/domain/usecases/kyc_use_cases.dart';
import 'package:my_sip/features/kyc/presentation/controllers/kyc_controller.dart';

class KycBindings extends Bindings{
  @override
  void dependencies() {

    Get.lazyPut(() => KycRemoteDataSource(Get.find<NetworkServicesApi>()));
    Get.lazyPut(() => KycRepositoryImpl(Get.find<KycRemoteDataSource>()));
    Get.lazyPut(() => GetAllBanksUseCases(Get.find<KycRepositoryImpl>()));
    Get.lazyPut(() => KycUseCases(getAllBanksUseCases: Get.find<GetAllBanksUseCases>()));
    Get.lazyPut(() => KycController(Get.find<KycUseCases>()));
  }
}