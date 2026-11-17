import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/explore/domain/entities/mutual_fund_list_entity.dart';
import 'package:my_sip/features/fund_details/domain/repositories/fund_detail_repository.dart';

class GetFundsByManagerUseCase {
  final FundDetailRepository _repository;

  GetFundsByManagerUseCase(this._repository);

  Future<Either<Result<MutualFundListResponseEntity>, ApiError>> call(
    int managerId,
  ) async {
    return await _repository.getFundsByManager(managerId);
  }
}
