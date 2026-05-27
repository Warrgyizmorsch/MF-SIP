import 'package:dartz/dartz.dart';
import 'package:my_sip/core/network/network_api_service.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/core/utils/helper/helpers.dart';
import 'package:my_sip/features/dashboard/data/model/portfolio_model.dart';
import 'package:my_sip/features/dashboard/data/model/transactionlist_model.dart';
import 'package:my_sip/services/session_manager.dart';

class DashboardRemoteDatasources {
  final NetworkServicesApi _apiService;
  final SessionManager sessionManager;

  DashboardRemoteDatasources(this._apiService, this.sessionManager);

   Future<Either<Result<MfuTransactionListModel>, ApiError>> getTransactions({
    required int uid,
  }) async {
    try {
      final body = {"uid": uid};

      createLog("[MfuRemoteDataSource] getTransactions Request: $body");

      final resp = await _apiService.postApi(
        "${Appurl.baseUrl}/api/v1/transaction",
        data: body,
      );

      createLog("[MfuRemoteDataSource] getTransactions Response: $resp");

      if (resp != null) {
        final result = MfuTransactionListModel.fromJson(resp);
        if (result.success == true) {
          return Left(Result.success(result));
        } else {
          return Right(ApiError(message: 'Failed to fetch transactions'));
        }
      } else {
        return Right(
          ApiError(message: 'getTransactions: Invalid response structure'),
        );
      }
    } catch (e) {
      return Right(ApiError(message: 'getTransactions Exception: $e'));
    }
  }

  Future<Either<Result<MfuPortfolioModel>, ApiError>> getPortfolio({
    required int uid,
  }) async {
    try {
      final body = {"uid": uid};

      createLog("[MfuRemoteDataSource] getPortfolio Request: $body");

      final resp = await _apiService.postApi(
        "${Appurl.baseUrl}/api/v1/portfolio",
        data: body,
      );

      createLog("[MfuRemoteDataSource] getPortfolio Response: $resp");

      if (resp != null) {
        final result = MfuPortfolioModel.fromJson(resp);
        if (result.success == true) {
          return Left(Result.success(result));
        } else {
          return Right(ApiError(message: 'Failed to fetch portfolio'));
        }
      } else {
        return Right(
          ApiError(message: 'getPortfolio: Invalid response structure'),
        );
      }
    } catch (e) {
      return Right(ApiError(message: 'getPortfolio Exception: $e'));
    }
  }

}
