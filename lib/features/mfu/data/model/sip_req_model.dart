class SipReqModel {
  final String schemeCode;
  final double amount;
  final String frequency;
  final String day;
  final int? goalId;

  SipReqModel({
    required this.schemeCode,
    required this.amount,
    this.frequency = 'M',
    required this.day,
    this.goalId,
  });

  Map<String, dynamic> toJson() => {
    'scheme_code': schemeCode,
    'amount': amount,
    'frequency': frequency,
    'day': day,
    if (goalId != null) 'goal_id': goalId,
  };
}
