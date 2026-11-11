import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/dashboard/domain/entity/portfolio_entity.dart';
import 'package:my_sip/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:my_sip/features/mfu/presentation/pages/redeem_page.dart';
import 'package:my_sip/navigation_menu_bar.dart';

import '../widgets/portfolio_fund_details_modal.dart';
import '../widgets/portfolio_holding_header.dart';
import '../widgets/portfolio_details_panels.dart';
import '../widgets/portfolio_transactions_section.dart';
import '../widgets/portfolio_fund_actions.dart';
import '../widgets/portfolio_additional_details_section.dart';
import '../widgets/sip_cancel_otp_modal.dart';

class PortfolioFundDetailsPage extends StatelessWidget {
  /// Static holder to preserve the active fund during GetX nested navigation or refresh on Web.
  static MfuPortfolioItemEntity? navFund;

  final MfuPortfolioItemEntity? fund;

  const PortfolioFundDetailsPage({super.key, this.fund});

  void _handleBack(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else if (kIsWeb && Get.isRegistered<NavigationBarController>()) {
      Get.find<NavigationBarController>().backNested(
        fallbackRoute: AppRoutes.managePortfolioweb,
      );
    } else {
      Get.back();
    }
  }

  Future<void> _handleRedeemOrCancel(
    BuildContext context,
    MfuPortfolioItemEntity selectedFund, {
    required bool redeem,
  }) async {
    final dashboard = Get.isRegistered<DashboardController>()
        ? Get.find<DashboardController>()
        : null;
    if (dashboard?.isLoadingPortfolio.value ?? false) return;
    var activeFund = _latestFund(selectedFund);
    if (!_canTransact(activeFund)) return;
    if (!redeem) {
      if (!activeFund.isSipActive || activeFund.hasPendingSipCancellation) {
        return;
      }
      await SipCancelOtpModal.show(context, activeFund);
    } else {
      final shouldProceed =
          await PortfolioFundDetailsModal.confirmGoalLinkedRedeemIfNeeded(
            context,
            activeFund,
          );
      if (!shouldProceed || !context.mounted) return;
      activeFund = _latestFund(selectedFund);
      if (!_canTransact(activeFund) ||
          (dashboard?.isLoadingPortfolio.value ?? false)) {
        return;
      }

      final redeemArgs = RedeemArgs(
        mfuOrderFundId: activeFund.mfuOrderFundId,
        amcLogo: activeFund.amcLogo,
        schemeCode: activeFund.schemeCode,
        schemeName: activeFund.fundName,
        folioNumber: activeFund.folioNo,
        folioType: 'Individual',
        totalUnits: activeFund.totalUnits,
        totalValue: activeFund.currentValue,
        lockedUnits: 0.0,
        lockedValue: 0,
        freeUnits: activeFund.totalUnits,
        freeValue: activeFund.currentValue,
        investedAmt: activeFund.investedAmount,
        hasPendingRedemption: activeFund.hasPendingRedemption,
        redemptionMessage: activeFund.redemptionMessage,
        orderRefNo: activeFund.redemptionDetails?.orderRefNo ?? '',
        pendingRedemptionAmount:
            activeFund.redemptionDetails?.amount ?? activeFund.redeemedAmount,
        pendingRedemptionUnits: activeFund.redeemedUnits,
        exitLoad: activeFund.exitLoad,
        goalId: activeFund.goalId,
        goalName: activeFund.goalName,
      );

      RedeemPage.navArgs = redeemArgs;

      if (kIsWeb && Get.isRegistered<NavigationBarController>()) {
        Get.find<NavigationBarController>().openNestedRoute(
          AppRoutes.redeemPage,
          arguments: redeemArgs,
        );
      } else {
        await Get.toNamed(AppRoutes.redeemPage, arguments: redeemArgs);
      }
    }
  }

  bool _canTransact(MfuPortfolioItemEntity activeFund) =>
      !activeFund.isAllotmentPending &&
      !activeFund.isRedemptionPending &&
      !activeFund.isFullyRedeemed &&
      activeFund.totalUnits > 0 &&
      (int.tryParse(activeFund.mfuOrderFundId?.toString().trim() ?? '') ?? 0) >
          0;

  MfuPortfolioItemEntity _latestFund(MfuPortfolioItemEntity selectedFund) {
    if (!Get.isRegistered<DashboardController>()) return selectedFund;
    final holdings =
        Get.find<DashboardController>().portfolioData.value?.portfolio;
    final id = selectedFund.mfuOrderFundId?.toString().trim();
    if (id == null || id.isEmpty || holdings == null) return selectedFund;
    return holdings.firstWhere(
      (holding) => holding.mfuOrderFundId?.toString().trim() == id,
      orElse: () => selectedFund,
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeFund =
        fund ??
        navFund ??
        (Get.arguments is MfuPortfolioItemEntity
            ? Get.arguments as MfuPortfolioItemEntity
            : null);

    if (activeFund == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black87,
              size: 18,
            ),
            onPressed: () => _handleBack(context),
          ),
          title: const Text(
            'Fund Details',
            style: TextStyle(
              fontFamily: FontFamily.medium,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.folder_open_rounded,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No Portfolio Fund Selected',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please select a fund from your portfolio to view its details.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Ucolors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _handleBack(context),
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  label: const Text(
                    'Back to Portfolio',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (!Get.isRegistered<DashboardController>()) {
      return _buildFundDetails(context, activeFund);
    }
    final controller = Get.find<DashboardController>();
    return Obx(
      () => _buildFundDetails(
        context,
        _latestFund(activeFund),
        isRefreshing: controller.isLoadingPortfolio.value,
      ),
    );
  }

  Widget _buildFundDetails(
    BuildContext context,
    MfuPortfolioItemEntity activeFund, {
    bool isRefreshing = false,
  }) {
    final isProfit = activeFund.gainLoss >= 0;
    final is1DProfit = activeFund.oneDayChange >= 0;

    final canTransact = _canTransact(activeFund);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 960;
        final topInset = MediaQuery.paddingOf(context).top;
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.transparent,
          ),
          child: Scaffold(
            backgroundColor: Ucolors.homeBackground,
            body: SingleChildScrollView(
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 174 + topInset,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: PortfolioDetailsHeader.gradient,
                      ),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: Alignment(0.64, -0.7),
                            radius: 0.22,
                            colors: [Color(0x599D85FF), Color(0x009D85FF)],
                            stops: [0, 0.28],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: SafeArea(
                      top: false,
                      bottom: false,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: isDesktop ? 1140 : double.infinity,
                        ),
                        child: Column(
                          children: [
                            SafeArea(
                              bottom: false,
                              child: PortfolioDetailsHeader(
                                fund: activeFund,
                                onBack: () => _handleBack(context),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: isDesktop ? 32 : 20,
                                vertical: isDesktop ? 28 : 20,
                              ),
                              child: isDesktop
                                  ? _buildDesktopLayout(
                                      context,
                                      activeFund,
                                      isProfit: isProfit,
                                      is1DProfit: is1DProfit,
                                      canTransact: canTransact,
                                      isRefreshing: isRefreshing,
                                    )
                                  : _buildMobileLayout(
                                      context,
                                      activeFund,
                                      isProfit: isProfit,
                                      is1DProfit: is1DProfit,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: (!isDesktop && canTransact)
                ? _buildBottomActionBar(
                    context,
                    activeFund,
                    isRefreshing: isRefreshing,
                  )
                : null,
          ),
        );
      },
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    MfuPortfolioItemEntity activeFund, {
    required bool isProfit,
    required bool is1DProfit,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeroCard(activeFund, isProfit: isProfit, is1DProfit: is1DProfit),
        const SizedBox(height: 14),
        ..._buildStatusBanners(activeFund),
        _buildDetailsPanels(context, activeFund, isDesktop: false),
        const SizedBox(height: 24),
        if (_hasTransactionsSection(activeFund)) ...[
          _buildFundTransactionsCard(activeFund),
          const SizedBox(height: 20),
        ],
      ],
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    MfuPortfolioItemEntity activeFund, {
    required bool isProfit,
    required bool is1DProfit,
    required bool canTransact,
    required bool isRefreshing,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column: Hero Overview, Status Banners, Actions, Transactions
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeroCard(
                activeFund,
                isProfit: isProfit,
                is1DProfit: is1DProfit,
              ),
              const SizedBox(height: 20),
              ..._buildStatusBanners(activeFund),
              if (canTransact) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x08000000),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Actions',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        activeFund.isSipActive
                            ? 'Cancel future SIP installments or redeem available units.'
                            : 'Submit a redemption request to withdraw your invested amount or units.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildFundActions(
                        context,
                        activeFund,
                        isRefreshing: isRefreshing,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
              if (_hasTransactionsSection(activeFund)) ...[
                _buildFundTransactionsCard(activeFund),
                const SizedBox(height: 20),
              ],
            ],
          ),
        ),
        const SizedBox(width: 24),
        // Right Column: Detail panels, with retained metrics and audits in the sheet.
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailsPanels(context, activeFund, isDesktop: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsPanels(
    BuildContext context,
    MfuPortfolioItemEntity activeFund, {
    required bool isDesktop,
  }) => PortfolioDetailsPanels(
    fund: activeFund,
    showSipSchedule: _hasSipScheduleSection(activeFund),
    onViewInvestmentDetails: () =>
        _showInvestmentDetails(context, activeFund, isDesktop: isDesktop),
  );

  void _showInvestmentDetails(
    BuildContext context,
    MfuPortfolioItemEntity activeFund, {
    required bool isDesktop,
  }) {
    Widget content(BuildContext overlayContext) => Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Additional details',
                  style: UTextStyles.homeText(
                    family: FontFamily.plusJakartaSans,
                    size: 17,
                    weight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Close additional details',
                onPressed: () => Navigator.of(overlayContext).pop(),
                icon: const Icon(Icons.close, color: Color(0xFF441D9E)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          PortfolioAdditionalDetailsSection(
            title: 'Performance & dates',
            initiallyExpanded: true,
            child: _buildInvestmentMetricsCard(
              activeFund,
              is1DProfit: activeFund.oneDayChange >= 0,
            ),
          ),
          if (_hasSipScheduleSection(activeFund))
            PortfolioAdditionalDetailsSection(
              title: 'SIP schedule',
              child: _buildSipScheduleCard(activeFund),
            ),
          if (_hasRedemptionSection(activeFund))
            PortfolioAdditionalDetailsSection(
              title: 'Redemption payout details',
              child: _buildRedemptionDetailsCard(activeFund),
            ),
          if (activeFund.sipCancellationDetails != null)
            PortfolioAdditionalDetailsSection(
              title: 'SIP cancellation audit',
              child: _buildSipCancellationCard(activeFund),
            ),
        ],
      ),
    );

    if (isDesktop) {
      showDialog<void>(
        context: context,
        builder: (dialogContext) => Dialog(
          backgroundColor: Ucolors.homeBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: SingleChildScrollView(child: content(dialogContext)),
          ),
        ),
      );
    } else {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: Ucolors.homeBackground,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        clipBehavior: Clip.antiAlias,
        builder: (sheetContext) => SafeArea(
          top: false,
          child: SingleChildScrollView(child: content(sheetContext)),
        ),
      );
    }
  }

  Widget _buildHeroCard(
    MfuPortfolioItemEntity activeFund, {
    required bool isProfit,
    required bool is1DProfit,
  }) => PortfolioHoldingCard(fund: activeFund);

  List<Widget> _buildStatusBanners(MfuPortfolioItemEntity activeFund) {
    final List<Widget> banners = [];
    if (activeFund.isSipCancelledFlag) return banners;
    if (activeFund.isRedemptionSettled) {
      banners.add(
        _buildStatusBanner(
          icon: Icons.check_circle_outline_rounded,
          title: 'Redemption Settled & Credited',
          subtitle: activeFund.redemptionMessage.isNotEmpty
              ? activeFund.redemptionMessage
              : 'Redemption payout of ₹${activeFund.redeemedAmount > 0 ? activeFund.redeemedAmount : activeFund.redemptionDetails?.amount ?? 0} has been credited to your bank account.',
          color: Colors.green,
        ),
      );
      banners.add(const SizedBox(height: 20));
    } else if (activeFund.isRedemptionPending) {
      banners.add(
        _buildStatusBanner(
          icon: Icons.hourglass_top_rounded,
          title: 'Redemption In Progress',
          subtitle: activeFund.redemptionMessage.isNotEmpty
              ? activeFund.redemptionMessage
              : 'Payout will be credited to your bank account in 1-2 working days.',
          color: Colors.amber,
        ),
      );
      banners.add(const SizedBox(height: 20));
    } else if (activeFund.isAllotmentPending) {
      banners.add(
        _buildStatusBanner(
          icon: Icons.access_time_rounded,
          title: 'Unit Allotment In Progress ⏳',
          subtitle: activeFund.allotmentMessage.isNotEmpty
              ? activeFund.allotmentMessage
              : 'Order accepted. Unit allotment in progress by AMC (1-2 business days).',
          color: Colors.blue,
        ),
      );
      banners.add(const SizedBox(height: 20));
    }
    return banners;
  }

  Widget _buildInvestmentMetricsCard(
    MfuPortfolioItemEntity activeFund, {
    required bool is1DProfit,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _infoRow(
            'Total Invested',
            '₹${activeFund.investedAmount.toStringAsFixed(2)}',
            icon: Iconsax.wallet_3,
          ),
          if (activeFund.purchaseNav > 0) ...[
            const Divider(height: 24),
            _infoRow(
              'Purchase NAV',
              '₹${activeFund.purchaseNav.toStringAsFixed(4)}',
              icon: Iconsax.card,
            ),
          ],
          const Divider(height: 24),
          _infoRow(
            'Current NAV',
            '₹${activeFund.currentNav.toStringAsFixed(4)} ${activeFund.navDate.isNotEmpty ? "(${activeFund.navDate})" : ""}',
            icon: Iconsax.chart,
          ),
          const Divider(height: 24),
          _infoRow(
            'Total Units',
            activeFund.totalUnits.toStringAsFixed(3),
            icon: Iconsax.box,
          ),
          const Divider(height: 24),
          _infoRow(
            '1-Day Returns',
            '${is1DProfit ? "+" : "−"}₹${activeFund.oneDayChange.abs().toStringAsFixed(2)} (${activeFund.oneDayChangePercent < 0 ? "−" : "+"}${activeFund.oneDayChangePercent.abs().toStringAsFixed(2)}%)',
            icon: Iconsax.trend_up,
            valueColor: is1DProfit
                ? Colors.green.shade700
                : Colors.red.shade700,
          ),
          if (activeFund.purchaseDate.isNotEmpty) ...[
            const Divider(height: 24),
            _infoRow(
              'Investment Date',
              activeFund.purchaseDate,
              icon: Iconsax.calendar,
            ),
          ],
          if (activeFund.firstInvestedDate.isNotEmpty &&
              activeFund.firstInvestedDate != activeFund.purchaseDate) ...[
            const Divider(height: 24),
            _infoRow(
              'First Invested Date',
              activeFund.firstInvestedDate,
              icon: Iconsax.calendar,
            ),
          ],
          if (activeFund.latestInvestedDate.isNotEmpty &&
              activeFund.latestInvestedDate != activeFund.purchaseDate &&
              activeFund.latestInvestedDate !=
                  activeFund.firstInvestedDate) ...[
            const Divider(height: 24),
            _infoRow(
              'Latest Invested Date',
              activeFund.latestInvestedDate,
              icon: Iconsax.calendar_tick,
            ),
          ],
          if (activeFund.latestPurchaseNav > 0 &&
              activeFund.latestPurchaseNav != activeFund.purchaseNav) ...[
            const Divider(height: 24),
            _infoRow(
              'Latest Purchase NAV',
              '₹${activeFund.latestPurchaseNav.toStringAsFixed(4)}',
              icon: Iconsax.card,
            ),
          ],
          const Divider(height: 24),
          _infoRow(
            'Folio Number',
            activeFund.folioNo,
            icon: Iconsax.folder_open,
          ),
        ],
      ),
    );
  }

  bool _hasExitLoadSection(MfuPortfolioItemEntity activeFund) {
    return activeFund.hasExitLoadData ||
        activeFund.exitLoad.isNotEmpty ||
        activeFund.exitLoadStatusBadge.isNotEmpty;
  }

  Widget _buildExitLoadCard(MfuPortfolioItemEntity activeFund) {
    final exitData = activeFund.exitLoadData;
    final bool isFree = activeFund.isExitLoadFree;
    final String statusBadge = activeFund.exitLoadStatusBadge.isNotEmpty
        ? activeFund.exitLoadStatusBadge
        : (isFree ? 'Nil (Exit Load Free)' : 'Applicable');
    final String smartTip = activeFund.exitLoadSmartTip;
    final double estLoad = activeFund.exitLoadAmount;
    final double estNet =
        exitData?.netEstimatedPayout ??
        (activeFund.currentValue - estLoad > 0
            ? activeFund.currentValue - estLoad
            : 0.0);
    final String rateStr = activeFund.exitLoadRateFormatted.isNotEmpty
        ? activeFund.exitLoadRateFormatted
        : (activeFund.exitLoadRate > 0
              ? '${activeFund.exitLoadRate.toStringAsFixed(2)}%'
              : (isFree ? '0.00%' : ''));
    final String freeDateStr = activeFund.exitLoadFreeDateFormatted.isNotEmpty
        ? activeFund.exitLoadFreeDateFormatted
        : (activeFund.exitLoadFreeDate.isNotEmpty
              ? activeFund.exitLoadFreeDate
              : '');
    final int daysRemaining = activeFund.exitLoadDaysRemaining;
    final List<MfuExitLoadLotEntity> lots = exitData?.lotsBreakdown ?? const [];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Status Badge & Exit Load Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Iconsax.shield_tick,
                    size: 20,
                    color: isFree
                        ? Colors.green.shade700
                        : const Color(0xFFD97706),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Exit Load Status',
                    style: TextStyle(
                      fontFamily: FontFamily.medium,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isFree
                      ? const Color(0xFFECFDF3)
                      : const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isFree
                        ? const Color(0xFFA7F3D0)
                        : const Color(0xFFFDE68A),
                  ),
                ),
                child: Text(
                  statusBadge,
                  style: TextStyle(
                    fontFamily: FontFamily.medium,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isFree
                        ? const Color(0xFF047857)
                        : const Color(0xFFB45309),
                  ),
                ),
              ),
            ],
          ),

          // 2. Smart Tip (if available)
          if (smartTip.isNotEmpty) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBBF7D0)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.lightbulb_outline_rounded,
                    size: 18,
                    color: Color(0xFF16A34A),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      smartTip,
                      style: const TextStyle(
                        fontFamily: FontFamily.medium,
                        fontSize: 12,
                        color: Color(0xFF15803D),
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const Divider(height: 24),

          // 3. Key Exit Load Numbers
          if (rateStr.isNotEmpty) ...[
            _infoRow(
              'Applicable Rate',
              rateStr,
              icon: Iconsax.percentage_circle,
            ),
            const Divider(height: 20),
          ],
          _infoRow(
            'Estimated Exit Load',
            '₹${estLoad.toStringAsFixed(2)}',
            icon: Iconsax.money_remove,
            valueColor: estLoad > 0
                ? Colors.red.shade700
                : Colors.green.shade700,
          ),
          const Divider(height: 20),
          _infoRow(
            'Est. Net Payout',
            '₹${estNet.toStringAsFixed(2)}',
            icon: Iconsax.money_recive,
            valueColor: Colors.green.shade800,
          ),
          if (freeDateStr.isNotEmpty) ...[
            const Divider(height: 20),
            _infoRow(
              'Exit Load Free Date',
              '$freeDateStr ${daysRemaining > 0 ? "($daysRemaining days left)" : "(Free Now)"}',
              icon: Iconsax.calendar_tick,
            ),
          ],

          // 4. FIFO Lots Breakdown (if lots available)
          if (lots.isNotEmpty) ...[
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'FIFO Lot Breakdown',
                  style: TextStyle(
                    fontFamily: FontFamily.medium,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  '${lots.length} ${lots.length == 1 ? "Lot" : "Lots"}',
                  style: TextStyle(
                    fontFamily: FontFamily.medium,
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...lots.asMap().entries.map((entry) {
              final idx = entry.key + 1;
              final lot = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lot #$idx • ${lot.allotmentDate}',
                          style: const TextStyle(
                            fontFamily: FontFamily.medium,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${lot.units.toStringAsFixed(3)} units • Held ${lot.daysHeld}d',
                          style: TextStyle(
                            fontFamily: FontFamily.medium,
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹${lot.amount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontFamily: FontFamily.medium,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          lot.exitLoadAmount > 0
                              ? 'Load: ₹${lot.exitLoadAmount.toStringAsFixed(2)} (${lot.ratePercent}%)'
                              : 'Load: Nil',
                          style: TextStyle(
                            fontFamily: FontFamily.medium,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: lot.exitLoadAmount > 0
                                ? Colors.red.shade700
                                : Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],

          // 5. AMC Rule & Disclaimer
          if (activeFund.exitLoad.isNotEmpty ||
              (exitData != null && exitData.rawRule.isNotEmpty)) ...[
            const Divider(height: 24),
            Text(
              'AMC Exit Load Policy:',
              style: TextStyle(
                fontFamily: FontFamily.medium,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              exitData?.rawRule.isNotEmpty == true
                  ? exitData!.rawRule
                  : activeFund.exitLoad,
              style: TextStyle(
                fontFamily: FontFamily.medium,
                fontSize: 11,
                color: Colors.grey.shade600,
                height: 1.35,
              ),
            ),
          ],
          if (exitData != null && exitData.disclaimer.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              exitData.disclaimer,
              style: TextStyle(
                fontFamily: FontFamily.medium,
                fontSize: 10,
                color: Colors.grey.shade500,
                fontStyle: FontStyle.italic,
                height: 1.3,
              ),
            ),
          ],
        ],
      ),
    );
  }

  bool _hasSipScheduleSection(MfuPortfolioItemEntity activeFund) {
    if (activeFund.isLumpsum || !activeFund.isSip) return false;
    return activeFund.nextSipDate.isNotEmpty ||
        activeFund.totalInstallments > 0 ||
        activeFund.sipFrequency.isNotEmpty ||
        activeFund.isSipActive;
  }

  Widget _buildSipScheduleCard(MfuPortfolioItemEntity activeFund) {
    final bool isCancelled = activeFund.isSipCancelledFlag;
    final String frequency = activeFund.sipFrequency.isNotEmpty
        ? activeFund.sipFrequency
        : 'Monthly';
    final String statusText = isCancelled ? 'Cancelled' : 'Active SIP';
    final Color statusColor = isCancelled
        ? Colors.grey
        : const Color(0xFF16A34A);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 10,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Iconsax.calendar_tick,
                      size: 18,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Flexible(
                    child: Text(
                      'SIP Schedule',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (activeFund.nextSipDate.isNotEmpty && !isCancelled) ...[
            _infoRow(
              'Next SIP Date',
              activeFund.nextSipDate,
              icon: Iconsax.calendar_1,
              valueColor: const Color(0xFF2563EB),
            ),
            const Divider(height: 24),
          ],
          _infoRow('Frequency', frequency, icon: Iconsax.repeat),
          if (activeFund.sipDay.isNotEmpty) ...[
            const Divider(height: 24),
            _infoRow(
              'Debit Day',
              '${activeFund.sipDay} of every month',
              icon: Iconsax.calendar_edit,
            ),
          ],
          if (activeFund.totalInstallments > 0) ...[
            const Divider(height: 24),
            _infoRow(
              'Completed Installments',
              '${activeFund.totalInstallments} ${activeFund.totalInstallments == 1 ? "installment" : "installments"}',
              icon: Iconsax.tick_circle,
              valueColor: Colors.green.shade700,
            ),
          ],
        ],
      ),
    );
  }

  bool _hasTransactionsSection(MfuPortfolioItemEntity activeFund) {
    return activeFund.transactions.isNotEmpty;
  }

  Widget _buildFundTransactionsCard(MfuPortfolioItemEntity activeFund) =>
      PortfolioTransactionsSection(fund: activeFund);

  bool _hasRedemptionSection(MfuPortfolioItemEntity activeFund) {
    return activeFund.redemptionDetails != null ||
        activeFund.redeemedAmount > 0 ||
        activeFund.redeemedUnits > 0 ||
        activeFund.hasPendingRedemption;
  }

  Widget _buildRedemptionDetailsCard(MfuPortfolioItemEntity activeFund) {
    final dtl = activeFund.redemptionDetails;
    final double amt = dtl?.amount ?? activeFund.redeemedAmount;
    final double units = (dtl?.units ?? 0) > 0
        ? dtl!.units
        : activeFund.redeemedUnits;
    final String volType = dtl?.transactionVolumeType ?? (amt > 0 ? 'A' : 'U');
    final String statusStr = dtl?.statusLabel.isNotEmpty == true
        ? dtl!.statusLabel
        : (dtl?.status.isNotEmpty == true
              ? dtl!.status
              : (activeFund.latestOrderStatusLabel.isNotEmpty
                    ? activeFund.latestOrderStatusLabel
                    : (activeFund.hasPendingRedemption
                          ? "In Progress"
                          : "Settled")));

    final String displayPayout = volType.toUpperCase() == 'U' || amt == 0
        ? '${units.toStringAsFixed(3)} Units (By Units)'
        : '₹${amt.toStringAsFixed(2)}';

    final double estValue =
        (volType.toUpperCase() == 'U' || amt == 0) && activeFund.currentNav > 0
        ? (units * activeFund.currentNav)
        : amt;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: activeFund.hasPendingRedemption
            ? const Color(0xFFFFFBEB)
            : const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: activeFund.hasPendingRedemption
              ? const Color(0xFFFDE68A)
              : const Color(0xFFBBF7D0),
        ),
      ),
      child: Column(
        children: [
          if (dtl?.orderRefNo.isNotEmpty == true)
            _infoRow(
              'Order Ref No',
              dtl!.orderRefNo,
              icon: Iconsax.document_text,
            ),
          if (dtl?.gorn.isNotEmpty == true) ...[
            const Divider(height: 20),
            _infoRow('GORN Ref', dtl!.gorn, icon: Iconsax.code),
          ],
          const Divider(height: 20),
          _infoRow(
            'Redemption Payout',
            displayPayout,
            icon: Iconsax.money_send,
            valueColor: activeFund.hasPendingRedemption
                ? const Color(0xFFD97706)
                : Colors.green.shade800,
          ),
          if (estValue > 0 && (volType.toUpperCase() == 'U' || amt == 0)) ...[
            const Divider(height: 20),
            _infoRow(
              'Estimated Value',
              '~₹${estValue.toStringAsFixed(2)}',
              icon: Iconsax.wallet_money,
            ),
          ],
          if (units > 0) ...[
            const Divider(height: 20),
            _infoRow(
              'Redeemed Units',
              '${units.toStringAsFixed(3)} Units',
              icon: Iconsax.box_remove,
            ),
          ],
          if (statusStr.isNotEmpty) ...[
            const Divider(height: 20),
            _infoRow(
              'Payout Status',
              statusStr,
              icon: Iconsax.verify,
              valueColor: activeFund.hasPendingRedemption
                  ? const Color(0xFFB45309)
                  : Colors.green.shade800,
            ),
          ],
          if (dtl?.estimatedPayoutDays.isNotEmpty == true) ...[
            const Divider(height: 20),
            _infoRow(
              'Payout Timeline',
              dtl!.estimatedPayoutDays,
              icon: Iconsax.clock,
            ),
          ],
          if (dtl?.message.isNotEmpty == true ||
              activeFund.redemptionMessage.isNotEmpty) ...[
            const Divider(height: 20),
            _infoRow(
              'Note',
              dtl?.message.isNotEmpty == true
                  ? dtl!.message
                  : activeFund.redemptionMessage,
              icon: Iconsax.info_circle,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSipCancellationCard(MfuPortfolioItemEntity activeFund) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          if (activeFund.sipCancellationDetails!.orderRefNo.isNotEmpty)
            _infoRow(
              'Cancellation Ref',
              activeFund.sipCancellationDetails!.orderRefNo,
              icon: Iconsax.document_code,
            ),
          if (activeFund.sipCancellationDetails!.cancelledDate.isNotEmpty) ...[
            const Divider(height: 20),
            _infoRow(
              'Cancelled Date',
              activeFund.sipCancellationDetails!.cancelledDate,
              icon: Iconsax.clock,
            ),
          ],
          if (activeFund.sipCancellationDetails!.message.isNotEmpty) ...[
            const Divider(height: 20),
            _infoRow(
              'Note',
              activeFund.sipCancellationDetails!.message,
              icon: Iconsax.info_circle,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(
    BuildContext context,
    MfuPortfolioItemEntity activeFund, {
    required bool isRefreshing,
  }) {
    return ColoredBox(
      color: Ucolors.homeBackground,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: _buildFundActions(
            context,
            activeFund,
            isRefreshing: isRefreshing,
          ),
        ),
      ),
    );
  }

  Widget _buildFundActions(
    BuildContext context,
    MfuPortfolioItemEntity activeFund, {
    required bool isRefreshing,
  }) => PortfolioFundActions(
    fund: activeFund,
    isRefreshing: isRefreshing,
    onCancelSip: () =>
        _handleRedeemOrCancel(context, activeFund, redeem: false),
    onRedeem: () => _handleRedeemOrCancel(context, activeFund, redeem: true),
  );

  Widget _infoRow(
    String label,
    String value, {
    required IconData icon,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 10),
        Expanded(
          flex: 5,
          child: Text(
            label,
            style: UTextStyles.homeText(
              family: FontFamily.plusJakartaSans,
              size: 13,
              weight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 6,
          child: Text(
            value,
            style: UTextStyles.homeText(
              family: FontFamily.plusJakartaSans,
              size: 13,
              weight: FontWeight.w700,
              color: valueColor ?? Colors.black87,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBanner({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.3,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
