import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/personalization/domain/entity/profile_update_entity.dart';
import 'package:my_sip/features/personalization/presentation/controllers/personalisation_controller.dart';

/// Interactive modal to choose which bank to use for checkout
void showCheckoutBankSelectorModal(
  BuildContext context, {
  required bool isLumpsum,
}) {
  final personalisationController = Get.find<PersonalisationController>();

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const Gap(16),

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Investment Bank',
                      style: TextStyle(
                        fontFamily: FontFamily.medium,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Ucolors.dark,
                      ),
                    ),
                    const Gap(3),
                    Text(
                      isLumpsum
                          ? 'Choose a CAN-verified bank for lumpsum'
                          : 'Choose a bank with an active AutoPay mandate',
                      style: TextStyle(
                        fontFamily: FontFamily.medium,
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded, size: 22),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const Gap(16),
            const Divider(height: 1),
            const Gap(12),

            // Bank List
            Expanded(
              child: Obx(() {
                final banks =
                    personalisationController.linkedBankAccounts.isNotEmpty
                    ? personalisationController.linkedBankAccounts
                    : (personalisationController.userData.value?.bankAccounts ??
                          <BankAccountEntity>[]);

                if (banks.isEmpty) {
                  return const Center(
                    child: Text(
                      'No bank accounts linked.',
                      style: TextStyle(
                        fontFamily: FontFamily.medium,
                        color: Colors.grey,
                      ),
                    ),
                  );
                }

                final selectedBank =
                    personalisationController.activeCheckoutBank;

                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: banks.length,
                  separatorBuilder: (_, __) => const Gap(12),
                  itemBuilder: (context, index) {
                    final bank = banks[index];
                    final isSelected =
                        selectedBank != null && selectedBank.id == bank.id;

                    final bool isEligible = isLumpsum
                        ? (bank.canInvestLumpsum ??
                              bank.isCanVerified ??
                              bank.isFullyApproved)
                        : (bank.canInvestSip ??
                              bank.hasActiveMandate ??
                              (bank.approvedMandates?.isNotEmpty ?? false));

                    return InkWell(
                      onTap: () {
                        personalisationController.selectCheckoutBank(bank);
                        Navigator.of(context).pop();
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Ucolors.primary.withValues(alpha: 0.05)
                              : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? Ucolors.primary
                                : Colors.grey.shade200,
                            width: isSelected ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Bank Icon
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Ucolors.primary.withValues(alpha: 0.12)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: const Icon(
                                Icons.account_balance_rounded,
                                color: Ucolors.primary,
                                size: 22,
                              ),
                            ),
                            const Gap(12),

                            // Bank Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          bank.bankName ?? 'Bank Account',
                                          style: const TextStyle(
                                            fontFamily: FontFamily.medium,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Ucolors.dark,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (isSelected)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 7,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Ucolors.primary,
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: const Text(
                                            'Selected',
                                            style: TextStyle(
                                              fontFamily: FontFamily.medium,
                                              fontSize: 10,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const Gap(3),
                                  Text(
                                    '${bank.accountType ?? "Savings"} • ${bank.maskedAccountNumber}',
                                    style: TextStyle(
                                      fontFamily: FontFamily.medium,
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  if (bank.ifscCode != null &&
                                      bank.ifscCode!.isNotEmpty) ...[
                                    const Gap(2),
                                    Text(
                                      'IFSC: ${bank.ifscCode}',
                                      style: TextStyle(
                                        fontFamily: FontFamily.medium,
                                        fontSize: 11,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                  const Gap(8),

                                  // Status badges
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 4,
                                    children: [
                                      if (isLumpsum)
                                        _buildEligibilityChip(
                                          label:
                                              (bank.canInvestLumpsum == true ||
                                                  bank.isCanVerified == true ||
                                                  bank.isFullyApproved)
                                              ? 'CAN Verified ✓'
                                              : 'CAN Pending',
                                          isSuccess:
                                              (bank.canInvestLumpsum == true ||
                                              bank.isCanVerified == true ||
                                              bank.isFullyApproved),
                                        )
                                      else
                                        _buildEligibilityChip(
                                          label:
                                              (bank.canInvestSip == true ||
                                                  bank.hasActiveMandate ==
                                                      true ||
                                                  (bank
                                                          .approvedMandates
                                                          ?.isNotEmpty ??
                                                      false))
                                              ? 'AutoPay Active ✓'
                                              : 'No Active Mandate',
                                          isSuccess:
                                              (bank.canInvestSip == true ||
                                              bank.hasActiveMandate == true ||
                                              (bank
                                                      .approvedMandates
                                                      ?.isNotEmpty ??
                                                  false)),
                                        ),
                                    ],
                                  ),

                                  if (!isEligible) ...[
                                    const Gap(6),
                                    Text(
                                      isLumpsum
                                          ? '⚠️ Not verified on MFU CAN yet'
                                          : '⚠️ AutoPay mandate setup required for SIP',
                                      style: TextStyle(
                                        fontFamily: FontFamily.medium,
                                        fontSize: 11,
                                        color: Colors.orange.shade800,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildEligibilityChip({required String label, required bool isSuccess}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: isSuccess
          ? const Color(0xFF10B981).withValues(alpha: 0.1)
          : Colors.orange.shade50,
      borderRadius: BorderRadius.circular(6),
      border: Border.all(
        color: isSuccess
            ? const Color(0xFF10B981).withValues(alpha: 0.4)
            : Colors.orange.shade200,
      ),
    ),
    child: Text(
      label,
      style: TextStyle(
        fontFamily: FontFamily.medium,
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: isSuccess ? const Color(0xFF047857) : Colors.orange.shade800,
      ),
    ),
  );
}

/// Standalone Bank Selection Card for Web & Desktop checkout summary
class CheckoutBankCard extends StatelessWidget {
  const CheckoutBankCard({super.key, required this.isLumpsum});

  final bool isLumpsum;

  @override
  Widget build(BuildContext context) {
    final personalisationCtrl = Get.find<PersonalisationController>();

    return Obx(() {
      final banks = personalisationCtrl.linkedBankAccounts.isNotEmpty
          ? personalisationCtrl.linkedBankAccounts
          : (personalisationCtrl.userData.value?.bankAccounts ??
                <BankAccountEntity>[]);

      final bank =
          personalisationCtrl.activeCheckoutBank ??
          (banks.isNotEmpty ? banks.first : null);

      final hasMultipleBanks = banks.length > 1;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Ucolors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.account_balance_rounded,
                size: 20,
                color: Ucolors.primary,
              ),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          bank?.bankName ?? 'Select Bank Account',
                          style: const TextStyle(
                            fontFamily: FontFamily.medium,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Ucolors.dark,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (hasMultipleBanks)
                        InkWell(
                          onTap: () => showCheckoutBankSelectorModal(
                            context,
                            isLumpsum: isLumpsum,
                          ),
                          borderRadius: BorderRadius.circular(6),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            child: Text(
                              'Change',
                              style: TextStyle(
                                fontFamily: FontFamily.medium,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Ucolors.primary,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const Gap(2),
                  Text(
                    bank != null
                        ? '${bank.accountType ?? "Savings"} • ${bank.maskedAccountNumber}'
                        : 'No bank linked',
                    style: TextStyle(
                      fontFamily: FontFamily.medium,
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  if (bank != null) ...[
                    const Gap(6),
                    _buildEligibilityChip(
                      label: isLumpsum
                          ? ((bank.canInvestLumpsum == true ||
                                    bank.isCanVerified == true ||
                                    bank.isFullyApproved)
                                ? 'CAN Verified ✓'
                                : 'CAN Pending')
                          : ((bank.canInvestSip == true ||
                                    bank.hasActiveMandate == true ||
                                    (bank.approvedMandates?.isNotEmpty ??
                                        false))
                                ? 'AutoPay Active ✓'
                                : 'No Active Mandate'),
                      isSuccess: isLumpsum
                          ? (bank.canInvestLumpsum == true ||
                                bank.isCanVerified == true ||
                                bank.isFullyApproved)
                          : (bank.canInvestSip == true ||
                                bank.hasActiveMandate == true ||
                                (bank.approvedMandates?.isNotEmpty ?? false)),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
