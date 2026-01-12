import 'dart:math';

/// Effective monthly rate from annual %
double effectiveMonthlyRate(double annualRatePercent) {
  final annual = annualRatePercent / 100;
  return pow(1 + annual, 1 / 12) - 1;
}
