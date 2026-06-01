import 'package:dartz/dartz.dart';
import 'package:my_sip/features/goal/domain/repositories/goal_repository.dart';

import '../../../../core/utils/api/api_error.dart';
import '../../../../core/utils/api/api_result.dart';
import '../entity/goal_entity.dart';
import '../entity/goal_fund_order_entity.dart';

class GoalFundOrderUseCase {
  final GoalRepository goalRepository;

  GoalFundOrderUseCase({required this.goalRepository});

  Future<Either<Result<GoalFundOrderEntity>,ApiError>>call(Map<String,dynamic> data) async {
    return await goalRepository.saveGoalFundOrder(data);
  }
}