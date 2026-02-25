import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/wishlist/domain/entity/wishlist_entity.dart';
import 'package:my_sip/features/wishlist/domain/repository/wishlist_abs_repo.dart';

class FetchwishlistUsecases {
  final WishlistAbsRepo wishlistAbsRepo;

  FetchwishlistUsecases(this.wishlistAbsRepo);

  Future<Either<Result<WishlistEntity>, ApiError>> call(String userId) async {
    return await wishlistAbsRepo.fetchWishlist(userId);
  }
}
