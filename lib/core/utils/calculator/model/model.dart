import 'package:my_sip/core/utils/calculator/mothlyeffectiverate.dart';

class SipResult {
  final double invested;
  final double totalValue;
  final double returns;

  SipResult({
    required this.invested,
    required this.totalValue,
    required this.returns,
  });
}

SipResult calculateSip({
  required double monthlyInvestment,
  required double annualRate,
  required double years,
}) {
  final months = (years * 12).round();
  final mRate = effectiveMonthlyRate(annualRate);

  double invested = 0;
  double value = 0;

  for (int i = 0; i < months; i++) {
    invested += monthlyInvestment;
    value = (value + monthlyInvestment) * (1 + mRate);
  }

  return SipResult(
    invested: invested,
    totalValue: value,
    returns: value - invested,
  );
}
