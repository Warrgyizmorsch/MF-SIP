import 'package:equatable/equatable.dart';

import '../../data/model/goal_model.dart';

class GoalResponseEntity extends Equatable {
  final bool success;
  final String message;
  final List<UserGoalEntity> data;

  const GoalResponseEntity({
    required this.success,
    required this.message,
    required this.data,
  });

  @override
  List<Object?> get props => [success, message, data];
}

class UserGoalEntity extends Equatable {
  final int id;
  final int userId;
  final int goalId;
  final String goalName;
  final String goalCover;
  final String frequency;
  final double monthlyInvestment;
  final double expectedReturnRate;
  final int goalTenure;
  final double investedAmount;
  final String status;
  final GoalTypeEntity? goalType; // API key: gold_type
  final List<GoalFundEntity> goalFunds;

  const UserGoalEntity({
    required this.id,
    required this.userId,
    required this.goalId,
    required this.goalName,
    required this.goalCover,
    required this.frequency,
    required this.monthlyInvestment,
    required this.expectedReturnRate,
    required this.goalTenure,
    required this.investedAmount,
    required this.status,
    this.goalType,
    required this.goalFunds,
  });

  @override
  List<Object?> get props => [
    id, userId, goalId, goalName, goalCover, frequency, monthlyInvestment,
    expectedReturnRate, goalTenure, investedAmount, status, goalType, goalFunds
  ];
}

class GoalTypeEntity extends Equatable {
  final int id;
  final String typeName; // API key: goal_type
  final String goalIcon;
  final String logo;
  final String goalDescription;
  final double targetAmount;
  final double monthlyInvestment;
  final double expectedReturnRate;
  final int goalTenure;
  final double investedAmount; // API key: Invested_amount
  final String status;

  const GoalTypeEntity({
    required this.id,
    required this.typeName,
    required this.goalIcon,
    required this.goalDescription,
    required this.targetAmount,
    required this.monthlyInvestment,
    required this.expectedReturnRate,
    required this.goalTenure,
    required this.investedAmount,
    required this.status, required this.logo,
  });

  @override
  List<Object?> get props => [
    id, typeName, goalIcon, goalDescription, targetAmount, monthlyInvestment,
    expectedReturnRate, goalTenure, investedAmount, status,logo
  ];
}

class GoalFundEntity extends Equatable {
  final int id;
  final int goalId;
  final int userId;
  final String schemeCode; // Handles int/string inconsistency
  final String orderDate;
  final String orderType;
  final double sipAmount;
  final int sipDay;
  final String sipStartDate;
  final String sipEndDate;
  final double lumpsumAmount;
  final String status;
  final String createdAt; // API key: cretated_at
  final String updatedAt;
  final MutualFundEntity? mutualFund;

  const GoalFundEntity({
    required this.id,
    required this.goalId,
    required this.userId,
    required this.schemeCode,
    required this.orderDate,
    required this.orderType,
    required this.sipAmount,
    required this.sipDay,
    required this.sipStartDate,
    required this.sipEndDate,
    required this.lumpsumAmount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.mutualFund,
  });

  @override
  List<Object?> get props => [
    id, goalId, userId, schemeCode, orderDate, orderType, sipAmount, sipDay,
    sipStartDate, sipEndDate, lumpsumAmount, status, createdAt, updatedAt, mutualFund
  ];
}

class MutualFundEntity extends Equatable {
  final String schemeCode;
  final String schemeName;
  final int amcId;
  final double minSipAmount;
  final double minLumpsum;
  final double minimumTopup;
  final AmcEntity? amc;

  const MutualFundEntity({
    required this.schemeCode,
    required this.schemeName,
    required this.amcId,
    required this.minSipAmount,
    required this.minLumpsum,
    required this.minimumTopup,
    this.amc,
  });

  @override
  List<Object?> get props => [schemeCode, schemeName, amcId, minSipAmount, minLumpsum, minimumTopup, amc];
}

class AmcEntity extends Equatable {
  final int id;
  final String amcLogo;
  final String amcLogoUrl;

  const AmcEntity({
    required this.id,
    required this.amcLogo,
    required this.amcLogoUrl,
  });

  @override
  List<Object?> get props => [id, amcLogo, amcLogoUrl];
}

extension GoalResponseMapper on GoalResponseModel {
  GoalResponseEntity toEntity() {
    return GoalResponseEntity(
      success: success ?? false,
      message: message ?? '',
      data: data?.map((e) => e.toEntity()).toList() ?? [],
    );
  }
}

extension UserGoalMapper on UserGoalModel {
  UserGoalEntity toEntity() {
    return UserGoalEntity(
      id: id ?? 0,
      userId: userId ?? 0,
      goalId: goalId ?? 0,
      goalName: goalName ?? '',
      goalCover: goalCover ?? '',
      frequency: frequency ?? '',
      monthlyInvestment: monthlyInvestment ?? 0.0,
      expectedReturnRate: expectedReturnRate ?? 0.0,
      goalTenure: goalTenure ?? 0,
      investedAmount: investedAmount ?? 0.0,
      status: status ?? '',
      goalType: goldType?.toEntity(),
      goalFunds: goalFunds?.map((e) => e.toEntity()).toList() ?? [],
    );
  }
}

extension GoalTypeMapper on GoalTypeModel {
  GoalTypeEntity toEntity() {
    return GoalTypeEntity(
      id: id ?? 0,
      typeName: goalType ?? '',
      goalIcon: goalIcon ?? '',
      logo: logo ?? '',
      goalDescription: goalDescription ?? '',
      targetAmount: targetAmount ?? 0.0,
      monthlyInvestment: monthlyInvestment ?? 0.0,
      expectedReturnRate: expectedReturnRate ?? 0.0,
      goalTenure: goalTenure ?? 0,
      investedAmount: investedAmount ?? 0.0,
      status: status ?? '',
    );
  }
}

extension GoalFundMapper on GoalFundModel {
  GoalFundEntity toEntity() {
    return GoalFundEntity(
      id: id ?? 0,
      goalId: goalId ?? 0,
      userId: userId ?? 0,
      schemeCode: schemeCode ?? '',
      orderDate: orderDate ?? '',
      orderType: orderType ?? '',
      sipAmount: sipAmount ?? 0.0,
      sipDay: sipDay ?? 0,
      sipStartDate: sipStartDate ?? '',
      sipEndDate: sipEndDate ?? '',
      lumpsumAmount: lumpsumAmount ?? 0.0,
      status: status ?? '',
      createdAt: createdAt ?? '',
      updatedAt: updatedAt ?? '',
      mutualFund: mutualFund?.toEntity(),
    );
  }
}

extension MutualFundMapper on MutualFundModel {
  MutualFundEntity toEntity() {
    return MutualFundEntity(
      schemeCode: schemeCode ?? '',
      schemeName: schemeName ?? '',
      amcId: amcId ?? 0,
      minSipAmount: minSipAmount ?? 0.0,
      minLumpsum: minLumpsum ?? 0.0,
      minimumTopup: minimumTopup ?? 0.0,
      amc: amc?.toEntity(),
    );
  }
}

extension AmcMapper on AmcModel {
  AmcEntity toEntity() {
    return AmcEntity(
      id: id ?? 0,
      amcLogo: amcLogo ?? '',
      amcLogoUrl: amcLogoUrl ?? '',
    );
  }
}