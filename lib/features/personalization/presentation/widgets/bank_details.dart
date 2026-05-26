// // import 'dart:developer';
// // import 'package:dartz/dartz.dart';
// // import 'package:flutter/material.dart';
// // import 'package:gap/gap.dart';
// // import 'package:get/get.dart';
// // import 'package:iconsax/iconsax.dart';
// // import 'package:my_sip/common/style/padding.dart';
// // import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
// // import 'package:my_sip/common/widget/button/elevated_button.dart';
// // import 'package:my_sip/config/routes/app_routes.dart';
// // import 'package:my_sip/features/personalization/presentation/pages/add_another_bank.dart';
// // import 'package:my_sip/core/utils/constant/colors.dart';
// // import 'package:my_sip/core/utils/constant/images.dart';
// // import 'package:my_sip/core/utils/constant/text_style.dart';

// // class BankDetailsScreen extends StatelessWidget {
// //   const BankDetailsScreen({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: CustomAppBarNormal(title: 'Bank Details'),
// //       body: Padding(
// //         padding: UPadding.screenPadding.copyWith(
// //           bottom: kBottomNavigationBarHeight,
// //         ),
// //         child: Column(
// //           children: [
// //             // SizedBox(height: kToolbarHeight - kTextTabBarHeight / 2),
// //             Gap(10),

// //             //Bank card
// //             BankCard(
// //               ifsccode: 'SBIN0031163',
// //               bankName: 'SBI',
// //               cardNumber: '00000036150491589',
// //               bankLogo: UImages.sbi,
// //               // color: Ucolors.icicibankGradient,
// //               color: Ucolors.backgroundGradient,
// //             ),
// //             SizedBox(height: 15),
// //             BankCard(
// //               ifsccode: 'ICIC0000004',
// //               bankName: 'ICICI',
// //               cardNumber: '000405007899',
// //               bankLogo: UImages.icici,
// //               color: Ucolors.icicibankGradient,
// //               // color: Ucolors.backgroundGradient,
// //             ),

// //             //Acoount Details
// //             // Card(
// //             //   elevation: 4,
// //             //   color: Ucolors.light,
// //             //   child: Padding(
// //             //     padding: const EdgeInsets.all(15.0),
// //             //     child: Column(
// //             //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             //       children: [
// //             //         bankinfo('Account', '4501560103'),
// //             //         bankinfo('IFSC Code', 'ICIC0000045'),
// //             //         // bankinfo('Branch Name', 'MADHUBAN, UDAIPUR'),
// //             //         // bankinfo('Account Type', 'Saving Account'),
// //             //       ],
// //             //     ),
// //             //   ),
// //             // ),
// //             SizedBox(height: 15),

// //             //Button
// //             UElevatedBUtton(
// //               outlined: true,
// //               child: Center(
// //                 child: Text(
// //                   'Set Up Auto Pay',
// //                   style: TextStyle(color: Ucolors.blue),
// //                 ),
// //               ),
// //             ),
// //             SizedBox(height: 15),

// //             //Button
// //             UElevatedBUtton(
// //               onPressed: () => Get.toNamed(AppRoutes.addanotherbank),
// //               outlined: true,
// //               child: Center(
// //                 child: Text(
// //                   'Add Another Account',
// //                   style: TextStyle(color: Ucolors.blue),
// //                 ),
// //               ),
// //             ),
// //             // Spacer(),

// //             //Button
// //             // UElevatedBUtton(
// //             //   // outlined: true,
// //             //   child: Center(
// //             //     child: Text('Continue', style: UTextStyles.buttonText),
// //             //   ),
// //             // ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget bankinfo(String title, String value) {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //       children: [
// //         Text(
// //           title,
// //           style: UTextStyles.subtitle2.copyWith(
// //             color: Ucolors.dark,
// //             fontWeight: FontWeight.w600,
// //             height: 2,
// //           ),
// //         ),
// //         Text(value, style: UTextStyles.caption),
// //       ],
// //     );
// //   }
// // }

// // class BankCard extends StatelessWidget {
// //   const BankCard({
// //     super.key,
// //     required this.bankName,
// //     required this.cardNumber,
// //     required this.bankLogo,
// //     required this.color,
// //     required this.ifsccode,
// //   });

// //   final String bankName;
// //   final String cardNumber;
// //   final String bankLogo;
// //   final Gradient color;
// //   final String ifsccode;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       width: MediaQuery.of(context).size.width,
// //       height: MediaQuery.of(context).size.height * 0.23,
// //       decoration: BoxDecoration(
// //         borderRadius: BorderRadius.circular(15),
// //         gradient: color,
// //       ),
// //       child: Padding(
// //         padding: const EdgeInsets.all(20),
// //         child: Stack(
// //           children: [
// //             // Top Right Delete Icon
// //             Positioned(top: 0, right: 0, child: Deleteiconwithcontainer()),

// //             Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 // Bank Name
// //                 Row(
// //                   children: [
// //                     CircleAvatar(
// //                       maxRadius: 18,
// //                       backgroundImage: AssetImage(bankLogo),
// //                       // child: Image.asset(UImages.sbi)
// //                     ),
// //                     Gap(6),
// //                     Text(
// //                       bankName,
// //                       style: TextStyle(
// //                         color: Colors.white,
// //                         fontSize: 22,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                   ],
// //                 ),

// //                 const SizedBox(height: 6),

// //                 // Primary Row
// //                 Row(
// //                   children: const [
// //                     Gap(8),
// //                     Icon(Icons.verified, color: Colors.lightGreen, size: 18),
// //                     SizedBox(width: 6),
// //                     Text(
// //                       "Primary",
// //                       style: TextStyle(
// //                         color: Colors.white,
// //                         fontSize: 14,
// //                         fontWeight: FontWeight.w600,
// //                       ),
// //                     ),
// //                   ],
// //                 ),

// //                 const Spacer(),

// //                 // Account Number
// //                 Row(
// //                   children: [
// //                     Text(
// //                       cardNumber,
// //                       style: UTextStyles.subtitle2.copyWith(
// //                         color: Ucolors.light,
// //                         fontWeight: FontWeight.w600,
// //                       ),
// //                     ),
// //                     Spacer(),
// //                     // Image.asset(bankLogo),
// //                     Text(
// //                       ifsccode,
// //                       style: UTextStyles.subtitle2.copyWith(
// //                         color: Ucolors.light,
// //                         fontWeight: FontWeight.w600,
// //                       ),
// //                     ),
// //                   ],
// //                 ),

// //                 const SizedBox(height: 12),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class Deleteiconwithcontainer extends StatelessWidget {
// //   const Deleteiconwithcontainer({super.key, this.containercolor, this.delete});

// //   final Color? containercolor;
// //   final VoidCallback? delete;
// //   @override
// //   Widget build(BuildContext context) {
// //     return InkWell(
// //       onTap: delete,
// //       child: Container(
// //         height: 40,
// //         width: 40,
// //         decoration: BoxDecoration(
// //           color: containercolor ?? Colors.white,
// //           // shape: BoxShape.circle,
// //           borderRadius: BorderRadius.circular(14),
// //         ),
// //         padding: const EdgeInsets.all(8),
// //         // child: IconButton( Icon(Iconsax.trash, color: Colors.deepOrange, size: 20),
// //         child: Icon(Iconsax.trash, color: Colors.deepOrange, size: 18),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:my_sip/common/style/padding.dart';
// import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
// import 'package:my_sip/common/widget/button/elevated_button.dart';
// import 'package:my_sip/config/routes/app_routes.dart';
// import 'package:my_sip/core/utils/constant/colors.dart';
// import 'package:my_sip/core/utils/constant/images.dart';
// import 'package:my_sip/core/utils/constant/text_style.dart';

// class BankDetailsScreen extends StatelessWidget {
//   const BankDetailsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // 🚀 Check if Desktop/Web or Mobile
//     final bool isDesktop = MediaQuery.of(context).size.width > 800;

//     return Scaffold(
//       backgroundColor: isDesktop ? const Color(0xFFF5F7FA) : Colors.white,
//       appBar: isDesktop ? null : CustomAppBarNormal(title: 'Bank Details'),
//       body: SingleChildScrollView(
//         padding: isDesktop
//             ? const EdgeInsets.all(40)
//             : UPadding.screenPadding.copyWith(
//                 bottom: kBottomNavigationBarHeight,
//               ),
//         child: Center(
//           child: ConstrainedBox(
//             constraints: const BoxConstraints(
//               maxWidth: 1000,
//             ), // Limit width for Web
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // 💻 WEB ONLY: Header & Buttons on top
//                 if (isDesktop) ...[
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         "Linked Accounts",
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Row(
//                         children: [
//                           OutlinedButton(
//                             onPressed: () =>
//                                 Get.toNamed(AppRoutes.addanotherbank, id: 1),
//                             style: OutlinedButton.styleFrom(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 24,
//                                 vertical: 16,
//                               ),
//                               side: const BorderSide(color: Ucolors.blue),
//                             ),
//                             child: const Text(
//                               'Add Another Account',
//                               style: TextStyle(color: Ucolors.blue),
//                             ),
//                           ),
//                           const Gap(16),
//                           ElevatedButton(
//                             onPressed: () {},
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Ucolors.blue,
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 24,
//                                 vertical: 16,
//                               ),
//                             ),
//                             child: const Text(
//                               'Set Up Auto Pay',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   const Gap(30),
//                 ] else ...[
//                   const Gap(10), // Mobile Top Padding
//                 ],

//                 // 💳 CARDS GRID
//                 GridView.count(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   crossAxisCount: isDesktop
//                       ? 2
//                       : 1, // Web par 2 cards per row, Mobile par 1
//                   childAspectRatio:
//                       1.7, // 🚀 FIX: Card jaisi feeling ke liye fixed ratio
//                   crossAxisSpacing: 24,
//                   mainAxisSpacing: 16,
//                   children: const [
//                     BankCard(
//                       ifsccode: 'SBIN0031163',
//                       bankName: 'SBI',
//                       cardNumber: '00000036150491589',
//                       bankLogo: UImages.sbi,
//                       color: Ucolors.backgroundGradient,
//                     ),
//                     BankCard(
//                       ifsccode: 'ICIC0000004',
//                       bankName: 'ICICI',
//                       cardNumber: '000405007899',
//                       bankLogo: UImages.icici,
//                       color: Ucolors.icicibankGradient,
//                     ),
//                   ],
//                 ),

//                 // 📱 MOBILE ONLY: Buttons at the bottom
//                 if (!isDesktop) ...[
//                   const Gap(30),
//                   UElevatedBUtton(
//                     outlined: true,
//                     onPressed: () {},
//                     child: const Center(
//                       child: Text(
//                         'Set Up Auto Pay',
//                         style: TextStyle(color: Ucolors.blue),
//                       ),
//                     ),
//                   ),
//                   const Gap(15),
//                   UElevatedBUtton(
//                     onPressed: () => Get.toNamed(AppRoutes.addanotherbank),
//                     outlined: true,
//                     child: const Center(
//                       child: Text(
//                         'Add Another Account',
//                         style: TextStyle(color: Ucolors.blue),
//                       ),
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class BankCard extends StatelessWidget {
//   const BankCard({
//     super.key,
//     required this.bankName,
//     required this.cardNumber,
//     required this.bankLogo,
//     required this.color,
//     required this.ifsccode,
//   });

//   final String bankName;
//   final String cardNumber;
//   final String bankLogo;
//   final Gradient color;
//   final String ifsccode;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // 🚀 FIX: Removed hardcoded media query height/width.
//       // AspectRatio in GridView handles this perfectly now.
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         gradient: color,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha:0.1),
//             blurRadius: 15,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(
//           24,
//         ), // Thoda padding badhaya premium feel ke liye
//         child: Stack(
//           children: [
//             // Top Right Delete Icon
//             Positioned(
//               top: 0,
//               right: 0,
//               child: Deleteiconwithcontainer(delete: () {}),
//             ),

//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Bank Name
//                 Row(
//                   children: [
//                     CircleAvatar(
//                       maxRadius: 20,
//                       backgroundColor: Colors.white,
//                       backgroundImage: AssetImage(bankLogo),
//                     ),
//                     const Gap(12),
//                     Text(
//                       bankName,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 12),

//                 // Primary Row
//                 Row(
//                   children: const [
//                     Icon(
//                       Icons.verified,
//                       color: Colors.lightGreenAccent,
//                       size: 18,
//                     ),
//                     SizedBox(width: 6),
//                     Text(
//                       "Primary",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),

//                 const Spacer(), // Pushes account details to the bottom
//                 // Account Number & IFSC
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           "A/C Number",
//                           style: TextStyle(color: Colors.white70, fontSize: 10),
//                         ),
//                         Text(
//                           cardNumber,
//                           style: UTextStyles.subtitle2.copyWith(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w600,
//                             letterSpacing:
//                                 2, // 🚀 FIX: Card numbers spacing makes it look real
//                           ),
//                         ),
//                       ],
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         const Text(
//                           "IFSC",
//                           style: TextStyle(color: Colors.white70, fontSize: 10),
//                         ),
//                         Text(
//                           ifsccode,
//                           style: UTextStyles.subtitle2.copyWith(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class Deleteiconwithcontainer extends StatelessWidget {
//   const Deleteiconwithcontainer({super.key, this.containercolor, this.delete});

//   final Color? containercolor;
//   final VoidCallback? delete;

//   @override
//   Widget build(BuildContext context) {
//     return MouseRegion(
//       // 🚀 FIX: Web cursor pointer for hover
//       cursor: SystemMouseCursors.click,
//       child: GestureDetector(
//         onTap: delete,
//         child: Container(
//           height: 36,
//           width: 36,
//           decoration: BoxDecoration(
//             color:
//                 containercolor ??
//                 Colors.white.withValues(alpha:
//                   0.2,
//                 ), // Transparent white looks better on gradients
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: const Icon(
//             Iconsax.trash,
//             color: Colors.white,
//             size: 18,
//           ), // Icon color white for premium look
//         ),
//       ),
//     );
//   }
// }
import 'dart:developer';

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
import 'package:my_sip/features/mfu/presentation/controller/mfu_controller.dart';

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
                  Obx(() {
                    if (controller.linkedBankAccount.value != null) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Get.find<MfuController>().isCreatingMandate.value
                              ? Center(child: CircularProgressIndicator())
                              : UElevatedBUtton(
                                  outlined: true,
                                  onPressed: () {
                                    // Get.find<MfuController>().createMandate(
                                    //   mandateType: 'upi',

                                    // );
                                    Get.toNamed(AppRoutes.paymentScreen);
                                  },
                                  child: const Center(
                                    child: Text(
                                      'Set Up Auto Pay',
                                      style: TextStyle(color: Ucolors.blue),
                                    ),
                                  ),
                                ),
                          const Gap(15),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
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
                            style: TextStyle(color: Ucolors.blue),
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
//               color: Colors.black.withValues(alpha:0.15),
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
//                     color: Colors.white.withValues(alpha:0.06),
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
//                     color: Colors.white.withValues(alpha:0.04),
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
            color: Colors.black.withValues(alpha:0.1),
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
            color: containercolor ?? Colors.white.withValues(alpha:0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Iconsax.trash, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}
