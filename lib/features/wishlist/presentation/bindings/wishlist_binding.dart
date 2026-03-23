import 'package:get/get.dart';
import 'package:my_sip/core/network/network_api_service.dart';
import 'package:my_sip/features/wishlist/data/datasource/wishlist_rm_ds.dart';
import 'package:my_sip/features/wishlist/data/repositories/wishlist_repo_implement.dart';
import 'package:my_sip/features/wishlist/domain/repository/wishlist_abs_repo.dart';
import 'package:my_sip/features/wishlist/domain/usecases/addwishlist_usecases.dart';
import 'package:my_sip/features/wishlist/domain/usecases/deleteWishlist_usecases.dart';
import 'package:my_sip/features/wishlist/domain/usecases/fetchWishlist_usecases.dart';
import 'package:my_sip/features/wishlist/domain/usecases/wishlist_usecases.dart';
import 'package:my_sip/features/wishlist/presentation/controller/wishlist_controller.dart';

class WishlistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WishlistRmDs>(
      () => WishlistRmDs(Get.find<NetworkServicesApi>()),
      fenix: true
    );

    Get.lazyPut<WishlistAbsRepo>(
      () => WishlistRepoImplement(Get.find<WishlistRmDs>()),
      fenix: true
    );

    Get.lazyPut(() => FetchwishlistUsecases(Get.find<WishlistAbsRepo>()), fenix: true);
    Get.lazyPut(() => AddwishlistUsecases(Get.find<WishlistAbsRepo>()), fenix: true);
    Get.lazyPut(() => DeleteWishlistUsecase(Get.find<WishlistAbsRepo>()), fenix: true);

    Get.lazyPut(
      () => WishlistUsecases(
        Get.find<AddwishlistUsecases>(),
        Get.find<FetchwishlistUsecases>(),
        Get.find<DeleteWishlistUsecase>(),
      ),
      fenix: true,
    );

    Get.lazyPut<WishlistController>(
      () => WishlistController(Get.find()),
      fenix: true,
    );
  }
}
