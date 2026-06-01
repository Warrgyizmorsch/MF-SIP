import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../domain/entity/goal_fund_order_entity.dart';
import '../../domain/entity/goal_master_entity.dart';

class GoalSipController extends GetxController {
  final GoalUseCases goalUseCases;
  // ── Investment Mode ───────────────────────────────────────────────────────────
  final RxString investmentMode = 'sip'.obs; // 'sip' | 'lumpsum'
  final RxInt selectedSipDay = 1.obs;
// ── Lumpsum Observables ───────────────────────────────────────────────────────
  final RxDouble lumpsumAmount = 0.0.obs;
  final RxDouble lumpsumFutureValue = 0.0.obs;
  final RxDouble lumpsumTotalReturn = 0.0.obs;
  final RxDouble lumpsumReturnPercent = 0.0.obs;
  final distributionRemainder = 0.0.obs;
  final Map<String, TextEditingController> amountControllers = {};

// ── Lumpsum Calculation ───────────────────────────────────────────────────────
  void recalculateLumpsum() {

    final double fv =
        lumpsumFutureValue.value;

    final double r =
        annualRate.value / 100;

    final int n =
    years.value.toInt();

    if (fv <= 0 || r <= 0 || n <= 0) {
      return;
    }

    // PV = FV / (1 + r)^n
    final double pv =
        fv / pow(1 + r, n);

    // ONLY ROUND HERE
    final double roundedPv =
    smartRoundOff(pv);

    lumpsumAmount.value =
        roundedPv;

    lumpsumTotalReturn.value =
        fv - roundedPv;

    lumpsumReturnPercent.value =
        ((fv - roundedPv) / roundedPv) * 100;

    update();
  }


  final RxBool isMasterGoalLoading = false.obs;
  /// =======================================
  /// USE EXISTING VARIABLES ONLY
  /// =======================================

  final RxBool isEdit = false.obs;
  final RxBool isHome = false.obs;
  final RxBool hasChanges = false.obs;

  final RxDouble existingSipAmount = 0.0.obs;
  final RxDouble additionalSipAmount = 0.0.obs;

  /// NEW ONLY
  final RxDouble dailySipAmount = 0.0.obs;
  final RxDouble weeklySipAmount = 0.0.obs;
  final isInitializing = true.obs;
  /// TRACK OLD VALUES
  double initialTargetAmount = 0;
  double initialYears = 0;
  double initialRate = 0;
  final RxList<MasterGoalEntity> masterGoals = <MasterGoalEntity>[].obs;
  final RxString masterGoalError = ''.obs;
  final RxInt selectedGoalIndex = (-1).obs;
  final GlobalKey goalDetailsKey = GlobalKey();
  @override
  @override
  void onInit() {
    super.onInit();
    investmentMode.value = 'sip';

    _recalculate();

    recalculateLumpsum();
  }
  void handleHomeGoal(MasterGoalEntity goal) {
    goalId.value = goal.id;

    selectedGoalType.value = goal.goalType;

    setTarget(goal.targetAmount);

    setYears(goal.goalTenure.toDouble());

    setRate(goal.expectedReturnRate);

    // ── Lumpsum Calculation
    final double r =
        goal.expectedReturnRate / 100;

    final int n =
    goal.goalTenure.toInt();

    final double pv =
        goal.targetAmount / pow(1 + r, n);

    lumpsumAmount.value =smartRoundOff(pv);

    lumpsumFutureValue.value =
        goal.targetAmount;

    lumpsumTotalReturn.value =
        goal.targetAmount - pv;

    debugPrint("init${ lumpsumAmount.value}");
    update();

  }
  final cartController = Get.find<CartController>();
  final RxList<GoalFundOrderEntity> savedGoalFunds =
      <GoalFundOrderEntity>[].obs;
  final savedDatabaseId = RxnInt();
  final savedInvestmentType = Rxn<String>();

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
  RxInt futureValue = 0.obs;
  RxInt targetLumpsumValue = 0.obs;
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
        goal.goalName ;

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
        (goal.investedAmount ).toDouble();

    initialYears =
        (goal.goalTenure ).toDouble();

    initialRate =
        (goal.expectedReturnRate ).toDouble();

    /// =========================
    /// EXISTING SIP
    /// =========================

    existingSipAmount.value =
        (goal.monthlyInvestment).toDouble();

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
        (annualRate.value - initialRate).abs() > 0.001;

    hasChanges.value =
        amountChanged ||
            yearChanged ||
            rateChanged;

    final double sip =
    monthlySip.value.toDouble();

    double diff =
        sip - existingSipAmount.value;

    if (diff < 0) {
      diff = 0;
    }

    additionalSipAmount.value = diff;

    // TOTAL SIP
    weeklySipAmount.value =
        sip / 4;

    dailySipAmount.value =
        sip / 30;

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
          debugPrint("Goals fetched: ${goalResponse.value?.data.length ?? 0}");
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
      //   title: "error",
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
      "goal_name": goalNameTextEditingController.text.trim(),
      "goal_id": goalId.value,

      "target_amount": investmentMode.value == 'sip'
          ? targetAmount.value.toDouble()
          : lumpsumFutureValue.value.toDouble(),

      "frequency": "Monthly",

      "monthly_investment": investmentMode.value == 'sip'
          ? monthlySip.value.toDouble()
          : 0.0,

      "expected_return_rate": annualRate.value.toDouble(),

      "goal_tenure": years.value.toInt(),

      "invested_amount": investmentMode.value == 'sip'
          ? invested.value.toDouble()
          : 0.0,

      "txn_type": investmentMode.value.toLowerCase(),

      "lumpsum_amount": investmentMode.value == 'lumpsum'
          ? lumpsumAmount.toDouble()
          : 0.0,

      "status": "active",

      "created_date": DateTime.now().toString(),
    };



    final result = await goalUseCases.saveGoalUseCase.call(requestData);
    return result.fold(
          (success) async {
        // Get.snackbar("Success", success.data ?? '');
        Get.snackbar("Success", 'Goal saved successfully,');
        await fetchCount();
        await getAllGoals();
        isGoalSaved.value = true;
        savedDatabaseId.value =
            success.data?.data.id ?? 0;
        savedInvestmentType.value =
            success.data?.data.txnType ?? 'sip';

        debugPrint(
          'Saved Goal Id: ${savedDatabaseId.value}',
        );

        debugPrint('goal id save ${success.data}');
      },
          (error) {
        Get.snackbar("Error", error.message);
        isGoalSaved.value = true;
      },
    );
  }

  int? getGoalFundId(String schemeCode) {
    final goals = goalResponse.value?.data ?? [];

    for (final goal in goals) {
      for (final fund in goal.goalFunds) {
        if (fund.schemeCode == schemeCode) {
          return fund.id;
        }
      }
    }

    return null;
  }

  int roundToNearest100(num amount) {
    final int a = amount.round();
    final remainder = a % 100;

    if (remainder >= 50) {
      return a + (100 - remainder);
    } else {
      return a - remainder;
    }
  }
  Future<void> distributeMonthlyAmount() async {
    if (savedInvestmentType.value != "lumpsum") return;
    if (lumpsumAmount.value <= 0) return;

    final MutualFundController mutualController = Get.find();

    final selectedFundNames = selectedPopularFund.toList();
    final int count = selectedFundNames.length;

    if (count == 0) return;

    final int roundedTotal = roundToNearest100(lumpsumAmount.value);
    int baseAmount = roundToNearest100((roundedTotal / count).round());

    final List<int> assignedAmounts = List.generate(count, (_) => baseAmount);

    int totalAssigned = assignedAmounts.fold(0, (a, b) => a + b);
    int difference = roundedTotal - totalAssigned;
    if (difference != 0) {
      assignedAmounts[count - 1] += difference;
    }

    distributionRemainder.value = lumpsumAmount.value -
        assignedAmounts.fold(0.0, (a, b) => a + b);

    debugPrint(
      "Count: $count\n"
          "Lumpsum Total: ${lumpsumAmount.value}\n"
          "Rounded Total: $roundedTotal\n"
          "Assigned: $assignedAmounts\n"
          "Remainder: ${distributionRemainder.value}",
    );

    final allFunds = mutualController.searchFund;

    for (int i = 0; i < selectedFundNames.length; i++) {
      final fundName = selectedFundNames[i];

      final fund = allFunds.firstWhereOrNull(
            (f) => f.baseSchemeName == fundName,
      );

      final schemeCode = fund?.schemeCode?.toString() ?? '';
      final assignedAmount = assignedAmounts[i];

      getAmountController(schemeCode).text =
          assignedAmount.toString();

      final fundId = getGoalFundId(schemeCode);

      if (fundId == null) continue;

      debugPrint(
        "START UPDATE => Fund ${i + 1}/$count | fundId=$fundId | amount=$assignedAmount",
      );

      await updateGoalFundOrder(
        goalId: savedDatabaseId.value ?? 0,
        orderType: "lumpsum",
        sipAmount: 0,
        sipDay: 0,
        fundId: fundId,
        lumpsumAmount: assignedAmount.toDouble(),
      );

      debugPrint(
        "COMPLETED UPDATE => Fund ${i + 1}/$count | fundId=$fundId",
      );

      // Optional delay
      await Future.delayed(
        const Duration(milliseconds: 300),
      );
    }

    debugPrint("ALL FUNDS UPDATED");
    await getAllGoals();
  }
  TextEditingController getAmountController(String schemeCode) {
    return amountControllers.putIfAbsent(
      schemeCode,
          () => TextEditingController(),
    );
  }
  Future<void> updateGoalFundOrder({
    required int goalId,
    required String orderType,
    required double sipAmount,
    required int sipDay,
    required int fundId,
    required double lumpsumAmount,
  }) async {
    debugPrint("orderType: $orderType");

    try {
      final requestData = {
        "goal_id": goalId,
        "order_type": orderType,

        if (orderType == "sip") ...{
          "sip_amount": sipAmount,
          "sip_day": sipDay,
          "sip_start_date":
          DateTime.now().toString().split(' ').first,
          "sip_end_date": DateTime.now()
              .add(const Duration(days: 365 * 3))
              .toString()
              .split(' ')
              .first,
        },

        if (orderType == "lumpsum")
          "lumpsum_amount": lumpsumAmount,
      };

      debugPrint("UPDATE FUND REQUEST => $requestData");
      debugPrint("FUND ID => $fundId");

      final result = await goalUseCases.updateGoalFundOrderUseCase(
        requestData,
        fundId,
      );

      result.fold(
            (success) async {
          debugPrint(
            "UPDATE SUCCESS => ${success.data?.id}",
          );

          await getAllGoals();
        },
            (failure) {
          showCustomToast(
            title: "Error",
            message: failure.message,
            backgroundColor: Colors.red.shade700,
            icon: Icons.error_outline,
          );
        },
      );
    } catch (e) {
      debugPrint("Update Goal Fund Exception: $e");

      showCustomToast(
        title: "Error",
        message: e.toString(),
        backgroundColor: Colors.red.shade700,
        icon: Icons.error_outline,
      );
    }
  }
  @override
  void onClose() {
    for (final c in amountControllers.values) {
      c.dispose();
    }
    super.onClose();
  }
  Future<void> saveGoalFund({
    required int goalId,
    required String schemeCode,
    required String schemeName,
    required double sipAmount,
    required int sipDay,
  }) async {
    HapticFeedback.successNotification();
  debugPrint("savedInvestmentType.value: ${savedInvestmentType.value}");
    try {
      final requestData = {
        "goal_id": goalId,
        "user_id": SessionManager.instance.getUserData!.id,
        "scheme_code": schemeCode,
        "order_date": DateTime.now().toString().split(' ').first,
        "order_type":savedInvestmentType.value,
        // "lumpsum_amount": lumpsumAmount,
        if (savedInvestmentType.value == "sip") ...{
          "sip_amount": sipAmount,
          "sip_day": sipDay,
          "sip_start_date": DateTime.now().toString().split(' ').first,
          "sip_end_date": DateTime.now()
              .add(const Duration(days: 365 * 3))
              .toString()
              .split(' ')
              .first,
        },

        if (savedInvestmentType.value == "lumpsum")
          "lumpsum_amount": lumpsumAmount.toString(),
      };

      final result =
      await goalUseCases.saveGoalFundUseCase.call(
        requestData,
      );

      result.fold(
            (success) async {

          /// Add to selected funds after successful API call
          if (!isSelectedFund(schemeName)) {
            toggleFund(schemeName);
          }

          showCustomToast(
            title: "Fund Added",
            message: schemeName,
            backgroundColor: Colors.green,
            icon: Icons.check_circle,
          );
          await    getAllGoals();
        },
            (failure) {
          showCustomToast(
            title: "Error",
            message: failure.message,
            backgroundColor: Colors.red.shade700,
            icon: Icons.error_outline,
          );
        },
      );
    } catch (e) {
      debugPrint("Save Goal Fund Exception: $e");

    }
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
      "scheme_code": int.tryParse(schemeCode ) ?? 0,
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
        // Get.snackbar("Error", "${error.message}");
        showCustomToast(
          title: "Already in Goal",
          message: fundName,
          backgroundColor: Colors.orange.shade700,
          icon: Icons.info_outline,
        );
      },
    );
  }

  Future<void> deleteGoalFund({
    required int id,
    required bool isEdit,
    String? schemeName,
  }) async {
    isDeleting[id] = true;

    final result = await goalUseCases.deleteGoalFundUseCase(
      id: id,
    );

    result.fold(
          (success) {

        final goals = goalResponse.value?.data;

        if (goals != null) {
          for (var goal in goals) {
            goal.goalFunds.removeWhere(
                  (fund) => fund.id == id,
            );
          }

          goalResponse.refresh();
        }



        if (isEdit) {
          Get.back();
          ULoaders.success(
            title: 'Deleted',
            message: success.data?.message ?? '',
          );
        } else {
          showCustomToast(
            title: "Removed from Goal",
            message: schemeName??"",
            backgroundColor: Ucolors.red,
            icon: Icons.check_circle_outline,
          );
        }
      },
          (error) {
        ULoaders.error(
          title: 'Error',
          message: error.message,
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
        await getAllGoals();
        Get.back();
        ULoaders.success(
          title: 'Deleted',
          message: success.data?.message ?? '',
        );
      },
          (error) {
        ULoaders.error(
          title: 'Error',
          message: error.message,
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
    targetAmount.value =
        smartRoundOff(value);
    _recalculate();
    checkForChanges();
  }

// ── Lumpsum Setter ────────────────────────────────────────────────────────────
  void setLumpsumAmount(double value) {

    lumpsumAmount.value = value;

    recalculateLumpsum();
  }
  double smartRoundOff(double value) {

    if (value < 1000) {
      return (value / 100).round() * 100;
    }

    if (value < 100000) {
      return (value / 1000).round() * 1000;
    }

    if (value < 10000000) {
      return (value / 10000).round() * 10000;
    }

    return (value / 100000).round() * 100000;
  }
  void setYears(double value) {
    years.value = value;
    _recalculate();
    recalculateLumpsum();
    checkForChanges();

  }

  void setRate(double value) {
    annualRate.value = value;
    _recalculate();
    recalculateLumpsum();

    checkForChanges();
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

     await Get.find<MutualFundController>().fetchData();
    // fundList.assignAll(result);
    debugPrint("Fund Result:");

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