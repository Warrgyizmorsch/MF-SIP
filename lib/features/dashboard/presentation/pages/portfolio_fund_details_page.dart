import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/widget/animated/custom_toast.dart';
import 'package:my_sip/common/widget/images/custom_cached_image.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/dashboard/domain/entity/portfolio_entity.dart';
import 'package:my_sip/features/mfu/presentation/pages/redeem_page.dart';

class PortfolioFundDetailsPage extends StatelessWidget {
  final MfuPortfolioItemEntity fund;

  const PortfolioFundDetailsPage({super.key, required this.fund});

  @override
  Widget build(BuildContext context) {
    final isProfit = fund.gainLoss >= 0;
    final is1DProfit = fund.oneDayChange >= 0;

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
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            if (fund.amcLogo.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomCachedImage(
                  imageUrl: fund.amcLogo,
                  width: 28,
                  height: 28,
                  fit: BoxFit.contain,
                ),
              ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                fund.fundName,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 1. Hero Portfolio Header Card ───
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
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
                          'Folio: ${fund.folioNo}',
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
                              (fund.isSip
                                      ? Colors.purpleAccent
                                      : Colors.cyanAccent)
                                  .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                (fund.isSip
                                        ? Colors.purpleAccent
                                        : Colors.cyanAccent)
                                    .withValues(alpha: 0.5),
                          ),
                        ),
                        child: Text(
                          fund.isSip ? 'SIP' : 'Lump Sum',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: fund.isSip
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
                    tween: Tween<double>(begin: 0, end: fund.currentValue),
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
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: (isProfit ? Colors.green : Colors.red)
                              .withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isProfit
                                  ? Icons.arrow_upward_rounded
                                  : Icons.arrow_downward_rounded,
                              size: 14,
                              color: isProfit
                                  ? Colors.greenAccent
                                  : Colors.redAccent,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${isProfit ? '+' : ''}₹${fund.gainLoss.abs().toStringAsFixed(2)} (${fund.gainLossPercent.abs().toStringAsFixed(2)}%)',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isProfit
                                    ? Colors.greenAccent
                                    : Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
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
                          '1D: ${is1DProfit ? "+" : ""}₹${fund.oneDayChange.abs().toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: is1DProfit
                                ? Colors.greenAccent
                                : Colors.redAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── 2. Dynamic Order Status Banner ───
            if (fund.isSipCancelledFlag) ...[
              _buildStatusBanner(
                icon: Icons.cancel_outlined,
                title: 'SIP Cancelled',
                subtitle:
                    fund.sipCancellationDetails?.message.isNotEmpty == true
                    ? fund.sipCancellationDetails!.message
                    : 'Your SIP for this fund has been cancelled. No future installments will be deducted.',
                color: Colors.grey,
              ),
              const SizedBox(height: 20),
            ] else if (fund.isRedemptionSettled) ...[
              _buildStatusBanner(
                icon: Icons.check_circle_outline_rounded,
                title: 'Redemption Settled & Credited',
                subtitle: fund.redemptionMessage.isNotEmpty
                    ? fund.redemptionMessage
                    : 'Redemption payout of ₹${fund.redeemedAmount > 0 ? fund.redeemedAmount : fund.redemptionDetails?.amount ?? 0} has been credited to your bank account.',
                color: Colors.green,
              ),
              const SizedBox(height: 20),
            ] else if (fund.isRedemptionPending) ...[
              _buildStatusBanner(
                icon: Icons.hourglass_top_rounded,
                title: 'Redemption In Progress',
                subtitle: fund.redemptionMessage.isNotEmpty
                    ? fund.redemptionMessage
                    : 'Payout will be credited to your bank account in 1-2 working days.',
                color: Colors.amber,
              ),
              const SizedBox(height: 20),
            ] else if (fund.isAllotmentPending) ...[
              _buildStatusBanner(
                icon: Icons.access_time_rounded,
                title: 'Unit Allotment In Progress ⏳',
                subtitle: fund.allotmentMessage.isNotEmpty
                    ? fund.allotmentMessage
                    : 'Order accepted. Unit allotment in progress by AMC (1-2 business days).',
                color: Colors.blue,
              ),
              const SizedBox(height: 20),
            ],

            // ── 3. Investment Breakdown Section ───
            const Text(
              'Investment Metrics',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Container(
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
                    '₹${fund.investedAmount.toStringAsFixed(2)}',
                    icon: Iconsax.wallet_3,
                  ),
                  if (fund.purchaseNav > 0) ...[
                    const Divider(height: 24),
                    _infoRow(
                      'Purchase NAV',
                      '₹${fund.purchaseNav.toStringAsFixed(4)}',
                      icon: Iconsax.card,
                    ),
                  ],
                  const Divider(height: 24),
                  _infoRow(
                    'Current NAV',
                    '₹${fund.currentNav.toStringAsFixed(4)} ${fund.navDate.isNotEmpty ? "(${fund.navDate})" : ""}',
                    icon: Iconsax.chart,
                  ),
                  const Divider(height: 24),
                  _infoRow(
                    'Total Units',
                    fund.totalUnits.toStringAsFixed(3),
                    icon: Iconsax.box,
                  ),
                  const Divider(height: 24),
                  _infoRow(
                    '1-Day Returns',
                    '${is1DProfit ? "+" : ""}₹${fund.oneDayChange.abs().toStringAsFixed(2)} (${fund.oneDayChangePercent.abs().toStringAsFixed(2)}%)',
                    icon: Iconsax.trend_up,
                    valueColor: is1DProfit
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                  ),
                  if (fund.purchaseDate.isNotEmpty) ...[
                    const Divider(height: 24),
                    _infoRow(
                      'Investment Date',
                      fund.purchaseDate,
                      icon: Iconsax.calendar,
                    ),
                  ],
                  const Divider(height: 24),
                  _infoRow(
                    'Folio Number',
                    fund.folioNo,
                    icon: Iconsax.folder_open,
                  ),
                  // if (fund.mfuOrderFundId != null) ...[
                  //   const Divider(height: 24),
                  //   _infoRow(
                  //     'MFU Order ID',
                  //     '#${fund.mfuOrderFundId}',
                  //     icon: Iconsax.receipt,
                  //   ),
                  // ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── 4. Redemption Payout Details Card ───
            if (fund.redemptionDetails != null || fund.redeemedAmount > 0) ...[
              const Text(
                'Redemption Payout Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFBBF7D0)),
                ),
                child: Column(
                  children: [
                    if (fund.redemptionDetails?.orderRefNo.isNotEmpty == true)
                      _infoRow(
                        'Order Ref No',
                        fund.redemptionDetails!.orderRefNo,
                        icon: Iconsax.document_text,
                      ),
                    if (fund.redemptionDetails?.gorn.isNotEmpty == true) ...[
                      const Divider(height: 20),
                      _infoRow(
                        'GORN Ref',
                        fund.redemptionDetails!.gorn,
                        icon: Iconsax.code,
                      ),
                    ],
                    const Divider(height: 20),
                    _infoRow(
                      'Payout Amount',
                      '₹${(fund.redeemedAmount > 0 ? fund.redeemedAmount : fund.redemptionDetails?.amount ?? 0).toStringAsFixed(2)}',
                      icon: Iconsax.money_send,
                      valueColor: Colors.green.shade800,
                    ),
                    if (fund.redeemedUnits > 0) ...[
                      const Divider(height: 20),
                      _infoRow(
                        'Redeemed Units',
                        fund.redeemedUnits.toStringAsFixed(3),
                        icon: Iconsax.box_remove,
                      ),
                    ],
                    if (fund.redemptionDetails?.status.isNotEmpty == true) ...[
                      const Divider(height: 20),
                      _infoRow(
                        'Payout Status',
                        fund.redemptionDetails!.status,
                        icon: Iconsax.verify,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // ── 5. SIP Cancellation Audit Card ───
            if (fund.sipCancellationDetails != null) ...[
              const Text(
                'SIP Cancellation Audit',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    if (fund.sipCancellationDetails!.orderRefNo.isNotEmpty)
                      _infoRow(
                        'Cancellation Ref',
                        fund.sipCancellationDetails!.orderRefNo,
                        icon: Iconsax.document_code,
                      ),
                    if (fund
                        .sipCancellationDetails!
                        .cancelledDate
                        .isNotEmpty) ...[
                      const Divider(height: 20),
                      _infoRow(
                        'Cancelled Date',
                        fund.sipCancellationDetails!.cancelledDate,
                        icon: Iconsax.clock,
                      ),
                    ],
                    if (fund.sipCancellationDetails!.message.isNotEmpty) ...[
                      const Divider(height: 20),
                      _infoRow(
                        'Note',
                        fund.sipCancellationDetails!.message,
                        icon: Iconsax.info_circle,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
      bottomNavigationBar:
          (!fund.isAllotmentPending &&
              !fund.isRedemptionPending &&
              !fund.isFullyRedeemed &&
              fund.totalUnits > 0)
          ? Container(
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
                  onPressed: () {
                    if (fund.isSipActive) {
                      CustomSnackbar.info(
                        title: "Cancel SIP",
                        message: "Navigating to SIP Cancellation...",
                      );
                    } else {
                      Get.to(
                        () => const RedeemPage(),
                        arguments: RedeemArgs(
                          mfuOrderFundId: fund.mfuOrderFundId,
                          amcLogo: fund.amcLogo,
                          schemeCode: fund.schemeCode,
                          schemeName: fund.fundName,
                          folioNumber: fund.folioNo,
                          folioType: 'Individual',
                          totalUnits: fund.totalUnits,
                          totalValue: fund.currentValue,
                          lockedUnits: 0.0,
                          lockedValue: 0,
                          freeUnits: fund.totalUnits,
                          freeValue: fund.currentValue,
                          investedAmt: fund.investedAmount,
                          hasPendingRedemption: fund.hasPendingRedemption,
                          redemptionMessage: fund.redemptionMessage,
                          orderRefNo: fund.redemptionDetails?.orderRefNo ?? '',
                        ),
                      );
                    }
                  },
                  child: Text(
                    fund.isSipActive
                        ? 'Cancel SIP'
                        : (fund.isPartiallyRedeemed
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
            )
          : null,
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
