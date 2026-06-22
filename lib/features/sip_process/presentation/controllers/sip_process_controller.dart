

// ignore_for_file: unused_local_variable

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/calculator/mothlyeffectiverate.dart';
import 'package:my_sip/features/cart/presentation/controllers/cart_controller.dart';
import 'package:my_sip/features/explore/domain/entities/mutual_fund_list_entity.dart';
import 'package:my_sip/features/explore/domain/usecases/get_mutual_fund_list_usecases.dart';
import 'package:my_sip/services/session_manager.dart';
import '../../domain/usecases/get_fund_list_usecase.dart';
import 'package:fl_chart/fl_chart.dart';

// FIX: Updated StateMixin to use MutualFundListEntity to match your API result
class SipProcessController extends GetxController
    with StateMixin<List<MutualFundListEntity>> {
  final GetFundListUsecase _getFundListUsecase;
  final GetMutualFundListUsecases _getMutualFundListUsecases;

  SipProcessController(
    this._getFundListUsecase,
    this._getMutualFundListUsecases,
  );

  final user = SessionManager.instance.userObs.value;

  // --- State Variables ---
  final RxDouble amount = 1000.0.obs;
  final RxInt selectedApproach = 0.obs;
  final RxBool isLumpsum = false.obs; // Track if it's Lumpsum mode
  final ValueNotifier<String?> selectedSipDay = ValueNotifier<String?>('10');
  final RxDouble totalInvested = 0.0.obs;
  final RxDouble totalProjected = 0.0.obs;
  final RxList<FlSpot> chartInvestedSpots = <FlSpot>[].obs;
  final RxList<FlSpot> chartProjectedSpots = <FlSpot>[].obs;

  final double expectedReturnRate = 12.0;
  final int durationYears = 5;

  // Define the sets of amounts
  final List<double> sipChips = [1000, 2000, 5000, 10000];
  final List<double> lumpsumChips = [25000, 50000, 75000, 100000];

  List<double> get currentChips => isLumpsum.value ? lumpsumChips : sipChips;

  // multiple selection
  final RxList<MutualFundListEntity> selectedFunds =
      <MutualFundListEntity>[].obs;

  final RxMap<String, double> fundAmounts = <String, double>{}.obs;

  static bool? navIsLumpsum;
  String getOrdinal(int number) {
    if (number >= 11 && number <= 13) {
      return '${number}th';
    }
    switch (number % 10) {
      case 1:
        return '${number}st';
      case 2:
        return '${number}nd';
      case 3:
        return '${number}rd';
      default:
        return '${number}th';
    }
  }
  void setInvestmentMode(bool lumpsum) {
    isLumpsum.value = lumpsum;
    if (lumpsum) {
      amount.value = 25000.0; // Default Lumpsum amount
    } else {
      amount.value = 1000.0; // Default SIP amount
    }
  }

  // void toggleSelection(MutualFundListEntity fund) {
  //   if (selectedFunds.contains(fund)) {
  //     selectedFunds.remove(fund);
  //   } else {
  //     selectedFunds.add(fund);
  //   }
  // }
  // void toggleSelection(MutualFundListEntity fund) {
  //   if (selectedFunds.any((item) => item.schemeCode == fund.schemeCode)) {
  //     selectedFunds.removeWhere((item) => item.schemeCode == fund.schemeCode);
  //   } else {
  //     selectedFunds.add(fund);
  //   }
  // }
  void toggleSelection(MutualFundListEntity fund) {
    final code = fund.schemeCode ?? "";
    int minSip = fund.minSipAmount ?? 500;
    if (selectedFunds.any((item) => item.schemeCode == code)) {
      selectedFunds.removeWhere((item) => item.schemeCode == code);
      fundAmounts.remove(code);
    } else {
      selectedFunds.add(fund);

      double initialValue = amount.value < minSip
          ? minSip.toDouble()
          : amount.value;
      if (initialValue % minSip != 0) {
        initialValue = ((initialValue / minSip).ceil() * minSip).toDouble();
      }
      // Initialize with the global amount from the slider/input
      fundAmounts[code] = amount.value;

      if (textControllers.containsKey(code)) {
        textControllers[code]!.text = initialValue.toStringAsFixed(0);
      }
    }
  }

  void updateFundAmount(String schemeCode, String val) {
    double? newAmount = double.tryParse(val);
    if (newAmount != null) {
      fundAmounts[schemeCode] = newAmount;
    }
  }

  Future<void> proceedToCart() async {
    if (selectedFunds.isEmpty) {
      showCustomToast(
        title: "Selection Required",
        backgroundColor: Colors.red,
        icon: Icons.warning,
        message: "", // Not used in your title-only toast
      );
      return;
    }

    bool isDesktop = Get.width > 600;

    // if (selectedFunds.isEmpty) return;
    for (var fund in selectedFunds) {
      // double enteredAmount = fundAmounts[fund.schemeCode] ?? amount.value;
      double enteredAmount = fundAmounts[fund.schemeCode] ?? amount.value;
      int minRequired = fund.minSipAmount ?? 500; // Default to 500 if null

      // if (enteredAmount < minRequired) {
      //   showCustomToast1(
      //     title: "Min. amount is ₹$minRequired",
      //     backgroundColor: Colors.orange.shade800,
      //     icon: Icons.error_outline,
      //     message: "${fund.baseSchemeName}",
      //   );
      //   return; // STOP execution and don't show loader or navigate
      // }
      // if (enteredAmount % minRequired != 0) {
      //   showCustomToast1(
      //     title: "Enter multiples of ₹$minRequired",
      //     backgroundColor: Colors.orange.shade900,
      //     icon: Icons.error_outline,
      //     message: "${fund.baseSchemeName}",
      //   );
      //   return;
      // }
      for (var fund in selectedFunds) {
        final String code = fund.schemeCode ?? "";
        final double entered = fundAmounts[code] ?? 0.0;
        final int min = fund.minSipAmount ?? 500;

        if (entered < min || entered % 100 != 0) {
          showCustomToast1(
            title: "Check amounts of",
            backgroundColor: Colors.redAccent,
            icon: Icons.error_outline,
            message: "${fund.baseSchemeName}",
          );
          return; // Stop the process
        }
      }
    }

    try {
      // 1. Open the dialog and store a reference or check state
      Get.dialog(
        const Center(child: CircularProgressIndicator(color: Colors.white)),
        barrierDismissible: false,
      );

      // 2. Loop and Call API
      for (var fund in selectedFunds) {
        final String code = fund.schemeCode ?? "";
        final String name = fund.baseSchemeName ?? "Fund";
        final int fundAmount = (fundAmounts[code] ?? amount.value).toInt();

        await Get.find<CartController>().addToCart(
          code,
          name,
          fundAmount,
          transType: isLumpsum.value ? 'lumpsum' : 'sip',
          null,
        );
        // Small delay between calls
        await Future.delayed(const Duration(milliseconds: 100));
      }

      // 3. THE FIX: Specifically check for dialog and close it
      if (Get.isDialogOpen == true) {
        // Use the internal Navigator to ensure the top-most route (the dialog) is popped
        Get.back(closeOverlays: true);
      }

      // 4. THE SYNC FIX: Wait for the pop animation to finish
      // before starting the next transition
      await Future.delayed(const Duration(milliseconds: 200));

      // 5. CLEAR SELECTIONS:
      // This prevents the user from seeing the same items selected if they go back
      selectedFunds.clear();
      fundAmounts.clear();

      // 6. NAVIGATE
      // Get.toNamed(AppRoutes.cart);
      // Get.offNamed(AppRoutes.cart);
      Get.offNamedUntil(
        AppRoutes.cart,
        id: isDesktop ? 1 : null,
        (route) =>
            route.isFirst ||
            route.settings.name == AppRoutes.navMenuBar ||
            route.settings.name == AppRoutes.home,
      );
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
      Get.snackbar("Error", "Something went wrong during the batch process.");
    }
  }

  // Future<void> proceedToCart() async {
  //   if (selectedFunds.isEmpty) return;

  //   try {
  //     // Show Loading Overlay
  //     Get.dialog(
  //       const Center(child: CircularProgressIndicator(color: Colors.white)),
  //       barrierDismissible: false,
  //       name: "loading_dialog", // Give it a name to be safe
  //     );

  //     // Loop and Call API sequentially
  //     for (var fund in selectedFunds) {
  //       final String code = fund.schemeCode ?? "";
  //       final String name = fund.baseSchemeName ?? "Fund";
  //       final int fundAmount = (fundAmounts[code] ?? amount.value).toInt();

  //       // Find CartController and call your existing single-item function
  //       await Get.find<CartController>().addToCart(
  //         code,
  //         name,
  //         fundAmount,
  //         null, // goalId
  //       );

  //       // Optional: small delay to avoid overwhelming the network
  //       await Future.delayed(const Duration(milliseconds: 100));
  //     }

  //     if (Get.isDialogOpen!) {
  //       Get.back(); // This closes the dialog
  //     }
  //     await Future.delayed(const Duration(milliseconds: 300));

  //     selectedFunds.clear();
  //     fundAmounts.clear();

  //     // Get.back(); // Close loading dialog
  //     Get.toNamed(AppRoutes.cart); // Move to Cart Screen
  //   } catch (e) {
  //     // Get.back();
  //     // Get.snackbar("Error", "Could not add all items to cart");
  //     if (Get.isDialogOpen!) Get.back();
  //     Get.snackbar("Error", "Something went wrong");
  //   }
  // }

  bool isSelected(String fundId) {
    return selectedFunds.any((item) => item.schemeCode == fundId);
  }

  double get totalSelectedAmount {
    return selectedFunds.fold(0.0, (sum, fund) {
      return sum + (fundAmounts[fund.schemeCode] ?? amount.value);
    });
  }

  final Map<String, TextEditingController> textControllers = {};

  // Helper to get or create a controller for a specific fund
  TextEditingController getTextController(String schemeCode) {
    if (!textControllers.containsKey(schemeCode)) {
      // Initialize with the current amount
      double initialAmount = fundAmounts[schemeCode] ?? amount.value;
      textControllers[schemeCode] = TextEditingController(
        text: initialAmount.toStringAsFixed(0),
      );
    }
    return textControllers[schemeCode]!;
  }

  @override
  void onInit() {
    super.onInit();
    if (navIsLumpsum != null) {
      setInvestmentMode(navIsLumpsum!);
      navIsLumpsum = null;
    } else if (Get.arguments != null && Get.arguments['isLumpsum'] != null) {
      setInvestmentMode(Get.arguments['isLumpsum']);
    }

    
    fetchFundsByApproach();
    _calculateSipProjection();
    ever(amount, (_) => _calculateSipProjection());
  }

  void selectApproach(int index) {
    selectedApproach.value = index;
    fetchFundsByApproach();
  }

  void updateAmount(double targetAmount) {
    if (targetAmount < 0) return;
    amount.value = targetAmount;
  }

  Future<void> fetchFundsByApproach() async {
    change(null, status: RxStatus.loading());

    // 0: Best High Growth -> best_sip
    // 1: Suggested Portfolio -> curated
    final Map<String, dynamic> params = selectedApproach.value == 0
        ? {'best_sip': 1, 'risk_type': user?.riskProfileModel?.profileName}
        : {'is_curated': 1};

    final result = await _getMutualFundListUsecases.call(params);

    result.fold((success) {
      final List<MutualFundListEntity> funds = success.data?.data ?? [];

      if (funds.isEmpty) {
        change([], status: RxStatus.empty());
      } else {
        change(funds, status: RxStatus.success());
      }
    }, (error) => change(null, status: RxStatus.error(error.message)));
  }

  // --- Best SIP API Call ---
  Future<void> getBestSipFunds() async {
    change(null, status: RxStatus.loading());

    // Fetch only the Best SIP collection
    final result = await _getMutualFundListUsecases.call({'best_sip': 1});

    result.fold((success) {
      final List<MutualFundListEntity> funds = success.data?.data ?? [];

      if (funds.isEmpty) {
        change([], status: RxStatus.empty());
      } else {
        // Now types match: List<MutualFundListEntity> passed to StateMixin<List<MutualFundListEntity>>
        change(funds, status: RxStatus.success());
      }
    }, (error) => change(null, status: RxStatus.error(error.message)));
  }

  void _calculateSipProjection() {
    double annualRate = expectedReturnRate / 100; // Kept for Lumpsum
    int totalMonths = durationYears * 12;
    double principal = amount.value;

    List<FlSpot> tempInvested = [];
    List<FlSpot> tempProjected = [];
    int startYear = DateTime.now().year;

    if (isLumpsum.value) {
      // --- LUMPSUM CALCULATION (Unchanged) ---
      totalInvested.value = principal;
      totalProjected.value =
          principal * math.pow((1 + annualRate), durationYears);

      for (int i = 0; i <= durationYears; i++) {
        double xValue = (startYear + i).toDouble();
        tempInvested.add(FlSpot(xValue, principal));
        tempProjected.add(
          FlSpot(xValue, principal * math.pow((1 + annualRate), i)),
        );
      }
    } else {
      // --- SIP CALCULATION (Using your exact formula) ---

      // Pass the raw percentage (12.0) since your function divides by 100 internally
      double mRate = effectiveMonthlyRate(expectedReturnRate);

      double invested = 0;
      double value = 0;

      // Start chart at year 0
      tempInvested.add(FlSpot(startYear.toDouble(), 0));
      tempProjected.add(FlSpot(startYear.toDouble(), 0));

      for (int month = 1; month <= totalMonths; month++) {
        invested += principal;
        value = (value + principal) * (1 + mRate);

        // Record chart spots at the end of each year (every 12 months)
        if (month % 12 == 0) {
          double xValue = (startYear + (month ~/ 12)).toDouble();
          tempInvested.add(FlSpot(xValue, invested));
          tempProjected.add(FlSpot(xValue, value));
        }
      }

      totalInvested.value = invested;
      totalProjected.value = value;
    }

    chartInvestedSpots.assignAll(tempInvested);
    chartProjectedSpots.assignAll(tempProjected);
  }

  // void _calculateSipProjection() {
  //   double annualRate = expectedReturnRate / 100;
  //   double monthlyRate = annualRate / 12;
  //   int totalMonths = durationYears * 12;
  //   double principal = amount.value;

  //   if (isLumpsum.value) {
  //     // --- LUMPSUM CALCULATION ---
  //     // Formula: A = P * (1 + r)^t
  //     totalInvested.value = principal;
  //     totalProjected.value =
  //         principal * math.pow((1 + annualRate), durationYears);
  //   } else {
  //     // --- SIP CALCULATION ---
  //     // Formula: P * [((1 + i)^n - 1) / i] * (1 + i)
  //     totalInvested.value = principal * totalMonths;
  //     totalProjected.value =
  //         principal *
  //         ((math.pow(1 + monthlyRate, totalMonths) - 1) / monthlyRate) *
  //         (1 + monthlyRate);
  //   }

  //   // Generate Chart Spots
  //   List<FlSpot> tempInvested = [];
  //   List<FlSpot> tempProjected = [];
  //   int startYear = DateTime.now().year;

  //   for (int i = 0; i <= durationYears; i++) {
  //     double xValue = (startYear + i).toDouble();
  //     double investedAtThisPoint;
  //     double projectedAtThisPoint;

  //     if (isLumpsum.value) {
  //       // For Lumpsum, invested stays flat, projected grows exponentially
  //       investedAtThisPoint = principal;
  //       projectedAtThisPoint = principal * math.pow((1 + annualRate), i);
  //     } else {
  //       // For SIP, both grow linearly/exponentially over time
  //       int months = i * 12;
  //       investedAtThisPoint = principal * months;
  //       projectedAtThisPoint = i == 0
  //           ? 0
  //           : principal *
  //                 ((math.pow(1 + monthlyRate, months) - 1) / monthlyRate) *
  //                 (1 + monthlyRate);
  //     }

  //     tempInvested.add(FlSpot(xValue, investedAtThisPoint));
  //     tempProjected.add(FlSpot(xValue, projectedAtThisPoint));
  //   }

  //   chartInvestedSpots.assignAll(tempInvested);
  //   chartProjectedSpots.assignAll(tempProjected);
  // }
  // ----------------- old ------------//
  // void _calculateSipProjection() {
  //   double monthlyRate = expectedReturnRate / 12 / 100;
  //   int totalMonths = durationYears * 12;
  //   double currentMonthlyAmt = amount.value;

  //   totalInvested.value = currentMonthlyAmt * totalMonths;
  //   totalProjected.value =
  //       currentMonthlyAmt *
  //       ((pow(1 + monthlyRate, totalMonths) - 1) / monthlyRate) *
  //       (1 + monthlyRate);

  //   List<FlSpot> tempInvested = [];
  //   List<FlSpot> tempProjected = [];
  //   int startYear = DateTime.now().year;

  //   for (int i = 0; i <= durationYears; i++) {
  //     int months = i * 12;
  //     double xValue = (startYear + i).toDouble();
  //     double invested = currentMonthlyAmt * months;
  //     double projected = months > 0
  //         ? currentMonthlyAmt *
  //               ((pow(1 + monthlyRate, months) - 1) / monthlyRate) *
  //               (1 + monthlyRate)
  //         : 0;

  //     tempInvested.add(FlSpot(xValue, invested));
  //     tempProjected.add(FlSpot(xValue, projected));
  //   }
  //   chartInvestedSpots.assignAll(tempInvested);
  //   chartProjectedSpots.assignAll(tempProjected);
  // }

  String formatCurrency(double val) {
    return "₹${val.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}";
  }

  @override
  void onClose() {
    for (var c in textControllers.values) {
      c.dispose();
    }
    super.onClose();
  }
}
