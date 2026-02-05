import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/fund_details/data/datasource/fund_detail_remote_data_source.dart';
import 'package:my_sip/features/fund_details/domain/entity/fund_detail_entity.dart';
import 'package:my_sip/features/fund_details/domain/entity/portfolio_analysis_entity.dart' as pf;
import 'package:my_sip/features/fund_details/domain/repositories/fund_detail_repository.dart';

class FundDetailRepositoryImpl extends FundDetailRepository {
  final FundDetailRemoteDataSource _fundDetailRemoteDataSource;

  FundDetailRepositoryImpl(this._fundDetailRemoteDataSource);

  @override
  Future<Either<Result<FundDetailEntity>, ApiError>> getFundDetail(Map<String, dynamic> data)
 async {
  try {
    final result = await _fundDetailRemoteDataSource.getSchemeInfo(data);
    return result.fold(
      (success) {
        if (success.isSuccess && success.data != null) {
          final result = success.data?.toEntity();
          return Left(Result.success(result));
        } else {
          return Right(ApiError(message: 'Scheme info details Failed'));
        }
      },
      (error) {
        return Right(ApiError(message: 'scheme info details failed $error'));
      },
    );
  } catch (e) {
    return Right(ApiError(message: 'Scheme info  fund list  Failed $e'));
  }
  }
  

  /// Portfolio analysis entity 
  @override
  Future<Either<Result<pf.SchemeDetailsEntity>, ApiError>> getPortfolioAnlysis(Map<String, dynamic> data)async {
    try {
    final result = await _fundDetailRemoteDataSource.getPortfolioAnlysis(data);
    return result.fold(
      (success) {
        if (success.isSuccess && success.data != null) {
          final result = success.data?.toEntity();
          return Left(Result.success(result));
        } else {
          return Right(ApiError(message: 'Portfolio info details Failed'));
        }
      },
      (error) {
        return Right(ApiError(message: 'Portfolio info details failed $error'));
      },
    );
  } catch (e) {
    return Right(ApiError(message: 'Portfolio info  fund list  Failed $e'));
  }
   
  }

}