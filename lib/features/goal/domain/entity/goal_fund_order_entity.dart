import 'package:equatable/equatable.dart';

import '../../data/model/goal_fund_order_model.dart';

class GoalFundResponseEntity extends Equatable {
  final bool status;
  final String message;
  final GoalFundOrderEntity data;

  const GoalFundResponseEntity({
    required this.status,
    required this.message,
    required this.data,
  });

  @override
  List<Object?> get props => [status, message, data];
}

class GoalFundOrderEntity extends Equatable {
  final int id;
  final int goalId;
  final int userId;
  final String schemeCode;
  final String orderType;
  final String orderDate;
  final String status;
  final double sipAmount;
  final int sipDay;
  final String sipStartDate;
  final String sipEndDate;
  final double lumpsumAmount;
  final double topUpAmount;
  final double stepUpPercentage;
  final double capingAmount;
  final String capingDate;

  const GoalFundOrderEntity({
    required this.id,
    required this.goalId,
    required this.userId,
    required this.schemeCode,
    required this.orderType,
    required this.orderDate,
    required this.status,
    required this.sipAmount,
    required this.sipDay,
    required this.sipStartDate,
    required this.sipEndDate,
    required this.lumpsumAmount,
    required this.topUpAmount,
    required this.stepUpPercentage,
    required this.capingAmount,
    required this.capingDate,
  });

  @override
  List<Object?> get props => [
    id,
    goalId,
    userId,
    schemeCode,
    orderType,
    orderDate,
    status,
    sipAmount,
    sipDay,
    sipStartDate,
    sipEndDate,
    lumpsumAmount,
    topUpAmount,
    stepUpPercentage,
    capingAmount,
    capingDate,
  ];
}

extension GoalFundResponseMapper on GoalFundResponseModel {
  GoalFundResponseEntity toEntity() {
    return GoalFundResponseEntity(
      status: status,
      message: message,
      data: data.toEntity(),
    );
  }
}

extension GoalFundOrderMapper on GoalFundOrderModel {
  GoalFundOrderEntity toEntity() {
    return GoalFundOrderEntity(
      id: id,
      goalId: goalId,
      userId: userId,
      schemeCode: schemeCode,
      orderType: orderType,
      orderDate: orderDate,
      status: status,
      sipAmount: sipAmount ?? 0,
      sipDay: sipDay??0,
      sipStartDate: sipStartDate??"",
      sipEndDate: sipEndDate??"",
      lumpsumAmount: lumpsumAmount ?? 0,
      topUpAmount: topUpAmount ?? 0,
      stepUpPercentage: stepUpPercentage ?? 0,
      capingAmount: capingAmount ?? 0,
      capingDate: capingDate??"",
    );
  }
}