import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/fund_details/domain/entity/portfolio_analysis_entity.dart';
import 'package:my_sip/features/fund_details/domain/repositories/fund_detail_repository.dart';

class PortfolioAnalysisUsecases {
  final FundDetailRepository _fundDetailRepository;

  PortfolioAnalysisUsecases(this._fundDetailRepository);

 

  // /// --------Portfolio analysis -------- //////////
  Future<Either<Result<SchemeDetailsEntity>, ApiError>> getPortfolioAnlysis(
    Map<String, dynamic> data,
  ) async {
    return await _fundDetailRepository.getPortfolioAnlysis(data);
  }
}