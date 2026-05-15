// features/goal/domain/usecases/delete_goal_fund_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/goal/domain/entity/delete_fund_goal_entity.dart';
import 'package:my_sip/features/goal/domain/repositories/goal_repository.dart';

class DeleteGoalFundUseCase {
  final GoalRepository goalRepository;

  DeleteGoalFundUseCase({required this.goalRepository});

  Future<Either<Result<DeleteGoalFundEntity>, ApiError>> call({
    required int id,
  }) async {
    return await goalRepository.deleteGoalFund(id: id);
  }
}