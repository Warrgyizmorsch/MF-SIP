import 'package:equatable/equatable.dart';

import '../../data/model/update_goal_fund_order_model.dart';

class UpdateGoalFundEntity extends Equatable {
  final int id;
  final int goalId;
  final int userId;
  final String schemeCode;
  final String orderDate;
  final String orderType;
  final double? sipAmount;
  final int? sipDay;
  final String? sipStartDate;
  final String? sipEndDate;
  final double? lumpsumAmount;
  final double? topUpAmount;
  final double? stepUpPercentage;
  final double? capingAmount;
  final String? capingDate;
  final String status;
  final String createdAt;
  final String updatedAt;

  const UpdateGoalFundEntity({
    required this.id,
    required this.goalId,
    required this.userId,
    required this.schemeCode,
    required this.orderDate,
    required this.orderType,
    this.sipAmount,
    this.sipDay,
    this.sipStartDate,
    this.sipEndDate,
    this.lumpsumAmount,
    this.topUpAmount,
    this.stepUpPercentage,
    this.capingAmount,
    this.capingDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    goalId,
    userId,
    schemeCode,
    orderDate,
    orderType,
    sipAmount,
    sipDay,
    sipStartDate,
    sipEndDate,
    lumpsumAmount,
    topUpAmount,
    stepUpPercentage,
    capingAmount,
    capingDate,
    status,
    createdAt,
    updatedAt,
  ];
}
extension UpdateGoalFundMapper on UpdateGoalFundModel {
  UpdateGoalFundEntity toEntity() {
    return UpdateGoalFundEntity(
      id: id ?? 0,
      goalId: goalId ?? 0,
      userId: userId ?? 0,
      schemeCode: schemeCode ?? '',
      orderDate: orderDate ?? '',
      orderType: orderType ?? '',
      sipAmount: double.tryParse(sipAmount ?? ''),
      sipDay: sipDay,
      sipStartDate: sipStartDate,
      sipEndDate: sipEndDate,
      lumpsumAmount: double.tryParse(lumpsumAmount ?? ''),
      topUpAmount: double.tryParse(topUpAmount ?? ''),
      stepUpPercentage: double.tryParse(stepUpPercentage ?? ''),
      capingAmount: double.tryParse(capingAmount ?? ''),
      capingDate: capingDate,
      status: status ?? '',
      createdAt: createdAt ?? '',
      updatedAt: updatedAt ?? '',
    );
  }
}