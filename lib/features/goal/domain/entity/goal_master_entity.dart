import 'package:equatable/equatable.dart';

import '../../data/model/get_goal_master_model.dart';
import 'goal_entity.dart';

class MasterGoalsResponseEntity extends Equatable {
  final bool status;
  final bool? success;
  final String message;
  final List<MasterGoalEntity> data;
  final List<UserGoalEntity>? userGoals;

  const MasterGoalsResponseEntity({
    required this.status,
    this.success,
    required this.message,
    required this.data,
    this.userGoals,
  });

  @override
  List<Object?> get props => [status, success, message, data, userGoals];
}

class MasterGoalEntity extends Equatable {
  final int id;
  final String goalType;
  final String goalIcon;
  final String logo;
  final String goalDescription;
  final double targetAmount;
  final double monthlyInvestment;
  final double expectedReturnRate;
  final int goalTenure;
  final double investedAmount;
  final String status;
  final bool isCreated;
  final UserGoalEntity? userGoal;
  final int? userGoalId;
  final int userGoalsCount;
  final double currentInvestedAmount;
  final double progressPercent;

  const MasterGoalEntity({
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

  @override
  List<Object?> get props => [
    id,
    goalType,
    goalIcon,
    logo,
    goalDescription,
    targetAmount,
    monthlyInvestment,
    expectedReturnRate,
    goalTenure,
    investedAmount,
    status,
    isCreated,
    userGoal,
    userGoalId,
    userGoalsCount,
    currentInvestedAmount,
    progressPercent,
  ];
}

extension MasterGoalsResponseMapper on MasterGoalsResponse {
  MasterGoalsResponseEntity toEntity() {
    return MasterGoalsResponseEntity(
      status: status,
      success: success,
      message: message,
      data: data.map((e) => e.toEntity()).toList(),
      userGoals: userGoals?.map((e) => e.toEntity()).toList(),
    );
  }
}

extension MasterGoalMapper on MasterGoal {
  MasterGoalEntity toEntity() {
    return MasterGoalEntity(
      id: id,
      goalType: goalType,
      goalIcon: goalIcon,
      logo: logo,
      goalDescription: goalDescription,
      targetAmount: double.tryParse(targetAmount) ?? 0.0,
      monthlyInvestment: double.tryParse(monthlyInvestment) ?? 0.0,
      expectedReturnRate: double.tryParse(expectedReturnRate) ?? 0.0,
      goalTenure: goalTenure,
      investedAmount: double.tryParse(investedAmount) ?? 0.0,
      status: status,
      isCreated: isCreated,
      userGoal: userGoal?.toEntity(),
      userGoalId: userGoalId,
      userGoalsCount: userGoalsCount,
      currentInvestedAmount: currentInvestedAmount,
      progressPercent: progressPercent,
    );
  }
}
