import 'package:dartz/dartz.dart';
import 'package:my_sip/features/goal/domain/repositories/goal_repository.dart';

import '../../../../core/utils/api/api_error.dart';
import '../../../../core/utils/api/api_result.dart';
import '../entity/update_goal_fund_order_entity.dart';

class UpdateGoalFundOrderUseCase {
  final GoalRepository goalRepository;

  UpdateGoalFundOrderUseCase({required this.goalRepository});

  Future<Either<Result<UpdateGoalFundEntity>,ApiError>>call(  List<Map<String, dynamic>> data, int fundId) async {
    return await goalRepository.updateGoalFund(data, fundId);  }
}