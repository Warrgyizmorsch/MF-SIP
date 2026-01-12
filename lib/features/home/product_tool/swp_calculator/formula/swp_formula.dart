// import 'package:my_sip/features/mf/screen/home/product_tool/swp_calculator/model/swp_report_row.dart';

// List<SwpYearReport> calculateSwpReport({
//   required double initialInvestment,
//   required double monthlyWithdrawal,
//   required double annualRate,
//   required int years,
// }) {
//   final double monthlyRate = annualRate / 12 / 100;

//   double balance = initialInvestment;
//   double totalWithdrawn = 0;

//   final List<SwpYearReport> report = [];

//   for (int year = 1; year <= years; year++) {
//     for (int month = 1; month <= 12; month++) {
//       if (balance <= 0) break;

//       // 1️⃣ Apply monthly interest
//       balance += balance * monthlyRate;

//       // 2️⃣ Withdraw at end of month
//       balance -= monthlyWithdrawal;
//       totalWithdrawn += monthlyWithdrawal;

//       if (balance < 0) balance = 0;
//     }

//     final double profit =
//         totalWithdrawn + balance - initialInvestment;

//     report.add(
//       SwpYearReport(
//         year: year,
//         totalWithdrawn: totalWithdrawn,
//         profit: profit,
//         remaining: balance,
//       ),
//     );
//   }

//   return report;
// }

// import 'package:my_sip/features/mf/screen/home/product_tool/swp_calculator/model/swp_report_row.dart';

// List<SwpYearReport> calculateSwpReport({
//   required double initialInvestment,
//   required double monthlyWithdrawal,
//   required double annualRate,
//   required int years,
// }) {
//   final double monthlyRate = annualRate / 12 / 100;

//   double balance = initialInvestment;
//   double totalWithdrawn = 0;

//   final List<SwpYearReport> report = [];

//   for (int year = 1; year <= years; year++) {
//     for (int month = 1; month <= 12; month++) {
//       if (balance <= 0) break;

//       // ✅ Withdraw FIRST (matches website)
//       balance -= monthlyWithdrawal;
//       totalWithdrawn += monthlyWithdrawal;

//       if (balance < 0) {
//         balance = 0;
//         break;
//       }

//       // ✅ Then apply interest
//       balance += balance * monthlyRate;
//     }

//     final double profit = totalWithdrawn + balance - initialInvestment;

//     report.add(
//       SwpYearReport(
//         year: year,
//         totalWithdrawn: totalWithdrawn,
//         profit: profit,
//         remaining: balance,
//       ),
//     );
//   }

//   return report;
// }

// import 'package:my_sip/features/mf/screen/home/product_tool/swp_calculator/model/swp_report_row.dart';

// List<SwpYearReport> calculateSwpReport({
//   required double initialInvestment,
//   required double monthlyWithdrawal,
//   required double annualRate,
//   required int years,
// }) {
//   final double monthlyRate = annualRate / 12 / 100;

//   double balance = initialInvestment;
//   double totalWithdrawn = 0;

//   final List<SwpYearReport> report = [];

//   for (int year = 1; year <= years; year++) {
//     for (int month = 1; month <= 12; month++) {
//       if (balance <= 0) break;

//       // ✅ INTEREST FIRST (WEBSITE LOGIC)
//       balance += balance * monthlyRate;

//       // ✅ THEN WITHDRAW
//       balance -= monthlyWithdrawal;
//       totalWithdrawn += monthlyWithdrawal;

//       if (balance < 0) {
//         balance = 0;
//         break;
//       }
//     }

//     final double profit = totalWithdrawn + balance - initialInvestment;

//     report.add(
//       SwpYearReport(
//         year: year,
//         totalWithdrawn: totalWithdrawn,
//         remaining: balance,
//         profit: profit,
//       ),
//     );
//   }

//   return report;
// }


import 'dart:math';
import '../model/swp_report_row.dart';
import '../model/swp_result.dart';

double effectiveMonthlyRate(double annualRatePercent) {
  final annual = annualRatePercent / 100;
  return pow(1 + annual, 1 / 12) - 1;
}

SwpResult calculateSwp({
  required double initialInvestment,
  required double monthlyWithdrawal,
  required int years,
  required double annualRate,
}) {
  final mRate = effectiveMonthlyRate(annualRate);
  final totalMonths = years * 12;

  double balance = max(0, initialInvestment);
  double withdrawn = 0;

  final List<SwpYearReport> report = [];
  int? exhaustedAtYear;

  for (int month = 1; month <= totalMonths; month++) {
    // 1️⃣ interest first
    balance = balance * (1 + mRate);

    // 2️⃣ withdraw
    if (monthlyWithdrawal > 0) {
      if (balance <= 0) {
        balance = 0;
      } else if (balance - monthlyWithdrawal < 0) {
        withdrawn += balance;
        balance = 0;
      } else {
        balance -= monthlyWithdrawal;
        withdrawn += monthlyWithdrawal;
      }
    }

    // yearly snapshot
    if (month % 12 == 0) {
      final year = month ~/ 12;
      final profit = withdrawn + balance - initialInvestment;

      report.add(
        SwpYearReport(
          year: year,
          withdrawn: withdrawn.roundToDouble(),
          remaining: balance.roundToDouble(),
          profit: profit.roundToDouble(),
        ),
      );

      if (balance <= 0 && exhaustedAtYear == null) {
        exhaustedAtYear = year;
        break;
      }
    }
  }

  final last = report.isNotEmpty ? report.last : null;

  return SwpResult(
    report: report,
    totalWithdrawn: withdrawn.roundToDouble(),
    remainingValue: last?.remaining ?? 0,
    totalProfit:
        (withdrawn + (last?.remaining ?? 0) - initialInvestment)
            .roundToDouble(),
    exhaustedAtYear: exhaustedAtYear,
  );
}
