import '../../../../core/utils/helper/custom_json_parser.dart';
import 'goal_model.dart';

class MasterGoalsResponse {
  final bool status;
  final bool? success;
  final String message;
  final List<MasterGoal> data;
  final List<UserGoalModel>? userGoals;

  MasterGoalsResponse({
    required this.status,
    this.success,
    required this.message,
    required this.data,
    this.userGoals,
  });

  factory MasterGoalsResponse.fromJson(Map<String, dynamic> json) {
    return MasterGoalsResponse(
      status: json.parse<bool>('status') ?? false,
      success: json.parse<bool>('success'),
      message: json.parse<String>('message') ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => MasterGoal.fromJson(e as Map<String, dynamic>))
          .toList(),
      userGoals: json.parseListOf<UserGoalModel>(
        'user_goals',
        (item) => UserGoalModel.fromJson(item as Map<String, dynamic>),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      if (success != null) 'success': success,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class MasterGoal {
  final int id;
  final String goalType;
  final String goalIcon;
  final String logo;
  final String goalDescription;
  final String targetAmount;
  final String monthlyInvestment;
  final String expectedReturnRate;
  final int goalTenure;
  final String investedAmount;
  final String status;
  final bool isCreated;
  final UserGoalModel? userGoal;
  final int? userGoalId;
  final int userGoalsCount;
  final double currentInvestedAmount;
  final double progressPercent;

  MasterGoal({
    required this.id,
    required this.goalType,
    required this.goalIcon,
    required this.logo,
    required this.goalDescription,
    required this.targetAmount,
    required this.monthlyInvestment,
    required this.expectedReturnRate,
    required this.goalTenure,
    required this.investedAmount,
    required this.status,
    this.isCreated = false,
    this.userGoal,
    this.userGoalId,
    this.userGoalsCount = 0,
    this.currentInvestedAmount = 0.0,
    this.progressPercent = 0.0,
  });

  factory MasterGoal.fromJson(Map<String, dynamic> json) {
    return MasterGoal(
      id: json.parse<int>('id') ?? 0,
      goalType: json.parse<String>('goal_type') ?? '',
      logo: json.parse<String>('logo') ?? '',
      goalIcon: json.parse<String>('goal_icon') ?? '',
      goalDescription: json.parse<String>('goal_description') ?? '',
      targetAmount: json.parse<String>('target_amount') ?? '',
      monthlyInvestment: json.parse<String>('monthly_investment') ?? '',
      expectedReturnRate: json.parse<String>('expected_return_rate') ?? '',
      goalTenure: json.parse<int>('goal_tenure') ?? 0,
      investedAmount: json.parse<String>('Invested_amount') ?? '',
      status: json.parse<String>('status') ?? '',
      isCreated: json.parse<bool>('is_created') ?? false,
      userGoal:
          json['user_goal'] != null && json['user_goal'] is Map<String, dynamic>
          ? UserGoalModel.fromJson(json['user_goal'] as Map<String, dynamic>)
          : null,
      userGoalId: json.parse<int>('user_goal_id'),
      userGoalsCount: json.parse<int>('user_goals_count') ?? 0,
      currentInvestedAmount: json.parse<double>('invested_amount') ?? 0.0,
      progressPercent: json.parse<double>('progress_percent') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'goal_type': goalType,
      'logo': logo,
      'goal_icon': goalIcon,
      'goal_description': goalDescription,
      'target_amount': targetAmount,
      'monthly_investment': monthlyInvestment,
      'expected_return_rate': expectedReturnRate,
      'goal_tenure': goalTenure,
      'Invested_amount': investedAmount,
      'status': status,
      'is_created': isCreated,
      'user_goal_id': userGoalId,
      'user_goals_count': userGoalsCount,
      'invested_amount': currentInvestedAmount,
      'progress_percent': progressPercent,
    };
  }
}
