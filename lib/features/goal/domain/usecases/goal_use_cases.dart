import 'package:my_sip/features/goal/domain/usecases/get_goals_use_case.dart';
import 'package:my_sip/features/goal/domain/usecases/save_goal_to_fund.dart';
import 'package:my_sip/features/goal/domain/usecases/save_goal_use_case.dart';

class GoalUseCases {
  final SaveGoalUseCase saveGoalUseCase;
  final GetGoalsUseCase getGoalsUseCase;
  final SaveGoalFundUseCase saveGoalFundUseCase;

  GoalUseCases({
    required this.saveGoalUseCase,
    required this.getGoalsUseCase,
    required this.saveGoalFundUseCase,
  });
}
