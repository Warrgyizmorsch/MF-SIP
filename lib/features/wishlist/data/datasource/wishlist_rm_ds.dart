import 'package:dartz/dartz.dart';
import 'package:my_sip/core/network/network_api_service.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/core/utils/helper/helpers.dart';
import 'package:my_sip/features/wishlist/data/model/wishlist_model.dart';

class WishlistRmDs {
  final NetworkServicesApi networkServicesApi;
  WishlistRmDs(this.networkServicesApi);

  // add to wishlist
  Future<Either<Result<String>, ApiError>> addToWishlist(
    Map<String, dynamic> data,
  ) async {
    try {
      final res = await networkServicesApi.postApi(
        "${Appurl.baseUrl}/api/v1/wishlist/store",
        data: data,
      );

      createLog("[Add to Wishlist Remote Data Source]  Response: $res");

      if (res['success'] == true) {
        final result = res['message'];
        return Left(Result.success(result));
      } else {
        return Right(
          ApiError(message: 'Wishlist add item Failed: Success was false'),
        );
      }
    } catch (e) {
      return Right(
        ApiError(message: 'add to Wishlist Failed with Exception $e'),
      );
    }
  }

  // Fetch  Wishlist
  Future<Either<Result<WishlistResponseModel>, ApiError>> fetchWishList(
    String userID,
  ) async {
    try {
      final res = await networkServicesApi.getApi(
        "${Appurl.baseUrl}/api/v1/wishlist/$userID",
      );

      createLog("[fetch Wishlist Remote Data Source]  Response: $res");

      if (res['success'] == true) {
        final result = WishlistResponseModel.fromJson(res);
        return Left(Result.success(result));
      } else {
        return Right(
          ApiError(message: 'Wishlist fetch item Failed: Success was false'),
        );
      }
    } catch (e) {
      return Right(
        ApiError(message: 'fetch Wishlist Failed with Exception $e'),
      );
    }
  }

  // delete wishlist item
  Future<Either<bool, ApiError>> deleteWishList(String wishlistId) async {
    try {
      final res = await networkServicesApi.deleteApi(
        "${Appurl.baseUrl}/api/v1/wishlist/$wishlistId",
        {},
      );

      createLog("[delete Wishlist Remote Data Source] Response: $res");

      if (res['success'] == true) {
        return const Left(true);
      } else {
        return Right(ApiError(message: res['message'] ?? 'Delete failed'));
      }
    } catch (e) {
      return Right(ApiError(message: 'Delete Wishlist Failed: $e'));
    }
  }
}
