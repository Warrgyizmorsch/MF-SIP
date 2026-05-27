// features/mfu/domain/usecases/get_transactions_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/dashboard/domain/entity/transactionlist_entity.dart';
import 'package:my_sip/features/dashboard/domain/repositories/dashboard_repo_abs.dart';

class GetTransactionsUseCase {
  final DashboardRepoAbs repo;

  GetTransactionsUseCase({required this.repo});

  Future<Either<Result<MfuTransactionListEntity>, ApiError>> call({
    required int uid,
  }) async {
    return await repo.getTransactions(uid: uid);
  }
}
