class UpdateGoalFundModel {
  final int? id;
  final int? goalId;
  final int? userId;
  final String? schemeCode;
  final String? orderDate;
  final String? orderType;
  final String? sipAmount;
  final int? sipDay;
  final String? sipStartDate;
  final String? sipEndDate;
  final String? lumpsumAmount;
  final String? topUpAmount;
  final String? stepUpPercentage;
  final String? capingAmount;
  final String? capingDate;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  UpdateGoalFundModel({
    this.id,
    this.goalId,
    this.userId,
    this.schemeCode,
    this.orderDate,
    this.orderType,
    this.sipAmount,
    this.sipDay,
    this.sipStartDate,
    this.sipEndDate,
    this.lumpsumAmount,
    this.topUpAmount,
    this.stepUpPercentage,
    this.capingAmount,
    this.capingDate,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory UpdateGoalFundModel.fromJson(Map<String, dynamic> json) {
    return UpdateGoalFundModel(
      id: json['id'],
      goalId: json['goal_id'],
      userId: json['user_id'],
      schemeCode: json['scheme_code'],
      orderDate: json['order_date'],
      orderType: json['order_type'],
      sipAmount: json['sip_amount'],
      sipDay: json['sip_day'],
      sipStartDate: json['sip_start_date'],
      sipEndDate: json['sip_end_date'],
      lumpsumAmount: json['lumpsum_amount'],
      topUpAmount: json['top_up_amount'],
      stepUpPercentage: json['step_up_percentage'],
      capingAmount: json['caping_amount'],
      capingDate: json['caping_date'],
      status: json['status'],
      createdAt: json['cretated_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'goal_id': goalId,
      'user_id': userId,
      'scheme_code': schemeCode,
      'order_date': orderDate,
      'order_type': orderType,
      'sip_amount': sipAmount,
      'sip_day': sipDay,
      'sip_start_date': sipStartDate,
      'sip_end_date': sipEndDate,
      'lumpsum_amount': lumpsumAmount,
      'top_up_amount': topUpAmount,
      'step_up_percentage': stepUpPercentage,
      'caping_amount': capingAmount,
      'caping_date': capingDate,
      'status': status,
      'cretated_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}