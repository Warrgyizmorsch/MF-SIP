import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/cart/domain/repositories/cart_repo.dart';

class AddToCartUsecases {
  final CartRepo cartRepo;

  AddToCartUsecases(this.cartRepo);

  Future<Either<Result<String>, ApiError>> call(
    Map<String, dynamic> data,
  ) async {
    return await cartRepo.addToCart(data);
  }
}
