import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';
import 'package:my_sip/common/widget/animated/popups.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/features/cart/presentation/controllers/cart_controller.dart';

import 'package:my_sip/features/fund_details/data/models/return_model.dart';
import 'package:my_sip/features/goal/domain/entity/goal_entity.dart';
import 'package:my_sip/features/goal/domain/usecases/goal_use_cases.dart';
import 'package:my_sip/services/session_manager.dart';

import '../../../explore/domain/entities/mutual_fund_list_entity.dart';
import '../../../explore/presentation/controller/mutual_fund_controller.dart';
import '../../domain/entity/goal_master_entity.dart';

class GoalSipController extends GetxController {
  final GoalUseCases goalUseCases;
  // ── Investment Mode ───────────────────────────────────────────────────────────
  final RxString investmentMode = 'sip'.obs; // 'sip' | 'lumpsum'

// ── Lumpsum Observables ───────────────────────────────────────────────────────
  final RxDouble lumpsumAmount = 500.0.obs;
  final RxDouble lumpsumFutureValue = 0.0.obs;
  final RxDouble lumpsumTotalReturn = 0.0.obs;
  final RxDouble lumpsumReturnPercent = 0.0.obs;

// ── Lumpsum Setter ────────────────────────────────────────────────────────────
  void setLumpsumAmount(double value) {
    lumpsumAmount.value = value;
    recalculateLumpsum();
  }

// ── Lumpsum Calculation ───────────────────────────────────────────────────────
// Call this inside setYears() and setRate() bhi — taaki slider change pe update ho
  void recalculateLumpsum() {
    final double fv = lumpsumFutureValue.value; // ← FV fixed rahega (goal.targetAmount)
    final double r = annualRate.value / 100;
    final int n = years.value.toInt();

    if (fv <= 0 || r <= 0 || n <= 0) return;

    // PV = FV / (1 + r)^n
    final double pv = fv / pow(1 + r, n);
    lumpsumAmount.value = pv;                          // Invest Once update
    lumpsumTotalReturn.value = fv - pv;
    lumpsumReturnPercent.value = ((fv - pv) / pv) * 100;
  }



  final RxBool isMasterGoalLoading = false.obs;
  /// =======================================
  /// USE EXISTING VARIABLES ONLY
  /// =======================================

  final RxBool isEdit = false.obs;
  final RxBool hasChanges = false.obs;

  final RxDouble existingSipAmount = 0.0.obs;
  final RxDouble additionalSipAmount = 0.0.obs;

  /// NEW ONLY
  final RxDouble dailySipAmount = 0.0.obs;
  final RxDouble weeklySipAmount = 0.0.obs;

  /// TRACK OLD VALUES
  double initialTargetAmount = 0;
  double initialYears = 0;
  double initialRate = 0;
  final RxList<MasterGoalEntity> masterGoals = <MasterGoalEntity>[].obs;
  final RxString masterGoalError = ''.obs;
  final RxInt selectedGoalIndex = (-1).obs;
  final GlobalKey goalDetailsKey = GlobalKey();
  @override
  void onInit() {
    super.onInit();
    investmentMode.value = 'sip';
    _recalculate();


    // Initial calculation
    recalculateLumpsum();
  }

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
   RxList<MutualFundListEntity> fundList= <MutualFundListEntity>[].obs;
  // Outputs (WHOLE NUMBERS like website)
  final monthlySip = 0.obs;
  final invested = 0.obs;
  final futureValue = 0.obs;
  final totalReturn = 0.obs;
  RxInt goalId = 0.obs;
  final isGoalSaved = false.obs;

  final selectedGoalType = 'custom'.obs;
  final goalError = RxString('');
  void setGoalName(String value) {
    if (value.trim().isEmpty) {
      goalError.value = "Goal title is required";
    } else {
      goalError.value = "";
    }
    update(); // for GetBuilder
  }
  bool get isFormValid =>
      goalError.value.isEmpty &&
          goalNameTextEditingController.text.isNotEmpty;
  final Map<String, Map<String, dynamic>> goalConfig = {
    // ✅ Added 'db_id' to each category (Check with your backend team for the exact IDs!)
    'car': {
      'db_id': "1",
      'amount': 1000000.0,
      'duration': 5.0,
      'rate': 12.0,
      'name': 'Car',
    },
    'education': {
      'db_id': "3",
      'amount': 500000.0,
      'duration': 3.0,
      'rate': 12.0,
      'name': 'Education',
    },
    'home': {
      'db_id': "2",
      'amount': 3000000.0,
      'duration': 10.0,
      'rate': 12.0,
      'name': 'Home',
    },
    'marriage': {
      'db_id': "4",
      'amount': 500000.0,
      'duration': 5.0,
      'rate': 12.0,
      'name': 'Marriage',
    },
    'vacation': {
      'db_id': "6",
      'amount': 100000.0,
      'duration': 2.0,
      'rate': 12.0,
      'name': 'Vacation',
    },
    'custom': {
      'db_id': "7",
      'amount': 100000.0,
      'duration': 2.0,
      'rate': 12.0,
      'name': 'Custom',
    },

    /// 3 - education
    /// 4 - marriage
    /// 5 - retirement
  };

  // Yearly report
  final yearlyReport = <ReturnRow>[].obs;

  ///Popular Funds Contains
  // final selectedPopularFund = <int>{}.obs;
  final selectedPopularFund = <String>{}.obs;
  // RxList<int> selectedPopularFund = <int>[].obs;
  final isDeleting = <int, bool>{}.obs;

  final goalNameTextEditingController = TextEditingController();

  GoalSipController({required this.goalUseCases});

  void updateGoalType(String newType) {
    if (!goalConfig.containsKey(newType)) return;

    selectedGoalType.value = newType;
    isGoalSaved.value = false;
    selectedPopularFund.clear(); // Reset selections for the new goal setup
    goalNameTextEditingController.clear();

    final targetConfig = goalConfig[newType]!;

    initFromGoal(
      amount: targetConfig['amount'],
      years: targetConfig['duration'],
      rate: targetConfig['rate'],
    );
  }
  /// =======================================
  /// loadGoalForEdit()
  /// =======================================
  void loadGoalForEdit(UserGoalEntity goal) {

    goalNameTextEditingController.text =
        goal.goalName ?? '';

    final selectedType = goalConfig.entries
        .firstWhere(
          (entry) =>
      entry.value['db_id'] ==
          goal.goalId.toString(),
      orElse: () => MapEntry(
        'custom',
        goalConfig['custom']!,
      ),
    )
        .key;

    selectedGoalType.value = selectedType;

    /// =========================
    /// OLD VALUES
    /// =========================

    initialTargetAmount =
        (goal.investedAmount ?? 0).toDouble();

    initialYears =
        (goal.goalTenure ?? 1).toDouble();

    initialRate =
        (goal.expectedReturnRate ?? 12).toDouble();

    /// =========================
    /// EXISTING SIP
    /// =========================

    existingSipAmount.value =
        (goal.monthlyInvestment ?? 0).toDouble();

    /// =========================
    /// INIT
    /// =========================

    initFromGoal(
      amount: initialTargetAmount,
      years: initialYears,
      rate: initialRate,
    );

    /// =========================
    /// RESET CHANGE VALUES
    /// =========================

    hasChanges.value = false;

    additionalSipAmount.value = 0;

    weeklySipAmount.value = 0;

    dailySipAmount.value = 0;

    isGoalSaved.value = true;

    _recalculate();

    update();
  }
  /// =======================================
  /// CHECK CHANGES
  /// =======================================

  void checkForChanges() {

    final bool amountChanged =
        targetAmount.value != initialTargetAmount;

    final bool yearChanged =
        years.value != initialYears;

    final bool rateChanged =
        annualRate.value != initialRate;

    hasChanges.value =
        amountChanged ||
            yearChanged ||
            rateChanged;

    if (!hasChanges.value) {

      additionalSipAmount.value = 0;

      weeklySipAmount.value = 0;

      dailySipAmount.value = 0;

      update();

      return;
    }

    final double newSip =
    monthlySip.value.toDouble();

    final double oldSip =
        existingSipAmount.value;

    double diff = newSip - oldSip;

    if (diff < 0) {
      diff = 0;
    }

    additionalSipAmount.value = diff;

    weeklySipAmount.value =
        diff / 4;

    dailySipAmount.value =
        diff / 30;

    update();
  }
  void initFromGoal({
    required double amount,
    required double years,
    required double rate,
  }) {

    /// =========================
    /// STORE INITIAL VALUES
    /// =========================

    initialTargetAmount = amount;
    initialYears = years;
    initialRate = rate;

    /// =========================
    /// SET VALUES
    /// =========================

    setTarget(amount);
    setYears(years);
    setRate(rate);

    /// =========================
    /// EXISTING SIP
    /// =========================

    existingSipAmount.value =
        monthlySip.value.toDouble();

    /// =========================
    /// RESET VALUES
    /// =========================

    additionalSipAmount.value = 0;

    weeklySipAmount.value = 0;

    dailySipAmount.value = 0;

    hasChanges.value = false;

    update();
  }
  Future<bool> getMasterGoals() async {

    isMasterGoalLoading.value = true;
    update();

    try {

      final result =
      await goalUseCases.getMasterGoalsUseCase.call();

      return result.fold(

            (success) {

          masterGoals.assignAll(
            success.data?.data ?? [],
          );

          isMasterGoalLoading.value = false;

          update();

          return true;
        },

            (error) {

          isMasterGoalLoading.value = false;

          update();

          Get.snackbar(
            "Error",
            error.message,
          );

          return false;
        },
      );

    } catch (e) {

      isMasterGoalLoading.value = false;

      update();

      Get.snackbar(
        "Error",
        e.toString(),
      );

      return false;
    }
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
    setGoalName(goalNameTextEditingController.text);
    if (!isFormValid) {
      return;
    }
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
    final currentType = selectedGoalType.value;
    final correctDbId = goalConfig[currentType]?['db_id'] ?? "6";

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
      "goal_id": goalId.value.toString(),
    };

    final result = await goalUseCases.saveGoalUseCase.call(requestData);
    return result.fold(
      (success) async {
        // Get.snackbar("Success", success.data ?? '');
        Get.snackbar("Success", 'Goal saved successfully,');
        await fetchCount();
        await getAllGoals();
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

        Get.back();
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
  Future<void> deleteGoal(int id) async {
    isDeleting[id] = true;

    final result = await goalUseCases.deleteGoalUseCase(id: id);

    result.fold(
      (success) async {
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
        await    getAllGoals();
        Get.back();
        Get.back();
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

      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (image != null) {
        coverImage.value = image;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick cover: $e");
    }
  }

  /// =======================================
  /// UPDATE THESE METHODS
  /// =======================================

  void setTarget(double value) {
    targetAmount.value = value;
    _recalculate();
    checkForChanges();
  }

  void setYears(double value) {
    years.value = value;
    _recalculate();
    checkForChanges();
    recalculateLumpsum();
  }

  void setRate(double value) {
    annualRate.value = value;
    _recalculate();
    checkForChanges();
    recalculateLumpsum();
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
  void toggleFund(String name) {

    if (selectedPopularFund.contains(name)) {

      selectedPopularFund.remove(name);

    } else {

      selectedPopularFund.add(name);
    }
  }
  Color getGoalColor(String goalType) {
    switch (goalType.toLowerCase()) {

      case 'car':
        return Colors.blue.shade300;

      case 'house':
        return Colors.orange.shade300;

      case 'education':
        return Colors.green.shade300;

      case 'marriage':
        return Colors.pink.shade300;

      case 'retirement':
        return Colors.deepPurple.shade300;

      case 'vacation':
        return Colors.teal.shade300;

      case 'other':
        return Colors.indigo.shade300;

      default:
        return Colors.grey;
    }
  }
  Future<void> fetchCount() async {
    Map<String, dynamic> params = {
      "return_max":annualRate.value,
      "sort_order":"desc",
      "return_year":years.value.toInt()
    };
    Get.find<MutualFundController>().applyFilters(
      params,);

    final result = await Get.find<MutualFundController>().fetchData(

    );
    // fundList.assignAll(result);
    print("Fund Result:");

  }

  bool isSelectedFund(String fundName) {
    return selectedPopularFund.contains(fundName);
  }

  // ✅ ADD THIS METHOD to GoalSipController
  void resetStateForNewGoal() {
    isGoalSaved.value = false;
    savedDatabaseId.value = null;
    selectedPopularFund.clear();
  }
}
