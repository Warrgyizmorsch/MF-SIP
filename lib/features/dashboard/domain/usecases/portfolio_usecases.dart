

import 'package:my_sip/features/dashboard/domain/entity/portfolio_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/dashboard/domain/repositories/dashboard_repo_abs.dart';

class GetPortfolioUseCase {
  final DashboardRepoAbs repo;

  GetPortfolioUseCase({required this.repo});

  Future<Either<Result<MfuPortfolioEntity>, ApiError>> call({
    required int uid,
  }) async {
    return await repo.getPortfolio.call(uid: uid);
  }
}