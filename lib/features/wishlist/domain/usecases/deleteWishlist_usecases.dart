import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/features/wishlist/domain/repository/wishlist_abs_repo.dart';

class DeleteWishlistUsecase {
  final WishlistAbsRepo repository;

  DeleteWishlistUsecase(this.repository);

  Future<Either<bool, ApiError>> call(String wishlistId) async {
    return await repository.deleteFromWishlist(wishlistId);
  }
}