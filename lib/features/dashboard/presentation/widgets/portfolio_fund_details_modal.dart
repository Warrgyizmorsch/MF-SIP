import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/widget/animated/custom_toast.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/features/dashboard/domain/entity/portfolio_entity.dart';
import 'package:my_sip/features/dashboard/presentation/pages/portfolio_fund_details_page.dart';
import 'package:my_sip/features/mfu/presentation/pages/redeem_page.dart';

class PortfolioFundDetailsModal extends StatelessWidget {
  final MfuPortfolioItemEntity fund;

  const PortfolioFundDetailsModal({super.key, required this.fund});

  static void show(BuildContext context, MfuPortfolioItemEntity fund) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PortfolioFundDetailsModal(fund: fund),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isProfit = fund.gainLoss >= 0;
    final is1DProfit = fund.oneDayChange >= 0;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        14,
        20,
        MediaQuery.of(context).padding.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 1. Top Drag Handle ─────────────────────────
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // ── 2. Header: Logo, Name & Type Tag ───────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade100,
                ),
                child: ClipOval(
                  child: fund.amcLogo.isNotEmpty
                      ? Image.network(
                          fund.amcLogo,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.account_balance_rounded,
                            size: 24,
                            color: Colors.grey,
                          ),
                        )
                      : const Icon(
                          Icons.account_balance_rounded,
                          size: 24,
                          color: Colors.grey,
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fund.fundName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (fund.folioNo.isNotEmpty) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Folio: ${fund.folioNo}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                        ],
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: fund.isSip
                                ? const Color(0xFFEFF6FF)
                                : const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            fund.investmentType.toUpperCase(),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: fund.isSip
                                  ? const Color(0xFF2563EB)
                                  : const Color(0xFF16A34A),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── 3. Hero Card: Current Value & Gain/Loss ────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: Ucolors.backgroundGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Ucolors.primary.withValues(alpha: 0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Current Value',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isProfit
                            ? Colors.green.withValues(alpha: 0.2)
                            : Colors.redAccent.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isProfit
                              ? Colors.greenAccent.withValues(alpha: 0.5)
                              : Colors.redAccent.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isProfit
                                ? Icons.arrow_upward_rounded
                                : Icons.arrow_downward_rounded,
                            size: 13,
                            color: isProfit
                                ? Colors.greenAccent
                                : Colors.redAccent,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '${isProfit ? '+' : ''}₹${fund.gainLoss.abs().toStringAsFixed(2)} (${fund.gainLossPercent.abs().toStringAsFixed(2)}%)',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isProfit
                                  ? Colors.greenAccent
                                  : Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Animated Counter for Current Value
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: fund.currentValue),
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOutQuart,
                  builder: (context, value, child) {
                    return Text(
                      '₹${value.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // ── 4. Dynamic Order / Status Stepper Banner ───
          if (fund.isSipCancelledFlag) ...[
            _buildStatusBanner(
              icon: Icons.cancel_outlined,
              title: 'SIP Cancelled',
              subtitle: fund.sipCancellationDetails?.message.isNotEmpty == true
                  ? fund.sipCancellationDetails!.message
                  : 'Your SIP for this fund has been cancelled. No future installments will be deducted.',
              color: Colors.grey,
              stepIndex: 3,
            ),
            const SizedBox(height: 18),
          ] else if (fund.isRedemptionSettled) ...[
            _buildStatusBanner(
              icon: Icons.check_circle_outline_rounded,
              title: 'Redemption Settled & Credited',
              subtitle: fund.redemptionMessage.isNotEmpty
                  ? fund.redemptionMessage
                  : 'Redemption payout of ₹${fund.redeemedAmount > 0 ? fund.redeemedAmount : fund.redemptionDetails?.amount ?? 0} has been credited to your bank account.',
              color: Colors.green,
              stepIndex: 3,
            ),
            const SizedBox(height: 18),
          ] else if (fund.isRedemptionPending) ...[
            _buildStatusBanner(
              icon: Icons.hourglass_top_rounded,
              title: 'Redemption In Progress',
              subtitle: fund.redemptionMessage.isNotEmpty
                  ? fund.redemptionMessage
                  : 'Payout will be credited to your bank account in 1-2 working days.',
              color: Colors.amber,
              stepIndex: 2,
            ),
            const SizedBox(height: 18),
          ] else if (fund.isAllotmentPending) ...[
            _buildStatusBanner(
              icon: Icons.access_time_rounded,
              title: 'Unit Allotment In Progress ⏳',
              subtitle: fund.allotmentMessage.isNotEmpty
                  ? fund.allotmentMessage
                  : 'Order accepted. Unit allotment in progress by AMC (1-2 business days).',
              color: Colors.blue,
              stepIndex: 2,
            ),
            const SizedBox(height: 18),
          ],

          // ── 5. Detailed Breakdown Grid ─────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                _detailRow(
                  'Total Invested',
                  '₹${fund.investedAmount.toStringAsFixed(2)}',
                ),
                const Divider(
                  height: 20,
                  thickness: 1,
                  color: Color(0xFFE2E8F0),
                ),
                _detailRow('Total Units', fund.totalUnits.toStringAsFixed(3)),
                const Divider(
                  height: 20,
                  thickness: 1,
                  color: Color(0xFFE2E8F0),
                ),
                _detailRow(
                  'Current NAV',
                  '₹${fund.currentNav.toStringAsFixed(4)} ${fund.navDate.isNotEmpty ? "(${fund.navDate})" : ""}',
                ),
                const Divider(
                  height: 20,
                  thickness: 1,
                  color: Color(0xFFE2E8F0),
                ),
                _detailRow(
                  '1-Day Returns',
                  '${is1DProfit ? "+" : ""}₹${fund.oneDayChange.abs().toStringAsFixed(2)} (${fund.oneDayChangePercent.abs().toStringAsFixed(2)}%)',
                  valueColor: is1DProfit
                      ? Colors.green.shade700
                      : Colors.red.shade700,
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          // ── 6. Bottom Action Buttons ───────────────────
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Ucolors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Get.to(() => PortfolioFundDetailsPage(fund: fund));
                  },
                  icon: const Icon(
                    Iconsax.eye,
                    size: 16,
                    color: Ucolors.primary,
                  ),
                  label: const Text(
                    'View Details',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Ucolors.primary,
                    ),
                  ),
                ),
              ),
              if (!fund.isAllotmentPending &&
                  !fund.isRedemptionPending &&
                  !fund.isFullyRedeemed &&
                  fund.totalUnits > 0) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Ucolors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
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
                            orderRefNo:
                                fund.redemptionDetails?.orderRefNo ?? '',
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
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBanner({
    required IconData icon,
    required String title,
    required String subtitle,
    required MaterialColor color,
    required int stepIndex,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color.shade800),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color.shade900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: color.shade800, height: 1.35),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: valueColor ?? const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}
