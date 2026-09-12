import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/widget/animated/custom_toast.dart';
import 'package:my_sip/common/widget/images/custom_cached_image.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/dashboard/domain/entity/portfolio_entity.dart';
import 'package:my_sip/features/mfu/presentation/pages/redeem_page.dart';
import 'package:my_sip/navigation_menu_bar.dart';

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

  void _handleRedeemOrCancel(
    BuildContext context,
    MfuPortfolioItemEntity activeFund,
  ) {
    if (activeFund.isSipActive) {
      CustomSnackbar.info(
        title: "Cancel SIP",
        message: "Navigating to SIP Cancellation...",
      );
    } else {
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
      );

      RedeemPage.navArgs = redeemArgs;

      if (kIsWeb && Get.isRegistered<NavigationBarController>()) {
        Get.find<NavigationBarController>().openNestedRoute(
          AppRoutes.redeemPage,
          arguments: redeemArgs,
        );
      } else {
        Get.toNamed(AppRoutes.redeemPage, arguments: redeemArgs);
      }
    }
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

    final isProfit = activeFund.gainLoss >= 0;
    final is1DProfit = activeFund.oneDayChange >= 0;

    final canTransact =
        !activeFund.isAllotmentPending &&
        !activeFund.isRedemptionPending &&
        !activeFund.isFullyRedeemed &&
        activeFund.totalUnits > 0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 960;

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
            title: Row(
              children: [
                if (activeFund.amcLogo.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomCachedImage(
                      imageUrl: activeFund.amcLogo,
                      width: 28,
                      height: 28,
                      fit: BoxFit.contain,
                    ),
                  ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    activeFund.fundName,
                    style: const TextStyle(
                      fontFamily: FontFamily.medium,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          body: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isDesktop ? 1140 : double.infinity,
              ),
              child: SingleChildScrollView(
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
                      )
                    : _buildMobileLayout(
                        context,
                        activeFund,
                        isProfit: isProfit,
                        is1DProfit: is1DProfit,
                      ),
              ),
            ),
          ),
          bottomNavigationBar: (!isDesktop && canTransact)
              ? _buildBottomActionBar(context, activeFund)
              : null,
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
        const SizedBox(height: 20),
        ..._buildStatusBanners(activeFund),
        const Text(
          'Investment Metrics',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        _buildInvestmentMetricsCard(activeFund, is1DProfit: is1DProfit),
        const SizedBox(height: 20),
        if (_hasRedemptionSection(activeFund)) ...[
          const Text(
            'Redemption Payout Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          _buildRedemptionDetailsCard(activeFund),
          const SizedBox(height: 20),
        ],
        if (activeFund.sipCancellationDetails != null) ...[
          const Text(
            'SIP Cancellation Audit',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          _buildSipCancellationCard(activeFund),
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
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column: Hero Overview, Status Banners, and Transaction Card
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
                            ? 'Cancel your active SIP mandate for this scheme.'
                            : 'Submit a redemption request to withdraw your invested amount or units.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Ucolors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () =>
                              _handleRedeemOrCancel(context, activeFund),
                          child: Text(
                            activeFund.isSipActive
                                ? 'Cancel SIP'
                                : (activeFund.isPartiallyRedeemed
                                      ? 'Redeem Remaining'
                                      : 'Redeem'),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ],
          ),
        ),
        const SizedBox(width: 24),
        // Right Column: Investment Metrics, Redemption Payout, SIP Cancellation Audit
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Investment Metrics',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              _buildInvestmentMetricsCard(activeFund, is1DProfit: is1DProfit),
              if (_hasRedemptionSection(activeFund)) ...[
                const SizedBox(height: 24),
                const Text(
                  'Redemption Payout Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                _buildRedemptionDetailsCard(activeFund),
              ],
              if (activeFund.sipCancellationDetails != null) ...[
                const SizedBox(height: 24),
                const Text(
                  'SIP Cancellation Audit',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                _buildSipCancellationCard(activeFund),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeroCard(
    MfuPortfolioItemEntity activeFund, {
    required bool isProfit,
    required bool is1DProfit,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Folio: ${activeFund.folioNo}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color:
                      (activeFund.isSip
                              ? Colors.purpleAccent
                              : Colors.cyanAccent)
                          .withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color:
                        (activeFund.isSip
                                ? Colors.purpleAccent
                                : Colors.cyanAccent)
                            .withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  activeFund.isSip ? 'SIP' : 'Lump Sum',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: activeFund.isSip
                        ? Colors.purpleAccent
                        : Colors.cyanAccent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Current Value',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 4),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: activeFund.currentValue),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOutQuart,
            builder: (context, value, child) {
              return Text(
                '₹${value.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: (isProfit ? Colors.green : Colors.red).withValues(
                    alpha: 0.18,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isProfit
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      size: 14,
                      color: isProfit ? Colors.greenAccent : Colors.redAccent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${isProfit ? '+' : ''}₹${activeFund.gainLoss.abs().toStringAsFixed(2)} (${activeFund.gainLossPercent.abs().toStringAsFixed(2)}%)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isProfit ? Colors.greenAccent : Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '1D: ${is1DProfit ? "+" : ""}₹${activeFund.oneDayChange.abs().toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: is1DProfit ? Colors.greenAccent : Colors.redAccent,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildStatusBanners(MfuPortfolioItemEntity activeFund) {
    final List<Widget> banners = [];
    if (activeFund.isSipCancelledFlag) {
      banners.add(
        _buildStatusBanner(
          icon: Icons.cancel_outlined,
          title: 'SIP Cancelled',
          subtitle:
              activeFund.sipCancellationDetails?.message.isNotEmpty == true
              ? activeFund.sipCancellationDetails!.message
              : 'Your SIP for this fund has been cancelled. No future installments will be deducted.',
          color: Colors.grey,
        ),
      );
      banners.add(const SizedBox(height: 20));
    } else if (activeFund.isRedemptionSettled) {
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
            '${is1DProfit ? "+" : ""}₹${activeFund.oneDayChange.abs().toStringAsFixed(2)} (${activeFund.oneDayChangePercent.abs().toStringAsFixed(2)}%)',
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
    MfuPortfolioItemEntity activeFund,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Ucolors.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: () => _handleRedeemOrCancel(context, activeFund),
          child: Text(
            activeFund.isSipActive
                ? 'Cancel SIP'
                : (activeFund.isPartiallyRedeemed
                      ? 'Redeem Remaining'
                      : 'Redeem'),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(
    String label,
    String value, {
    required IconData icon,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
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
