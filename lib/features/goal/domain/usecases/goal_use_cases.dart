import 'package:my_sip/features/goal/domain/usecases/get_goals_use_case.dart';
import 'package:my_sip/features/goal/domain/usecases/goal_fund_delete_usecases.dart';
import 'package:my_sip/features/goal/domain/usecases/save_goal_to_fund.dart';
import 'package:my_sip/features/goal/domain/usecases/save_goal_use_case.dart';
import 'package:my_sip/features/goal/domain/usecases/update_goal_fund_order_use_case.dart';

import 'get_goal_master_use_case.dart';
import 'goal_fund_order_use_case.dart';

class GoalUseCases {
  final SaveGoalUseCase saveGoalUseCase;
  final GetGoalsUseCase getGoalsUseCase;
  final SaveGoalFundUseCase saveGoalFundUseCase;
  final DeleteGoalFundUseCase deleteGoalFundUseCase;
  final DeleteGoalUseCase deleteGoalUseCase;
  final GetMasterGoalsUseCase getMasterGoalsUseCase;
  final GoalFundOrderUseCase  goalFundOrderUseCase;
  final UpdateGoalFundOrderUseCase updateGoalFundOrderUseCase;
  GoalUseCases({
    required this.saveGoalUseCase,
    required this.getGoalsUseCase,
    required this.saveGoalFundUseCase,
    required this.deleteGoalFundUseCase,
    required this.deleteGoalUseCase,
    required this.getMasterGoalsUseCase,
    required this.goalFundOrderUseCase,
    required this.updateGoalFundOrderUseCase,
  });
}
