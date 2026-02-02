import 'package:dartz/dartz.dart';
import 'package:my_sip/features/fund_details/domain/entity/fund_detail_entity.dart';

import '../../../../core/utils/api/api_error.dart';
import '../../../../core/utils/api/api_result.dart';

abstract class FundDetailRepository {
  Future<Either<Result<FundDetailEntity>, ApiError>> getFundDetail(Map<String, dynamic> data);
}