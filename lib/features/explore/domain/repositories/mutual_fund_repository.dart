import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/explore/domain/entities/categories_filter_entity.dart';
import 'package:my_sip/features/explore/domain/entities/mutual_fund_list_entity.dart';

abstract class MutualFundRepository {
  Future<Either<Result<MutualFundListResponseEntity>, ApiError>>
  getMutualFundList(Map<String, dynamic> data);
  // Future<Either<Result<SchemeDetailEntity>, ApiError>> getSchemeInfo(Map<String, dynamic> data);

  Future<Either<Result<FundCategoryEntity>, ApiError>>
  getMfCategories(Map<String, dynamic> data);
}
