import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';

// Ensure this imports your actual PersonalisationController
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
                              style: TextStyle(color: Ucolors.blue),
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
                              style: TextStyle(color: Colors.white),
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
                Obx(() {
                  // 1. Loading State
                  if (controller.isLinkedBankLoading.value) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  // 2. Empty State (User hasn't linked a bank yet)
                  if (controller.linkedBankAccount.value == null) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.account_balance_wallet,
                              size: 60,
                              color: Colors.grey,
                            ),
                            const Gap(16),
                            const Text(
                              "No bank accounts linked yet.\nPlease add an account.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                            const Gap(20),
                            if (!isDesktop) // Show button here for mobile
                              UElevatedBUtton(
                                onPressed: () =>
                                    Get.toNamed(AppRoutes.addanotherbank),
                                child: const Center(
                                  child: Text(
                                    'Add Bank Account',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }

                  // 3. Data State (Show the fetched bank account)
                  final bank = controller.linkedBankAccount.value;

                  // Adjust property access based on your Dart Entity
                  // e.g., bank.bankName OR bank['bank_name']
                  final String bankName = bank.bankName ?? 'Unknown Bank';
                  final String accNumber =
                      bank.accountNumberEncrypted ?? 'XXXX';
                  final String ifsc = bank.ifscCode ?? 'XXXX';
                  final int isVerified = bank.verified ?? 0;

                  // Simple logic to color-code based on bank name
                  final gradient = Ucolors.deepOceanGradient;

                  return BankCard(
                    bankName: bankName,
                    cardNumber: accNumber,
                    ifsccode: ifsc,
                    isVerified: isVerified == 1,
                    bankLogo: UImages.sbi,
                    color: gradient,
                  );
                }),

                if (!isDesktop) ...[
                  const Gap(30),
                  // Obx(() {
                  //   if (controller.linkedBankAccount.value != null) {
                  //     return Column(
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: [

                  //         UElevatedBUtton(
                  //           outlined: true,
                  //           onPressed: () {
                  //             // Get.find<MfuController>().createMandate(
                  //             //   mandateType: 'upi',

                  //             // );
                  //             Get.toNamed(AppRoutes.paymentScreen);
                  //           },
                  //           child: const Center(
                  //             child: Text(
                  //               'Set Up Auto Pay',
                  //               style: TextStyle(color: Ucolors.blue),
                  //             ),
                  //           ),
                  //         ),
                  //         const Gap(15),
                  //       ],
                  //     );
                  //   }
                  //   return const SizedBox.shrink();
                  // }),
                  Obx(() {
                    if (controller.hasApprovedMandate) {
                      return UElevatedBUtton(
                        outlined: true,
                        child: const Center(
                          child: Text(
                            '✅ Auto Pay Active',
                            style: TextStyle(
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
                            color: Ucolors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }),
                  // "Add Another" button
                  Obx(() {
                    if (controller.linkedBankAccount.value != null) {
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
}

// class BankCard extends StatelessWidget {
//   const BankCard({
//     super.key,
//     required this.bankName,
//     required this.cardNumber,
//     required this.bankLogo,
//     required this.color,
//     required this.ifsccode,
//     required this.isVerified,
//     this.onDelete,
//   });

//   final String bankName;
//   final String cardNumber;
//   final String bankLogo;
//   final Gradient color;
//   final String ifsccode;
//   final bool isVerified;
//   final VoidCallback? onDelete;

//   @override
//   Widget build(BuildContext context) {
//     // 🚀 FIX: AspectRatio guarantees the widget has a finite size, preventing layout crashes!
//     // 1.586 is the exact aspect ratio of a standard physical credit card.
//     return AspectRatio(
//       aspectRatio: 1.586,
//       child: Container(
//         width: double.infinity,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           gradient: color,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.15),
//               blurRadius: 15,
//               offset: const Offset(0, 8),
//             ),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(16),
//           child: Stack(
//             children: [
//               // --- WATERMARK RINGS ---
//               Positioned(
//                 right: -50,
//                 top: -50,
//                 child: Container(
//                   height: 180,
//                   width: 180,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.white.withOpacity(0.06),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 right: 40,
//                 bottom: -60,
//                 child: Container(
//                   height: 140,
//                   width: 140,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.white.withOpacity(0.04),
//                   ),
//                 ),
//               ),

//               // --- FOREGROUND CONTENT ---
//               Padding(
//                 padding: const EdgeInsets.all(24),
//                 child: Column(
//                   // 🚀 FIX: Instead of Spacer(), we use spaceBetween inside a bounded height!
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // TOP ROW: Logo & Name
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CircleAvatar(
//                           maxRadius: 20,
//                           backgroundColor: Colors.white,
//                           backgroundImage: AssetImage(bankLogo),
//                         ),
//                         const Gap(12),
//                         Expanded(
//                           child: Text(
//                             bankName,
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         if (onDelete != null)
//                           Deleteiconwithcontainer(delete: onDelete),
//                       ],
//                     ),

//                     // MIDDLE ROW: Verification Status
//                     Row(
//                       children: [
//                         Icon(
//                           isVerified ? Icons.verified : Icons.pending_actions,
//                           color: isVerified
//                               ? Colors.lightGreenAccent
//                               : Colors.orangeAccent,
//                           size: 18,
//                         ),
//                         const SizedBox(width: 6),
//                         Text(
//                           isVerified
//                               ? "Verified Primary"
//                               : "Pending Verification",
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),

//                     // BOTTOM ROW: Account Number & IFSC
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               "A/C Number",
//                               style: TextStyle(
//                                 color: Colors.white70,
//                                 fontSize: 10,
//                               ),
//                             ),
//                             Text(
//                               cardNumber,
//                               style: UTextStyles.subtitle2.copyWith(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w600,
//                                 letterSpacing: 1.5,
//                               ),
//                             ),
//                           ],
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             const Text(
//                               "IFSC",
//                               style: TextStyle(
//                                 color: Colors.white70,
//                                 fontSize: 10,
//                               ),
//                             ),
//                             Text(
//                               ifsccode,
//                               style: UTextStyles.subtitle2.copyWith(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

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
            color: Colors.black.withOpacity(0.1),
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
                      style: TextStyle(color: Colors.white70, fontSize: 10),
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
                      style: TextStyle(color: Colors.white70, fontSize: 10),
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
            color: containercolor ?? Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Iconsax.trash, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}
