import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/dashboard/domain/entity/portfolio_entity.dart';
import 'package:my_sip/features/dashboard/domain/entity/transactionlist_entity.dart';

abstract class DashboardRepoAbs {
  Future<Either<Result<MfuTransactionListEntity>, ApiError>> getTransactions({
    required int uid,
  });

  Future<Either<Result<MfuPortfolioEntity>, ApiError>> getPortfolio({
    required int uid,
  });
}
