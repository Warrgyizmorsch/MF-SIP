import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/dashboard/data/datasources/dashboard_remote_datasources.dart';
import 'package:my_sip/features/dashboard/domain/entity/portfolio_entity.dart';
import 'package:my_sip/features/dashboard/domain/entity/transactionlist_entity.dart';
import 'package:my_sip/features/dashboard/domain/repositories/dashboard_repo_abs.dart';

class DashboardRepoImple extends DashboardRepoAbs {
  final DashboardRemoteDatasources _remoteDataSource;

  DashboardRepoImple(this._remoteDataSource);

  @override
  Future<Either<Result<MfuTransactionListEntity>, ApiError>> getTransactions({
    required int uid,
  }) async {
    try {
      final response = await _remoteDataSource.getTransactions(uid: uid);
      return response.fold(
        (successResult) => Left(Result.success(successResult.data!.toEntity())),
        (error) => Right(error),
      );
    } catch (e) {
      return Right(ApiError(message: e.toString()));
    }
  }

  @override
  Future<Either<Result<MfuPortfolioEntity>, ApiError>> getPortfolio({
    required int uid,
  }) async {
    try {
      final response = await _remoteDataSource.getPortfolio(uid: uid);
      return response.fold(
        (successResult) => Left(Result.success(successResult.data!.toEntity())),
        (error) => Right(error),
      );
    } catch (e) {
      return Right(ApiError(message: e.toString()));
    }
  }
}
