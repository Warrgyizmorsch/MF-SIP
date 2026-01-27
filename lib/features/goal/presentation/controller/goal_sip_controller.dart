// import 'dart:math';
// import 'package:get/get.dart';

// class GoalSipController extends GetxController {
//   // Inputs
//   final targetAmount = 0.0.obs;
//   final years = 1.0.obs;
//   final annualRate = 12.0.obs;

//   // Output
//   final monthlySip = 0.0.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     _recalculate();
//   }

//   void setTarget(double value) {
//     targetAmount.value = value;
//     _recalculate();
//   }

//   void setYears(double value) {
//     years.value = value;
//     _recalculate();
//   }

//   void setRate(double value) {
//     annualRate.value = value;
//     _recalculate();
//   }

//   // 🔥 WEBSITE MATCHING LOGIC
//   double _effectiveMonthlyRate(double annualRatePercent) {
//     final annual = annualRatePercent / 100;
//     return pow(1 + annual, 1 / 12) - 1;
//   }

//   void _recalculate() {
//     final months = (years.value * 12).round();
//     if (months <= 0 || targetAmount.value <= 0) {
//       monthlySip.value = 0;
//       return;
//     }

//     final r = _effectiveMonthlyRate(annualRate.value);

//     if (r == 0) {
//       monthlySip.value = targetAmount.value / months;
//       return;
//     }

//     final factor =
//         ((pow(1 + r, months) - 1) / r) * (1 + r);

//     final sip = targetAmount.value / factor;

//     // UX rounding (₹100)
//     monthlySip.value = (sip / 100) * 100;
//   }
// }

import 'dart:math';
import 'package:get/get.dart';

// class GoalSipController extends GetxController {
//   // Inputs
//   final targetAmount = 0.0.obs;
//   final years = 1.0.obs;
//   final annualRate = 12.0.obs;

//   // Outputs
//   final monthlySip = 0.0.obs;
//   final invested = 0.0.obs;
//   final futureValue = 0.0.obs;
//   final totalReturn = 0.0.obs;
//   final rawSip = 0.0.obs; // exact

//   @override
//   void onInit() {
//     super.onInit();
//     _recalculate();

//   }

//   void setTarget(double value) {
//     targetAmount.value = value;
//     _recalculate();
//   }

//   void setYears(double value) {
//     years.value = value;
//     _recalculate();
//   }

//   void setRate(double value) {
//     annualRate.value = value;
//     _recalculate();
//   }

//   // ✅ Website-matching monthly rate
//   double _effectiveMonthlyRate(double annualRatePercent) {
//     final annual = annualRatePercent / 100;
//     return pow(1 + annual, 1 / 12) - 1;
//   }

//   void _recalculate() {
//     final months = (years.value * 12);

//     if (months <= 0 || targetAmount.value <= 0) {
//       rawSip.value = 0;
//       monthlySip.value = 0;
//       invested.value = 0;
//       futureValue.value = 0;
//       totalReturn.value = 0;
//       return;
//     }

//     final r = _effectiveMonthlyRate(annualRate.value);

//     // 1️⃣ calculate exact SIP
//     double sip;
//     if (r == 0) {
//       sip = targetAmount.value / months;
//     } else {
//       final factor = ((pow(1 + r, months) - 1) / r) * (1 + r);
//       sip = targetAmount.value / factor;
//     }

//     rawSip.value = sip;

//     // 2️⃣ rounded SIP ONLY for display
//     monthlySip.value = (sip / 10) * 10;

//     // 3️⃣ use RAW sip for projections
//     double investedTmp = 0;
//     double valueTmp = 0;

//     for (int i = 0; i < months; i++) {
//       investedTmp += rawSip.value;
//       valueTmp = (valueTmp + rawSip.value) * (1 + r);
//     }

//     invested.value = investedTmp.toDouble();
//     futureValue.value = valueTmp.toDouble();
//     totalReturn.value = (futureValue.value - invested.value).toDouble();
//   }

//   // void _recalculate() {
//   //   final months = (years.value * 12).round();

//   //   if (months <= 0 || targetAmount.value <= 0) {
//   //     monthlySip.value = 0;
//   //     invested.value = 0;
//   //     futureValue.value = 0;
//   //     totalReturn.value = 0;
//   //     return;
//   //   }

//   //   final r = _effectiveMonthlyRate(annualRate.value);

//   //   double sip;
//   //   if (r == 0) {
//   //     sip = targetAmount.value / months;
//   //   } else {
//   //     final factor = ((pow(1 + r, months) - 1) / r) * (1 + r);
//   //     sip = targetAmount.value / factor;
//   //   }

//   //   // ✅ UX rounding
//   //   monthlySip.value = (sip / 100) * 100;

//   //   // 🔥 Calculate invested + FV (loop = website logic)
//   //   double investedTmp = 0;
//   //   double valueTmp = 0;

//   //   for (int i = 0; i < months; i++) {
//   //     investedTmp += monthlySip.value;
//   //     valueTmp = (valueTmp + monthlySip.value) * (1 + r);
//   //   }

//   //   invested.value = investedTmp.roundToDouble();
//   //   futureValue.value = valueTmp.roundToDouble();
//   //   totalReturn.value = (futureValue.value - invested.value).roundToDouble();
//   // }
// }

import 'dart:math';
import 'package:get/get.dart';

// class GoalSipController extends GetxController {
//   // Inputs
//   final targetAmount = 0.0.obs;
//   final years = 1.0.obs;
//   final annualRate = 12.0.obs;

//   // Outputs (WHOLE NUMBER ONLY)
//   final monthlySip = 0.obs;      // int
//   final invested = 0.obs;        // int
//   final futureValue = 0.obs;     // int
//   final totalReturn = 0.obs;     // int

//   @override
//   void onInit() {
//     super.onInit();
//     _recalculate();
//   }

//   void setTarget(double value) {
//     targetAmount.value = value;
//     _recalculate();
//   }

//   void setYears(double value) {
//     years.value = value;
//     _recalculate();
//   }

//   void setRate(double value) {
//     annualRate.value = value;
//     _recalculate();
//   }

//   double _effectiveMonthlyRate(double annualRatePercent) {
//     final annual = annualRatePercent / 100;
//     return pow(1 + annual, 1 / 12) - 1;
//   }

//   void _recalculate() {
//     final int months = (years.value * 12).round();

//     if (months <= 0 || targetAmount.value <= 0) {
//       monthlySip.value = 0;
//       invested.value = 0;
//       futureValue.value = 0;
//       totalReturn.value = 0;
//       return;
//     }

//     final r = _effectiveMonthlyRate(annualRate.value);

//     // 1️⃣ Calculate SIP (double)
//     double sipDouble;
//     if (r == 0) {
//       sipDouble = targetAmount.value / months;
//     } else {
//       final factor =
//           ((pow(1 + r, months) - 1) / r) * (1 + r);
//       sipDouble = targetAmount.value / factor;
//     }

//     // 2️⃣ FORCE WHOLE NUMBER SIP (₹1 granularity)
//     final int sip = sipDouble.round();
//     monthlySip.value = sip;

//     // 3️⃣ Use ONLY whole SIP everywhere
//     int investedTmp = 0;
//     double valueTmp = 0;

//     for (int i = 0; i < months; i++) {
//       investedTmp += sip;
//       valueTmp = (valueTmp + sip) * (1 + r);
//     }

//     invested.value = investedTmp;
//     futureValue.value = valueTmp.round();
//     totalReturn.value = futureValue.value - invested.value;
//   }
// }

import 'package:my_sip/features/fund_details/data/models/return_model.dart';

class GoalSipController extends GetxController {
  // Inputs
  final targetAmount = 0.0.obs;
  final years = 1.0.obs;
  final annualRate = 12.0.obs;

  // Outputs (WHOLE NUMBERS like website)
  final monthlySip = 0.obs;
  final invested = 0.obs;
  final futureValue = 0.obs;
  final totalReturn = 0.obs;

  final yearlyReport = <ReturnRow>[].obs;

  @override
  void onInit() {
    super.onInit();
    _recalculate();
  }

  void setTarget(double value) {
    targetAmount.value = value;
    _recalculate();
  }

  void setYears(double value) {
    years.value = value;
    _recalculate();
  }

  void setRate(double value) {
    annualRate.value = value;
    _recalculate();
  }

  // same as website
  double _effectiveMonthlyRate(double annualRatePercent) {
    final annual = annualRatePercent / 100;
    return pow(1 + annual, 1 / 12) - 1;
  }

  void _recalculate() {
    final int totalMonths = (years.value * 12).round();

    if (totalMonths <= 0 || targetAmount.value <= 0) {
      monthlySip.value = 0;
      invested.value = 0;
      futureValue.value = 0;
      totalReturn.value = 0;
      yearlyReport.clear(); // ✅ clear report

      return;
    }

    final r = _effectiveMonthlyRate(annualRate.value);

    // ✅ Step 1: exact SIP (double)
    double exactSip;
    if (r == 0) {
      exactSip = targetAmount.value / totalMonths;
    } else {
      final factor = ((pow(1 + r, totalMonths) - 1) / r) * (1 + r);
      exactSip = targetAmount.value / factor;
    }

    // ✅ Step 2: ROUND like website
    final int roundedSip = exactSip.round();
    monthlySip.value = roundedSip;

    // ✅ Step 3: build projection using ROUNDED SIP ONLY
    int investedTmp = 0;
    double valueTmp = 0;

    for (int i = 0; i < totalMonths; i++) {
      investedTmp += roundedSip;
      valueTmp = (valueTmp + roundedSip) * (1 + r);
    }

    invested.value = investedTmp;
    futureValue.value = valueTmp.round();
    // totalReturn.value = futureValue.value - invested.value;
    totalReturn.value = (targetAmount.value - invested.value).round();

    yearlyReport.value = buildYearlyReport();
  }

  List<ReturnRow> buildYearlyReport() {
    final int yearsCount = years.value.round();
    final int sip = monthlySip.value;
    final double r = _effectiveMonthlyRate(annualRate.value);

    List<ReturnRow> rows = [];

    int invested = 0;
    double value = 0;

    for (int y = 1; y <= yearsCount; y++) {
      for (int m = 1; m <= 12; m++) {
        invested += sip;
        value = (value + sip) * (1 + r);
      }

      final int roundedValue = value.round();
      final int profit = roundedValue - invested;

      rows.add(
        ReturnRow(
          period: y.toString(),
          scheme: invested.toDouble(),
          category: roundedValue.toDouble(),
          benchmark: profit.toDouble(),
        ),
      );
    }

    return rows;
  }
}
