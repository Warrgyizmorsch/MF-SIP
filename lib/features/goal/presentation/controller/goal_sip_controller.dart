import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';
import 'package:my_sip/common/widget/animated/popups.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/features/cart/presentation/controllers/cart_controller.dart';
import 'package:my_sip/features/explore/domain/entities/mutual_fund_list_entity.dart';

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
  final isDeleting = <int, bool>{}.obs;

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
      // Get.snackbar("Error", "Please enter a goal name");
      // showCustomToast(
      //   title: "errro",
      //   message: 'Please enter a Goal name',
      //   backgroundColor: Colors.yellow,
      //   icon: Icons.warning,
      // );
      // ULoaders.warning(title: 'Enter a Goal Name ');
      showCustomToast(
        title: 'Enter a Goal name',
        message: "",
        backgroundColor: Colors.orange,
        icon: Icons.warning,
      );
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

  Future<void> saveFundToGoal({
    required int goalId,
    required String schemeCode,
    required String fundName,
  }) async {
    // if (savedDatabaseId.value == null) {
    //   Get.snackbar("Wait!", "Please save your goal first before adding funds.");
    //   return;
    // }

    final String formattedDate = DateTime.now().toIso8601String().split('T')[0];

    final fundData = {
      "goal_id": goalId,
      "user_id": SessionManager.instance.getUserData?.id ?? 7,
      "scheme_code": int.tryParse(schemeCode ?? '') ?? 0,
      "order_date": formattedDate,
    };

    // 1. Call the new Use Case
    final result = await goalUseCases.saveGoalFundUseCase.call(fundData);

    result.fold(
      (success) async {
        // 2. Highlight the card in the UI
        toggleFund(fundName);

        // 3. Add to Cart Controller for Checkout
        // cartController.addToCart(
        //   fund.schemeCode ?? '',
        //   fundName,
        //   fund.minSipAmount ?? 0,
        //   savedDatabaseId.value,
        // );

        // Get.snackbar("Success", "$fundName linked to your goal!");
        showCustomToast(
          title: "Added to Goal",
          message: fundName,
          backgroundColor: Ucolors.primary,
          icon: Icons.check_circle_outline,
        );
        await getAllGoals();
      },
      (error) {
        // Get.snackbar("Errorrr", "${error.message}");
        showCustomToast(
          title: "Already in Goal",
          message: fundName,
          backgroundColor: Colors.orange.shade700,
          icon: Icons.info_outline,
        );
      },
    );
  }

  Future<void> deleteGoalFund(int id) async {
    isDeleting[id] = true;

    final result = await goalUseCases.deleteGoalFundUseCase(id: id);

    result.fold(
      (success) {
        // // Remove from local list instantly — no extra fetch needed
        final goals = goalResponse.value?.data;
        if (goals != null) {
          // 2. Iterate through goals to find where this fund link exists
          for (var goal in goals) {
            goal.goalFunds.removeWhere((fund) => fund.id == id);
          }
          // 3. Trigger Rx update
          goalResponse.refresh();
        }
        // goalResponse.value?.data.removeWhere((item) => item.id == id);
        ULoaders.success(
          title: 'Deleted',
          message: success.data?.message ?? '',
        );
      },
      (error) {
        ULoaders.error(
          title: 'Error',
          message: error.message ?? 'Delete failed',
        );
      },
    );

    isDeleting[id] = false;
  }

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
