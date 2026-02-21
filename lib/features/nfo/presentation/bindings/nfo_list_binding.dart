import 'package:get/get.dart';
import 'package:my_sip/core/network/network_api_service.dart';
import 'package:my_sip/features/nfo/data/datasource/nfo_remote_ds.dart';
import 'package:my_sip/features/nfo/data/repositories/nfo_repo_impl.dart';
import 'package:my_sip/features/nfo/domain/repositories/nfo_repo.dart';
import 'package:my_sip/features/nfo/domain/usecases/nfo_use_usecases.dart';
import 'package:my_sip/features/nfo/presentation/controller/nfo_controller.dart';

class NfoListBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Remote Data Source
    Get.lazyPut<NfoRemoteDs>(() => NfoRemoteDs(Get.find<NetworkServicesApi>()));

    // 2. Repository Implementation
    Get.lazyPut<NfoRepo>(() => NfoRepoImpl(Get.find<NfoRemoteDs>()));

    // 3. Use Case
    Get.lazyPut<NfoUseUsecases>(() => NfoUseUsecases(Get.find<NfoRepo>()));

    // 4. Controller
    Get.lazyPut<NfoController>(() => NfoController(Get.find<NfoUseUsecases>()));
  }
}
