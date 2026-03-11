import 'package:dartz/dartz.dart';
import 'package:my_sip/core/network/network_api_service.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/core/utils/helper/helpers.dart';
import 'package:my_sip/features/cart/data/model/cart_list_model.dart';
import 'package:my_sip/services/session_manager.dart';

class CartRemoteDs {
  final NetworkServicesApi networkServicesApi;

  CartRemoteDs(this.networkServicesApi);

  //add to cart item
  Future<Either<Result<String>, ApiError>> addToCart(
    Map<String, dynamic> data,
  ) async {
    try {
      final res = await networkServicesApi.postApi(
        "${Appurl.baseUrl}/api/v1/addcart",
        data: data,
        headers: {
          "Authorization": "Bearer ${SessionManager.instance.jwtAccessToken}",
        },
      );

      createLog("[Add to cart Remote Data Source]  Response: $res");

      if (res['status'] == true) {
        final result = res['message'];
        return Left(Result.success(result));
      } else {
        return Right(
          ApiError(message: 'cart add item Failed: Success was false'),
        );
      }
    } catch (e) {
      return Right(ApiError(message: 'add to cart Failed with Exception $e'));
    }
  }

  // Fetch cart details
  Future<Either<Result<CartResponseModel>, ApiError>> getCartItems(
    Map<String, dynamic> data,
  ) async {
    try {
      final res = await networkServicesApi.getApi(
        "${Appurl.baseUrl}/api/v1/cart",
        data: data,
        headers: {
          "Authorization": "Bearer ${SessionManager.instance.jwtAccessToken}",
        },
      );

      createLog("[Get details cart Remote Data Source]  Response: $res");

      if (res['status'] == true) {
        final result = CartResponseModel.fromJson(res);
        return Left(Result.success(result));
      } else {
        return Right(
          ApiError(message: 'cart details item  Failed: Success was false'),
        );
      }
    } catch (e) {
      return Right(
        ApiError(message: 'cart items details Failed with Exception $e'),
      );
    }
  }

  ///Update cart
  Future<Either<Result<String>, ApiError>> updateCart(
    Map<String, dynamic> data,
  ) async {
    try {
      final res = await networkServicesApi.postApi(
        "${Appurl.baseUrl}/api/v1/cart/update-item",
        data: data,
        headers: {
          "Authorization": "Bearer ${SessionManager.instance.jwtAccessToken}",
        },
      );

      createLog("[Update to cart Remote Data Source]  Response: $res");

      if (res['status'] == true) {
        final result = res['message'];
        return Left(Result.success(result));
      } else {
        return Right(
          ApiError(message: 'Update item Failed: Success was false'),
        );
      }
    } catch (e) {
      return Right(
        ApiError(message: 'Update to cart Failed with Exception $e'),
      );
    }
  }

  //Delete Item from cart
  Future<Either<Result<String>, ApiError>> deleteCartItem(
    Map<String, dynamic> data,
  ) async {
    try {
      final res = await networkServicesApi.postApi(
        "${Appurl.baseUrl}/api/v1/cart/delete-item",
        data: data,
        headers: {
          "Authorization": "Bearer ${SessionManager.instance.jwtAccessToken}",
        },
      );

      createLog("[Delete Item from cart Remote Data Source]  Response: $res");

      if (res['status'] == true) {
        final result = res['message'];
        return Left(Result.success(result));
      } else {
        return Right(
          ApiError(message: 'Delete item Failed: Success was false'),
        );
      }
    } catch (e) {
      return Right(
        ApiError(message: 'Delete to cart Failed with Exception $e'),
      );
    }
  }
}
