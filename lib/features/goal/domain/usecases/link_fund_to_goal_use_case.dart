import 'package:dartz/dartz.dart';
import '../../../../core/utils/api/api_error.dart';
import '../../../../core/utils/api/api_result.dart';
import '../entity/link_fund_goal_response_entity.dart';
import '../repositories/goal_repository.dart';

class LinkFundToGoalUseCase {
  final GoalRepository goalRepository;

  LinkFundToGoalUseCase({required this.goalRepository});

  Future<Either<Result<LinkFundGoalResponseEntity>, ApiError>> call({
    required int goalId,
    required int mfuOrderId,
  }) async {
    return await goalRepository.linkFundToGoal(
      goalId: goalId,
      mfuOrderId: mfuOrderId,
    );
  }
}
