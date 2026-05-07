import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/cart/domain/entities/cart_response_entity.dart';

abstract class CartRepo {
    Future<Either<Result<String>, ApiError>> addToCart(Map<String, dynamic> data);
    Future<Either<Result<CartResponseEntity>, ApiError>> getCartItems(Map<String, dynamic> data);
    Future<Either<Result<String>, ApiError>> updateCart(Map<String, dynamic> data);
    Future<Either<Result<String>, ApiError>> deleteCartItem(Map<String, dynamic> data);

}