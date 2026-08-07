import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/animated/dialog_button.dart';
import 'package:my_sip/common/widget/animated/popups.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';

import 'package:my_sip/features/personalization/presentation/controllers/personalisation_controller.dart';

class BankDetailsScreen extends GetView<PersonalisationController> {
  const BankDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: isDesktop
          ? null
          : const CustomAppBarNormal(title: 'Bank Details'),
      body: SingleChildScrollView(
        padding: isDesktop
            ? const EdgeInsets.all(0)
            : UPadding.screenPadding.copyWith(
                bottom: kBottomNavigationBarHeight,
              ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isDesktop) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Linked Accounts",
                    style: TextStyle(
                      fontFamily: FontFamily.medium,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () =>
                            Get.toNamed(AppRoutes.addanotherbank, id: 1),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          side: const BorderSide(color: Ucolors.blue),
                        ),
                        child: const Text(
                          'Add Another Account',
                          style: TextStyle(
                            fontFamily: FontFamily.medium,
                            color: Ucolors.blue,
                          ),
                        ),
                      ),
                      const Gap(16),
                      ElevatedButton(
                        onPressed: () {
                          final canNumber =
                              controller.session.getUserData?.canNumber ?? '';
                          final canStatus =
                              (controller.session.getUserData?.canStatus ?? '')
                                  .trim()
                                  .toLowerCase();

                          if (canNumber.isEmpty || canStatus == 'pending') {
                            ULoaders.warning(
                              title: "Account Activation Pending",
                              message:
                                  "Your investment account is currently being set up by MF Utility. Auto Pay setup will unlock as soon as account activation completes.",
                            );
                            return;
                          }

                          Get.toNamed(
                            AppRoutes.paymentScreen,
                            arguments: {'isMandate': true, 'amount': '100000'},
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Ucolors.blue,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                        ),
                        child: const Text(
                          'Set Up Auto Pay',
                          style: TextStyle(
                            fontFamily: FontFamily.medium,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Gap(10),
            ] else ...[
              const Gap(10),
            ],
            // 💳 SHOW LINKED BANK ACCOUNTS
            Obx(() {
              final bankCount = controller.linkedBankAccounts.length;

              // 1. Loading State
              // if (controller.isLinkedBankLoading.value) {
              //   return const Center(
              //     child: Padding(
              //       padding: EdgeInsets.all(40.0),
              //       child: CircularProgressIndicator(),
              //     ),
              //   );
              // }

              // 2. EMPTY STATE (No Bank Accounts)
              if (bankCount == 0) {
                return _buildEmptyState(isDesktop, context);
              }

              // 3. DATA STATE (1, 2, or 3 Banks Exist)
              return Column(
                children: [
                  // Render all current bank cards
                  ...controller.linkedBankAccounts
                      .where((bank) => bank != null)
                      .map(
                        (bank) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: BankCard(
                            onDelete: () {
                              if (bank.id != null) {
                                _confirmDelete(
                                  context,
                                  bank.id!,
                                  bank.bankName ?? 'Unknown',
                                );
                              } else {
                                Get.snackbar("Error", "Bank ID not found");
                              }
                            },
                            bankName: bank.bankName ?? 'Unknown',
                            cardNumber: bank.accountNumberEncrypted ?? '****',
                            ifsccode: bank.ifscCode ?? '',
                            isVerified: bank.verified == 1,
                            bankLogo: UImages.sbi,
                            color: Ucolors.deepOceanGradient,
                          ),
                        ),
                      )
                      .toList(),

                  const Gap(16),

                  // Show "Add Another" or "Manage" button
                  if (!isDesktop)
                    UElevatedBUtton(
                      color: Ucolors.primary,
                      onPressed: () {
                        if (bankCount < 3) {
                          // Allow adding another
                          controller.clearBankFields();
                          Get.toNamed(AppRoutes.addanotherbank);
                        } else {
                          // Limit Reached Warning
                          ULoaders.warning(
                            title: 'Limit Reached',
                            message:
                                "You can only link a maximum of 3 bank accounts. Please delete an existing account to add a new one.",
                          );
                        }
                      },
                      child: Center(
                        child: Text(
                          bankCount < 3
                              ? 'Add Another Account'
                              : 'Manage Bank Accounts',
                          style: const TextStyle(
                            fontFamily: FontFamily.medium,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }),

            // ⚙️ AUTO PAY SECTION (Only visible on Mobile AND when a Bank exists)
            if (!isDesktop) ...[
              Obx(() {
                // HIDE EVERYTHING BELOW IF NO BANK ACCOUNTS
                if (controller.linkedBankAccounts.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Column(
                  children: [
                    const Gap(10),
                    if (!controller.hasApprovedMandate)
                      UElevatedBUtton(
                        outlined: true,
                        child: const Center(
                          child: Text(
                            '✅ Auto Pay Active',
                            style: TextStyle(
                              fontFamily: FontFamily.medium,
                              color: Color(0xFF10B981),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    else if (controller.hasPendingMandate)
                      UElevatedBUtton(
                        child: const Center(
                          child: Text(
                            '⏳ Auto Pay Pending Approval',
                            style: TextStyle(
                              fontFamily: FontFamily.medium,
                              color: Color(0xFFE5941A),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    else
                      UElevatedBUtton(
                        outlined: true,
                        onPressed: () {
                          final canNumber =
                              controller.session.getUserData?.canNumber ?? '';
                          final canStatus =
                              (controller.session.getUserData?.canStatus ?? '')
                                  .trim()
                                  .toLowerCase();

                          if (canNumber.isEmpty || canStatus == 'pending') {
                            ULoaders.warning(
                              title: "Account Activation Pending",
                              message:
                                  "Your investment account is currently being set up by MF Utility. Auto Pay setup will unlock as soon as account activation completes.",
                            );
                            return;
                          }

                          Get.toNamed(
                            AppRoutes.paymentScreen,
                            arguments: {'isMandate': true, 'amount': '100000'},
                          );
                        },
                        child: const Center(
                          child: Text(
                            'Set Up Auto Pay',
                            style: TextStyle(
                              fontFamily: FontFamily.medium,
                              color: Ucolors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              }),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDesktop, BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: const BoxDecoration(
              color: Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            child: Icon(Iconsax.bank, size: 40, color: Colors.grey.shade400),
          ),

          const SizedBox(height: 24),

          const Text(
            "No Bank Accounts Linked",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),

          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "Please link a bank account to enable mutual fund purchases and automatic SIP setups.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ),

          const SizedBox(height: 28),

          ElevatedButton(
            onPressed: () {
              controller.clearBankFields();
              Get.toNamed(AppRoutes.addanotherbank, id: isDesktop ? 1 : null);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Ucolors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Link Bank Account",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, int bankid, String bankName) {
    DialogHelper.showPrerequisiteDialog(
      title: 'Delete Bank',
      message: 'Are you sure you want to delete $bankName?',
      buttonText: 'Delete',
      onTap: () {
        Get.back(); // Close dialog
        controller.deleteBank(bankid);
      },
    );

    // Get.defaultDialog(
    //   title: "Delete Bank",
    //   middleText: "Are you sure you want to delete $bankName?",
    //   textCancel: "Cancel",
    //   textConfirm: "Delete",
    //   confirmTextColor: Colors.white,
    //   onConfirm: () {
    //     Get.back(); // Close dialog
    //     controller.deleteBank(bankid);
    //   },
    // );
  }
}

class BankCard extends StatelessWidget {
  const BankCard({
    super.key,
    required this.bankName,
    required this.cardNumber,
    required this.bankLogo,
    required this.color,
    required this.ifsccode,
    required this.isVerified,
    this.onDelete,
  });

  final String bankName;
  final String cardNumber;
  final String bankLogo;
  final Gradient color;
  final String ifsccode;
  final bool isVerified;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: color,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Logo, Name, and Delete
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  maxRadius: 20,
                  backgroundColor: Colors.white,

                  // backgroundImage: AssetImage(bankLogo),
                  child: Icon(Iconsax.bank),
                ),
                const Gap(12),
                Expanded(
                  child: Text(
                    bankName,
                    style: const TextStyle(
                      fontFamily: FontFamily.medium,
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (onDelete != null) Deleteiconwithcontainer(delete: onDelete),
              ],
            ),

            const SizedBox(height: 12),

            // Primary / Verified Status
            Row(
              children: [
                Icon(
                  isVerified ? Icons.verified : Icons.pending_actions,
                  color: isVerified
                      ? Colors.lightGreenAccent
                      : Colors.orangeAccent,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  isVerified ? "Verified Primary" : "Pending Verification",
                  style: const TextStyle(
                    fontFamily: FontFamily.medium,
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Account Number & IFSC
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "A/C Number",
                      style: TextStyle(
                        fontFamily: FontFamily.medium,
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      cardNumber,
                      style: UTextStyles.subtitle2.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "IFSC",
                      style: TextStyle(
                        fontFamily: FontFamily.medium,
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      ifsccode,
                      style: UTextStyles.subtitle2.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Deleteiconwithcontainer extends StatelessWidget {
  const Deleteiconwithcontainer({super.key, this.containercolor, this.delete});

  final Color? containercolor;
  final VoidCallback? delete;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: delete,
        child: Container(
          height: 36,
          width: 36,
          decoration: BoxDecoration(
            color: containercolor ?? Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Iconsax.trash, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}

void _showMaxBankLimitDialog(BuildContext context) {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Iconsax.danger, color: Colors.orange, size: 50),
            const Gap(16),
            Text(
              "Limit Reached",
              style: TextStyle(fontFamily: FontFamily.regular, fontSize: 20),
            ),
            const Gap(12),
            const Text(
              "You can only link a maximum of 3 bank accounts. Please delete an existing account to add a new one.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
            ),
            const Gap(24),
            SizedBox(
              width: double.infinity,
              child: UElevatedBUtton(
                color: Ucolors.primary,
                onPressed: () => Get.back(),

                child: Center(
                  child: Text(
                    "Got it",
                    style: UTextStyles.bodySmall.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
