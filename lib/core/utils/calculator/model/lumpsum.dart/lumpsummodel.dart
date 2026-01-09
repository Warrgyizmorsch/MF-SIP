import 'dart:math';

import 'package:my_sip/core/utils/calculator/model/model.dart';

SipResult calculateLumpsum({
  required double investment,
  required double annualRate,
  required double years,
}) {
  final annual = annualRate / 100;
  final value = investment * pow(1 + annual, years);

  return SipResult(
    invested: investment,
    totalValue: value,
    returns: value - investment,
  );
}
