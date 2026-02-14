import 'package:get/get.dart';
import 'package:my_sip/core/network/network_api_service.dart';
import 'package:my_sip/features/cart/data/datasources/cart_remote_ds.dart';
import 'package:my_sip/features/cart/data/repositories/cart_repo_imp.dart';
import 'package:my_sip/features/cart/domain/repositories/cart_repo.dart';
import 'package:my_sip/features/cart/domain/usecases/add_to_cart_usecases.dart';
import 'package:my_sip/features/cart/domain/usecases/cart_usecases.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<CartRemoteDs>(
    //   () => CartRemoteDs(Get.find<NetworkServicesApi>()),
    // );

    // Get.lazyPut<CartRepo>(() => CartRepoImp(Get.find<CartRemoteDs>()));

    // Get.lazyPut(() => CartUsecases(Get.find()));

    // Get.lazyPut(() => AddToCartUsecases(Get.find<CartRepo>()));
  }
}
