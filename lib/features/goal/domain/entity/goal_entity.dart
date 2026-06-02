import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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

class SaveGoalResponseEntity extends Equatable {
  final bool success;
  final String message;
  final GoalDetailEntity data;

  const SaveGoalResponseEntity({
    required this.success,
    required this.message,
    required this.data,
  });

  @override
  List<Object?> get props => [success, message, data];
}

class GoalDetailEntity extends Equatable {
  final int id;
  final int userId;
  final int goalId;
  final String goalName;
  final String goalCover;
  final String txnType;
  final double lumpsumAmount;
  final String createdDate;
  final double targetAmount;
  final String frequency;
  final double monthlyInvestment;
  final double expectedReturnRate;
  final int goalTenure;
  final double investedAmount;
  final String status;
  final GoalTypeEntity? goalType;
  final List<GoalFundEntity> goalFunds;

  const GoalDetailEntity({
    required this.id,
    required this.userId,
    required this.goalId,
    required this.goalName,
    required this.goalCover,
    required this.txnType,
    required this.lumpsumAmount,
    required this.createdDate,
    required this.targetAmount,
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
    id, userId, goalId, goalName, goalCover, txnType, lumpsumAmount,
    createdDate, targetAmount, frequency, monthlyInvestment,
    expectedReturnRate, goalTenure, investedAmount, status, goalType, goalFunds,
  ];
}

class UserGoalEntity extends Equatable {
  final int id;
  final int userId;
  final int goalId;
  final String goalName;
  final String goalCover;
  final String txnType;
  final double lumpsumAmount;
  final double targetAmount;
  final String frequency;
  final double monthlyInvestment;
  final double expectedReturnRate;
  final int goalTenure;
  final double investedAmount;
  final String status;
  final String mfuOrderStatus;
  final GoalTypeEntity? goalType;
  final List<GoalFundEntity> goalFunds;

  const UserGoalEntity({
    required this.id,
    required this.userId,
    required this.goalId,
    required this.goalName,
    required this.goalCover,
    required this.txnType,
    required this.lumpsumAmount,
    required this.targetAmount,
    required this.frequency,
    required this.monthlyInvestment,
    required this.expectedReturnRate,
    required this.goalTenure,
    required this.investedAmount,
    required this.status,
    required this.mfuOrderStatus,
    this.goalType,
    required this.goalFunds,
  });

  @override
  List<Object?> get props => [
    id, userId, goalId, goalName, goalCover, txnType, lumpsumAmount, targetAmount,
    frequency, monthlyInvestment, expectedReturnRate, goalTenure, investedAmount,
    status, mfuOrderStatus, goalType, goalFunds,
  ];
}

class GoalTypeEntity extends Equatable {
  final int id;
  final String typeName;
  final String goalIcon;
  final String logo;
  final String goalDescription;
  final double targetAmount;
  final double monthlyInvestment;
  final double expectedReturnRate;
  final int goalTenure;
  final double investedAmount;
  final String status;

  const GoalTypeEntity({
    required this.id,
    required this.typeName,
    required this.goalIcon,
    required this.logo,
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
    id, typeName, goalIcon, goalDescription, targetAmount, monthlyInvestment,
    expectedReturnRate, goalTenure, investedAmount, status, logo,
  ];
}

class GoalFundEntity extends Equatable {
  final int id;
  final int goalId;
  final int userId;
  final String schemeCode;
  final String orderDate;
  final String orderType;
  final double sipAmount;
  final int sipDay;
  final String sipStartDate;
  final String sipEndDate;
  final double lumpsumAmount;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String mfuOrderStatus;
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
    required this.mfuOrderStatus,
    this.mutualFund,
  });

  @override
  List<Object?> get props => [
    id, goalId, userId, schemeCode, orderDate, orderType, sipAmount, sipDay,
    sipStartDate, sipEndDate, lumpsumAmount, status, createdAt, updatedAt, mfuOrderStatus, mutualFund,
  ];
}

class MutualFundEntity extends Equatable {
  final int id;
  final String schemeCode;
  final String schemeName;
  final String baseSchemeName;
  final String schemeType;
  final String schemeCategory;
  final String assetClass;
  final String riskLevel;
  final String isin;
  final int amcId;
  final double minSipAmount;
  final double minLumpsum;
  final double minimumTopup;
  final double nav;
  final String navDate;
  final AmcEntity? amc;

  const MutualFundEntity({
    required this.id,
    required this.schemeCode,
    required this.schemeName,
    required this.baseSchemeName,
    required this.schemeType,
    required this.schemeCategory,
    required this.assetClass,
    required this.riskLevel,
    required this.isin,
    required this.amcId,
    required this.minSipAmount,
    required this.minLumpsum,
    required this.minimumTopup,
    required this.nav,
    required this.navDate,
    this.amc,
  });

  @override
  List<Object?> get props => [
    id, schemeCode, schemeName, baseSchemeName, schemeType, schemeCategory,
    assetClass, riskLevel, isin, amcId, minSipAmount, minLumpsum, minimumTopup, nav, navDate, amc,
  ];
}

class AmcEntity extends Equatable {
  final int id;
  final String amcName;
  final String amcCode;
  final String amcLogo;
  final String amcLogoUrl;

  const AmcEntity({
    required this.id,
    required this.amcName,
    required this.amcCode,
    required this.amcLogo,
    required this.amcLogoUrl,
  });

  @override
  List<Object?> get props => [id, amcName, amcCode, amcLogo, amcLogoUrl];
}

// --- Mappers ---

extension GoalResponseMapper on GoalResponseModel {
  GoalResponseEntity toEntity() {
    return GoalResponseEntity(
      success: success ?? false,
      message: message ?? '',
      data: data?.map((e) => e.toEntity()).toList() ?? [],
    );
  }
}

extension GoalDetailMapper on GoalDetailModel {
  GoalDetailEntity toEntity() {
    return GoalDetailEntity(
      id: id ?? 0,
      userId: userId ?? 0,
      goalId: goalId ?? 0,
      goalName: goalName ?? '',
      goalCover: goalCover ?? '',
      txnType: txnType ?? '',
      lumpsumAmount: lumpsumAmount ?? 0.0,
      createdDate: createdDate ?? '',
      targetAmount: targetAmount ?? 0.0,
      frequency: frequency ?? '',
      monthlyInvestment: monthlyInvestment ?? 0.0,
      expectedReturnRate: expectedReturnRate ?? 0.0,
      goalTenure: goalTenure ?? 0,
      investedAmount: investedAmount ?? 0.0,
      status: status ?? '',
      goalFunds: const [],
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
      txnType: txnType ?? '',
      lumpsumAmount: lumpsumAmount ?? 0.0,
      targetAmount: targetAmount ?? 0.0,
      frequency: frequency ?? '',
      monthlyInvestment: monthlyInvestment ?? 0.0,
      expectedReturnRate: expectedReturnRate ?? 0.0,
      goalTenure: goalTenure ?? 0,
      investedAmount: investedAmount ?? 0.0,
      status: status ?? '',
      mfuOrderStatus: mfuOrderStatus ?? 'not_ordered',
      goalType: goalType?.toEntity(),
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
      mfuOrderStatus: mfuOrderStatus ?? 'not_ordered',
      mutualFund: mutualFund?.toEntity(),
    );
  }
}

extension MutualFundMapper on MutualFundModel {
  MutualFundEntity toEntity() {
    return MutualFundEntity(
      id: id ?? 0,
      schemeCode: schemeCode ?? '',
      schemeName: schemeName ?? '',
      baseSchemeName: baseSchemeName ?? '',
      schemeType: schemeType ?? '',
      schemeCategory: schemeCategory ?? '',
      assetClass: assetClass ?? '',
      riskLevel: riskLevel ?? '',
      isin: isin ?? '',
      amcId: amcId ?? 0,
      minSipAmount: minSipAmount ?? 0.0,
      minLumpsum: minLumpsum ?? 0.0,
      minimumTopup: minimumTopup ?? 0.0,
      nav: nav ?? 0.0,
      navDate: navDate ?? '',
      amc: amc?.toEntity(),
    );
  }
}

extension AmcMapper on AmcModel {
  AmcEntity toEntity() {
    return AmcEntity(
      id: id ?? 0,
      amcName: amcName ?? '',
      amcCode: amcCode ?? '',
      amcLogo: amcLogo ?? '',
      amcLogoUrl: amcLogoUrl ?? '',
    );
  }
}

extension SaveGoalResponseMapper on SaveGoalResponseModel {
  SaveGoalResponseEntity toEntity() {
    return SaveGoalResponseEntity(
      success: success ?? false,
      message: message ?? '',
      data: data != null
          ? data!.toEntity()
          : const GoalDetailEntity(
        id: 0, userId: 0, goalId: 0, goalName: '', goalCover: '',
        txnType: '', lumpsumAmount: 0.0, createdDate: '', targetAmount: 0.0,
        frequency: '', monthlyInvestment: 0.0, expectedReturnRate: 0.0,
        goalTenure: 0, investedAmount: 0.0, status: '', goalFunds: [],
      ),
    );
  }
}