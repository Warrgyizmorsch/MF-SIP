// class SwpResult {
//   final double totalWithdrawn;
//   final double remainingValue;
//   final double profit;

//   SwpResult({
//     required this.totalWithdrawn,
//     required this.remainingValue,
//     required this.profit,
//   });
// }

// import 'package:my_sip/features/mf/screen/home/product_tool/swp_calculator/formula/swp_formula.dart';

// class SwpSummary {
//   final double totalWithdrawn;
//   final double remainingValue;
//   final double totalProfit;

//   SwpSummary({
//     required this.totalWithdrawn,
//     required this.remainingValue,
//     required this.totalProfit,
//   });
// }

// SwpSummary calculateSwpSummary({
//   required double initialInvestment,
//   required double monthlyWithdrawal,
//   required double annualRate,
//   required int years,
// }) {
//   final report = calculateSwpReport(
//     initialInvestment: initialInvestment,
//     monthlyWithdrawal: monthlyWithdrawal,
//     annualRate: annualRate,
//     years: years,
//   );

//   final last = report.last;

//   return SwpSummary(
//     totalWithdrawn: last.totalWithdrawn,
//     remainingValue: last.remaining,
//     totalProfit: last.profit,
//   );
// }

import 'package:my_sip/features/mf/screen/home/product_tool/swp_calculator/model/swp_report_row.dart';

class SwpResult {
  final List<SwpYearReport> report;
  final double totalWithdrawn;
  final double remainingValue;
  final double totalProfit;
  final int? exhaustedAtYear;

  SwpResult({
    required this.report,
    required this.totalWithdrawn,
    required this.remainingValue,
    required this.totalProfit,
    this.exhaustedAtYear,
  });
}
