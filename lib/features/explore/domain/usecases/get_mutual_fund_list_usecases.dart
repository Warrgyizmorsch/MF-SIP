import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/explore/domain/entities/mutual_fund_list_entity.dart';
import 'package:my_sip/features/explore/domain/repositories/mutual_fund_repository.dart';

class GetMutualFundListUsecases {
  final MutualFundRepository _mutualFundRepository;

  GetMutualFundListUsecases(this._mutualFundRepository);

  Future<Either<Result<MutualFundListResponseEntity>, ApiError>> call(
    Map<String, dynamic> data,
  ) async {
    return await _mutualFundRepository.getMutualFundList(data);
  }
}
