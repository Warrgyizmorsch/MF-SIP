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
      backgroundColor: isDesktop ? const Color(0xFFF5F7FA) : Colors.white,
      appBar: isDesktop
          ? null
          : const CustomAppBarNormal(title: 'Bank Details'),
      body: SingleChildScrollView(
        padding: isDesktop
            ? const EdgeInsets.all(40)
            : UPadding.screenPadding.copyWith(
                bottom: kBottomNavigationBarHeight,
              ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
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
                          fontWeight: FontWeight.bold,
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
                            onPressed: () {},
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
                  const Gap(30),
                ] else ...[
                  const Gap(10),
                ],

                // 💳 SHOW LINKED BANK ACCOUNT
                // Obx(() {
                //   // 1. Loading State
                //   if (controller.isLinkedBankLoading.value) {
                //     return const Center(
                //       child: Padding(
                //         padding: EdgeInsets.all(40.0),
                //         child: CircularProgressIndicator(),
                //       ),
                //     );
                //   }

                //   // 2. Empty State (User hasn't linked a bank yet)
                //   if (controller.linkedBankAccounts.isEmpty) {
                //     return Center(
                //       child: Padding(
                //         padding: const EdgeInsets.all(40.0),
                //         child: Column(
                //           children: [
                //             const Icon(
                //               Icons.account_balance_wallet,
                //               size: 60,
                //               color: Colors.grey,
                //             ),
                //             const Gap(16),
                //             const Text(
                //               "No bank accounts linked yet.\nPlease add an account.",
                //               textAlign: TextAlign.center,
                //               style: TextStyle(
                //                 fontFamily: FontFamily.medium,
                //                 color: Colors.grey,
                //                 fontSize: 16,
                //               ),
                //             ),
                //             const Gap(20),
                //             if (!isDesktop) // Show button here for mobile
                //               UElevatedBUtton(
                //                 onPressed: () =>
                //                     Get.toNamed(AppRoutes.addanotherbank),
                //                 child: const Center(
                //                   child: Text(
                //                     'Add Bank Account',
                //                     style: TextStyle(
                //                       fontFamily: FontFamily.medium,
                //                       color: Colors.white,
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //           ],
                //         ),
                //       ),
                //     );
                //   }

                //   return ListView.separated(
                //     shrinkWrap: true, // Required inside SingleChildScrollView
                //     physics: const NeverScrollableScrollPhysics(),
                //     itemCount: controller.linkedBankAccounts.length,
                //     separatorBuilder: (context, index) =>
                //         const Gap(16), // Spacing between cards
                //     itemBuilder: (context, index) {
                //       final bank = controller.linkedBankAccounts[index];

                //       final String bankName = bank.bankName ?? 'Unknown Bank';
                //       final String accNumber =
                //           bank.accountNumberEncrypted ?? 'XXXX';
                //       final String ifsc = bank.ifscCode ?? 'XXXX';
                //       final int isVerified = bank.verified ?? 0;

                //       final gradient = Ucolors.deepOceanGradient;

                //       return BankCard(
                //         bankName: bankName,
                //         cardNumber: accNumber,
                //         ifsccode: ifsc,
                //         isVerified: isVerified == 1,
                //         bankLogo: UImages.sbi,
                //         color: gradient,
                //       );
                //     },
                //   );
                // }),
                // 💳 SHOW LINKED BANK ACCOUNTS
                Obx(() {
                  final bankCount = controller.linkedBankAccounts.length;
                  // if (controller.isLinkedBankLoading.value) {
                  //   return const Center(child: CircularProgressIndicator());
                  // }

                  return Column(
                    children: [
                      // 1. Render all current bank cards
                      ...controller.linkedBankAccounts.map(
                        (bank) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: BankCard(
                            onDelete: () {
                              // controller.deleteBank(bank.id ?? 0);
                              if (bank.id != null) {
                                // controller.deleteBank(bank.id!);
                                _confirmDelete(
                                  context,
                                  bank.id!,
                                  bank.bankName!,
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
                      ),

                      // 2. Conditionally show "Add Another" button (Only if < 3)
                      // if (bankCount < 3) ...[
                      const Gap(16),

                      UElevatedBUtton(
                        color: Ucolors.primary,
                        onPressed: () {
                          if (bankCount < 3) {
                            // Allow adding
                            controller.clearBankFields();
                            Get.toNamed(AppRoutes.addanotherbank);
                          } else {
                            // Show Modern Alert Dialog
                            // _showMaxBankLimitDialog(context);
                            ULoaders.warning(
                              title: 'Warning',
                              message:
                                  "You can only link a maximum of 3 bank accounts. Please delete an existing account to add a new one.",
                            );
                          }
                        },
                        child: Center(
                          child: Text(
                            // 'Add Another Bank Account',
                            bankCount < 3
                                ? 'Add Another Bank Account'
                                : 'Manage Bank Accounts',
                            style: TextStyle(
                              fontFamily: FontFamily.medium,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      // ],
                    ],
                  );
                }),

                if (!isDesktop) ...[
                  // const Gap(30),
                  Obx(() {
                    if (controller.hasApprovedMandate) {
                      return UElevatedBUtton(
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
                      );
                    }

                    if (controller.hasPendingMandate) {
                      return UElevatedBUtton(
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
                      );
                    }

                    return UElevatedBUtton(
                      outlined: true,
                      onPressed: () {
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
                    );
                  }),
                  // "Add Another" button
                  Obx(() {
                    if (controller.linkedBankAccounts.isEmpty) {
                      return UElevatedBUtton(
                        onPressed: () {
                          Get.find<PersonalisationController>()
                              .clearBankFields();
                          Get.toNamed(AppRoutes.addanotherbank);
                        },
                        outlined: true,
                        child: const Center(
                          child: Text(
                            'Update Bank Account',
                            style: TextStyle(
                              fontFamily: FontFamily.medium,
                              color: Ucolors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, int bankid, String bankName) {
    Get.defaultDialog(
      title: "Delete Bank",
      middleText: "Are you sure you want to delete $bankName?",
      textCancel: "Cancel",
      textConfirm: "Delete",
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back(); // Close dialog
        controller.deleteBank(bankid);
      },
    );
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
                      fontWeight: FontWeight.bold,
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
            const Text(
              "Limit Reached",
              style: TextStyle(fontFamily: FontFamily.bold, fontSize: 20),
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
