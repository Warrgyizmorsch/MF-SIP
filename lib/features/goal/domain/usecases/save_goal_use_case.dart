import 'package:dartz/dartz.dart';
import 'package:my_sip/features/goal/domain/repositories/goal_repository.dart';

import '../../../../core/utils/api/api_error.dart';
import '../../../../core/utils/api/api_result.dart';

class SaveGoalUseCase {
  final GoalRepository goalRepository;

  SaveGoalUseCase({required this.goalRepository});

  Future<Either<Result<String>,ApiError>>call(Map<String,dynamic> data) async {
    return await goalRepository.saveGoal(data);
  }
}