import 'package:dartz/dartz.dart';
import 'package:my_sip/features/fund_details/domain/entity/fund_detail_entity.dart';
import 'package:my_sip/features/fund_details/domain/entity/nav_history_entity.dart';
import 'package:my_sip/features/fund_details/domain/entity/portfolio_analysis_entity.dart' as pf;


import '../../../../core/utils/api/api_error.dart';
import '../../../../core/utils/api/api_result.dart';

abstract class FundDetailRepository {
  Future<Either<Result<FundDetailEntity>, ApiError>> getFundDetail(Map<String, dynamic> data);
  Future<Either<Result<pf.SchemeDetailsEntity>, ApiError>> getPortfolioAnlysis(Map<String, dynamic> data);
  Future<Either<Result<NavHistoryResponseEntity>, ApiError>> getNavhistory(Map<String, dynamic> data);
  
  
}