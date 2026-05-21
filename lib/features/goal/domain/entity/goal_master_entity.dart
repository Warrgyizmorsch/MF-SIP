import 'package:equatable/equatable.dart';

import '../../data/model/get_goal_master_model.dart';

class MasterGoalsResponseEntity extends Equatable {
  final bool status;
  final String message;
  final List<MasterGoalEntity> data;

  const MasterGoalsResponseEntity({
    required this.status,
    required this.message,
    required this.data,
  });

  @override
  List<Object?> get props => [status, message, data];
}

class MasterGoalEntity extends Equatable {
  final int id;
  final String goalType;
  final String goalIcon;
  final String goalDescription;
  final double targetAmount;
  final double monthlyInvestment;
  final double expectedReturnRate;
  final int goalTenure;
  final double investedAmount;
  final String status;

  const MasterGoalEntity({
    required this.id,
    required this.goalType,
    required this.goalIcon,
    required this.goalDescription,
    required this.targetAmount,
    required this.monthlyInvestment,
    required this.expectedReturnRate,
    required this.goalTenure,
    required this.investedAmount,
    required this.status,
  });

  @override
  List<Object?> get props => [
    id,
    goalType,
    goalIcon,
    goalDescription,
    targetAmount,
    monthlyInvestment,
    expectedReturnRate,
    goalTenure,
    investedAmount,
    status,
  ];
}

extension MasterGoalsResponseMapper on MasterGoalsResponse {
  MasterGoalsResponseEntity toEntity() {
    return MasterGoalsResponseEntity(
      status: status,
      message: message,
      data: data.map((e) => e.toEntity()).toList(),
    );
  }
}

extension MasterGoalMapper on MasterGoal {
  MasterGoalEntity toEntity() {
    return MasterGoalEntity(
      id: id,
      goalType: goalType,
      goalIcon: goalIcon,
      goalDescription: goalDescription,
      targetAmount: double.tryParse(targetAmount) ?? 0.0,
      monthlyInvestment:
      double.tryParse(monthlyInvestment) ?? 0.0,
      expectedReturnRate:
      double.tryParse(expectedReturnRate) ?? 0.0,
      goalTenure: goalTenure,
      investedAmount:
      double.tryParse(investedAmount) ?? 0.0,
      status: status,
    );
  }
}