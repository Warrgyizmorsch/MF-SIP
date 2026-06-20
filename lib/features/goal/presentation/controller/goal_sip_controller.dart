import 'dart:math';
import 'dart:math' as math;
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
  final RxBool isSavingGoal = false.obs;

  RxInt additionalRoundingAmount = 0.obs;
  final RxBool isMasterGoalLoading = false.obs;

  /// =======================================
  /// USE EXISTING VARIABLES ONLY
  /// =======================================

  final RxBool isEdit = false.obs;
  final RxBool isHome = false.obs;
  final RxBool isAddFund = false.obs;
  final RxBool hasChanges = false.obs;
  final RxBool isNewGoal = false.obs;
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
   getAllGoals();
    _recalculate();
    recalculateLumpsum();
  }



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
  RxList<MutualFundListEntity> fundList = <MutualFundListEntity>[].obs;
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
      goalError.value.isEmpty && goalNameTextEditingController.text.isNotEmpty;
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
  void handleHomeGoal(MasterGoalEntity goal) {
    goalId.value = goal.id;

    selectedGoalType.value = goal.goalType;

    setTarget(goal.targetAmount);

    setYears(goal.goalTenure.toDouble());

    setRate(goal.expectedReturnRate);

    // ── Lumpsum Calculation
    final double r = goal.expectedReturnRate / 100;

    final int n = goal.goalTenure.toInt();

    final double pv = goal.targetAmount / pow(1 + r, n);

    lumpsumAmount.value = smartRoundOff(pv);

    lumpsumFutureValue.value = goal.targetAmount;

    lumpsumTotalReturn.value = goal.targetAmount - pv;

    debugPrint("init${lumpsumAmount.value}");
    update();
  }
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
  ///
  void loadGoalForAddFund(UserGoalEntity goal) {
    goalNameTextEditingController.text = goal.goalName;
    savedDatabaseId.value = goal.id;
    isGoalSaved.value = true;
    savedInvestmentType.value = goal.txnType ;
    if(goal.txnType.toLowerCase() == "lumpsum"){
      investmentMode.value = "lumpsum";
      lumpsumAmount.value = goal.lumpsumAmount.toDouble() ;
      lumpsumReturnPercent.value= goal.expectedReturnRate;
      lumpsumFutureValue.value = goal.goalType?.targetAmount.toDouble() ?? 0.0;
      years.value = goal.goalTenure.toDouble() ;

    } else {
      investmentMode.value = "sip";
      existingSipAmount.value = goal.monthlyInvestment.toDouble() ;
      monthlySip.value = goal.monthlyInvestment.toInt() ;
      targetAmount.value = goal.goalType?.targetAmount.toDouble() ?? 0.0;
      years.value = goal.goalTenure.toDouble() ;
      annualRate.value = goal.expectedReturnRate.toDouble();
    }

    /// =========================
    /// OLD VALUES
    /// =========================

    initialTargetAmount = (goal.investedAmount).toDouble();

    initialYears = (goal.goalTenure).toDouble();

    initialRate = (goal.expectedReturnRate).toDouble();

    /// =========================
    /// EXISTING SIP
    /// =========================

    existingSipAmount.value = (goal.monthlyInvestment).toDouble();

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
    recalculateLumpsum();

    update();
  }
  /// =======================================
  /// loadGoalForEdit()
  /// =======================================
  void loadGoalForEdit(UserGoalEntity goal) {
    goalNameTextEditingController.text = goal.goalName;

    final selectedType = goalConfig.entries
        .firstWhere(
          (entry) => entry.value['db_id'] == goal.goalId.toString(),
          orElse: () => MapEntry('custom', goalConfig['custom']!),
        )
        .key;

    selectedGoalType.value = selectedType;

    /// =========================
    /// OLD VALUES
    /// =========================

    initialTargetAmount = (goal.investedAmount).toDouble();

    initialYears = (goal.goalTenure).toDouble();

    initialRate = (goal.expectedReturnRate).toDouble();

    /// =========================
    /// EXISTING SIP
    /// =========================

    existingSipAmount.value = (goal.monthlyInvestment).toDouble();

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
    final bool amountChanged = targetAmount.value != initialTargetAmount;

    final bool yearChanged = years.value != initialYears;

    final bool rateChanged = (annualRate.value - initialRate).abs() > 0.001;

    hasChanges.value = amountChanged || yearChanged || rateChanged;

    final double sip = monthlySip.value.toDouble();

    double diff = sip - existingSipAmount.value;

    if (diff < 0) {
      diff = 0;
    }

    additionalSipAmount.value = diff;

    // TOTAL SIP
    weeklySipAmount.value = sip / 4;

    dailySipAmount.value = sip / 30;

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

    existingSipAmount.value = monthlySip.value.toDouble();

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
      final result = await goalUseCases.getMasterGoalsUseCase.call();

      return result.fold(
        (success) {
          masterGoals.assignAll(success.data?.data ?? []);

          isMasterGoalLoading.value = false;

          update();

          return true;
        },

        (error) {
          isMasterGoalLoading.value = false;

          update();

          Get.snackbar("Error", error.message);

          return false;
        },
      );
    } catch (e) {
      isMasterGoalLoading.value = false;

      update();

      Get.snackbar("Error", e.toString());

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
    try{
    isSavingGoal.value = true;
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

      "status": "pending",
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
        savedDatabaseId.value = success.data?.data.id ?? 0;
        savedInvestmentType.value = success.data?.data.txnType ?? 'sip';

        debugPrint('Saved Goal Id: ${savedDatabaseId.value}');

        debugPrint('goal id save ${success.data}');
      },
      (error) {
        Get.snackbar("Error", error.message);
        isGoalSaved.value = true;
      },
    );
    } catch(e){
      Get.snackbar("Error", e.toString());
      isGoalSaved.value = true;
    } finally {
      isSavingGoal.value = false;
    }
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
  int roundToNearest5(num amount) {
    final int a = amount.round();
    final int remainder = a % 5;

    if (remainder >= 3) {
      return a + (5 - remainder);
    } else {
      return a - remainder;
    }
  }

  final isDistributingAmount = false.obs;
  Future<void> distributeMonthlyAmount() async {
    if (savedInvestmentType.value != "lumpsum") return;
    if (lumpsumAmount.value <= 0) return;

    try {
      isDistributingAmount.value = true;

      final MutualFundController mutualController = Get.find();

      final selectedFundNames = selectedPopularFund.toList();
      final int count = selectedFundNames.length;

      if (count == 0) return;

      final int roundedTotal = roundToNearest5(lumpsumAmount.value);
      int baseAmount = roundToNearest5((roundedTotal / count).round());

      final List<int> assignedAmounts = List.generate(count, (_) => baseAmount);

      int totalAssigned = assignedAmounts.fold(0, (a, b) => a + b);
      int difference = roundedTotal - totalAssigned;

      if (difference != 0) {
        assignedAmounts[count - 1] += difference;
      }

      final allFunds = mutualController.searchFund;

      final List<Map<String, dynamic>> fundList = [];

      for (int i = 0; i < selectedFundNames.length; i++) {
        final fundName = selectedFundNames[i];

        final fund = allFunds.firstWhereOrNull(
          (f) => f.baseSchemeName == fundName,
        );

        final schemeCode = fund?.schemeCode?.toString() ?? '';

        getAmountController(schemeCode).text = assignedAmounts[i].toString();

        final fundId = getGoalFundId(schemeCode);
        debugPrint("Fund ID for schemeCode $schemeCode is $fundId and goal id ${ savedDatabaseId.value }");

        if (fundId == null) continue;
        debugPrint("Adding fund with ID $fundId, schemeCode $schemeCode, amount ${assignedAmounts[i]}");
        fundList.add({
          "id": fundId,
          "goal_id": savedDatabaseId.value ?? 0,
          "order_type": "lumpsum",
          "status": "pending",
          "scheme_code":schemeCode,

          "lumpsum_amount": assignedAmounts[i].toDouble(),
        });
      }

      debugPrint("REQUEST => $fundList");

      await updateGoalFundOrder(
        goalId: savedDatabaseId.value ?? 0,
        orderType: "sip",
        sipAmount: 0,
        sipDay: selectedSipDay.value,
        fundId: 0,
        lumpsumAmount: 0,
        funds: fundList,
      );

      await getAllGoals();
    } catch (e) {
      debugPrint("distributeMonthlyAmount Error: $e");
    } finally {
      isDistributingAmount.value = false;
    }
  }

  Future<void> redistributeRemainingAmount({
    required String editedSchemeCode,
    required double editedAmount,
  }) async {
    try {
      showLoading();
      isDistributingAmount.value = true;

      final MutualFundController mutualController = Get.find();

      final selectedFunds = selectedPopularFund.toList();
      if (selectedFunds.isEmpty) return;

      final totalAmount = roundToNearest5(lumpsumAmount.value);
      final remainingAmount = totalAmount - editedAmount;

      if (remainingAmount < 0) return;

      final allFunds = mutualController.searchFund;

      final remainingSchemeCodes = <String>[];
      final List<Map<String, dynamic>> funds = [];

      for (final fundName in selectedFunds) {
        final fund = allFunds.firstWhereOrNull(
          (f) => f.baseSchemeName == fundName,
        );

        final schemeCode = fund?.schemeCode?.toString() ?? '';

        if (schemeCode != editedSchemeCode) {
          remainingSchemeCodes.add(schemeCode);
        }
      }

      /// Edited Fund
      getAmountController(editedSchemeCode).text = editedAmount
          .toInt()
          .toString();

      final editedFundId = getGoalFundId(editedSchemeCode);

      if (editedFundId != null) {
        funds.add({
          "goal_id": savedDatabaseId.value ?? 0,
          "order_type": "lumpsum",
          "fund_id": editedFundId,
          "lumpsum_amount": editedAmount,
        });
      }

      /// Remaining Funds Distribution
      if (remainingSchemeCodes.isNotEmpty) {
        int perFund = roundToNearest5(
          (remainingAmount / remainingSchemeCodes.length).round(),
        );


        final amounts = List.generate(
          remainingSchemeCodes.length,
          (_) => perFund,
        );

        int assigned = amounts.fold(0, (a, b) => a + b);
        int diff = remainingAmount.round() - assigned;

        if (diff != 0) {
          amounts.last += diff;
        }

        for (int i = 0; i < remainingSchemeCodes.length; i++) {
          final schemeCode = remainingSchemeCodes[i];
          final amount = amounts[i];

          getAmountController(schemeCode).text = amount.toString();

          final fundId = getGoalFundId(schemeCode);

          if (fundId != null) {
            funds.add({
              "goal_id": savedDatabaseId.value ?? 0,
              "order_type": "lumpsum",
              "id": fundId,
              "status": "pending",
              "scheme_code":schemeCode,
              "lumpsum_amount": amount.toDouble(),
            });
          }
        }
      }

      debugPrint("BULK UPDATE REQUEST => $funds");

      await updateGoalFundOrder(
        goalId: savedDatabaseId.value ?? 0,
        orderType: "lumpsum",
        sipAmount: 0,
        sipDay: 0,
        fundId: 0,
        lumpsumAmount: 0,
        funds: funds,
      );

      await getAllGoals();
    } catch (e) {
      debugPrint("redistributeRemainingAmount Error: $e");
    } finally {
      isDistributingAmount.value = false;
      hideLoading();
    }
  }
  Future<void> distributeSipAmount() async {
    if (savedInvestmentType.value != "sip") return;

    try {
      showLoading();
      isDistributingAmount.value = true;

      final totalSip = monthlySip.value;
      if (totalSip <= 0) return;

      final selectedFunds = selectedPopularFund.toList();
      if (selectedFunds.isEmpty) return;

      final MutualFundController mutualController = Get.find();
      final allFunds = mutualController.searchFund;
      final count = selectedFunds.length;

      // Apply rounding to the base per-fund amount
      int perFund = roundToNearest5(totalSip / count);
      debugPrint("Initial Base perFund: $perFund");
      final amounts = List.generate(count, (_) => perFund);

      // Reconcile total with perfect round-up to nearest 5
      int assigned = amounts.fold(0, (a, b) => a + b);
      int diff = totalSip.toInt() - assigned;

      if (diff != 0) {
        amounts[amounts.length - 1] += diff;
        amounts[amounts.length - 1] = ((amounts.last / 5.0).ceil()) * 5;
      }

      final List<Map<String, dynamic>> funds = [];

      for (int i = 0; i < selectedFunds.length; i++) {
        final fund = allFunds.firstWhereOrNull((f) => f.baseSchemeName == selectedFunds[i]);
        final schemeCode = fund?.schemeCode?.toString() ?? '';

        // Set the amount in the controller
        getAmountController(schemeCode).text = amounts[i].toString();
        final fundId = getGoalFundId(schemeCode);
        final newTotal = amounts.fold(0, (a, b) => a + b);

        int extraAdded = newTotal - totalSip.toInt();
        additionalRoundingAmount.value = extraAdded;
        if (fundId != null) {
          funds.add({
            "goal_id": savedDatabaseId.value ?? 0,
            "order_type": "sip",
            "id": fundId,
            "status": "pending",
            "scheme_code": schemeCode,
            "sip_amount": amounts[i].toDouble(),
            "sip_day": selectedSipDay.value,
            "sip_start_date": DateTime.now().toString().split(' ').first,
            "sip_end_date": DateTime.now().add(const Duration(days: 365 * 3)).toString().split(' ').first,
          });
        }
      }

      // await updateGoalFundOrder(...);
      // await getAllGoals();

    } catch (e) {
      debugPrint("distributeSipAmount Error: $e");
    } finally {
      isDistributingAmount.value = false;
      hideLoading();
    }
  }

// ==========================================
// 2. REDISTRIBUTION (When user edits a text field)
// ==========================================

  Future<void> redistributeSipAmountAfterEdit({
    required String editedSchemeCode,
    required double editedAmount,
  }) async {
    // 1. Guard against double-triggers (Prevents Infinite Loop)
    if (isDistributingAmount.value) {
      debugPrint("Skipping: Already distributing.");
      return;
    }

    try {
      isDistributingAmount.value = true; // Lock the function
      // 🚀 NO showLoading() here to prevent GetX dialog glitches interrupting the keyboard

      final totalSip = monthlySip.value;
      final remainingAmount = totalSip - editedAmount;

      if (remainingAmount < 0) {
        Get.snackbar("Error", "Fund amount cannot exceed total SIP.");
        return;
      }

      final selectedFunds = selectedPopularFund.toList();
      final allFunds = Get.find<MutualFundController>().searchFund;

      final remainingSchemeCodes = selectedFunds
          .map((name) => allFunds.firstWhereOrNull((f) => f.baseSchemeName == name)?.schemeCode?.toString())
          .where((code) => code != null && code != editedSchemeCode)
          .cast<String>()
          .toList();

      final List<Map<String, dynamic>> funds = [];

      // Process Edited Fund
      getAmountController(editedSchemeCode).text = editedAmount.toInt().toString();
      final editedFundId = getGoalFundId(editedSchemeCode);

      if (editedFundId != null) {
        funds.add({
          "goal_id": savedDatabaseId.value ?? 0,
          "order_type": "sip",
          "id": editedFundId,
          "status": "pending",
          "scheme_code": editedSchemeCode,
          "sip_amount": editedAmount,
          "sip_day": selectedSipDay.value,
          "sip_start_date": DateTime.now().toString().split(' ').first,
          "sip_end_date": DateTime.now().add(const Duration(days: 365 * 3)).toString().split(' ').first,
        });
      }

      // Process Remaining Funds
      if (remainingSchemeCodes.isNotEmpty) {
        int perFund = roundToNearest5(remainingAmount / remainingSchemeCodes.length);
        final amounts = List.generate(remainingSchemeCodes.length, (_) => perFund);

        int assigned = amounts.fold(0, (a, b) => a + b);
        int diff = remainingAmount.round() - assigned;

        if (diff != 0) {
          amounts[amounts.length - 1] += diff;
          // 🚀 FORCE ROUND UP TO MULTIPLE OF 5
          amounts[amounts.length - 1] = ((amounts.last / 5.0).ceil()) * 5;
        }

        for (int i = 0; i < remainingSchemeCodes.length; i++) {
          final schemeCode = remainingSchemeCodes[i];

          // Update Text Field instantly
          getAmountController(schemeCode).text = amounts[i].toString();
          debugPrint("Final Edited Amount for $schemeCode: ${amounts[i]}");

          final fundId = getGoalFundId(schemeCode);

          if (fundId != null) {
            funds.add({
              "goal_id": savedDatabaseId.value ?? 0,
              "order_type": "sip",
              "id": fundId,
              "status": "pending",
              "scheme_code": schemeCode,
              "sip_amount": amounts[i].toDouble(),
              "sip_day": selectedSipDay.value,
              "sip_start_date": DateTime.now().toString().split(' ').first,
              "sip_end_date": DateTime.now().add(const Duration(days: 365 * 3)).toString().split(' ').first,
            });
          }
        }
      }



    } catch (e) {
      debugPrint("redistributeSipAmountAfterEdit Error: $e");
    } finally {
      isDistributingAmount.value = false; // Unlock
      // 🚀 NO hideLoading() here to prevent GetX dialog glitches
    }
  }


  void showLoading() {
    if (Get.isDialogOpen == true) return;

    Get.dialog(
      const Center(child: CircularProgressIndicator(color: Ucolors.primary)),
      barrierDismissible: false,
    );
  }

  void hideLoading() {
    debugPrint("hideLoading called");
    debugPrint("isDialogOpen: ${Get.isDialogOpen}");

    if (Get.isDialogOpen ?? false) {
      Get.close(1); // ya Get.back(closeOverlays: true);
    }
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
    required List<Map<String, dynamic>> funds,
  }) async {
    debugPrint("orderType: $orderType");

    try {
      debugPrint("UPDATE FUND REQUEST => $funds");
      debugPrint("FUND ID => $fundId");

      final result = await goalUseCases.updateGoalFundOrderUseCase(
        funds,
        fundId,
      );

      result.fold(
        (success) async {
          debugPrint("UPDATE SUCCESS => ${success.data?.id}");

          await getAllGoals();
        },
        (failure) {
          // showCustomToast(
          //   title: "Error",
          //   message: failure.message,
          //   backgroundColor: Colors.red.shade700,
          //   icon: Icons.error_outline,
          // );
        },
      );
    } catch (e) {
      debugPrint("Update Goal Fund Exception: $e");

      // showCustomToast(
      //   title: "Error",
      //   message: e.toString(),
      //   backgroundColor: Colors.red.shade700,
      //   icon: Icons.error_outline,
      // );
    }
  }

  @override
  void onClose() {
    for (final c in amountControllers.values) {
      c.dispose();
    }
    super.onClose();
  }
  RxBool isLoading =false.obs;
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
      final totalSip = (sipAmount).toDouble();
      final selectedFundCount = selectedPopularFund.length;

      final sipPerFund = selectedFundCount > 0
          ? totalSip / selectedFundCount
          : 0.0;
      final requestData = {
        "goal_id": goalId,
        "user_id": SessionManager.instance.getUserData!.id,
        "scheme_code": schemeCode,
        "order_date": DateTime.now().toString().split(' ').first,
        "order_type": savedInvestmentType.value,
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

      final result = await goalUseCases.saveGoalFundUseCase.call(requestData);

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
      debugPrint("Save Goal Fund Exception: $e");

      showCustomToast(
        title: "Error",
        message: e.toString(),
        backgroundColor: Colors.red.shade700,
        icon: Icons.error_outline,
      );
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
      "scheme_code": int.tryParse(schemeCode) ?? 0,
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

    final result = await goalUseCases.deleteGoalFundUseCase(id: id);

    result.fold(
      (success) {
        final goals = goalResponse.value?.data;

        if (goals != null) {
          for (var goal in goals) {
            goal.goalFunds.removeWhere((fund) => fund.id == id);
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
            message: schemeName ?? "",
            backgroundColor: Ucolors.red,
            icon: Icons.check_circle_outline,
          );
        }
      },
      (error) {
        ULoaders.error(title: 'Error', message: error.message);
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
        ULoaders.error(title: 'Error', message: error.message);
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
    targetAmount.value = smartRoundOff(value);
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
  // ── Lumpsum Calculation ───────────────────────────────────────────────────────
  void recalculateLumpsum() {
    final double fv = lumpsumFutureValue.value;
    final double r = annualRate.value / 100;
    final int n = years.value.toInt();

    if (fv <= 0 || r <= 0 || n <= 0) {
      // Reset defaults if inputs are invalid/empty
      lumpsumAmount.value = 0;
      lumpsumTotalReturn.value = 0;
      lumpsumReturnPercent.value = 0;
      update();
      return;
    }

    // Step 1: Calculate exact Present Value (PV)
    // PV = FV / (1 + r)^n
    final double exactPv = fv / pow(1 + r, n);

    // 🚀 Step 2: ROUND PV to nearest 10 (e.g., 56743 -> 56740)
    // .toDouble() lagaya hai taaki variable type match kare
    final double roundedPv = (exactPv / 10).round() * 10.0;
    lumpsumAmount.value = roundedPv;

    // 🚀 Step 3: Calculate Return and round it to nearest 10 as well
    final double exactReturn = fv - roundedPv;
    lumpsumTotalReturn.value = (exactReturn / 10).round() * 10.0;

    // Step 4: Calculate Percentage based on the rounded values
    if (roundedPv > 0) {
      lumpsumReturnPercent.value = (lumpsumTotalReturn.value / roundedPv) * 100;
    } else {
      lumpsumReturnPercent.value = 0;
    }

    update();
  }
  void _recalculate() {
    final int totalMonths = (years.value * 12).round();

    if (totalMonths <= 0 || targetAmount.value <= 0) {
      monthlySip.value = 0;
      invested.value = 0;
      futureValue.value = 0;
      totalReturn.value = 0;
      yearlyReport.clear(); // clear report
      return;
    }

    final r = _effectiveMonthlyRate(annualRate.value);

    // Step 1: exact SIP (double)
    double exactSip;
    if (r == 0) {
      exactSip = targetAmount.value / totalMonths;
    } else {
      final factor = ((pow(1 + r, totalMonths) - 1) / r) * (1 + r);
      exactSip = targetAmount.value / factor;
    }

    final int roundedSip = (exactSip / 10).round() * 10;
    monthlySip.value = roundedSip;

    int investedTmp = 0;
    double valueTmp = 0;

    for (int i = 0; i < totalMonths; i++) {
      investedTmp += roundedSip;
      valueTmp = (valueTmp + roundedSip) * (1 + r);
    }


    invested.value = investedTmp;

    futureValue.value = (valueTmp / 10).round() * 10;

    double exactTotalReturn = targetAmount.value - invested.value;
    totalReturn.value = (exactTotalReturn / 10).round() * 10;

    yearlyReport.value = buildYearlyReport();
  }

  List<ReturnRow> buildLumpsumYearlyReport() {
    final List<ReturnRow> rows = [];

    final double principal = lumpsumAmount.value;
    final double annualReturn = lumpsumReturnPercent.value;
    final int yearsCount = years.value.round();

    if (principal <= 0 || yearsCount <= 0) {
      return rows;
    }

    for (int year = 1; year <= yearsCount; year++) {
      final double currentValue =
          principal * math.pow(1 + (annualReturn / 100), year);

      final double profit = currentValue - principal;

      rows.add(
        ReturnRow(
          period: year.toString(),
          scheme: principal, // Invested Amount
          category: currentValue, // Current Value
          benchmark: profit, // Profit
        ),
      );
    }

    return rows;
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
      "return_max": annualRate.value,
      "sort_order": "desc",
      "return_year": years.value.toInt(),
    };
    Get.find<MutualFundController>().applyFilters(params);

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
    investmentMode.value= "sip";
    goalNameTextEditingController.clear();
    targetAmount.value = 0;
    years.value = 0;
    savedDatabaseId.value = null;
    selectedPopularFund.clear();
    debugPrint("Goal save 1${isGoalSaved.value},${isEdit.value},${isHome.value},${isAddFund.value},${isNewGoal.value},");

  }
}
