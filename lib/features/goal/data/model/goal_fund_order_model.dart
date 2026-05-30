class GoalFundResponseModel {
  final bool status;
  final String message;
  final GoalFundOrderModel data;

  const GoalFundResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GoalFundResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return GoalFundResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: GoalFundOrderModel.fromJson(
        json['data'] ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class GoalFundOrderModel {
  final int id;
  final int goalId;
  final int userId;
  final String schemeCode;
  final String orderType;
  final String orderDate;
  final String status;
  final double? sipAmount;
  final int? sipDay;
  final String? sipStartDate;
  final String? sipEndDate;
  final double? lumpsumAmount;
  final double? topUpAmount;
  final double? stepUpPercentage;
  final double? capingAmount;
  final String? capingDate;

  const GoalFundOrderModel({
    required this.id,
    required this.goalId,
    required this.userId,
    required this.schemeCode,
    required this.orderType,
    required this.orderDate,
    required this.status,
    this.sipAmount,
    this.sipDay,
    this.sipStartDate,
    this.sipEndDate,
    this.lumpsumAmount,
    this.topUpAmount,
    this.stepUpPercentage,
    this.capingAmount,
    this.capingDate,
  });

  factory GoalFundOrderModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return GoalFundOrderModel(
      id: json['id'] ?? 0,
      goalId: json['goal_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      schemeCode: json['scheme_code'] ?? '',
      orderType: json['order_type'] ?? '',
      orderDate: json['order_date'] ?? '',
      status: json['status'] ?? '',
      sipAmount: json['sip_amount']?.toDouble(),
      sipDay: json['sip_day'],
      sipStartDate: json['sip_start_date'],
      sipEndDate: json['sip_end_date'],
      lumpsumAmount: json['lumpsum_amount']?.toDouble(),
      topUpAmount: json['top_up_amount']?.toDouble(),
      stepUpPercentage: json['step_up_percentage']?.toDouble(),
      capingAmount: json['caping_amount']?.toDouble(),
      capingDate: json['caping_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'goal_id': goalId,
      'user_id': userId,
      'scheme_code': schemeCode,
      'order_type': orderType,
      'order_date': orderDate,
      'status': status,
      'sip_amount': sipAmount,
      'sip_day': sipDay,
      'sip_start_date': sipStartDate,
      'sip_end_date': sipEndDate,
      'lumpsum_amount': lumpsumAmount,
      'top_up_amount': topUpAmount,
      'step_up_percentage': stepUpPercentage,
      'caping_amount': capingAmount,
      'caping_date': capingDate,
    };
  }
}