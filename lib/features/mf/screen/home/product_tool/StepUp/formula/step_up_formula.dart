// import 'dart:math';

// import 'package:my_sip/features/mf/screen/home/product_tool/StepUp/model/step_up_model.dart';

// //Normal sip

// Map<String, dynamic> simulateNormalSip({
//   required double monthly,
//   required int years,
//   required double mRate,
// }) {
//   final totalMonths = years * 12;
//   double invested = 0;
//   double value = 0;

//   final List<ChartRow> yearly = [];

//   for (int m = 1; m <= totalMonths; m++) {
//     invested += monthly;
//     value = (value + monthly) * (1 + mRate);

//     if (m % 12 == 0) {
//       yearly.add(
//         ChartRow(
//           year: m ~/ 12,
//           invested: invested.roundToDouble(),
//           value: value.roundToDouble(),
//         ),
//       );
//     }
//   }

//   return {
//     'invested': invested.roundToDouble(),
//     'value': value.roundToDouble(),
//     'profit': (value - invested).roundToDouble(),
//     'yearly': yearly,
//   };
// }

// ///Step-Up SIP Formula
// StepUpSipResult simulateStepUpSip({
//   required double baseMonthly,
//   required StepUpType stepUpType,
//   required double stepUpValue,
//   required int years,
//   required double annualRate,
// }) {
//   final mRate = effectiveMonthlyRate(annualRate);
//   final totalMonths = years * 12;

//   double monthly = baseMonthly;
//   double invested = 0;
//   double value = 0;

//   final List<ChartRow> chartData = [];
//   final List<DetailRow> detailRows = [];

//   final normal = simulateNormalSip(
//     monthly: baseMonthly,
//     years: years,
//     mRate: mRate,
//   );

//   final List<ChartRow> normalYearly =
//       List<ChartRow>.from(normal['yearly']);

//   for (int m = 1; m <= totalMonths; m++) {
//     invested += monthly;
//     value = (value + monthly) * (1 + mRate);

//     if (m % 12 == 0) {
//       final year = m ~/ 12;

//       final investedY = invested.roundToDouble();
//       final valueY = value.roundToDouble();
//       final profitY = (valueY - investedY).roundToDouble();

//       chartData.add(
//         ChartRow(
//           year: year,
//           invested: investedY,
//           value: valueY,
//         ),
//       );

//       final normalValue =
//           normalYearly.firstWhere((e) => e.year == year).value;

//       detailRows.add(
//         DetailRow(
//           year: year,
//           stepInvested: investedY,
//           stepValue: valueY,
//           stepProfit: profitY,
//           normalValue: normalValue,
//           extraGain: (valueY - normalValue).roundToDouble(),
//         ),
//       );

//       // 🔥 Step-up happens AFTER year completes
//       if (stepUpType == StepUpType.percentage) {
//         monthly += monthly * (stepUpValue / 100);
//       } else {
//         monthly += stepUpValue;
//       }
//     }
//   }

//   return StepUpSipResult(
//     normal: Compare(
//       invested: normal['invested'],
//       value: normal['value'],
//       profit: normal['profit'],
//     ),
//     stepUp: Compare(
//       invested: invested.roundToDouble(),
//       value: value.roundToDouble(),
//       profit: (value - invested).roundToDouble(),
//     ),
//     chartData: chartData,
//     detailRows: detailRows,
//   );
// }

// ////
// double effectiveMonthlyRate(double annualRate) {
//   final annual = annualRate / 100;
//   return pow(1 + annual, 1 / 12) - 1;
// }

import 'dart:math';
import 'package:my_sip/features/mf/screen/home/product_tool/StepUp/model/step_up_model.dart';

double effectiveMonthlyRate(double annualRate) {
  final annual = annualRate / 100;
  return pow(1 + annual, 1 / 12) - 1;
}

/// NORMAL SIP
Map<String, dynamic> simulateNormalSip({
  required double monthly,
  required int years,
  required double mRate,
}) {
  final totalMonths = years * 12;
  double value = 0;

  final List<ChartRow> yearly = [];

  for (int m = 1; m <= totalMonths; m++) {
    value = (value + monthly) * (1 + mRate);

    if (m % 12 == 0) {
      yearly.add(
        ChartRow(
          year: m ~/ 12,
          invested: monthly * 12 * (m ~/ 12),
          value: value,
        ),
      );
    }
  }

  final invested = monthly * 12 * years;

  return {
    'invested': invested,
    'value': value,
    'profit': value - invested,
    'yearly': yearly,
  };
}

/// STEP-UP SIP (WEB-MATCHED)
StepUpSipResult simulateStepUpSip({
  required double baseMonthly,
  required StepUpType stepUpType,
  required double stepUpValue,
  required int years,
  required double annualRate,
}) {
  final mRate = effectiveMonthlyRate(annualRate);
  final totalMonths = years * 12;

  double monthly = baseMonthly;
  double invested = 0;
  double value = 0;

  final List<ChartRow> chartData = [];
  final List<DetailRow> detailRows = [];

  final normal = simulateNormalSip(
    monthly: baseMonthly,
    years: years,
    mRate: mRate,
  );

  final List<ChartRow> normalYearly = List<ChartRow>.from(normal['yearly']);

  for (int m = 1; m <= totalMonths; m++) {
    invested += monthly;
    value = (value + monthly) * (1 + mRate);

    if (m % 12 == 0) {
      final year = m ~/ 12;

      chartData.add(ChartRow(year: year, invested: invested, value: value));

      final normalValue = normalYearly
          .firstWhere(
            (e) => e.year == year,
            orElse: () => ChartRow(year: year, invested: 0, value: 0),
          )
          .value;

      detailRows.add(
        DetailRow(
          year: year,
          stepInvested: invested,
          stepValue: value,
          stepProfit: value - invested,
          normalValue: normalValue,
          extraGain: value - normalValue,
        ),
      );

      // ✅ Step-up AFTER year ends
      if (stepUpType == StepUpType.percentage) {
        monthly += monthly * (stepUpValue / 100);
      } else {
        monthly += stepUpValue;
      }
    }
  }

  return StepUpSipResult(
    normal: Compare(
      invested: normal['invested'],
      value: normal['value'],
      profit: normal['profit'],
    ),
    stepUp: Compare(invested: invested, value: value, profit: value - invested),
    chartData: chartData,
    detailRows: detailRows,
  );
}
