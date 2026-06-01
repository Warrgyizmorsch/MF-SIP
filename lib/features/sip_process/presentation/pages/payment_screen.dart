// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:my_sip/common/widget/animated/custom_footer.dart';
import 'package:my_sip/common/widget/animated/custom_toast.dart';
import 'package:my_sip/common/widget/animated/popups.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/features/cart/presentation/controllers/cart_controller.dart'
    hide showCustomToast;
import 'package:my_sip/features/mfu/data/model/mfu_mandate_create_req.dart';
import 'package:my_sip/features/mfu/presentation/controller/mfu_controller.dart';
import 'package:my_sip/features/personalization/presentation/controllers/personalisation_controller.dart';
import 'package:my_sip/services/session_manager.dart';

import '../../../../core/utils/constant/text_style.dart';

class PaymentScreen extends StatelessWidget {
  PaymentScreen({super.key});

  final CartController cartController = Get.find<CartController>();
  final PersonalisationController personalisationController =
      Get.find<PersonalisationController>();
  final MfuController paymentController = Get.find<MfuController>();

  final TextEditingController upiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arg = Get.arguments as Map<String, dynamic>?;
    final bool isMandateFlow = arg?['isMandate'] ?? false;
    final String amount =
        arg?['amount']?.toString() ?? cartController.totalAmount.toString();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      // backgroundColor: const Color(0xFFF6F7FB),
      appBar: _buildAppBar(context, isMandateFlow),

      body: SingleChildScrollView(
        // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24, // <-- FIX
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Section Label ────────────────────────────────
            const Text(
              'Choose Payment Method',
              style: TextStyle(fontFamily: FontFamily.medium,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF8A8FA8),
                letterSpacing: 0.6,
              ),
            ),
            const Gap(14),

            Obx(
              () => _MethodSelectorRow(
                selected: paymentController.selectedMethod.value,
                onSelect: paymentController.selectMethod,
              ),
            ),
            const Gap(20),

            Obx(() {
              final method = paymentController.selectedMethod.value;
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 280),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.06),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
                child: method == 'upi'
                    ? _UpiPanel(
                        key: const ValueKey('upi'),
                        controller: paymentController,
                        textController: upiController,
                        bankName:
                            personalisationController
                                .userData
                                .value
                                ?.bankAccount
                                ?.bankName ??
                            'Saved Bank',
                        maskedAccount:
                            personalisationController
                                .userData
                                .value
                                ?.bankAccount
                                ?.accountNumberEncrypted ??
                            '••••  ••••  1234',
                      )
                    : _NetBankingPanel(
                        key: const ValueKey('netbanking'),
                        bankName:
                            personalisationController
                                .userData
                                .value
                                ?.bankAccount
                                ?.bankName ??
                            'Saved Bank',
                        maskedAccount:
                            personalisationController
                                .userData
                                .value
                                ?.bankAccount
                                ?.accountNumberEncrypted ??
                            '••••  ••••  1234',
                      ),
              );
            }),

            const Gap(24),
          ],
        ),
      ),
      bottomNavigationBar: _BottomBar(
        amount: amount,
        isMandateFlow: isMandateFlow,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isMandateFlow) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: GestureDetector(
        onTap: () => Get.back(),
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha:0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 16,
            color: Color(0xFF1A1D2E),
          ),
        ),
      ),
      title: Text(
        isMandateFlow ? 'Setup Auto Pay' : 'Payment',
        style: TextStyle(fontFamily: FontFamily.medium,
          color: Color(0xFF1A1D2E),
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true,
    );
  }
}

class _MethodSelectorRow extends StatelessWidget {
  const _MethodSelectorRow({required this.selected, required this.onSelect});
  final String selected;
  final void Function(String) onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MethodTab(
            label: 'UPI',
            icon: Icons.qr_code_2_rounded,
            isSelected: selected == 'upi',
            onTap: () => onSelect('upi'),
          ),
        ),
        const Gap(12),
        Expanded(
          child: _MethodTab(
            label: 'Net Banking',
            icon: Icons.account_balance_rounded,
            isSelected: selected == 'netbanking',
            onTap: () => onSelect('netbanking'),
          ),
        ),
      ],
    );
  }
}

class _MethodTab extends StatelessWidget {
  const _MethodTab({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          // color: isSelected ? const Color(0xFF4F46E5) : Colors.white,
          gradient: isSelected ? Ucolors.backgroundGradient : null,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Ucolors.primary : const Color(0xFFE8EAF0),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF4F46E5).withValues(alpha:0.28),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha:0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 26,
              color: isSelected ? Colors.white : const Color(0xFF8A8FA8),
            ),
            const Gap(6),
            Text(
              label,
              style: TextStyle(fontFamily: FontFamily.medium,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF4A4E6A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// UPI Panel
// ─────────────────────────────────────────────────────────────
class _UpiPanel extends StatelessWidget {
  const _UpiPanel({
    super.key,
    required this.controller,
    required this.textController,
    required this.bankName,
    required this.maskedAccount,
  });

  final MfuController controller;
  final TextEditingController textController;
  final String bankName;
  final String maskedAccount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Saved Bank Account ──────────────────────────────
        _PanelCard(
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFF4F46E5).withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.credit_card_rounded,
                  color: Color(0xFF4F46E5),
                  size: 22,
                ),
              ),
              const Gap(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bankName,
                      style: const TextStyle(fontFamily: FontFamily.medium,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1D2E),
                      ),
                    ),
                    const Gap(2),
                    Text(
                      maskedAccount,
                      style: const TextStyle(fontFamily: FontFamily.medium,
                        fontSize: 13,
                        color: Color(0xFF8A8FA8),
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
                  color: const Color(0xFF10B981).withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Linked',
                  style: TextStyle(fontFamily: FontFamily.medium,
                    color: Color(0xFF10B981),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Gap(16),

        // ── Manual UPI Entry ────────────────────────────────
        _PanelCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Or enter UPI ID manually',
                style: TextStyle(fontFamily: FontFamily.medium,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A4E6A),
                ),
              ),
              const Gap(12),
              Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textController,
                        onChanged: (v) {
                          controller.upiId.value = v;
                          controller.isVerified.value = false;
                        },
                        style: const TextStyle(fontFamily: FontFamily.medium,
                          fontSize: 15,
                          color: Color(0xFF1A1D2E),
                        ),
                        decoration: InputDecoration(
                          hintText: 'yourname@upi',
                          hintStyle: const TextStyle(fontFamily: FontFamily.medium,
                            color: Color(0xFFBCC0D0),
                            fontSize: 14,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF6F7FB),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: controller.isVerified.value
                              ? const Icon(
                                  Icons.check_circle_rounded,
                                  color: Color(0xFF10B981),
                                )
                              : null,
                        ),
                      ),
                    ),
                    const Gap(10),
                    Obx(
                      () => GestureDetector(
                        onTap: controller.isVerifying.value
                            ? null
                            : controller.verifyUpi,
                        child: controller.isVerified.value
                            ? SizedBox.shrink()
                            : AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                height: 52,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                ),
                                decoration: BoxDecoration(
                                  color: controller.isVerified.value
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFF4F46E5),
                                  gradient: controller.isVerified.value
                                      ? Ucolors.modernFintechGradient
                                      : Ucolors.backgroundGradient,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: controller.isVerifying.value
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                          controller.isVerified.value
                                              ? 'Verified ✓'
                                              : 'Verify',
                                          style: const TextStyle(fontFamily: FontFamily.medium,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(4),
              const Text(
                'e.g. mobilenumber@upi, name@oksbi',
                style: TextStyle(fontFamily: FontFamily.medium,fontSize: 11, color: Color(0xFFBCC0D0)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NetBankingPanel extends StatelessWidget {
  const _NetBankingPanel({
    super.key,
    required this.bankName,
    required this.maskedAccount,
  });

  final String bankName;
  final String maskedAccount;

  @override
  Widget build(BuildContext context) {
    return _PanelCard(
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFF4F46E5).withValues(alpha:0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.account_balance_rounded,
              color: Color(0xFF4F46E5),
              size: 22,
            ),
          ),
          const Gap(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bankName,
                  style: const TextStyle(fontFamily: FontFamily.medium,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1D2E),
                  ),
                ),
                const Gap(2),
                Text(
                  maskedAccount,
                  style: const TextStyle(fontFamily: FontFamily.medium,
                    fontSize: 13,
                    color: Color(0xFF8A8FA8),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha:0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Linked',
              style: TextStyle(fontFamily: FontFamily.medium,
                color: Color(0xFF10B981),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PanelCard extends StatelessWidget {
  const _PanelCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.amount, required this.isMandateFlow});
  final String amount;
  final bool isMandateFlow;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.lock_rounded, size: 12, color: Color(0xFF8A8FA8)),
                Gap(4),
                Text(
                  'Payments are encrypted & secured',
                  style: TextStyle(fontFamily: FontFamily.medium,fontSize: 11, color: Color(0xFF8A8FA8)),
                ),
              ],
            ),
            const Gap(5),

            UElevatedBUtton(
              height: 54,
              onPressed: () {
                if (Get.find<MfuController>().upiId.isEmpty &&
                    Get.find<MfuController>().selectedMethod.value == 'upi') {
                  showCustomToast(
                    title: 'Enter UPI Id',
                    message: '',
                    backgroundColor: Colors.red,
                    icon: Icons.warning,
                  );
                  return;
                }
                // _showMandateSheet(context, amount);
                if (isMandateFlow) {
                  // Flow A: Open the Mandate Confirmation Sheet
                  _showMandateSheet(context, amount);
                } else {
                  // Flow B: Process Cart Payment directly
                  // Call your Cart Checkout or normalTransaction API here!
                  _processCartPayment();
                }
              },

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isMandateFlow ? 'Enable Auto Pay' : 'Pay  ',
                    style: TextStyle(fontFamily: FontFamily.medium,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  if (!isMandateFlow)
                    Text(
                      '₹$amount',
                      style: const TextStyle(fontFamily: FontFamily.medium,
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                ],
              ),
            ),

            CustomFooter(),
          ],
        ),
      ),
    );
  }

  void _processCartPayment() {
    // For example: controller.normalTransaction(request);
    CustomSnackbar.info(
      title: "Processing",
      message: "Initializing secure cart checkout...",
    );
  }
}

void _showMandateSheet(BuildContext context, String amount) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        // padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        padding: EdgeInsets.fromLTRB(
          24,
          0,
          24,
          MediaQuery.of(context).padding.bottom + 32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Gap(12),
            // Drag handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E5F0),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            const Gap(28),

            // Shield icon
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                gradient: Ucolors.backgroundGradient,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4F46E5).withValues(alpha:0.30),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.verified_user_rounded,
                color: Colors.white,
                size: 34,
              ),
            ),
            const Gap(20),

            // Title & subtitle
            const Text(
              'Setup Bank Mandate',
              style: TextStyle(fontFamily: FontFamily.medium,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1D2E),
                letterSpacing: -0.3,
              ),
            ),
            const Gap(8),
            const Text(
              'Authorise a one-time mandate to enable\nautomatic payments from your bank account.',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: FontFamily.medium,
                fontSize: 13,
                color: Color(0xFF8A8FA8),
                height: 1.55,
              ),
            ),
            const Gap(28),

            // Info rows
            _mandateRow(
              Icons.currency_rupee_rounded,
              'Mandate Amount',
              // '₹$amount',
              '₹100,000.00',
              // valueColor: const Color(0xFF4F46E5),
              valueColor: Ucolors.darkBlue,
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF0F2F8)),
            _mandateRow(
              Icons.repeat_rounded,
              'Frequency',
              'As & when presented',
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF0F2F8)),
            _mandateRow(
              Icons.account_balance_rounded,
              'Debit type',
              'Auto-debit (e-NACH)',
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF0F2F8)),
            _mandateRow(
              Icons.calendar_today_rounded,
              'Valid until',
              'Until cancelled',
            ),
            const Gap(24),

            // Warning notice
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8ED),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFFE0A3)),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: Color(0xFFE5941A),
                  ),
                  Gap(8),
                  Expanded(
                    child: Text(
                      'You can revoke this mandate anytime from your bank or app settings.',
                      style: TextStyle(fontFamily: FontFamily.medium,
                        fontSize: 12,
                        color: Color(0xFFB06A00),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(28),

            // Buttons
            Row(
              children: [
                // Close
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      height: 54,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F7FB),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E5F0)),
                      ),
                      child: const Center(
                        child: Text(
                          'Close',
                          style: TextStyle(fontFamily: FontFamily.medium,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4A4E6A),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Gap(12),

                // Auto Pay
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () async {
                      Get.back();
                      final controller = Get.find<MfuController>();
                      final method = controller.selectedMethod.value;
                      final uid =
                          Get.find<SessionManager>().getUserData?.id ?? 0;
                      final String? enteredUpi = method == 'upi'
                          ? controller.upiId.value.trim()
                          : null;
                      if (uid == 0) {
                        ULoaders.error(
                          title: "Error",
                          message: "User session not found.",
                        );
                        return;
                      }

                      if (method == 'upi') {
                        final String upiId = controller.upiId.value.trim();

                        await controller.createMandate(
                          MfuMandateCreateRequest.upi(
                            uid: 9105,
                            amount: 100000, // Use the amount from PaymentScreen
                            // vpaId: upiId,
                            vpaId: 'MFUYES14157AZA01@yesbankltd',
                            endDate:
                                "2036-05-24", // Adjust as per your requirement
                          ),
                        );
                      } else {
                        // eNACH
                        await controller.createMandate(
                          MfuMandateCreateRequest.enach(
                            uid: 9105,
                            amount: 100000,
                            startDate: DateTime.now().toString().split(
                              ' ',
                            )[0], // Dynamic Start Date
                            endDate: "2036-05-24",
                          ),
                        );
                      }

                      // controller.createMandate(
                      //   mandateType: method == 'upi' ? 'upi' : 'enach',
                      //   upiId: enteredUpi,
                      // );

                      // Get.find<MfuController>().createMandate(
                      //   mandateType: method == 'upi' ? 'upi' : 'enach',

                      // );
                    },
                    child: Container(
                      height: 54,
                      decoration: BoxDecoration(
                        gradient: Ucolors.backgroundGradient,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bolt_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                          Gap(6),
                          Text(
                            'Enable Auto Pay',
                            style: TextStyle(fontFamily: FontFamily.medium,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

// Helper — info row
Widget _mandateRow(
  IconData icon,
  String label,
  String value, {
  Color valueColor = const Color(0xFF1A1D2E),
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 13),
    child: Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            // color: const Color(0xFF4F46E5).withValues(alpha:0.08),
            color: Ucolors.skyblue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: Ucolors.darkBlue),
        ),
        const Gap(14),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontFamily: FontFamily.medium,
              fontSize: 13,
              color: Color(0xFF8A8FA8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(fontFamily: FontFamily.medium,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    ),
  );
}
