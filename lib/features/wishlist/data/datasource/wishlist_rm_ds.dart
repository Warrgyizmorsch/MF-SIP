import 'package:dartz/dartz.dart';
import 'package:my_sip/core/network/network_api_service.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/core/utils/helper/helpers.dart';

class  WishlistRmDs {
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
      return Right(ApiError(message: 'add to Wishlist Failed with Exception $e'));
    }
  }

}