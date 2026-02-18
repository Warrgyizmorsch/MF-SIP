import 'package:dartz/dartz.dart';
import 'package:my_sip/features/goal/domain/repositories/goal_repository.dart';

import '../../../../core/utils/api/api_error.dart';
import '../../../../core/utils/api/api_result.dart';
import '../entity/goal_entity.dart';

class GetGoalsUseCase {
  final GoalRepository goalRepository;

  GetGoalsUseCase({required this.goalRepository});

  Future<Either<Result<GoalResponseEntity>,ApiError>>call() async {
    return await goalRepository.getGoals();
  }
}