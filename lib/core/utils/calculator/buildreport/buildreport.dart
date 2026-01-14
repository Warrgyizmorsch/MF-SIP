import 'package:my_sip/core/utils/calculator/mothlyeffectiverate.dart';

import '../../../../features/fund_details/data/models/return_model.dart';

List<ReturnRow> buildSipReport({
  required double monthlyInvestment,
  required double annualRate,
  required int years,
}) {
  final monthlyRate = effectiveMonthlyRate(annualRate);

  final int startYear = DateTime.now().year; // 👈 change here

  double invested = 0;
  double value = 0;
  List<ReturnRow> report = [];

  for (int year = 1; year <= years; year++) {
    for (int month = 1; month <= 12; month++) {
      invested += monthlyInvestment;
      value = (value + monthlyInvestment) * (1 + monthlyRate);
    }

    report.add(
      ReturnRow(
        // period: year.toString(),
        period: (startYear + year - 1).toString(), // ✅ 2026, 2027...

        scheme: invested, // Investment
        category: value - invested, // Profit
        benchmark: value, // Total Value
      ),
    );
  }

  return report;
}
