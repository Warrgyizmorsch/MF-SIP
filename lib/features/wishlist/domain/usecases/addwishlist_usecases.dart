import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/wishlist/domain/repository/wishlist_abs_repo.dart';

class AddwishlistUsecases {
  final WishlistAbsRepo wishlistAbsRepo;

  AddwishlistUsecases(this.wishlistAbsRepo);

   Future<Either<Result<String>, ApiError>> call(
    Map<String, dynamic> data,
  ) async {
    return await wishlistAbsRepo.addToWishlist(data);
  }


}