

import 'package:dartz/dartz.dart';

import 'package:my_sip/core/utils/api/api_error.dart';

import 'package:my_sip/core/utils/api/api_result.dart';

import '../entity/goal_master_entity.dart';
import '../repositories/goal_repository.dart';

class GetMasterGoalsUseCase {
  final GoalRepository goalRepository;

  GetMasterGoalsUseCase({required this.goalRepository});


  Future<Either<Result<MasterGoalsResponseEntity>, ApiError>> call() async {
    return await goalRepository.getGoalsMaster();
  }
}