import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/widget/animated/empty_filled.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/common/widget/images/custom_cached_image.dart';
import 'package:my_sip/common/widget/text_form/text_field_component.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/core/utils/enums/enums.dart';
import 'package:my_sip/features/authentication/presentation/widgets/term_policy.dart';
import 'package:my_sip/features/cart/domain/entities/cart_response_entity.dart';
import 'package:my_sip/features/cart/presentation/controllers/cart_controller.dart';
import 'package:my_sip/features/fund_details/presentation/pages/fund_deatails.dart';
import 'package:my_sip/features/personalization/presentation/widgets/bank_details.dart';

// class CartPage extends GetView<CartController> {
//   const CartPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // log('${Get.arguments}');
//     final args = Get.arguments as Map<String, dynamic>?;
//     if (args != null && args['monthlyAmount'] != null) {
//       controller.monthlyAmount.value = int.parse(
//         args['monthlyAmount'].toString(),
//       );
//     }
//     // final monthly = args?['monthlyAmount'];
//     // final amount = args['totalAmount'] ?? '';
//     return Scaffold(
//       appBar: CustomAppBarNormal(title: 'Cart'),
//       body:
//           //  Obx(() {
//           //   final items = controller.cartResponseEntity.value?.items ?? [];
//           //   if ((controller.cartResponseEntity.value?.items.length ?? 0) < 1) {
//           //     return Center(child: Text('Add scheme to cart'));
//           //   }
//           //   // return ListView.builder(
//           //   //   padding: EdgeInsets.symmetric(vertical: 8),
//           //   //   itemBuilder: (context, index) =>
//           //   //       CartItemCard(item: controller.items[index], index: index),
//           //   //   itemCount: controller.itemsCount,
//           //   // );
//           //   if (controller.cartResponseEntity?.value?.items.isEmpty ?? true) {
//           //     return SizedBox.shrink();
//           //   }
//           //   return ListView.builder(
//           //     padding: EdgeInsets.symmetric(vertical: 8),
//           //     itemBuilder: (context, index) => CartItemCard(
//           //       index: index,
//           //       // itemEntity: controller.cartResponseEntity.value!.items[index],
//           //       itemEntity: items[index],
//           //     ),
//           //     itemCount: controller.cartResponseEntity.value?.items.length,
//           //   );
//           // }),
//           Obx(() {
//             // Use the filtered list from the controller
//             final items = controller.displayedItems;

//             // if (items.isEmpty) {
//             //   return Center(
//             //     child: Text(
//             //       "No funds for Goal ID: ${controller.filterGoalId.value}",
//             //     ),
//             //   );
//             if (items.isEmpty) {
//               return controller.filterGoalId.value != null
//                   ? Center(
//                       child: Text(
//                         controller.filterGoalId.value != null
//                             ? "No funds for this goal"
//                             : "No general funds in cart",
//                       ),
//                     )
//                   : Center(
//                       child: AnimatedEmptyState(
//                         title: "Your Cart is Empty",
//                         message:
//                             "Looks like you haven't added any funds yet. Go explore!",
//                         icon: Icons.shopping_cart_outlined,
//                       ),
//                     );

//               // return Center(
//               //   child: Column(
//               //     mainAxisAlignment: MainAxisAlignment.center,
//               //     children: [
//               //       Icon(
//               //         Icons.shopping_cart_outlined,
//               //         size: 64,
//               //         color: Colors.grey,
//               //       ),
//               //       SizedBox(height: 16),
//               //       Text(
//               //         controller.filterGoalId.value != null
//               //             ? 'No funds added for this specific goal'
//               //             : 'Add funds to cart',
//               //         style: TextStyle(color: Colors.grey.shade600),
//               //       ),
//               //     ],
//               //   ),
//               // );
//             }

//             return ListView.builder(
//               padding: EdgeInsets.symmetric(vertical: 8),
//               itemCount: items.length,
//               itemBuilder: (context, index) {
//                 return CartItemCard(
//                   index: index,
//                   itemEntity: items[index], // Binding to the filtered list
//                 );
//               },
//             );
//           }),
//       persistentFooterDecoration: BoxDecoration(),
//       persistentFooterButtons: [
//         TermAndPolicy(term: 'By Proceeding I accept the '),
//       ],

//       bottomNavigationBar: SafeArea(
//         top: false,
//         child: Obx(() {
//           final displayAmount = controller.totalAmount.toString();
//           return CartBottomBar(
//             isValid: controller.isCartValid1,
//             // goalAmount: controller.items.isEmpty
//             //     ? '/Monthly'
//             //     : controller.monthlyAmount.value == 0
//             //     ? '/Monthly'
//             //     : '/${controller.monthlyAmount.value.toString()}',
//             amount: displayAmount,

//             ontap: () {
//               // 1. RUN VALIDATION GUARD
//               if (!controller.isCartValid1) {
//                 // showCustomToast1(
//                 //   title: "Validation Error",
//                 //   message: "Please correct the amounts in your cart.",
//                 //   backgroundColor: Colors.red.shade700,
//                 //   icon: Icons.error_outline,
//                 // );
//                 return; // Stop here
//               }
//               Get.toNamed(
//                 AppRoutes.paymentScreen,
//                 arguments: {'amount': controller.totolAmount1},
//               );

//               // final totalPayable = controller.totalAmount;
//               // if (controller.monthlyAmount.value > totalPayable) {
//               //   showDialog(
//               //     context: context,
//               //     builder: (context) => AlertDialog(
//               //       title: Text(
//               //         'SIP amount is insufficient for this goal.\nPlease increase the amount or duration.',
//               //       ),
//               //       actions: [
//               //         TextButton(
//               //           onPressed: () => Navigator.pop(context),
//               //           child: Text('Back'),
//               //         ),
//               //       ],
//               //     ),
//               //   );

//               //   // Get.toNamed(AppRoutes.paymentScreen);
//               // } else if (controller.monthlyAmount.value ==
//               //     controller.totolAmount1) {
//               //   Get.toNamed(
//               //     AppRoutes.paymentScreen,
//               //     arguments: {'amount': controller.totolAmount1},
//               //   );
//               // } else if (controller.monthlyAmount.value <
//               //     controller.totolAmount1) {
//               //   log('Inscrease');
//               //   Get.toNamed(
//               //     AppRoutes.paymentScreen,
//               //     arguments: {'amount': controller.totolAmount1},
//               //   );
//               // }
//             },
//           );
//         }),
//       ),
//     );
//   }
// }

class CartPage extends GetView<CartController> {
  const CartPage({super.key});
  void _handlePurchase() {
    if (!controller.isCartValid1) return;
    final bool isDesktop = Get.width > 600;
    Get.toNamed(
      AppRoutes.paymentScreen,
      // arguments: {'amount': controller.totalAmount},
      id: isDesktop ? 1 : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['monthlyAmount'] != null) {
      controller.monthlyAmount.value = int.parse(
        args['monthlyAmount'].toString(),
      );
    }

    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: isDesktop ? const Color(0xFFF5F7FA) : Colors.white,
      appBar: isDesktop ? null : const CustomAppBarNormal(title: 'Cart'),

      persistentFooterDecoration: isDesktop ? null : const BoxDecoration(),
      persistentFooterButtons: isDesktop
          ? null
          : [const TermAndPolicy(term: 'By Proceeding I accept the ')],
      bottomNavigationBar: isDesktop
          ? null
          : SafeArea(
              top: false,
              child: Obx(() {
                return CartBottomBar(
                  isValid: controller.isCartValid1,
                  amount: controller.totalAmount.toString(),
                  ontap: _handlePurchase,
                );
              }),
            ),

      body: Obx(() {
        final items = controller.displayedItems;

        if (controller.isLoading.value && items.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        // --- EMPTY STATE ---
        if (items.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: controller.filterGoalId.value != null
                    ? const Text("No funds for this goal")
                    : const AnimatedEmptyState(
                        title: "Your Cart is Empty",
                        message:
                            "Looks like you haven't added any funds yet. Go explore!",
                        icon: Icons.shopping_cart_outlined,
                      ),
              ),

              InkWell(
                onTap: () {
                  Get.toNamed(AppRoutes.explorePage);
                },
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Explore more funds',
                      style: AppTextStyles.bodyMediumBold().copyWith(
                        color: Ucolors.primary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 18,
                      color: Ucolors.primary,
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        // --- DESKTOP / WEB LAYOUT ---
        if (isDesktop) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 1100,
              ), // Max width for clean look
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 16,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 6,
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return CartItemCard(
                            index: index,
                            itemEntity: items[index],
                          );
                        },
                      ),
                    ),
                    const Gap(24),
                    // 40% Right Side: Order Summary Card
                    Expanded(flex: 4, child: _buildWebOrderSummary()),
                  ],
                ),
              ),
            ),
          );
        }

        // --- MOBILE LAYOUT ---
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return CartItemCard(index: index, itemEntity: items[index]);
          },
        );
      }),
    );
  }

  // =========================================
  // 💻 WEB ORDER SUMMARY WIDGET
  // =========================================
  Widget _buildWebOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Ucolors.dark,
            ),
          ),
          const Gap(16),
          Divider(color: Colors.grey.shade200),
          const Gap(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount Payable',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              Obx(
                () => Text(
                  '₹ ${controller.totalAmount}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Ucolors.success,
                  ),
                ),
              ),
            ],
          ),
          const Gap(24),
          const TermAndPolicy(term: 'By Proceeding I accept the '),

          const Gap(24),

          Obx(() {
            final isValid = controller.isCartValid1;
            return UElevatedBUtton(
              color: isValid ? Ucolors.primary : Colors.grey,
              onPressed: isValid ? _handlePurchase : null,
              child: const Center(
                child: Text(
                  'Complete Purchase',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class CartBottomBar extends StatelessWidget {
  const CartBottomBar({
    super.key,
    this.title,
    this.buttonText,
    this.amountColor,
    required this.ontap,
    this.amount,
    this.goalAmount,
    this.isValid = true,
  });

  final String? title;
  final String? buttonText;
  final Color? amountColor;
  final VoidCallback ontap;
  final String? amount;
  final String? goalAmount;
  final bool isValid;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(color: Color(0xffE8F4FF)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 0,
                children: [
                  Text(
                    title ?? 'Amount Payable ',
                    style: UTextStyles.small.copyWith(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        amount ?? '₹ 5,000',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: amountColor ?? Ucolors.success,
                        ),
                      ),
                      Text(
                        goalAmount != null ? goalAmount! : '',
                        style: TextStyle(
                          fontSize: goalAmount != null ? 14 : 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child:
                  //  Obx(() {
                  //   final isValid = Get.find<CartController>().isCartValid1;
                  //   return
                  UElevatedBUtton(
                    // color: isValid ? null : Colors.grey,
                    color: isValid ? null : Colors.grey,
                    // height: 50,
                    // onPressed: ontap,
                    onPressed: isValid ? ontap : null,
                    // width: 50,
                    child: Center(
                      child: Text(
                        buttonText ?? 'Purchase',
                        style: UTextStyles.buttonText,
                      ),
                    ),
                  ),
              // }),
            ),
          ],
        ),
      ),
    );
  }
}

class CartItemCard extends StatelessWidget {
  const CartItemCard({
    super.key,
    required this.index,
    required this.itemEntity,
  });

  final int index;
  final CartItemEntity itemEntity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Ucolors.light,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FundHeader(index: index, itemEntity: itemEntity),
          SizedBox(height: 12),
          DashedLine(color: Color(0xffACACAC), dashSpace: 3.5),
          SizedBox(height: 12),
          InvestmentInputsRow(itemEntity: itemEntity),
        ],
      ),
    );
  }
}

class FundHeader extends StatelessWidget {
  FundHeader({super.key, required this.index, required this.itemEntity});
  final int index;
  final CartItemEntity itemEntity;

  final CartController controller = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipOval(
          child: CustomCachedImage(
            imageUrl: '${Appurl.baseUrl}${itemEntity.amcLogo}',
            radius: 16,
          ),
        ),
        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                itemEntity.schemeName ?? '',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 4),
              // RichText(
              //   text: TextSpan(
              //     children: [
              //       TextSpan(
              //         text: '● ',
              //         style: TextStyle(color: Ucolors.red, fontSize: 10),
              //       ),
              //       TextSpan(
              //         text: 'Very High Risk ',
              //         style: UTextStyles.small.copyWith(
              //           fontSize: 10,

              //           color: Color(0xff5B5B5B),
              //         ),
              //       ),
              //       const TextSpan(text: '  '),
              //       TextSpan(
              //         text: 'SIP Returns (3Y):',
              //         style: UTextStyles.small.copyWith(
              //           fontSize: 10,
              //           color: Color(0xff5B5B5B),
              //         ),
              //       ),
              //       TextSpan(
              //         text: '29.89%',
              //         style: UTextStyles.small.copyWith(
              //           color: Ucolors.success,
              //           fontSize: 10,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // Row(
              //   // mainAxisSize: MainAxisSize.min,
              //   children: [
              //     const Icon(Icons.circle, size: 6, color: Colors.red),
              //     const SizedBox(width: 3),
              //     Text(
              //       'Very High Risk',
              //       style: UTextStyles.small.copyWith(fontSize: 10),
              //     ),
              //     // const SizedBox(width: 12),
              //     Gap(5),
              //     Text(
              //       'SIP Returns (3Y):',
              //       style: UTextStyles.small.copyWith(fontSize: 10),
              //     ),
              //     const SizedBox(width: 4),
              //     Text(
              //       '29.89%',
              //       style: UTextStyles.small.copyWith(
              //         color: Ucolors.success,
              //         fontSize: 10,
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
        Obx(() {
          // Check if this specific item is the one being deleted
          bool isDeleting =
              controller.deletingItemId.value.toString() ==
              itemEntity.id.toString();
          return isDeleting
              ? Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(
                      12.0,
                    ), // Padding to make spinner small
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  ),
                )
              : Deleteiconwithcontainer(
                  containercolor: Colors.redAccent.shade200,
                  delete: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Are you sure ? '),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.maybePop(context),
                            child: const Text(
                              'No',
                              style: TextStyle(
                                fontSize: 14,
                                color: Ucolors.blue,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.maybePop(context);
                              controller.deleteCartItem(
                                itemEntity.id ?? 0,
                                itemEntity.schemeName ?? "",
                              );
                            },
                            child: const Text(
                              'Yes',
                              style: TextStyle(fontSize: 14, color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
        }),

        // Deleteiconwithcontainer(
        //   delete: () {
        //     showDialog(
        //       context: context,
        //       builder: (context) => AlertDialog(
        //         // backgroundColor: Ucolors.primary,
        //         title: Text('Are you sure ? '),
        //         actions: [
        //           TextButton(
        //             onPressed: () => Get.back(),
        //             child: Text(
        //               'No',
        //               style: TextStyle(fontSize: 14, color: Ucolors.blue),
        //             ),
        //           ),
        //           TextButton(
        //             onPressed: () {
        //               Navigator.of(context).pop();
        //               // Get.snackbar(
        //               //   margin: EdgeInsets.symmetric(
        //               //     vertical: 15,
        //               //     horizontal: 15,
        //               //   ),
        //               //   colorText: Ucolors.light,
        //               //   'Remove from cart',
        //               //   // item.fundName.toString(),
        //               //   itemEntity.schemeName ?? '',

        //               //   snackPosition: SnackPosition.BOTTOM,
        //               //   backgroundColor: Ucolors.red,
        //               // );

        //               // controller.removeItem(index);
        //               controller.deleteCartItem(
        //                 itemEntity.id ?? 0,
        //                 itemEntity.schemeName ?? "",
        //               );
        //             },
        //             child: Text(
        //               'Yes',
        //               style: TextStyle(fontSize: 14, color: Colors.red),
        //             ),
        //           ),
        //         ],
        //       ),
        //     );
        //   },
        //   // delete: () => controller.removeItem(index),
        //   containercolor: Colors.redAccent.withOpacity(0.1),
        // ),
      ],
    );
  }
}

class InvestmentInputsRow extends StatelessWidget {
  InvestmentInputsRow({super.key, required this.itemEntity});

  final CartItemEntity itemEntity;
  final controller = Get.find<CartController>();

  /// Helper to convert API strings like "1000.00" to int 1000
  int _parseAmount(String? value, {int defaultVal = 0}) {
    if (value == null || value.isEmpty) return defaultVal;
    return double.tryParse(value)?.toInt() ?? defaultVal;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // FIX: Accessing the controller variable here registers this Obx
      // with GetX so it rebuilds when fetchCart() is called in the controller.
      final cartResponse = controller.cartResponseEntity.value;

      final _ = controller.cartResponseEntity.value;

      // Extract local variables from the current state of the entity
      final currentType = itemEntity.transType?.toLowerCase() ?? 'sip';

      // Calculate Limits based on Type
      final int minSip = _parseAmount(itemEntity.minSipAmount);
      final int minLumpsum = _parseAmount(itemEntity.minLumpsum);
      // final int minStepup = _parseAmount(itemEntity.minSipAmount);

      final int currentMinLimit = (currentType == 'lumpsum')
          ? minLumpsum
          : minSip;

      // --- 3. DISPLAY AMOUNT LOGIC ---
      // If amount is 0 or invalid, force it to show the current minimum
      final currentAmount =
          (itemEntity.amount != null && itemEntity.amount! > 0)
          ? itemEntity.amount.toString()
          : currentMinLimit.toString();

      return Column(
        children: [
          Row(
            children: [
              /// 1. Investment Type Dropdown
              Expanded(
                flex: 3,
                child: _buildColumn(
                  'Inv. Type',
                  DropdownButton<String>(
                    dropdownColor: Colors.white,
                    isDense: true,
                    value: currentType,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(
                        value: 'sip',
                        child: Text('SIP', style: TextStyle(fontSize: 12)),
                      ),
                      DropdownMenuItem(
                        value: 'lumpsum',
                        child: Text('Lumpsum', style: TextStyle(fontSize: 12)),
                      ),
                      DropdownMenuItem(
                        value: 'stepup',
                        child: Text('Step Up', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null && val != currentType) {
                        // LOGIC: When Type changes, auto-switch Amount to new Minimum
                        int newDefaultAmount = minSip;
                        if (val == 'lumpsum') {
                          newDefaultAmount = minLumpsum;
                        }

                        int? newTopUp;
                        String? newFrequency; // Add this variable
                        if (val == 'stepup') {
                          // When switching to Step Up, init the Top-up field to 1000
                          newTopUp = _parseAmount(itemEntity.minTopupAmount);
                          newFrequency = '1';
                        }

                        controller.updateCartItem(
                          itemId: itemEntity.id!,
                          transType: val,
                          amount: newDefaultAmount,
                          // ✅ Updates UI & API instantly
                          topUpAmount: newTopUp,
                          frequency: newFrequency, // ✅ Pass frequency here
                        );
                      }
                    },
                  ),
                ),
              ),

              const SizedBox(width: 12),

              /// 2. SIP Date Dropdown (Visible for SIP/StepUp)
              if (currentType != 'lumpsum')
                Expanded(
                  flex: 2,
                  child: _buildColumn(
                    'SIP Date',
                    DropdownButton<String>(
                      menuMaxHeight: 300,
                      dropdownColor: Colors.white,
                      isDense: true,
                      value: (itemEntity.sipDay ?? 1).toString(),
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: List.generate(
                        28,
                        (i) => DropdownMenuItem(
                          value: '${i + 1}',
                          child: Text(
                            '${i + 1}',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      onChanged: (val) {
                        if (val != null) {
                          controller.updateCartItem(
                            itemId: itemEntity.id!,
                            sipDay: int.parse(val),
                          );
                        }
                      },
                    ),
                  ),
                ),

              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Inv Amount',
                      style: UTextStyles.small.copyWith(
                        color: Color(0xff5B5B5B),
                      ),
                    ),
                    const SizedBox(height: 6),
                    CustomTextField(
                      height: 55,

                      // IMPORTANT: ValueKey forces text refresh when new data returns from server
                      key: ValueKey('amt_${itemEntity.id}_$currentAmount'),
                      // hint: '500',
                      keyboardType: TextInputType.number,
                      controller: TextEditingController(
                        text: currentAmount,
                        // text: currentAmount == '1'
                        //     ? itemEntity.minSipAmount
                        //     : currentAmount,
                      ),
                      validationType: ValidationType.custom,
                      // onChanged: (value) {
                      //   final amount = int.tryParse(value) ?? 0;
                      //   bool hasError =
                      //       amount < currentMinLimit || amount % 100 != 0;
                      //   controller.setItemError(itemEntity.id!, hasError);
                      // },
                      onChanged: (value) {
                        controller.debouncedAmountUpdate(
                          itemId: itemEntity.id!,
                          value: value,
                          currentMinLimit: currentMinLimit,
                        );
                      },
                      customValidator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          // controller.setItemError(itemEntity.id!, true);
                          return 'Required';
                        }
                        final amount = int.tryParse(value) ?? 0;

                        // Check against the dynamic limit (SIP vs Lumpsum)
                        if (amount < currentMinLimit) {
                          // controller.setItemError(itemEntity.id!, true);
                          return 'Min ₹$currentMinLimit'; // Shows red text automatically
                        }
                        if (amount % 100 != 0) {
                          // controller.setItemError(itemEntity.id!, true);
                          return 'Multiple of ₹100';
                        }
                        // controller.setItemError(itemEntity.id!, false);
                        return null;
                      },

                      onSubmitted: (value) {
                        final newAmt = int.tryParse(value);
                        if (newAmt != null &&
                            newAmt >= currentMinLimit &&
                            newAmt % 100 == 0) {
                          controller.updateCartItem(
                            itemId: itemEntity.id!,
                            amount: newAmt,
                          );
                        }
                      },
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    // CustomTextField(
                    //   // onChanged: item.updateAmount,
                    //   keyboardType: TextInputType.number,
                    //   // controller: item.amountController,
                    //   validationType: ValidationType.custom,
                    //   customValidator: (value) {
                    //     if (value == null || value.trim().isEmpty) {
                    //       return 'Amount is required';
                    //     }

                    //     final amount = int.tryParse(value);
                    //     if (amount == null) {
                    //       return 'Enter a valid number';
                    //     }

                    //     if (amount <= 0) {
                    //       return 'Amount must be greater than 0';
                    //     }

                    //     if (amount < 500) {
                    //       return 'Minimum investment is ₹500';
                    //     }

                    //     return null; // ✅ valid
                    //   },
                    //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    //   height: 44,
                    //   borderRadius: 10,
                    // ),

                    // _box(
                    //   child:
                    //   TextField(
                    //     keyboardType: TextInputType.number,
                    //     controller: TextEditingController(
                    //       text: item.amount.value.toString(),
                    //     ),

                    //     decoration: InputDecoration(
                    //       // hintText: amount,
                    //       border: InputBorder.none,
                    //       isCollapsed: true,
                    //     ),
                    //     onChanged: (value) {
                    //       // amount = value;
                    //       item.amount.value = int.tryParse(value) ?? 0;
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              ),

              /// 3. Amount Field
              // Expanded(
              //   flex: 3,
              //   child:
              //   _buildColumn(

              //     'Inv Amount',
              //     CustomTextField(
              //       borderColor: Colors.transparent,
              //       focusedBorderColor: Colors.transparent,
              //       height: 44,

              //       // IMPORTANT: ValueKey forces text refresh when new data returns from server
              //       key: ValueKey('amt_${itemEntity.id}_$currentAmount'),
              //       // hint: '500',
              //       keyboardType: TextInputType.number,
              //       controller: TextEditingController(text: currentAmount),
              //       validationType: ValidationType.custom,
              //       customValidator: (value) {
              //         if (value == null || value.trim().isEmpty)
              //           return 'Required';
              //         final amount = int.tryParse(value);
              //         if (amount == null || amount < 500) return 'Min ₹500';
              //         return null;
              //       },

              //       onSubmitted: (value) {
              //         final newAmt = int.tryParse(value);
              //         if (newAmt != null && newAmt >= 500) {
              //           controller.updateCartItem(
              //             itemId: itemEntity.id!,
              //             amount: newAmt,
              //           );
              //         }
              //       },
              //       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              //     ),
              //   ),
              // ),
            ],
          ),

          /// 4. Step Up Section (Visible for StepUp)
          if (currentType == 'stepup') ...[
            const Gap(15),
            _buildStepUpSection(),
          ],
        ],
      );
    });
  }

  Widget _buildColumn(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: UTextStyles.small.copyWith(
            color: const Color(0xff5B5B5B),
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 6),
        _box(child: child),
      ],
    );
  }

  Widget _box({required Widget child}) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(11),
        color: Colors.white,
      ),
      child: child,
    );
  }

  Widget _buildStepUpSection() {
    final stepUpAmt =
        double.tryParse(
          itemEntity.topUpAmount?.toString() ?? '0',
        )?.toInt().toString() ??
        '0';

    final int minTopUp = _parseAmount(
      itemEntity.minTopupAmount,
      defaultVal: 500,
    );

    // final String currentTopUp = _parseAmount(
    //   itemEntity.topUpAmount,
    //   defaultVal: 0, // If null, show 0 or min topup
    // ).toString();

    final String currentTopUp =
        (itemEntity.topUpAmount != null &&
            itemEntity.topUpAmount != '0' &&
            itemEntity.topUpAmount != '')
        ? _parseAmount(itemEntity.topUpAmount).toString()
        : minTopUp.toString();
    debugPrint("frequency: ${itemEntity.frequency}");
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xffEAF5FF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildColumn(
              'Step up Frequency',
              DropdownButton<String>(
                value: itemEntity.frequency ?? '6',
                isExpanded: true,
                isDense: true,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(value: '1', child: Text('Monthly', style: TextStyle(fontSize: 12))),
                  DropdownMenuItem(value: '3', child: Text('Quarterly', style: TextStyle(fontSize: 12))),
                  DropdownMenuItem(value: '6', child: Text('6 Months', style: TextStyle(fontSize: 12))),
                  DropdownMenuItem(value: '12', child: Text('Yearly', style: TextStyle(fontSize: 12))),
                ],
                onChanged: (val) {
                  // if (val != null) {
                  controller.updateCartItem(
                    itemId: itemEntity.id!,
                    frequency: val,
                  );
                  // }
                },
              ),
            ),
          ),
          const Gap(20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Step Up Amount',
                  style: UTextStyles.small.copyWith(
                    color: const Color(0xff5B5B5B),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 6),
                // We REMOVE the _box() wrapper here because CustomTextField
                // provides its own border and background.
                CustomTextField(
                  bgColor: Colors.white,
                  height: 55, // Matches your other inputs
                  borderRadius: 11, // Matches your _box decoration
                  key: ValueKey('topup_${itemEntity.id}_$currentTopUp'),
                  controller: TextEditingController(text: currentTopUp),
                  keyboardType: TextInputType.number,
                  validationType: ValidationType.custom,
                  // Match your app's theme colors
                  borderColor: Colors.grey.shade300,

                  focusedBorderColor: Ucolors.primary,
                  onChanged: (value) {
                    final amt = int.tryParse(value) ?? 0;
                    bool hasError = amt < minTopUp || amt % 100 != 0;
                    controller.setItemError(-itemEntity.id!, hasError);
                  },
                  customValidator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Required';
                    }
                    final amt = int.tryParse(value) ?? 0;
                    if (amt < minTopUp) {
                      return 'Min ₹$minTopUp';
                    }
                    if (amt % 100 != 0) {
                      return 'Multiple of ₹100';
                    }

                    return null;
                  },

                  onSubmitted: (val) {
                    final amt = int.tryParse(val);
                    if (amt != null && amt >= minTopUp && amt % 100 == 0) {
                      controller.updateCartItem(
                        itemId: itemEntity.id!,
                        topUpAmount: amt,
                      );
                    }
                  },
                ),
              ],
            ),
          ),

          // Expanded(
          //   child: _buildColumn(
          //     'Step Up Amount',
          //     CustomTextField(
          //       borderRadius: 11, // Matches your _box decoration

          //       height: 44,
          //       borderColor: Colors.grey.shade300,
          //       key: ValueKey('topup_${itemEntity.id}_$currentTopUp'),
          //       controller: TextEditingController(text: currentTopUp),
          //       keyboardType: TextInputType.number,
          //       validationType: ValidationType.custom,
          //       customValidator: (value) {
          //         if (value == null || value.trim().isEmpty) return 'Required';
          //         final amt = int.tryParse(value) ?? 0;
          //         if (amt < minTopUp) return 'Min ₹$minTopUp';
          //         if (amt % minTopUp != 0) return 'Multiple of ₹$minTopUp';
          //         return null;
          //       },
          //       onSubmitted: (val) {
          //         final amt = int.tryParse(val);
          //         if (amt != null && amt >= minTopUp && amt % minTopUp == 0) {
          //           controller.updateCartItem(
          //             itemId: itemEntity.id!,
          //             topUpAmount: amt,
          //           );
          //         }
          //       },
          //     ),

          //     // TextField(
          //     //   key: ValueKey('topup_${itemEntity.id}_$currentTopUp'),
          //     //   // controller: TextEditingController(

          //     //   //   text: stepUpAmt,
          //     //   // ),
          //     //   // controller: TextEditingController(
          //     //   //   text: currentTopUp == '0'
          //     //   //       ? minTopUp.toString()
          //     //   //       : currentTopUp,
          //     //   // ),
          //     //   controller: TextEditingController(text: currentTopUp),
          //     //   keyboardType: TextInputType.number,
          //     //   decoration: const InputDecoration(
          //     //     border: InputBorder.none,
          //     //     isDense: true,
          //     //   ),

          //     //   onSubmitted: (val) {
          //     //     // final stepAmt = int.tryParse(val);
          //     //     // if (stepAmt != null) {
          //     //     //   controller.updateCartItem(
          //     //     //     itemId: itemEntity.id!,
          //     //     //     topUpAmount: stepAmt,
          //     //     //   );
          //     //     // }
          //     //     final amt = int.tryParse(val);

          //     //     // TOPUP VALIDATION
          //     //     if (amt != null
          //     //     // && amt >= minTopUp
          //     //     ) {
          //     //       controller.updateCartItem(
          //     //         itemId: itemEntity.id!,
          //     //         topUpAmount: amt,
          //     //       );
          //     //     }
          //     //   },
          //     // ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

/*
// class InvestmentInputsRow extends StatelessWidget {
//   InvestmentInputsRow({super.key, required this.itemEntity});

//   final CartItemEntity itemEntity;

//   final controller = Get.find<CartController>();

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final currentType = itemEntity.transType?.toLowerCase() ?? 'sip';
//       return Column(
//         children: [
//           Row(
//             children: [
//               /// Investment Type
//               Expanded(
//                 flex: 3,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Inv. Type',
//                       style: UTextStyles.small.copyWith(
//                         color: Color(0xff5B5B5B),
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     _box(
//                       child: DropdownButton<String>(
//                         dropdownColor: Colors.white,

//                         isDense: true,

//                         value: itemEntity.transType?.toLowerCase(),

//                         isExpanded: true,
//                         underline: const SizedBox(),
//                         items: const [
//                           DropdownMenuItem(value: 'sip', child: Text('SIP')),
//                           DropdownMenuItem(
//                             value: 'lumpsum',
//                             child: Text('Lumpsum'),
//                           ),
//                           DropdownMenuItem(
//                             value: 'stepup',
//                             child: Text('Step Up'),
//                           ),
//                         ],
//                         onChanged: (value) {
//                           // ite.invType.value = value!;
//                           // itemEntity.transType = value!;

//                           // if (value == 'lumpsum') {
//                           //   // item.amount.value = 25000;
//                           //   // itemEntity.amount = 1000;
//                           // } else if (value == 'sip') {
//                           //   // item.amount.value = 12330;
//                           // } else if (value == 'stepup') {
//                           //   // item.amount.value = 100000;
//                           //   // item.stepupFrequency.value = '6m'; // ✅ IMPORTANT
//                           // }

//                           if (value != null) {
//                             controller.updateCartItem(
//                               itemId: itemEntity.id!,
//                               transType: value,
//                               // Reset amount if switching to lumpsum if required
//                               amount: value == 'lumpsum' ? 5000 : 500,
//                             );
//                           }
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(width: 12),

//               // invType != 'lumpsum'
//               //     ?
//               // itemEntity.transType != 'lumpsum'
//               //     ?
//               if (currentType != 'lumpsum')
//                 /// SIP Date
//                 Expanded(
//                   flex: 2,
//                   // flex: ,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'SIP Date',
//                         style: UTextStyles.small.copyWith(
//                           color: Color(0xff5B5B5B),
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//                       _box(
//                         child: DropdownButton<String>(
//                           menuMaxHeight: 300,
//                           dropdownColor: Colors.white,

//                           isDense: true,
//                           // value: item.sipDate.value.toString(),
//                           // value: itemEntity.sipDay.toString(),
//                           // value:
//                           //     (itemEntity.sipDay != null &&
//                           //         itemEntity.sipDay! >= 1 &&
//                           //         itemEntity.sipDay! <= 28)
//                           //     ? itemEntity.sipDay.toString()
//                           //     : '1',
//                           value: (itemEntity.sipDay ?? 1).toString(),
//                           isExpanded: true,
//                           underline: const SizedBox(),
//                           items: List.generate(
//                             28,
//                             (i) => DropdownMenuItem(
//                               value: '${i + 1}',
//                               child: Text('${i + 1}'),
//                             ),
//                           ),
//                           onChanged: (value) {
//                             // item.invType.value = value!;
//                             // item.sipDate.value = int.parse(value!);

//                             // setState(() => sipDate = value!);
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//               const SizedBox(width: 12),

//               /// Amount
//               Expanded(
//                 flex: 3,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Inv Amount',
//                       style: UTextStyles.small.copyWith(
//                         color: Color(0xff5B5B5B),
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     CustomTextField(
//                       hint: itemEntity.amount?.toString() ?? '500',
//                       // onChanged: item.updateAmount,
//                       keyboardType: TextInputType.number,
//                       controller: TextEditingController(
//                         text: itemEntity.amount.toString(),
//                       ),
//                       validationType: ValidationType.custom,
//                       customValidator: (value) {
//                         if (value == null || value.trim().isEmpty) {
//                           return 'Amount is required';
//                         }

//                         final amount = int.tryParse(value);
//                         if (amount == null) {
//                           return 'Enter a valid number';
//                         }

//                         if (amount <= 0) {
//                           return 'Amount must be greater than 0';
//                         }

//                         if (amount < 500) {
//                           return 'Minimum investment is ₹500';
//                         }

//                         return null; // ✅ valid
//                         // if (value == null || value.trim().isEmpty)
//                         //   return 'Required';
//                         // final amount = int.tryParse(value);
//                         // if (amount == null || amount < 500) return 'Min ₹500';
//                         // return null;
//                       },
//                       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                       height: 44,
//                       borderRadius: 10,
//                     ),

//                     // _box(
//                     //   child:
//                     //   TextField(
//                     //     keyboardType: TextInputType.number,
//                     //     controller: TextEditingController(
//                     //       text: item.amount.value.toString(),
//                     //     ),

//                     //     decoration: InputDecoration(
//                     //       // hintText: amount,
//                     //       border: InputBorder.none,
//                     //       isCollapsed: true,
//                     //     ),
//                     //     onChanged: (value) {
//                     //       // amount = value;
//                     //       item.amount.value = int.tryParse(value) ?? 0;
//                     //     },
//                     //   ),
//                     // ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const Gap(15),
//           // if (itemEntity.transType?.toLowerCase() == 'stepup')
//           if (currentType == 'stepup')
//             Container(
//               // height: 50,
//               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
//               decoration: BoxDecoration(
//                 color: Color(0xffEAF5FF),
//                 borderRadius: BorderRadius.circular(14),
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Step up Frequency',
//                           style: TextStyle(fontSize: 10),
//                         ),
//                         const Gap(5),
//                         _box(
//                           child: DropdownButton<String>(
//                             // style: TextStyle(color: Ucolors.dark),
//                             isExpanded: true,
//                             isDense: true,
//                             underline: SizedBox(),
//                             // value: item.stepupFrequency.value,
//                             // value: itemEntity.frequency,
//                             value: itemEntity.frequency ?? '6m',
//                             items: [
//                               DropdownMenuItem(
//                                 value: '6m',
//                                 child: Text('6 month'),
//                               ),
//                               DropdownMenuItem(
//                                 value: '1y',
//                                 child: Text('1 Year'),
//                               ),
//                               DropdownMenuItem(
//                                 value: '2y',
//                                 child: Text('2 Year '),
//                               ),
//                               DropdownMenuItem(
//                                 value: '5y',
//                                 child: Text('5 Year'),
//                               ),
//                             ],
//                             onChanged: (value) {
//                               // item.stepupFrequency.value = value!;
//                               itemEntity.frequency;

//                               // setState(() {});
//                               // stepup = value.toString();
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   Gap(20),

//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Step Up Amount', style: TextStyle(fontSize: 10)),
//                         Gap(5),
//                         _box(
//                           child: TextField(
//                             onChanged: (value) {},
//                             keyboardType: TextInputType.number,
//                             decoration: InputDecoration(
//                               isCollapsed: true,
//                               isDense: true,
//                               border: InputBorder.none,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       );
//     });
//   }

//   Widget _box({required Widget child}) {
//     return Container(
//       height: 38,
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       alignment: Alignment.centerLeft,
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(11),
//       ),
//       child: child,
//     );
//   }
// }
*/

class InputBox extends StatelessWidget {
  final String label;
  final String value;

  const InputBox({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 6),
        Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
