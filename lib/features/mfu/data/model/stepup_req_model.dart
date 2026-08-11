class StepUpReqModel {
  final String schemeCode;
  final double amount;
  final String frequency;
  final String day;

  StepUpReqModel({
    required this.schemeCode,
    required this.amount,
    this.frequency = 'M',
    required this.day,
  });

  Map<String, dynamic> toJson() => {
    'scheme_code': schemeCode,
    'amount': amount,
    'frequency': frequency,
    'day': day,
  };
}
