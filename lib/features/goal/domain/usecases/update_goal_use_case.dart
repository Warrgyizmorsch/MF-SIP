import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/goal/domain/repositories/goal_repository.dart';

class UpdateGoalUseCase {
  final GoalRepository goalRepository;

  UpdateGoalUseCase({required this.goalRepository});

  Future<Either<Result<String>, ApiError>> call({
    required int goalId,
    required Map<String, dynamic> data,
  }) async {
    return await goalRepository.updateGoal(goalId: goalId, data: data);
  }
}
