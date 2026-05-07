import 'dart:math';
import 'package:get/get.dart';

import '../../data/models/fund_performance.dart';

class ChartInvestmentController extends GetxController {
  RxDouble investment = 100000.0.obs;

  RxInt selectedIndex = 0.obs;
  RxString selectedPeriod = "1Y".obs;
  final selectedGain = 0.0.obs;

  /// Slider limits
  final double minInvestment = 1000;
  final double maxInvestment = 5000000;

  /// Convert period label to years
  double getYears(String label) {
    label = label.toUpperCase();

    if (label.contains("M")) {
      final months = int.parse(label.replaceAll("M", ""));
      return months / 12;
    } else {
      return double.parse(label.replaceAll("Y", ""));
    }
  }

  /// Future Value
  double getFutureValue(double returnPercent, String label) {
    final rate = returnPercent / 100;
    final years = getYears(label);

    return investment.value * pow((1 + rate), years);
  }

  /// Profit / Loss Amount
  double getGainAmount(double returnPercent, String label) {
    return getFutureValue(returnPercent, label) - investment.value;
  }

  /// Profit / Loss %
  double getGainPercent(double returnPercent, String label) {
    return (getGainAmount(returnPercent, label) / investment.value) * 100;
  }

}