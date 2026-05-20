import 'package:dartz/dartz.dart';
import 'package:my_sip/features/goal/domain/entity/delete_fund_goal_entity.dart';
import 'package:my_sip/features/goal/domain/entity/goal_entity.dart';

import '../../../../core/utils/api/api_error.dart';
import '../../../../core/utils/api/api_result.dart';

abstract class GoalRepository {
  Future<Either<Result<String>, ApiError>> saveGoal(Map<String, dynamic> data);
  Future<Either<Result<GoalResponseEntity>, ApiError>> getGoals();
  Future<Either<Result<String>, ApiError>> saveGoalFund(Map<String, dynamic> data);
  Future<Either<Result<DeleteGoalFundEntity>, ApiError>> deleteGoalFund({
  required int id,
});
  Future<Either<Result<DeleteGoalFundEntity>, ApiError>> deleteGoal({
  required int id,
});
}
