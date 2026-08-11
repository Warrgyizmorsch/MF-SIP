class LumpsumReqModel {
  final String schemeCode;
  final double amount;
  final String folio;
  final int? goalId;

  LumpsumReqModel({
    required this.schemeCode,
    required this.amount,
    this.folio = 'NEW',
    this.goalId,
  });

  Map<String, dynamic> toJson() => {
    'scheme_code': schemeCode,
    'amount': amount,
    'folio': folio,
    if (goalId != null) 'goal_id': goalId,
  };
}
