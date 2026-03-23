import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/explore/domain/entities/categories_filter_entity.dart';
import 'package:my_sip/features/explore/domain/repositories/mutual_fund_repository.dart';

class GetCategoriesFilterUsecases {
  final MutualFundRepository _mutualFundRepository;

  GetCategoriesFilterUsecases(this._mutualFundRepository);

  Future<Either<Result<FundCategoryEntity>, ApiError>> call(
    Map<String, dynamic> data,
  ) async {
    return await _mutualFundRepository.getMfCategories(data);
  }
}
