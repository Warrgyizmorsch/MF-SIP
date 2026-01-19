import 'package:get/get.dart';
import 'package:my_sip/core/network/network_api_service.dart';
import 'package:my_sip/features/explore/data/datasources/fund_house_remote_ds.dart';
import 'package:my_sip/features/explore/data/repositories/fund_house_repo_imple.dart';
import 'package:my_sip/features/explore/domain/repositories/fund_house_repository.dart';
import 'package:my_sip/features/explore/domain/usecases/get_fundhouse_usecase.dart';
import 'package:my_sip/features/explore/presentation/controller/fundhouse_controller.dart';

class Fundhousebinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => NetworkServicesApi());

    // Get.lazyPut(() => FundHouseRemoteDs(Get.find()));

    // Get.lazyPut<FundHouseRepository>(() => FundHouseRepoImple(Get.find()));

    // Get.lazyPut(() => GetFundListUsecase(Get.find()));
    // Get.lazyPut(() => FundhouseUsecases(Get.find()));

    // Get.lazyPut(() => FundhouseController(Get.find()));

    Get.lazyPut(() => NetworkServicesApi());

    // 2. Register the Data Source (it will "find" the API service)
    Get.lazyPut(() => FundHouseRemoteDs(Get.find()));

    // 3. Register the Repository
    Get.lazyPut<FundHouseRepository>(() => FundHouseRepoImple(Get.find()));

    // 4. Register the Use Case
    Get.lazyPut(() => GetFundhouseUsecase(Get.find()));

    // 5. Finally, register the Controller
    Get.lazyPut(() => FundhouseController(Get.find()));
  }
}
