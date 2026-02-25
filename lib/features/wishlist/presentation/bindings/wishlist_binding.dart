import 'package:get/get.dart';
import 'package:my_sip/core/network/network_api_service.dart';
import 'package:my_sip/features/wishlist/data/datasource/wishlist_rm_ds.dart';
import 'package:my_sip/features/wishlist/data/repositories/wishlist_repo_implement.dart';
import 'package:my_sip/features/wishlist/domain/repository/wishlist_abs_repo.dart';
import 'package:my_sip/features/wishlist/domain/usecases/addwishlist_usecases.dart';
import 'package:my_sip/features/wishlist/domain/usecases/wishlist_usecases.dart';
import 'package:my_sip/features/wishlist/presentation/controller/wishlist_controller.dart';

class WishlistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WishlistRmDs>(
      () => WishlistRmDs(Get.find<NetworkServicesApi>()),
    );

    Get.lazyPut<WishlistAbsRepo>(
      () => WishlistRepoImplement(Get.find<WishlistRmDs>()),
    );

    Get.lazyPut(() => AddwishlistUsecases(Get.find<WishlistAbsRepo>()));
    // Get.lazyPut(() => UpdateCartUsecases(Get.find<CartRepo>()));

    // Get.lazyPut(() => AddToCartUsecases(Get.find<CartRepo>()));
    // Get.lazyPut(() => DeleteCartItemUsecases(Get.find<CartRepo>()));

    Get.lazyPut(
      () => WishlistUsecases(
        // Get.find<AddToCartUsecases>(),
        // // Get.find<GetCartListUsecases>(),
        // Get.find<UpdateCartUsecases>(),
        // Get.find<DeleteCartItemUsecases>(),
        Get.find<AddwishlistUsecases>(),
      ),
    );

    Get.lazyPut<WishlistController>(
      () => WishlistController(Get.find()),
      fenix: true,
    );
  }
}
