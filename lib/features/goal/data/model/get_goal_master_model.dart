class MasterGoalsResponse {
  final bool status;
  final String message;
  final List<MasterGoal> data;

  MasterGoalsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MasterGoalsResponse.fromJson(
      Map<String, dynamic> json) {
    return MasterGoalsResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => MasterGoal.fromJson(e))
          .toList(),
    );
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
  });

  factory MasterGoal.fromJson(Map<String, dynamic> json) {
    return MasterGoal(
      id: json['id'] ?? 0,
      goalType: json['goal_type'] ?? '',
      logo: json['logo'] ?? '',
      goalIcon: json['goal_icon'] ?? '',
      goalDescription: json['goal_description'] ?? '',
      targetAmount: json['target_amount'] ?? '',
      monthlyInvestment: json['monthly_investment'] ?? '',
      expectedReturnRate: json['expected_return_rate'] ?? '',
      goalTenure: json['goal_tenure'] ?? 0,
      investedAmount: json['Invested_amount'] ?? '',
      status: json['status'] ?? '',
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
    };
  }
}