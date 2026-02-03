import 'package:get/get.dart';
import 'package:my_sip/features/sip_process/domain/entity/fund_entity.dart';
import '../../domain/usecases/get_fund_list_usecase.dart';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';

class SipProcessController extends GetxController with StateMixin<List<FundEntity>> {
  final GetFundListUsecase _getFundListUsecase;

  SipProcessController(this._getFundListUsecase);

  // --- State Variables ---
  final RxDouble amount = 1000.0.obs;

// --- New State for Investing Approach ---
  final RxInt selectedApproach = 0.obs;

  void selectApproach(int index) {
    selectedApproach.value = index;
  }

  // Output variables (Observables)
  final RxDouble totalInvested = 0.0.obs;
  final RxDouble totalProjected = 0.0.obs;
  final RxList<FlSpot> chartInvestedSpots = <FlSpot>[].obs;
  final RxList<FlSpot> chartProjectedSpots = <FlSpot>[].obs;

  // Constants
  final double expectedReturnRate = 18.0; // 18% per annum
  final int durationYears = 5;

  @override
  void onInit() {
    super.onInit();
    getFundList();

    // Initial Calculation
    _calculateSipProjection();

    // Trigger calculation whenever 'amount' changes
    ever(amount, (_) => _calculateSipProjection());
  }

  void updateAmount(double targetAmount) {
    if (targetAmount < 0) return;
    amount.value = targetAmount;
  }

  // --- Calculation Logic ---
  void _calculateSipProjection() {
    double monthlyRate = expectedReturnRate / 12 / 100;
    int totalMonths = durationYears * 12;
    double currentMonthlyAmt = amount.value;

    // 1. Calculate Totals (5 Years)
    totalInvested.value = currentMonthlyAmt * totalMonths;

    // SIP Formula: P * ({ (1+i)^n - 1 } / i) * (1+i)
    totalProjected.value = currentMonthlyAmt * ((pow(1 + monthlyRate, totalMonths) - 1) / monthlyRate) * (1 + monthlyRate);

    // 2. Calculate Chart Spots (Year by Year)
    List<FlSpot> tempInvested = [];
    List<FlSpot> tempProjected = [];
    int startYear = DateTime.now().year;

    for (int i = 0; i <= durationYears; i++) {
      int months = i * 12;
      double xValue = (startYear + i).toDouble();

      // Invested so far
      double invested = currentMonthlyAmt * months;

      // Projected so far
      double projected = 0;
      if (months > 0) {
        projected = currentMonthlyAmt * ((pow(1 + monthlyRate, months) - 1) / monthlyRate) * (1 + monthlyRate);
      }

      tempInvested.add(FlSpot(xValue, invested));
      tempProjected.add(FlSpot(xValue, projected));
    }

    chartInvestedSpots.assignAll(tempInvested);
    chartProjectedSpots.assignAll(tempProjected);
  }

  // --- Existing API Call ---
  Future<void> getFundList() async {
    change(null, status: RxStatus.loading());
    final result = await _getFundListUsecase.call();

    result.fold(
          (success) {
        if (success.isSuccess && success.data != null) {
          if (success.data!.isEmpty) {
            change([], status: RxStatus.empty());
          } else {
            change(success.data, status: RxStatus.success());
          }
        } else {
          change(null, status: RxStatus.error("Failed to load funds"));
        }
      },
          (error) {
        change(null, status: RxStatus.error(error.message));
      },
    );
  }

  // Helper to format currency (Optional, or use intl package)
  String formatCurrency(double val) {
    return "₹${val.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}";
  }
}