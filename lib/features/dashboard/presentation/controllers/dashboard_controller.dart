// ignore_for_file: dead_null_aware_expression, dead_code

import 'dart:developer';

import 'package:get/get.dart';
import 'package:my_sip/features/dashboard/domain/entity/portfolio_entity.dart';
import 'package:my_sip/features/dashboard/domain/entity/transactionlist_entity.dart';
import 'package:my_sip/features/dashboard/domain/usecases/dashboard_usecases.dart';
import 'package:my_sip/services/session_manager.dart';

class DashboardController extends GetxController {
  final DashboardUsecases usecases;
  final session = SessionManager.instance;

  DashboardController(this.usecases);

  @override
  void onInit() {
    super.onInit();
    // getTransactions();
    getPortfolio();
  }

  final isLoadingTransactions = false.obs;
  final isLoadingPortfolio = false.obs;
  final errorMessageTranscation = ''.obs;
  final errorMessagePortfolio = ''.obs;
  final isBalanceVisible = false.obs;

  /// 0 = My Portfolio, 1 = Transactions
  final selectedIndex = 0.obs;

  void changeTab(int index) {
    selectedIndex.value = index;
    if (index == 1) {
      // if (transactionList.value == null) {
      //   getTransactions();
      // }
      getTransactions();
    }
  }

  final transactionList = Rxn<MfuTransactionListEntity>();
  final portfolioData = Rxn<MfuPortfolioEntity>();

  Future<void> getTransactions() async {
    isLoadingTransactions.value = true;
    errorMessageTranscation.value = '';

    final uid = session.getUserData?.id ?? 0;

    final result = await usecases.getTransactionsUseCase(uid: uid);

    result.fold(
      (success) {
        transactionList.value = success.data;
        log("[MfuController] Transactions loaded: ${success.data?.totalCount}");
      },
      (error) {
        errorMessageTranscation.value =
            error.message ?? 'Failed to fetch transactions';
        Get.snackbar('Error', errorMessageTranscation.value);
      },
    );

    isLoadingTransactions.value = false;
  }
  // Load
  // controller.getTransactions();

  // // Filtered lists
  // Obx(() {
  //   final txns = controller.transactionList.value;

  //   final allTxns = txns?.transactions ?? [];
  //   final pendingTxns = txns?.pending ?? [];
  //   final sipTxns = txns?.sipTransactions ?? [];
  //   final failedTxns = txns?.failed ?? [];
  // });

  Future<void> getPortfolio() async {
    isLoadingPortfolio.value = true;
    errorMessagePortfolio.value = '';

    final uid = session.getUserData?.id ?? 0;

    final result = await usecases.getPortfolioUseCase(uid: uid);

    result.fold(
      (success) {
        portfolioData.value = success.data;
        log(
          "[MfuController] Portfolio loaded: ${success.data?.totalFunds} funds",
        );
      },
      (error) {
        errorMessagePortfolio.value =
            error.message ?? 'Failed to fetch portfolio';
        Get.snackbar('Error', errorMessagePortfolio.value);
      },
    );

    isLoadingPortfolio.value = false;
  }

  //   controller.getPortfolio();

  // Obx(() {
  //   final portfolio = controller.portfolioData.value;
  //   final summary = portfolio?.summary;

  //   // Summary card
  //   final totalInvested = summary?.totalInvested ?? 0.0;
  //   final totalCurrentValue = summary?.totalCurrentValue ?? 0.0;
  //   final totalGainLoss = summary?.totalGainLoss ?? 0.0;
  //   final isProfit = summary?.isOverallProfit ?? false;
  //   final gainPercent = summary?.totalGainLossPercent ?? 0.0;

  //   // Filtered lists
  //   final sipFunds = portfolio?.sipFunds ?? [];
  //   final lumpsumFunds = portfolio?.lumpsumFunds ?? [];
  // });
}
