import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/cart/data/datasources/cart_remote_ds.dart';
import 'package:my_sip/features/cart/domain/entities/cart_response_entity.dart';
import 'package:my_sip/features/cart/domain/repositories/cart_repo.dart';

class CartRepoImp extends CartRepo {
  final CartRemoteDs cartRemoteDs;

  CartRepoImp(this.cartRemoteDs);

  /// Add to cart 
  @override
  Future<Either<Result<String>, ApiError>> addToCart(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await cartRemoteDs.addToCart(data);
      return result.fold(
        (success) {
          if (success.isSuccess && success.data != null) {
            final result = success.data;
            return Left(Result.success(result));
          } else {
            return Right(ApiError(message: 'add to   cart Failed'));
          }
        },
        (error) {
          return Right(ApiError(message: 'add to cart failed $error'));
        },
      );
    } catch (e) {
      return Right(ApiError(message: 'add  to cart  Failed $e'));
    }
  }


  // Get cart details 
  @override
  Future<Either<Result<CartResponseEntity>, ApiError>> getCartItems(Map<String, dynamic> data)async {

    try {
      final result = await cartRemoteDs.getCartItems(data);
      return result.fold(
        (success) {
          if (success.isSuccess) {
            final result = success.data?.toEntity();
            return Left(Result.success(result));
          } else {
            return Right(ApiError(message: 'Cart items list Failed'));
          }
        },
        (error) {
          return Right(
            ApiError(message: 'Gcart item list  Failed $error'),
          );
        },
      );
    } catch (e) {
      return Right(ApiError(message: 'cart items  list  Failed $e'));
    }
   
  }
  
  //// Update Items 
  @override
  Future<Either<Result<String>, ApiError>> updateCart(Map<String, dynamic> data) async{

    try {
      final result = await cartRemoteDs.updateCart(data);
      return result.fold(
        (success) {
          if (success.isSuccess) {
            final result = success.data;
            return Left(Result.success(result));
          } else {
            return Right(ApiError(message: 'Cart items list Failed'));
          }
        },
        (error) {
          return Right(
            ApiError(message: 'Gcart item list  Failed $error'),
          );
        },
      );
    } catch (e) {
      return Right(ApiError(message: 'cart items  list  Failed $e'));
    }
   
  }

  /// Delete cart Items 
  @override
  Future<Either<Result<String>, ApiError>> deleteCartItem(Map<String, dynamic> data) async {
    try {
      final result = await cartRemoteDs.deleteCartItem(data);
      return result.fold(
        (success) {
          if (success.isSuccess) {
            final result = success.data;
            return Left(Result.success(result));
          } else {
            return Right(ApiError(message: 'Delete Cart items list Failed'));
          }
        },
        (error) {
          return Right(
            ApiError(message: 'delete cart item list  Failed $error'),
          );
        },
      );
    } catch (e) {
      return Right(ApiError(message: 'delete cart items  list  Failed $e'));
    }
  }
}
