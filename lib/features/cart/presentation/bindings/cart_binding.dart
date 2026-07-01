import 'package:get/get.dart';


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
