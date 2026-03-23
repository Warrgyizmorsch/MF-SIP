import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/cart/domain/repositories/cart_repo.dart';

class DeleteCartItemUsecases {
  final CartRepo cartRepo;
  DeleteCartItemUsecases(this.cartRepo);

  Future<Either<Result<String>, ApiError>> call(
    Map<String, dynamic> data,
  ) async {
    return await cartRepo.deleteCartItem(data);
  }
}
