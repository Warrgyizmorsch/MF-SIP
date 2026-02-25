import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/wishlist/data/datasource/wishlist_rm_ds.dart';
import 'package:my_sip/features/wishlist/domain/entity/wishlist_entity.dart';
import 'package:my_sip/features/wishlist/domain/repository/wishlist_abs_repo.dart';

class WishlistRepoImplement extends WishlistAbsRepo {
  final WishlistRmDs wishlistRmDs;

  WishlistRepoImplement(this.wishlistRmDs);

  ///////// [ add to wishlist ]  ///////
  @override
  Future<Either<Result<String>, ApiError>> addToWishlist(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await wishlistRmDs.addToWishlist(data);
      return result.fold(
        (success) {
          if (success.isSuccess && success.data != null) {
            final result = success.data;
            return Left(Result.success(result));
          } else {
            return Right(ApiError(message: 'add to wishiist Failed'));
          }
        },
        (error) {
          return Right(ApiError(message: 'add to wishlist failed $error'));
        },
      );
    } catch (e) {
      return Right(ApiError(message: 'add  to wishlist  Failed $e'));
    }
  }

  //////  [ fetch wishlist ]  //////
  @override
  Future<Either<Result<WishlistEntity>, ApiError>> fetchWishlist(
    String userId,
  ) async {
    try {
      final result = await wishlistRmDs.fetchWishList(userId);
      return result.fold(
        (success) {
          if (success.isSuccess) {
            final result = success.data?.toEntity();
            return Left(Result.success(result));
          } else {
            return Right(ApiError(message: 'Fetch  wishiist Failed'));
          }
        },
        (error) {
          return Right(ApiError(message: 'fetch to wishlist failed $error'));
        },
      );
    } catch (e) {
      return Right(ApiError(message: 'fetch wishlist  Failed $e'));
    }
  }
  
  // Delete Wishlist item
  @override
  Future<Either<bool, ApiError>> deleteFromWishlist(String wishlistId) async {
   return await wishlistRmDs.deleteWishList(wishlistId);
  }
}
