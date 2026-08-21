import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/animated/custom_footer.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/images/custom_cached_image.dart';
import 'package:my_sip/common/widget/text_form/text_field_component.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/mfu/presentation/controller/mfu_controller.dart';

class _T {
  static const bg = Color(0xFFF0F4F8); // light grey page bg
  static const surface = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF0D1117);
  static const textSec = Color(0xFF6B7280);
  static const textMuted = Color(0xFF9CA3AF);
  static const border = Color(0xFFE5E7EB);
  static const success = Color(0xFF059669);
  static const danger = Color(0xFFDC2626);
  static const dangerBg = Color(0xFFFEF2F2);
  static const activeRowBg = Color(0xFFEFF6FF); // selected radio row bg
}

class RedeemArgs {
  final dynamic mfuOrderFundId;
  final String amcLogo;
  final String schemeCode;
  final String schemeName;
  final String folioNumber;
  final String folioType;
  final double totalUnits;
  final double totalValue;
  final double lockedUnits;
  final double lockedValue;
  final double freeUnits;
  final double freeValue;
  final double investedAmt;
  final String bankName;
  final String bankAccount; // masked, e.g. "• • • • 2649"
  final String ifsc;
  final String payoutMode;
  final bool hasPendingRedemption;
  final String redemptionMessage;
  final String orderRefNo;

  const RedeemArgs({
    this.mfuOrderFundId,
    this.amcLogo = '',
    required this.schemeCode,
    required this.schemeName,
    required this.folioNumber,
    required this.folioType,
    required this.totalUnits,
    required this.totalValue,
    required this.lockedUnits,
    required this.lockedValue,
    required this.freeUnits,
    required this.freeValue,
    required this.investedAmt,
    this.bankName = 'BANK OF BARODA',
    this.bankAccount = '• • • • 2649',
    this.ifsc = 'BARB0NIMBAH',
    this.payoutMode = 'NEFT PAYOUT',
    this.hasPendingRedemption = false,
    this.redemptionMessage = '',
    this.orderRefNo = '',
  });
}

class RedeemPage extends StatefulWidget {
  const RedeemPage({super.key});

  @override
  State<RedeemPage> createState() => _RedeemPageState();
}

class _RedeemPageState extends State<RedeemPage> {
  late final RedeemArgs _args;
  late final MfuController _mfu;
  final _amountFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _args = Get.arguments as RedeemArgs;
    _mfu = Get.find<MfuController>();

    _mfu.selectRedeemType(RedeemType.amount);
    _mfu.redeemAmountCtrl.clear();
    _mfu.redeemUnitsCtrl.clear();
  }

  @override
  void dispose() {
    _amountFocus.dispose();
    super.dispose();
  }

  void _onProceed() {
    FocusScope.of(context).unfocus();
    HapticFeedback.mediumImpact();

    // Determine values for summary dialog
    String redeemSummary = '';
    final rType = _mfu.redeemType.value;

    if (rType == RedeemType.amount) {
      final v = double.tryParse(_mfu.redeemAmountCtrl.text) ?? 0;
      if (v <= 0) {
        _mfu.redeemInputError.value = 'Please enter an amount';
        return;
      }
      if (_args.freeValue > 0 && v > _args.freeValue) {
        _mfu.redeemInputError.value =
            'Exceeds free value (Max: ₹${_args.freeValue.toStringAsFixed(2)})';
        return;
      }
      redeemSummary = '₹${_fmtVal(v)}';
    } else if (rType == RedeemType.units) {
      final v = double.tryParse(_mfu.redeemUnitsCtrl.text) ?? 0;
      if (v <= 0) {
        _mfu.redeemInputError.value = 'Please enter units';
        return;
      }
      if (_args.freeUnits > 0 && v > _args.freeUnits) {
        _mfu.redeemInputError.value =
            'Exceeds free units (Max: ${_args.freeUnits.toStringAsFixed(3)})';
        return;
      }
      redeemSummary = '${v.toStringAsFixed(3)} Units';
    } else {
      redeemSummary =
          'Full Redemption (${_args.freeUnits.toStringAsFixed(3)} Units / ₹${_fmtVal(_args.freeValue)})';
    }

    _showConfirmationBottomSheet(context, redeemSummary);
  }

  void _showConfirmationBottomSheet(
    BuildContext context,
    String redeemSummary,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Confirm Redemption',
                style: UTextStyles.bodyLargeBold.copyWith(
                  color: _T.textPrimary,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Please verify your request details before submitting.',
                style: UTextStyles.bodyMedium.copyWith(color: _T.textSec),
              ),
              const SizedBox(height: 16),

              // Detail box
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _T.border),
                ),
                child: Column(
                  children: [
                    _buildConfirmRow('Fund', _args.schemeName),
                    const Divider(height: 16),
                    _buildConfirmRow('Folio', _args.folioNumber),
                    const Divider(height: 16),
                    _buildConfirmRow('Redemption', redeemSummary),
                    const Divider(height: 16),
                    _buildConfirmRow(
                      'Payout Bank',
                      '${_args.bankName}\n(A/c ending ${_args.bankAccount})',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Ucolors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        _mfu.processRedemption(
                          mfuOrderFundId: _args.mfuOrderFundId,
                          schemeCode: _args.schemeCode,
                          folio: _args.folioNumber,
                          freeUnits: _args.freeUnits,
                          freeValue: _args.freeValue,
                          onSuccess: (_) => Navigator.maybePop(context),
                        );
                      },
                      child: const Text(
                        'Confirm & Submit',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConfirmRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: UTextStyles.bodyMedium.copyWith(color: _T.textSec)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: UTextStyles.bodyMediumSemiBold.copyWith(
              color: _T.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPendingRedemptionBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFD97706),
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pending Redemption Request Found',
                  style: UTextStyles.bodyMediumBold.copyWith(
                    color: const Color(0xFF92400E),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _args.redemptionMessage.isNotEmpty
                      ? _args.redemptionMessage
                      : 'A redemption request is already in progress for this folio. Payout will be processed in 1-2 working days.',
                  style: UTextStyles.bodyMedium.copyWith(
                    color: const Color(0xFFB45309),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        appBar: CustomAppBarNormal(title: 'Redeem'),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_args.hasPendingRedemption) ...[
                      _buildPendingRedemptionBanner(),
                      const SizedBox(height: 12),
                    ],
                    _buildFundCard(),
                    const SizedBox(height: 12),
                    _buildSelectionCard(context),
                    const SizedBox(height: 12),
                    _buildBankCard(),
                    const SizedBox(height: 12),
                    _buildNoticeCard(),
                    const SizedBox(height: 12),
                    CustomFooter(),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildProceedButton(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Card 1: Fund Info ─────────────────────────────────────────────────────────
  Widget _buildFundCard() {
    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Folio',
                      style: UTextStyles.bodyMediumW500.copyWith(
                        color: _T.textMuted,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_args.folioNumber}-${_args.folioType}',
                      style: UTextStyles.bodyMediumSemiBold.copyWith(
                        color: _T.textPrimary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Ucolors.primary, width: 1.5),
                ),
                child: Text(
                  'Active',
                  style: UTextStyles.bodyMediumSemiBold.copyWith(
                    color: Ucolors.primary,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'CURRENT INVESTMENT',
            style: UTextStyles.bodySmallBold.copyWith(
              color: _T.textMuted,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              // Circular Logo
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: _T.border, width: 1.5),
                ),
                child: ClipOval(
                  child: CustomCachedImage(
                    imageUrl: _args.amcLogo.isNotEmpty
                        ? _args.amcLogo
                        : '${Appurl.baseUrl}/assets/amc-logos/axis_groww.webp',
                    height: 40,
                    width: 40,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Fund Name (Expanded so it wraps if long)
              Expanded(
                child: Text(
                  _args.schemeName,
                  style: UTextStyles.heading2.copyWith(
                    color: _T.textPrimary,
                    fontSize: 18, // Slightly reduced to balance with logo
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: _T.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _T.border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Market Value',
                        style: UTextStyles.bodyMediumW500.copyWith(
                          color: _T.textSec,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '₹ ',
                            style: UTextStyles.bodyLarge.copyWith(
                              color: _T.textPrimary,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            _fmtVal(_args.totalValue),
                            style: UTextStyles.heading1.copyWith(
                              color: _T.textPrimary,
                              fontSize: 26,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  '${_args.totalUnits.toStringAsFixed(3)} Units',
                  style: UTextStyles.bodyMediumW500.copyWith(
                    color: _T.textSec,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _ValueBox(
                  label: 'Locked Value',
                  value: _args.lockedValue,
                  units: _args.lockedUnits,
                  color: _T.textPrimary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ValueBox(
                  label: 'Free Value',
                  value: _args.freeValue,
                  units: _args.freeUnits,
                  color: Ucolors.primary,
                  showInfo: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Card 2: Selection Criteria ────────────────────────────────────────────────
  Widget _buildSelectionCard(BuildContext context) {
    return _WhiteCard(
      child: Obx(() {
        final rType = _mfu.redeemType.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selection Criteria',
              style: UTextStyles.bodyLargeBold.copyWith(
                color: _T.textPrimary,
                fontSize: 20,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Choose how you want to withdraw your funds.',
              style: UTextStyles.bodyMedium.copyWith(
                color: _T.textSec,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),

            _RadioRow(
              label: 'Amount',
              selected: rType == RedeemType.amount,
              trailing: Text(
                'Recommended',
                style: UTextStyles.bodyMediumSemiBold.copyWith(
                  color: Ucolors.primary,
                  fontSize: 12,
                ),
              ),
              onTap: () => _mfu.selectRedeemType(RedeemType.amount),
            ),
            const SizedBox(height: 10),

            _RadioRow(
              label: 'All Free units',
              selected: rType == RedeemType.allFree,
              trailing: Text(
                '${_args.freeUnits.toStringAsFixed(3)} units',
                style: UTextStyles.bodyMediumW500.copyWith(
                  color: _T.textSec,
                  fontSize: 13,
                ),
              ),
              onTap: () => _mfu.selectRedeemType(RedeemType.allFree),
            ),
            const SizedBox(height: 10),

            _RadioRow(
              label: 'No. of units',
              selected: rType == RedeemType.units,
              onTap: () => _mfu.selectRedeemType(RedeemType.units),
            ),
            const SizedBox(height: 20),

            if (rType == RedeemType.amount) ...[
              Text(
                'Enter Amount',
                style: UTextStyles.bodyMediumSemiBold.copyWith(
                  color: _T.textPrimary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              _AmountInput(
                controller: _mfu.redeemAmountCtrl,
                focusNode: _amountFocus,
                prefix: '₹',
                hint: '0.00',
                error: _mfu.redeemInputError.value,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _mfu.redeemAmountInWords.value,
                      style: UTextStyles.bodyMedium.copyWith(
                        color: _T.textSec,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _mfu.useMaxRedeemAmount(_args.freeValue);
                      _amountFocus.requestFocus();
                    },
                    child: Text(
                      'Use Max',
                      style: UTextStyles.bodyMediumBold.copyWith(
                        color: Ucolors.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: Ucolors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],

            if (rType == RedeemType.allFree) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFBBF7D0)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: _T.success,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '${_args.freeUnits.toStringAsFixed(3)} units  ·  ₹${_fmtVal(_args.freeValue)} will be redeemed',
                        style: UTextStyles.bodyMediumSemiBold.copyWith(
                          color: const Color(0xFF065F46),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            if (rType == RedeemType.units) ...[
              Text(
                'Enter No. of Units',
                style: UTextStyles.bodyMediumSemiBold.copyWith(
                  color: _T.textPrimary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              _AmountInput(
                // focusNode: FocusNode(),
                controller: _mfu.redeemUnitsCtrl,
                prefix: '',
                hint: '0.000',
                suffix: 'units',
                error: _mfu.redeemInputError.value,
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Available: ${_args.freeUnits.toStringAsFixed(3)} units',
                    style: UTextStyles.bodyMedium.copyWith(color: _T.textSec),
                  ),
                  GestureDetector(
                    onTap: () => _mfu.useMaxRedeemUnits(_args.freeUnits),
                    child: Text(
                      'Use Max',
                      style: UTextStyles.bodyMediumBold.copyWith(
                        color: Ucolors.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: Ucolors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        );
      }),
    );
  }

  // ── Card 3: Bank for Payout ───────────────────────────────────────────────────
  Widget _buildBankCard() {
    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'BANK FOR PAYOUT',
            style: UTextStyles.bodyMediumBold.copyWith(
              color: _T.textMuted,
              fontSize: 11,
              letterSpacing: 0.9,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _T.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.account_balance_outlined,
                    color: Ucolors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _args.bankName,
                        style: UTextStyles.bodyLargeBold.copyWith(
                          color: _T.textPrimary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'A/c ending in ${_args.bankAccount}',
                        style: UTextStyles.bodyMediumW500.copyWith(
                          color: _T.textSec,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: _T.textMuted,
                  size: 20,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'IFSC',
                      style: UTextStyles.bodyMediumSemiBold.copyWith(
                        color: _T.textSec,
                        fontSize: 11,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _args.ifsc,
                      style: UTextStyles.bodyLargeBold.copyWith(
                        color: _T.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payout Method',
                      style: UTextStyles.bodyMediumSemiBold.copyWith(
                        color: _T.textSec,
                        fontSize: 11,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _args.payoutMode,
                      style: UTextStyles.bodyLargeBold.copyWith(
                        color: _T.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Card 4: Important Notice ──────────────────────────────────────────────────
  Widget _buildNoticeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _T.dangerBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(Icons.info_outline_rounded, color: _T.danger, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Important Notice',
                  style: UTextStyles.bodyMediumBold.copyWith(
                    color: _T.danger,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Redemption proceeds will be credited to your primary bank account within 3 working days. Please ensure your bank details are active to avoid failures.',
                  style: UTextStyles.bodyMedium.copyWith(
                    color: const Color(0xFF991B1B),
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Proceed button ────────────────────────────────────────────────────────────
  Widget _buildProceedButton(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + bottomPad),
      // color: _T.bg,
      child: Obx(() {
        final loading = _mfu.isSubmittingTxn.value;
        return GestureDetector(
          onTap: loading ? null : _onProceed,
          child: Container(
            width: double.infinity,
            height: 54,
            decoration: BoxDecoration(
              // gradient: loading ? null : Ucolors.backgroundGradient,
              color: loading ? null : Ucolors.primary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Ucolors.primary,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Text(
                      'Proceed to Redeem',
                      style: UTextStyles.bodyLargeBold.copyWith(
                        color: Colors.white,
                        letterSpacing: -0.2,
                      ),
                    ),
            ),
          ),
        );
      }),
    );
  }

  String _fmtVal(double v) {
    if (v >= 100000) return '${(v / 100000).toStringAsFixed(2)}L';
    final s = v.toStringAsFixed(3);
    return s.replaceAll(RegExp(r'\.?0+$'), '');
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable Widgets (Updated Typography)
// ─────────────────────────────────────────────────────────────────────────────

class _WhiteCard extends StatelessWidget {
  final Widget child;
  const _WhiteCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _T.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ValueBox extends StatelessWidget {
  final String label;
  final double value, units;
  final Color color;
  final bool showInfo;
  const _ValueBox({
    required this.label,
    required this.value,
    required this.units,
    required this.color,
    this.showInfo = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _T.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _T.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: UTextStyles.bodyMediumW500.copyWith(
                  color: _T.textSec,
                  fontSize: 11,
                ),
              ),
              if (showInfo) ...[
                const SizedBox(width: 4),
                const Icon(
                  Icons.info_outline_rounded,
                  color: _T.textMuted,
                  size: 12,
                ),
              ],
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Text(
                '₹ ',
                style: UTextStyles.bodyMediumW500.copyWith(
                  color: color,
                  fontSize: 13,
                ),
              ),
              Text(
                _fmt(value),
                style: UTextStyles.bodyLargeBold.copyWith(color: color),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            '${units.toStringAsFixed(3)} Units',
            style: UTextStyles.bodyMediumW500.copyWith(
              color: _T.textSec,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  static String _fmt(double v) {
    final s = v.toStringAsFixed(3);
    return s.replaceAll(RegExp(r'\.?0+$'), '');
  }
}

class _RadioRow extends StatelessWidget {
  final String label;
  final bool selected;
  final Widget? trailing;
  final VoidCallback onTap;
  const _RadioRow({
    required this.label,
    required this.selected,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? _T.activeRowBg : _T.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? Ucolors.primary : _T.border,
            width: selected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? Ucolors.primary : _T.border,
                  width: selected ? 6 : 2,
                ),
                color: selected ? Colors.white : Colors.transparent,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: selected
                    ? UTextStyles.bodyLargeSemiBold.copyWith(
                        color: _T.textPrimary,
                        fontSize: 15,
                      )
                    : UTextStyles.bodyLargeW500.copyWith(
                        color: _T.textSec,
                        fontSize: 15,
                      ),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

class _AmountInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String prefix, hint;
  final String? suffix, error;

  const _AmountInput({
    required this.controller,
    required this.prefix,
    required this.hint,
    this.focusNode,
    this.suffix,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      focusNode: focusNode,
      hint: hint,
      errorText: error,
      height: 52,
      bgColor: _T.surface,
      borderColor: _T.border,
      focusedBorderColor: Ucolors.primary,
      borderRadius: 12,
      textSize: 20,
      textColor: _T.textPrimary,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
      leading: prefix.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(left: 14, right: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    prefix,
                    style: UTextStyles.bodyLarge.copyWith(
                      color: _T.textSec,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            )
          : null,
      trailing: suffix != null
          ? Padding(
              padding: const EdgeInsets.only(right: 14, left: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    suffix!,
                    style: UTextStyles.bodyMediumW500.copyWith(
                      color: _T.textSec,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
