import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/explore/domain/entities/scheme_info_entity.dart';
import 'package:my_sip/features/explore/domain/repositories/mutual_fund_repository.dart';
import 'package:my_sip/features/fund_details/domain/entity/fund_detail_entity.dart';
import 'package:my_sip/features/fund_details/domain/repositories/fund_detail_repository.dart';

class GetFundDetailUseCase {
  final FundDetailRepository _fundDetailRepository;

  GetFundDetailUseCase(this._fundDetailRepository);

  Future<Either<Result<FundDetailEntity>, ApiError>> getSchemeInfo(
    Map<String, dynamic> data,
  ) async {
    return await _fundDetailRepository.getFundDetail(data);
  }
}
