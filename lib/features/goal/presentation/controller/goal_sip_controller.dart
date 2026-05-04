import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';
import 'package:my_sip/features/cart/presentation/controllers/cart_controller.dart';

import 'package:my_sip/features/fund_details/data/models/return_model.dart';
import 'package:my_sip/features/goal/domain/entity/goal_entity.dart';
import 'package:my_sip/features/goal/domain/usecases/goal_use_cases.dart';
import 'package:my_sip/services/session_manager.dart';

class GoalSipController extends GetxController {
  final GoalUseCases goalUseCases;

  final cartController = Get.find<CartController>();

  final savedDatabaseId = RxnInt();

  // --- Goal Response data ---
  final isLoadingGoals = false.obs;
  final goalResponse = Rxn<GoalResponseEntity>();

  final coverImage = Rxn<XFile>();
  // Inputs
  final targetAmount = 0.0.obs;
  final years = 1.0.obs;
  final annualRate = 12.0.obs;

  // Outputs (WHOLE NUMBERS like website)
  final monthlySip = 0.obs;
  final invested = 0.obs;
  final futureValue = 0.obs;
  final totalReturn = 0.obs;

  final isGoalSaved = false.obs;

  // Yearly report
  final yearlyReport = <ReturnRow>[].obs;

  ///Popular Funds Contains
  // final selectedPopularFund = <int>{}.obs;
  final selectedPopularFund = <String>{}.obs;
  // RxList<int> selectedPopularFund = <int>[].obs;

  final goalNameTextEditingController = TextEditingController();

  GoalSipController({required this.goalUseCases});

  @override
  void onInit() {
    super.onInit();
    _recalculate();
  }

  void initFromGoal({
    required double amount,
    required double years,
    required double rate,
  }) {
    setTarget(amount);
    setYears(years);
    setRate(rate);
  }

  Future<bool> getAllGoals() async {
    isLoadingGoals.value = true;
    try {
      final result = await goalUseCases.getGoalsUseCase.call();
      return result.fold(
        (success) {
          goalResponse.value = success.data;
          return true;
        },
        (error) {
          Get.snackbar("Error", error.message);
          return false;
        },
      );
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    } finally {
      isLoadingGoals.value = false;
    }
  }

  Future<void> saveGoalToDb() async {
    if (goalNameTextEditingController.text.isEmpty) {
      Get.snackbar("Error", "Please enter a goal name");
      return;
    }

    final requestData = {
      "user_id": SessionManager.instance.getUserData?.id,
      "created_date": DateTime.now().toString(),
      "target_amount": targetAmount.value,
      "frequency": "Monthly",
      "monthly_investment": monthlySip.value,
      "expected_return_rate": annualRate.value,
      "goal_tenure": years.value,
      "invested_amount": invested.value,
      "status": "active",
      "goal_name": goalNameTextEditingController.text,
      "goal_id": "1",
    };

    final result = await goalUseCases.saveGoalUseCase.call(requestData);
    return result.fold(
      (success) {
        // Get.snackbar("Success", success.data ?? '');
        Get.snackbar("Success", 'Goal saved successfully,');

        isGoalSaved.value = true;
        savedDatabaseId.value = int.tryParse(success.data?.toString() ?? '0');

        print('goal id save ${success.data}');
      },
      (error) {
        Get.snackbar("Error", error.message);
        isGoalSaved.value = true;
      },
    );
  }

  // Add this inside GoalSipController
  Future<void> pickCoverImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();

      // Using the exact same picker setup as your signature code
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 80, // Optional: compresses the image slightly
      );

      if (image != null) {
        coverImage.value = image; // Updates the Obx in the UI
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick cover: $e");
    }
  }

  ///// -------------- Goal Calculation ---------------///
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
      yearlyReport.clear(); //  clear report

      return;
    }

    final r = _effectiveMonthlyRate(annualRate.value);

    //  Step 1: exact SIP (double)
    double exactSip;
    if (r == 0) {
      exactSip = targetAmount.value / totalMonths;
    } else {
      final factor = ((pow(1 + r, totalMonths) - 1) / r) * (1 + r);
      exactSip = targetAmount.value / factor;
    }

    //  Step 2: ROUND like website
    final int roundedSip = exactSip.round();
    monthlySip.value = roundedSip;

    //  Step 3: build projection using ROUNDED SIP ONLY
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

  // ------Report -- //
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
  //--------------------------------------------------///

  ///// ---------Popular Fund ----------//

  // void toggleFund(String id) {
  //   selectedPopularFund.contains(id)
  //       ? selectedPopularFund.remove(id)
  //       : selectedPopularFund.add(id);
  // }

  void toggleFund(String fundName) {
    selectedPopularFund.contains(fundName)
        ? selectedPopularFund.remove(fundName)
        : selectedPopularFund.add(fundName);
  }

  bool isSelectedFund(String fundName) {
    return selectedPopularFund.contains(fundName);
  }
}
