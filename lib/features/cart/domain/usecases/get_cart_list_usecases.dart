import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/cart/domain/entities/cart_response_entity.dart';
import 'package:my_sip/features/cart/domain/repositories/cart_repo.dart';

class GetCartListUsecases {
  final CartRepo cartRepo;

  GetCartListUsecases(this.cartRepo);

  Future<Either<Result<CartResponseEntity>, ApiError>> call(
    Map<String, dynamic> data,
  ) async {
    return await cartRepo.getCartItems(data);
  }
}
