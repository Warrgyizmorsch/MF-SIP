import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/goal/domain/entity/single_goal_detail_entity.dart';
import 'package:my_sip/features/goal/domain/repositories/goal_repository.dart';

class GetSingleGoalUseCase {
  final GoalRepository goalRepository;

  GetSingleGoalUseCase({required this.goalRepository});

  Future<Either<Result<SingleGoalDetailResponseEntity>, ApiError>> call(
    int id,
  ) {
    return goalRepository.getSingleGoal(id);
  }
}
