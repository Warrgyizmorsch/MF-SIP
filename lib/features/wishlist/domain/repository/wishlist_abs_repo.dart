import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/wishlist/domain/entity/wishlist_entity.dart';

abstract class WishlistAbsRepo {
  Future<Either<Result<String>, ApiError>> addToWishlist(
    Map<String, dynamic> data,
  );
  Future<Either<Result<WishlistEntity>, ApiError>> fetchWishlist(String userId);

  Future<Either<bool, ApiError>> deleteFromWishlist(String wishlistId);
}
