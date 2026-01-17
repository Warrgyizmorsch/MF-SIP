import 'package:get/get.dart';
import 'package:my_sip/core/network/network_api_service.dart';
import 'package:my_sip/features/explore/data/datasources/fund_house_remote_ds.dart';
import 'package:my_sip/features/explore/data/repositories/fund_house_repo_imple.dart';
import 'package:my_sip/features/explore/domain/repositories/fund_house_repository.dart';
import 'package:my_sip/features/explore/domain/usecases/fundhouse_usecases.dart';
import 'package:my_sip/features/explore/presentation/controller/fundhouse_controller.dart';
import 'package:my_sip/features/sip_process/domain/usecases/get_fund_list_usecase.dart';

class Fundhousebinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NetworkServicesApi());

    Get.lazyPut(() => FundHouseRemoteDs(Get.find()));

    Get.lazyPut<FundHouseRepository>(() => FundHouseRepoImple(Get.find()));

    Get.lazyPut(() => GetFundListUsecase(Get.find()));
    Get.lazyPut(() => FundhouseUsecases(Get.find()));

    Get.lazyPut(() => FundhouseController(Get.find()));
  }
}
