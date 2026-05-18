import 'dart:async';
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
import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';
import 'package:my_sip/features/fund_details/presentation/pages/fund_deatails.dart';
import 'package:my_sip/features/home/presentation/pages/home.dart';
import 'package:my_sip/features/personalization/presentation/widgets/bank_details.dart';

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

      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Obx(() {
          final items = controller.displayedItems;

          if (controller.isLoading.value && items.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          // --- EMPTY STATE ---
          if (items.isEmpty) {
            return SingleChildScrollView(
              child: Column(
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
                  const SizedBox(height: 60),
                  _buildRecentlyViewed(),
                ],
              ),
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
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // 1. Your Cart Items (Scrolls normally)
              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return CartItemCard(index: index, itemEntity: items[index]);
                  }, childCount: items.length),
                ),
              ),

              if (items.length <= 2)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(height: 20),
                      _buildRecentlyViewed(),
                    ],
                  ),
                ),
            ],
          );

          // --- MOBILE LAYOUT ---
          // return SingleChildScrollView(
          //   child: Column(
          //     children: [
          //       ListView.builder(
          //         physics: const NeverScrollableScrollPhysics(), // 🚀 3. ADD THIS
          //         shrinkWrap: true,
          //         padding: const EdgeInsets.symmetric(vertical: 8),
          //         itemCount: items.length,
          //         itemBuilder: (context, index) {
          //           return CartItemCard(index: index, itemEntity: items[index]);
          //         },
          //       ),
          //       // if (items.length <= 2) _buildRecentlyViewed(),
          //       if (items.length <= 2) ...[
          //         // const SizedBox(height: 32),
          //         _buildRecentlyViewed(),
          //         // const SizedBox(height: 12),
          //       ],
          //     ],
          //   ),
          // );
        }),
      ),
    );
  }

  // =========================================
  // 🧩 RECENTLY VIEWED HELPER
  // =========================================
  Widget _buildRecentlyViewed() {
    return Obx(() {
      // Safely fetch the recently viewed funds
      final recentFunds = Get.find<MutualFundController>().recentlyViewedFunds;

      if (recentFunds.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Ucolors.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  "Recently Viewed",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              clipBehavior: Clip.none,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: recentFunds.length,
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final fund = recentFunds[index];
                final img = "${Appurl.baseUrl}${fund.amc?.amcLogoUrl}";
                final name = fund.baseSchemeName ?? 'Unknown Name';
                final threeyear = fund.returnsEntity?.threeYear ?? '';
                final schemeCode = fund.schemeCode.toString();

                return SizedBox(
                  width: Get.width * 0.45,
                  child: Column(
                    children: [
                      Expanded(
                        child: PopularFundCardMob(
                          onTap: () {
                            Get.find<MutualFundController>()
                                .addToLocalRecentlyViewed(fund);
                            Get.toNamed(
                              AppRoutes.funddetails,
                              arguments: {
                                'scheme': name,
                                'imgUrl': img,
                                'scheme_code': schemeCode,
                              },
                            );
                          },
                          isNetwork: true,
                          imgPath: img,
                          name: name,
                          threeYear: threeyear,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        height: 32, // Compact button height
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.find<CartController>().addToCart(
                              schemeCode,
                              name,
                              fund.minSipAmount ?? 1000,
                              null,
                            );
                            Get.find<MutualFundController>()
                                .removeFromRecentlyViewed(schemeCode);
                          },
                          icon: const Icon(
                            Icons.add_shopping_cart,
                            size: 16,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Add to Cart",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Ucolors.primary, // Using your theme color
                            padding: EdgeInsets.zero,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
        ],
      );
    });
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

class InvestmentInputsRow extends StatefulWidget {
  final CartItemEntity itemEntity;

  const InvestmentInputsRow({super.key, required this.itemEntity});

  @override
  State<InvestmentInputsRow> createState() => _InvestmentInputsRowState();
}

class _InvestmentInputsRowState extends State<InvestmentInputsRow> {
  final controller = Get.find<CartController>();

  // Reactive variables
  late final RxString localCapDate;
  late final RxString capType;
  late final RxString stepUpType;

  late final TextEditingController stepUpController;
  late final TextEditingController amountController;
  late final TextEditingController capAmountController;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // initState only runs ONCE when the row is first created!
    // Keyboard popping up will NO LONGER reset these values.

    // final int minTopUp = _parseAmount(
    //   widget.itemEntity.minTopupAmount,
    //   defaultVal: 500,
    // );
    // final String initialTopUp =
    //     (widget.itemEntity.topUpAmount != null &&
    //         widget.itemEntity.topUpAmount != '0' &&
    //         widget.itemEntity.topUpAmount != '')
    //     ? _parseAmount(widget.itemEntity.topUpAmount).toString()
    //     : minTopUp.toString();
    // stepUpController = TextEditingController(text: initialTopUp);
    bool hasPercentage =
        widget.itemEntity.stepUpPercentage != null &&
        widget.itemEntity.stepUpPercentage! > 0;

    if (hasPercentage) {
      stepUpType = 'percentage'.obs;
      stepUpController = TextEditingController(
        text: widget.itemEntity.stepUpPercentage.toString(),
      );
    } else {
      stepUpType = 'amount'.obs;
      final int minTopUp = _parseAmount(
        widget.itemEntity.minTopupAmount,
        defaultVal: 500,
      );
      final String initialTopUp =
          (widget.itemEntity.topUpAmount != null &&
              widget.itemEntity.topUpAmount != '0' &&
              widget.itemEntity.topUpAmount != '')
          ? _parseAmount(widget.itemEntity.topUpAmount).toString()
          : minTopUp.toString();

      stepUpController = TextEditingController(text: initialTopUp);
    }

    bool hasAmount =
        widget.itemEntity.capingAmount != null &&
        widget.itemEntity.capingAmount!.isNotEmpty;
    bool hasDate =
        widget.itemEntity.capingDate != null &&
        widget.itemEntity.capingDate!.isNotEmpty;

    // stepUpType = 'amount'.obs;

    if (hasAmount && !hasDate) {
      capType = 'amount'.obs;
    } else {
      capType = 'date'.obs;
    }

    localCapDate = (widget.itemEntity.capingDate ?? '').obs;

    final currentType = widget.itemEntity.transType?.toLowerCase() ?? 'sip';
    final int minSip = _parseAmount(widget.itemEntity.minSipAmount);
    final int minLumpsum = _parseAmount(widget.itemEntity.minLumpsum);
    final int currentMinLimit = (currentType == 'lumpsum')
        ? minLumpsum
        : minSip;

    final String initialAmount =
        (widget.itemEntity.amount != null && widget.itemEntity.amount! > 0)
        ? widget.itemEntity.amount.toString()
        : currentMinLimit.toString();

    amountController = TextEditingController(text: initialAmount);

    // capAmountController = TextEditingController(
    //   text: widget.itemEntity.capingAmount ?? '',
    // );
    final int minTopUpForCap = _parseAmount(
      widget.itemEntity.minTopupAmount,
      defaultVal: 500,
    );
    final int defaultCap = minSip + minTopUpForCap;

    capAmountController = TextEditingController(
      text:
          (widget.itemEntity.capingAmount != null &&
              widget.itemEntity.capingAmount!.isNotEmpty)
          ? widget.itemEntity.capingAmount
          : defaultCap.toString(),
    );
  }

  /// Helper to convert API strings like "1000.00" to int 1000
  int _parseAmount(String? value, {int defaultVal = 0}) {
    if (value == null || value.isEmpty) return defaultVal;
    return double.tryParse(value)?.toInt() ?? defaultVal;
  }

  @override
  void dispose() {
    super.dispose();
    stepUpController.dispose();
    amountController.dispose();
    capAmountController.dispose();
    _debounce?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final cartResponse = controller.cartResponseEntity.value;
      final _ = controller.cartResponseEntity.value;

      final currentType = widget.itemEntity.transType?.toLowerCase() ?? 'sip';

      final int minSip = _parseAmount(widget.itemEntity.minSipAmount);
      final int minLumpsum = _parseAmount(widget.itemEntity.minLumpsum);

      final int currentMinLimit = (currentType == 'lumpsum')
          ? minLumpsum
          : minSip;

      final currentAmount =
          (widget.itemEntity.amount != null && widget.itemEntity.amount! > 0)
          ? widget.itemEntity.amount.toString()
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
                        int newDefaultAmount = minSip;
                        if (val == 'lumpsum') {
                          newDefaultAmount = minLumpsum;
                        }

                        int? newTopUp;
                        String? newFrequency;
                        if (val == 'stepup') {
                          newTopUp = _parseAmount(
                            widget.itemEntity.minTopupAmount,
                          );
                          newFrequency = '6';
                        }

                        amountController.text = newDefaultAmount.toString();

                        controller.updateCartItem(
                          itemId: widget.itemEntity.id!,
                          transType: val,
                          amount: newDefaultAmount,
                          topUpAmount: newTopUp,
                          frequency: newFrequency,
                        );
                      }
                    },
                  ),
                ),
              ),

              const SizedBox(width: 12),

              /// 2. SIP Date Dropdown
              if (currentType != 'lumpsum')
                Expanded(
                  flex: 2,
                  child: _buildColumn(
                    'SIP Date',
                    DropdownButton<String>(
                      menuMaxHeight: 300,
                      dropdownColor: Colors.white,
                      isDense: true,
                      value: (widget.itemEntity.sipDay ?? 1).toString(),
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: List.generate(
                        28,
                        (i) => DropdownMenuItem(
                          value: '${i + 1}',
                          child: Text(
                            '${i + 1}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      onChanged: (val) {
                        if (val != null) {
                          controller.updateCartItem(
                            itemId: widget.itemEntity.id!,
                            sipDay: int.parse(val),
                          );
                        }
                      },
                    ),
                  ),
                ),

              const SizedBox(width: 12),

              /// 3. Amount Field
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Inv Amount',
                      style: UTextStyles.small.copyWith(
                        color: const Color(0xff5B5B5B),
                      ),
                    ),
                    const SizedBox(height: 6),
                    CustomTextField(
                      height: 55,
                      // key: ValueKey(
                      //   'amt_${widget.itemEntity.id}_$currentAmount',
                      // ),
                      keyboardType: TextInputType.number,
                      // controller: TextEditingController(text: currentAmount),
                      controller: amountController,
                      validationType: ValidationType.custom,
                      onChanged: (value) {
                        controller.debouncedAmountUpdate(
                          itemId: widget.itemEntity.id!,
                          value: value,
                          currentMinLimit: currentMinLimit,
                        );
                      },
                      customValidator: (value) {
                        if (value == null || value.trim().isEmpty)
                          return 'Required';
                        final amount = int.tryParse(value) ?? 0;
                        if (amount < currentMinLimit)
                          return 'Min ₹$currentMinLimit';
                        if (amount % 100 != 0) return 'Multiple of ₹100';
                        return null;
                      },
                      onSubmitted: (value) {
                        final newAmt = int.tryParse(value);
                        if (newAmt != null &&
                            newAmt >= currentMinLimit &&
                            newAmt % 100 == 0) {
                          controller.updateCartItem(
                            itemId: widget.itemEntity.id!,
                            amount: newAmt,
                          );
                        }
                      },
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ],
                ),
              ),
            ],
          ),

          /// 4. Step Up Section
          if (currentType == 'stepup') ...[
            const Gap(15),
            _buildStepUpSection(context),
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

  Widget _buildStepUpSection(BuildContext context) {
    final int minTopUp = _parseAmount(
      widget.itemEntity.minTopupAmount,
      defaultVal: 500,
    );

    final String currentTopUp =
        (widget.itemEntity.topUpAmount != null &&
            widget.itemEntity.topUpAmount != '0' &&
            widget.itemEntity.topUpAmount != '')
        ? _parseAmount(widget.itemEntity.topUpAmount).toString()
        : minTopUp.toString();

    String safeFrequency = widget.itemEntity.frequency ?? '6';
    if (safeFrequency != '6' && safeFrequency != '12') safeFrequency = '6';

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xffEAF5FF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildColumn(
                  'Step up Frequency',
                  DropdownButton<String>(
                    value: safeFrequency,
                    isExpanded: true,
                    isDense: true,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(
                        value: '6',
                        child: Text('6 Months', style: TextStyle(fontSize: 12)),
                      ),
                      DropdownMenuItem(
                        value: '12',
                        child: Text('Yearly', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        controller.updateCartItem(
                          itemId: widget.itemEntity.id!,
                          frequency: val,
                        );
                      }
                    },
                  ),
                ),
              ),
              const Gap(20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- HEADER WITH SMALL TOGGLE SWITCH ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Step Up By',
                          style: UTextStyles.small.copyWith(
                            color: const Color(0xff5B5B5B),
                            fontSize: 11,
                          ),
                        ),
                        Obx(
                          () => Container(
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // AMOUNT (₹) BUTTON
                                InkWell(
                                  onTap: () {
                                    stepUpType.value = 'amount';
                                    stepUpController.text =
                                        (widget.itemEntity.topUpAmount !=
                                                null &&
                                            widget.itemEntity.topUpAmount !=
                                                '0' &&
                                            widget.itemEntity.topUpAmount != '')
                                        ? _parseAmount(
                                            widget.itemEntity.topUpAmount,
                                          ).toString()
                                        : minTopUp.toString();

                                    controller.updateCartItem(
                                      itemId: widget.itemEntity.id!,
                                      topUpAmount: minTopUp,
                                      stepUpPercentage: 0,
                                    );

                                    // stepUpType.value = 'amount';
                                    // stepUpController.text =
                                    //     currentTopUp; // Restore amount text
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: stepUpType.value == 'amount'
                                          ? Ucolors.primary
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '₹',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: stepUpType.value == 'amount'
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                                // PERCENTAGE (%) BUTTON
                                InkWell(
                                  // onTap: () => stepUpType.value = 'percentage',
                                  onTap: () {
                                    stepUpType.value = 'percentage';
                                    stepUpController
                                        .clear(); // Clear text for percentage
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: stepUpType.value == 'percentage'
                                          ? Ucolors.primary
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '%',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: stepUpType.value == 'percentage'
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    Obx(
                      () => CustomTextField(
                        bgColor: Colors.white,
                        height: 55,
                        borderRadius: 11,
                        // key: ValueKey(
                        //   'topup_${widget.itemEntity.id}_${stepUpType.value}_$currentTopUp',
                        // ),
                        // controller: TextEditingController(
                        //   text: stepUpType.value == 'amount'
                        //       ? currentTopUp
                        //       : '',
                        // ),
                        controller: stepUpController,
                        keyboardType: TextInputType.number,
                        validationType: ValidationType.custom,
                        borderColor: Colors.grey.shade300,
                        focusedBorderColor: Ucolors.primary,
                        hint: stepUpType.value == 'amount'
                            ? 'e.g. $minTopUp'
                            : 'e.g. 10',
                        // --- 3. REPLACE STEP UP onChanged WITH THIS ---
                        onChanged: (value) {
                          final amt = int.tryParse(value) ?? 0;
                          bool hasError = false;

                          // 1. Check for errors
                          if (stepUpType.value == 'amount') {
                            hasError = amt < minTopUp || amt % 100 != 0;
                          } else {
                            hasError = amt <= 0 || amt > 100;
                          }

                          // 2. Set error state in UI
                          controller.setItemError(
                            -widget.itemEntity.id!,
                            hasError,
                          );

                          // 3. Only send API call if there are no errors
                          if (!hasError) {
                            if (_debounce?.isActive ?? false)
                              _debounce!.cancel();

                            _debounce = Timer(
                              const Duration(milliseconds: 800),
                              () {
                                if (stepUpType.value == 'amount') {
                                  controller.updateCartItem(
                                    itemId: widget.itemEntity.id!,
                                    topUpAmount: amt,
                                    stepUpPercentage: 0,
                                  );
                                } else if (stepUpType.value == 'percentage') {
                                  controller.updateCartItem(
                                    itemId: widget.itemEntity.id!,
                                    stepUpPercentage: amt,
                                    // topUpAmount: 0,
                                  );
                                }
                              },
                            );
                          }
                        },

                        // onChanged: (value) {
                        //   final amt = int.tryParse(value) ?? 0;
                        //   if (stepUpType.value == 'amount') {
                        //     controller.setItemError(
                        //       -widget.itemEntity.id!,
                        //       amt < minTopUp || amt % 100 != 0,
                        //     );
                        //   } else {
                        //     // Percentage validation
                        //     controller.setItemError(
                        //       -widget.itemEntity.id!,
                        //       amt <= 0 || amt > 100,
                        //     );
                        //   }
                        // },
                        customValidator: (value) {
                          if (value == null || value.trim().isEmpty)
                            return 'Required';
                          final amt = int.tryParse(value) ?? 0;

                          if (stepUpType.value == 'amount') {
                            if (amt < minTopUp) return 'Min ₹$minTopUp';
                            if (amt % 100 != 0) return 'Multiple of ₹100';
                          } else {
                            if (amt <= 0) return 'Min 1%';
                            if (amt > 100) return 'Max 100%';
                          }
                          return null;
                        },
                        // onSubmitted: (val) {
                        //   final amt = int.tryParse(val);
                        //   if (amt != null) {
                        //     if (stepUpType.value == 'amount' &&
                        //         amt >= minTopUp &&
                        //         amt % 100 == 0) {
                        //       controller.updateCartItem(
                        //         itemId: widget.itemEntity.id!,
                        //         topUpAmount: amt,
                        //       );
                        //     } else if (stepUpType.value == 'percentage' &&
                        //         amt > 0 &&
                        //         amt <= 100) {
                        //       // IMPORTANT: You may need to add a 'topUpPercentage' parameter
                        //       // to your updateCartItem method if your backend expects it!
                        //       controller.updateCartItem(
                        //         itemId: widget.itemEntity.id!,
                        //         topUpAmount: amt,
                        //       );
                        //     }
                        //   }
                        // },
                        onSubmitted: (val) {
                          final amt = int.tryParse(val);
                          if (amt != null) {
                            if (stepUpType.value == 'amount' &&
                                amt >= minTopUp &&
                                amt % 100 == 0) {
                              controller.updateCartItem(
                                itemId: widget.itemEntity.id!,
                                topUpAmount: amt,
                                stepUpPercentage:
                                    0, // <-- Added this to clear %
                              );
                            } else if (stepUpType.value == 'percentage' &&
                                amt > 0 &&
                                amt <= 100) {
                              controller.updateCartItem(
                                itemId: widget.itemEntity.id!,
                                stepUpPercentage:
                                    amt, // <-- Sends to correct field
                                topUpAmount: null, // <-- Clears amount
                              );
                            }
                          }
                        },

                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Expanded(
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         'Step Up Amount',
              //         style: UTextStyles.small.copyWith(
              //           color: const Color(0xff5B5B5B),
              //           fontSize: 11,
              //         ),
              //       ),
              //       const SizedBox(height: 6),
              //       CustomTextField(
              //         bgColor: Colors.white,
              //         height: 55,
              //         borderRadius: 11,
              //         key: ValueKey(
              //           'topup_${widget.itemEntity.id}_$currentTopUp',
              //         ),
              //         controller: TextEditingController(text: currentTopUp),
              //         keyboardType: TextInputType.number,
              //         validationType: ValidationType.custom,
              //         borderColor: Colors.grey.shade300,
              //         focusedBorderColor: Ucolors.primary,
              //         onChanged: (value) {
              //           final amt = int.tryParse(value) ?? 0;
              //           controller.setItemError(
              //             -widget.itemEntity.id!,
              //             amt < minTopUp || amt % 100 != 0,
              //           );
              //         },
              //         customValidator: (value) {
              //           if (value == null || value.trim().isEmpty)
              //             return 'Required';
              //           final amt = int.tryParse(value) ?? 0;
              //           if (amt < minTopUp) return 'Min ₹$minTopUp';
              //           if (amt % 100 != 0) return 'Multiple of ₹100';
              //           return null;
              //         },
              //         onSubmitted: (val) {
              //           final amt = int.tryParse(val);
              //           if (amt != null && amt >= minTopUp && amt % 100 == 0) {
              //             controller.updateCartItem(
              //               itemId: widget.itemEntity.id!,
              //               topUpAmount: amt,
              //             );
              //           }
              //         },
              //         inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),

          const Gap(15),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cap Limit By',
                      style: UTextStyles.small.copyWith(
                        color: const Color(0xff5B5B5B),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Obx(
                      () => Container(
                        height: 55,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(11),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  capType.value = 'date';

                                  controller.updateCartItem(
                                    itemId: widget.itemEntity.id!,
                                    capingAmount: "",
                                    capingDate: localCapDate.value,
                                  );
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: capType.value == 'date'
                                        ? Ucolors.primary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Date',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: capType.value == 'date'
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                      color: capType.value == 'date'
                                          ? Colors.white
                                          : Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  capType.value = 'amount';

                                  // if (capAmountController.text.isEmpty) {
                                  //   final int minSip = _parseAmount(widget.itemEntity.minSipAmount);
                                  //   final int minTopUp = _parseAmount(widget.itemEntity.minTopupAmount, defaultVal: 500);
                                  //   capAmountController.text = (minSip + minTopUp).toString();

                                  //   // Optional: Instantly send to backend
                                  //   controller.updateCartItem(
                                  //     itemId: widget.itemEntity.id!,
                                  //     capingAmount: capAmountController.text,
                                  //     capingDate: "",
                                  //   );
                                  // }
                                  final int minSip = _parseAmount(
                                    widget.itemEntity.minSipAmount,
                                  );
                                  final int minTopUp = _parseAmount(
                                    widget.itemEntity.minTopupAmount,
                                    defaultVal: 500,
                                  );
                                  final int absoluteMinCap = minSip + minTopUp;

                                  // Auto-fill if empty OR if the current number is too low to be legal!
                                  final currentCapAmt =
                                      int.tryParse(capAmountController.text) ??
                                      0;
                                  if (capAmountController.text.isEmpty ||
                                      currentCapAmt <= absoluteMinCap) {
                                    // Adding 100 so it is strictly greater than the minimum
                                    capAmountController.text =
                                        (absoluteMinCap + 100).toString();
                                  }

                                  // Tell backend to clear date and use the valid amount
                                  controller.updateCartItem(
                                    itemId: widget.itemEntity.id!,
                                    capingAmount: capAmountController.text,
                                    capingDate: "",
                                  );
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: capType.value == 'amount'
                                        ? Ucolors.primary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Amount',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: capType.value == 'amount'
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                      color: capType.value == 'amount'
                                          ? Colors.white
                                          : Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Gap(20),

              Expanded(
                child: Obx(
                  () => capType.value == 'amount'
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Max Amount',
                              style: UTextStyles.small.copyWith(
                                color: const Color(0xff5B5B5B),
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 6),
                            CustomTextField(
                              bgColor: Colors.white,
                              height: 55,
                              borderRadius: 11,
                              // key: ValueKey(
                              //   'capAmt_${widget.itemEntity.id}_${widget.itemEntity.capingAmount}',
                              // ),
                              // controller: TextEditingController(
                              //   text: widget.itemEntity.capingAmount ?? '',
                              // ),
                              controller: capAmountController,
                              keyboardType: TextInputType.number,
                              validationType: ValidationType.custom,
                              borderColor: Colors.grey.shade300,
                              focusedBorderColor: Ucolors.primary,
                              hint: 'e.g. 5000',
                              // onChanged: (value) {},
                              // --- 4. REPLACE CAP AMOUNT onChanged WITH THIS ---
                              onChanged: (value) {
                                final capAmt = int.tryParse(value) ?? 0;
                                final int minSip = _parseAmount(
                                  widget.itemEntity.minSipAmount,
                                );
                                final int minTopUp = _parseAmount(
                                  widget.itemEntity.minTopupAmount,
                                  defaultVal: 500,
                                );
                                final int absoluteMinCap = minSip + minTopUp;

                                // bool hasError = capAmt <= absoluteMinCap;
                                bool hasError =
                                    capAmt <= absoluteMinCap ||
                                    capAmt % 100 != 0;
                                controller.setItemError(
                                  -widget.itemEntity.id!,
                                  hasError,
                                );

                                // if (_debounce?.isActive ?? false)
                                //   _debounce!.cancel();

                                // _debounce = Timer(
                                //   const Duration(milliseconds: 900),
                                //   () {
                                //     controller.updateCartItem(
                                //       itemId: widget.itemEntity.id!,
                                //       capingAmount: value,
                                //       capingDate: "",
                                //     );
                                //   },
                                // );
                                if (!hasError) {
                                  if (_debounce?.isActive ?? false)
                                    _debounce!.cancel();
                                  _debounce = Timer(
                                    const Duration(milliseconds: 800),
                                    () {
                                      controller.updateCartItem(
                                        itemId: widget.itemEntity.id!,
                                        capingAmount: value,
                                        capingDate: "",
                                      );
                                    },
                                  );
                                }
                              },
                              // customValidator: (value) => null,
                              customValidator: (value) {
                                if (value == null || value.trim().isEmpty)
                                  return 'Required';
                                final capAmt = int.tryParse(value) ?? 0;

                                final int minSip = _parseAmount(
                                  widget.itemEntity.minSipAmount,
                                );
                                final int minTopUp = _parseAmount(
                                  widget.itemEntity.minTopupAmount,
                                  defaultVal: 500,
                                );
                                final int absoluteMinCap = minSip + minTopUp;

                                // Show error if it is not greater than the baseline
                                // if (capAmt <= absoluteMinCap)
                                //   return 'Must be > ₹$absoluteMinCap';
                                if (capAmt <= absoluteMinCap)
                                  return 'Must be > ₹$absoluteMinCap';
                                if (capAmt % 100 != 0)
                                  return 'Multiple of ₹100';
                                return null;
                              },
                              // onSubmitted: (val) {
                              //   controller.updateCartItem(
                              //     itemId: widget.itemEntity.id!,
                              //     capingAmount: val,
                              //     capingDate: "",
                              //   );
                              // },
                              onSubmitted: (val) {
                                final capAmt = int.tryParse(val) ?? 0;

                                final int minSip = _parseAmount(
                                  widget.itemEntity.minSipAmount,
                                );
                                final int minTopUp = _parseAmount(
                                  widget.itemEntity.minTopupAmount,
                                  defaultVal: 500,
                                );
                                final int absoluteMinCap = minSip + minTopUp;

                                // Only submit if valid
                                if (capAmt > absoluteMinCap &&
                                    capAmt % 100 == 0) {
                                  controller.updateCartItem(
                                    itemId: widget.itemEntity.id!,
                                    capingAmount: val,
                                    capingDate: "",
                                  );
                                }
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'End Date',
                              style: UTextStyles.small.copyWith(
                                color: const Color(0xff5B5B5B),
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 6),
                            InkWell(
                              onTap: () async {
                                FocusScope.of(context).unfocus();

                                DateTime initialDate = DateTime.now();
                                if (localCapDate.value.isNotEmpty) {
                                  try {
                                    initialDate = DateTime.parse(
                                      localCapDate.value,
                                    );
                                    if (initialDate.isBefore(DateTime.now())) {
                                      initialDate = DateTime.now();
                                    }
                                  } catch (_) {
                                    initialDate = DateTime.now();
                                  }
                                }

                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: initialDate,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2050),
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: const ColorScheme.light(
                                          primary: Ucolors.primary,
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );

                                if (pickedDate != null) {
                                  String formattedDate =
                                      "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                                  localCapDate.value = formattedDate;

                                  controller.updateCartItem(
                                    itemId: widget.itemEntity.id!,
                                    capingDate: formattedDate,
                                    capingAmount: "",
                                  );
                                }
                              },
                              child: Container(
                                height: 55,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      localCapDate.value.isEmpty
                                          ? 'Select Date'
                                          : localCapDate.value,
                                      style: TextStyle(
                                        color: localCapDate.value.isNotEmpty
                                            ? Colors.black87
                                            : Colors.grey.shade500,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Icon(
                                      Icons.calendar_month_outlined,
                                      color: Colors.grey.shade600,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// class InvestmentInputsRow extends StatelessWidget {
//   InvestmentInputsRow({super.key, required this.itemEntity});

//   final CartItemEntity itemEntity;
//   final controller = Get.find<CartController>();

//   /// Helper to convert API strings like "1000.00" to int 1000
//   int _parseAmount(String? value, {int defaultVal = 0}) {
//     if (value == null || value.isEmpty) return defaultVal;
//     return double.tryParse(value)?.toInt() ?? defaultVal;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       // FIX: Accessing the controller variable here registers this Obx
//       // with GetX so it rebuilds when fetchCart() is called in the controller.
//       final cartResponse = controller.cartResponseEntity.value;

//       final _ = controller.cartResponseEntity.value;

//       // Extract local variables from the current state of the entity
//       final currentType = itemEntity.transType?.toLowerCase() ?? 'sip';

//       // Calculate Limits based on Type
//       final int minSip = _parseAmount(itemEntity.minSipAmount);
//       final int minLumpsum = _parseAmount(itemEntity.minLumpsum);
//       // final int minStepup = _parseAmount(itemEntity.minSipAmount);

//       final int currentMinLimit = (currentType == 'lumpsum')
//           ? minLumpsum
//           : minSip;

//       // --- 3. DISPLAY AMOUNT LOGIC ---
//       // If amount is 0 or invalid, force it to show the current minimum
//       final currentAmount =
//           (itemEntity.amount != null && itemEntity.amount! > 0)
//           ? itemEntity.amount.toString()
//           : currentMinLimit.toString();

//       return Column(
//         children: [
//           Row(
//             children: [
//               /// 1. Investment Type Dropdown
//               Expanded(
//                 flex: 3,
//                 child: _buildColumn(
//                   'Inv. Type',
//                   DropdownButton<String>(
//                     dropdownColor: Colors.white,
//                     isDense: true,
//                     value: currentType,
//                     isExpanded: true,
//                     underline: const SizedBox(),
//                     items: const [
//                       DropdownMenuItem(
//                         value: 'sip',
//                         child: Text('SIP', style: TextStyle(fontSize: 12)),
//                       ),
//                       DropdownMenuItem(
//                         value: 'lumpsum',
//                         child: Text('Lumpsum', style: TextStyle(fontSize: 12)),
//                       ),
//                       DropdownMenuItem(
//                         value: 'stepup',
//                         child: Text('Step Up', style: TextStyle(fontSize: 12)),
//                       ),
//                     ],
//                     onChanged: (val) {
//                       if (val != null && val != currentType) {
//                         // LOGIC: When Type changes, auto-switch Amount to new Minimum
//                         int newDefaultAmount = minSip;
//                         if (val == 'lumpsum') {
//                           newDefaultAmount = minLumpsum;
//                         }

//                         int? newTopUp;
//                         String? newFrequency; // Add this variable
//                         if (val == 'stepup') {
//                           // When switching to Step Up, init the Top-up field to 1000
//                           newTopUp = _parseAmount(itemEntity.minTopupAmount);
//                           newFrequency = '6';
//                         }

//                         controller.updateCartItem(
//                           itemId: itemEntity.id!,
//                           transType: val,
//                           amount: newDefaultAmount,
//                           // ✅ Updates UI & API instantly
//                           topUpAmount: newTopUp,
//                           frequency: newFrequency, // ✅ Pass frequency here
//                         );
//                       }
//                     },
//                   ),
//                 ),
//               ),

//               const SizedBox(width: 12),

//               /// 2. SIP Date Dropdown (Visible for SIP/StepUp)
//               if (currentType != 'lumpsum')
//                 Expanded(
//                   flex: 2,
//                   child: _buildColumn(
//                     'SIP Date',
//                     DropdownButton<String>(
//                       menuMaxHeight: 300,
//                       dropdownColor: Colors.white,
//                       isDense: true,
//                       value: (itemEntity.sipDay ?? 1).toString(),
//                       isExpanded: true,
//                       underline: const SizedBox(),
//                       items: List.generate(
//                         28,
//                         (i) => DropdownMenuItem(
//                           value: '${i + 1}',
//                           child: Text(
//                             '${i + 1}',
//                             style: TextStyle(fontSize: 12),
//                           ),
//                         ),
//                       ),
//                       onChanged: (val) {
//                         if (val != null) {
//                           controller.updateCartItem(
//                             itemId: itemEntity.id!,
//                             sipDay: int.parse(val),
//                           );
//                         }
//                       },
//                     ),
//                   ),
//                 ),

//               const SizedBox(width: 12),
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
//                       height: 55,

//                       // IMPORTANT: ValueKey forces text refresh when new data returns from server
//                       key: ValueKey('amt_${itemEntity.id}_$currentAmount'),
//                       // hint: '500',
//                       keyboardType: TextInputType.number,
//                       controller: TextEditingController(
//                         text: currentAmount,
//                         // text: currentAmount == '1'
//                         //     ? itemEntity.minSipAmount
//                         //     : currentAmount,
//                       ),
//                       validationType: ValidationType.custom,
//                       // onChanged: (value) {
//                       //   final amount = int.tryParse(value) ?? 0;
//                       //   bool hasError =
//                       //       amount < currentMinLimit || amount % 100 != 0;
//                       //   controller.setItemError(itemEntity.id!, hasError);
//                       // },
//                       onChanged: (value) {
//                         controller.debouncedAmountUpdate(
//                           itemId: itemEntity.id!,
//                           value: value,
//                           currentMinLimit: currentMinLimit,
//                         );
//                       },
//                       customValidator: (value) {
//                         if (value == null || value.trim().isEmpty) {
//                           // controller.setItemError(itemEntity.id!, true);
//                           return 'Required';
//                         }
//                         final amount = int.tryParse(value) ?? 0;

//                         // Check against the dynamic limit (SIP vs Lumpsum)
//                         if (amount < currentMinLimit) {
//                           // controller.setItemError(itemEntity.id!, true);
//                           return 'Min ₹$currentMinLimit'; // Shows red text automatically
//                         }
//                         if (amount % 100 != 0) {
//                           // controller.setItemError(itemEntity.id!, true);
//                           return 'Multiple of ₹100';
//                         }
//                         // controller.setItemError(itemEntity.id!, false);
//                         return null;
//                       },

//                       onSubmitted: (value) {
//                         final newAmt = int.tryParse(value);
//                         if (newAmt != null &&
//                             newAmt >= currentMinLimit &&
//                             newAmt % 100 == 0) {
//                           controller.updateCartItem(
//                             itemId: itemEntity.id!,
//                             amount: newAmt,
//                           );
//                         }
//                       },
//                       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                     ),
//                     // CustomTextField(
//                     //   // onChanged: item.updateAmount,
//                     //   keyboardType: TextInputType.number,
//                     //   // controller: item.amountController,
//                     //   validationType: ValidationType.custom,
//                     //   customValidator: (value) {
//                     //     if (value == null || value.trim().isEmpty) {
//                     //       return 'Amount is required';
//                     //     }

//                     //     final amount = int.tryParse(value);
//                     //     if (amount == null) {
//                     //       return 'Enter a valid number';
//                     //     }

//                     //     if (amount <= 0) {
//                     //       return 'Amount must be greater than 0';
//                     //     }

//                     //     if (amount < 500) {
//                     //       return 'Minimum investment is ₹500';
//                     //     }

//                     //     return null; // ✅ valid
//                     //   },
//                     //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                     //   height: 44,
//                     //   borderRadius: 10,
//                     // ),

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

//               /// 3. Amount Field
//               // Expanded(
//               //   flex: 3,
//               //   child:
//               //   _buildColumn(

//               //     'Inv Amount',
//               //     CustomTextField(
//               //       borderColor: Colors.transparent,
//               //       focusedBorderColor: Colors.transparent,
//               //       height: 44,

//               //       // IMPORTANT: ValueKey forces text refresh when new data returns from server
//               //       key: ValueKey('amt_${itemEntity.id}_$currentAmount'),
//               //       // hint: '500',
//               //       keyboardType: TextInputType.number,
//               //       controller: TextEditingController(text: currentAmount),
//               //       validationType: ValidationType.custom,
//               //       customValidator: (value) {
//               //         if (value == null || value.trim().isEmpty)
//               //           return 'Required';
//               //         final amount = int.tryParse(value);
//               //         if (amount == null || amount < 500) return 'Min ₹500';
//               //         return null;
//               //       },

//               //       onSubmitted: (value) {
//               //         final newAmt = int.tryParse(value);
//               //         if (newAmt != null && newAmt >= 500) {
//               //           controller.updateCartItem(
//               //             itemId: itemEntity.id!,
//               //             amount: newAmt,
//               //           );
//               //         }
//               //       },
//               //       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//               //     ),
//               //   ),
//               // ),
//             ],
//           ),

//           /// 4. Step Up Section (Visible for StepUp)
//           if (currentType == 'stepup') ...[
//             const Gap(15),
//             _buildStepUpSection(),
//           ],
//         ],
//       );
//     });
//   }

//   Widget _buildColumn(String label, Widget child) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: UTextStyles.small.copyWith(
//             color: const Color(0xff5B5B5B),
//             fontSize: 11,
//           ),
//         ),
//         const SizedBox(height: 6),
//         _box(child: child),
//       ],
//     );
//   }

//   Widget _box({required Widget child}) {
//     return Container(
//       height: 44,
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       alignment: Alignment.centerLeft,
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(11),
//         color: Colors.white,
//       ),
//       child: child,
//     );
//   }

//   Widget _buildStepUpSection() {
//     final stepUpAmt =
//         double.tryParse(
//           itemEntity.topUpAmount?.toString() ?? '0',
//         )?.toInt().toString() ??
//         '0';

//     final int minTopUp = _parseAmount(
//       itemEntity.minTopupAmount,
//       defaultVal: 500,
//     );

//     // final String currentTopUp = _parseAmount(
//     //   itemEntity.topUpAmount,
//     //   defaultVal: 0, // If null, show 0 or min topup
//     // ).toString();

//     final String currentTopUp =
//         (itemEntity.topUpAmount != null &&
//             itemEntity.topUpAmount != '0' &&
//             itemEntity.topUpAmount != '')
//         ? _parseAmount(itemEntity.topUpAmount).toString()
//         : minTopUp.toString();
//     String safeFrequency = itemEntity.frequency ?? '6';
//     if (safeFrequency != '6' && safeFrequency != '12') {
//       safeFrequency = '6';
//     }
//     return Container(
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: const Color(0xffEAF5FF),
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: _buildColumn(
//               'Step up Frequency',
//               DropdownButton<String>(
//                 // value: itemEntity.frequency ?? '6',
//                 value: safeFrequency,
//                 isExpanded: true,
//                 isDense: true,
//                 underline: const SizedBox(),
//                 items: const [
//                   // DropdownMenuItem(
//                   //   value: '1',
//                   //   child: Text('Monthly', style: TextStyle(fontSize: 12)),
//                   // ),
//                   // DropdownMenuItem(
//                   //   value: '3',
//                   //   child: Text('Quarterly', style: TextStyle(fontSize: 12)),
//                   // ),
//                   DropdownMenuItem(
//                     value: '6',
//                     child: Text('6 Months', style: TextStyle(fontSize: 12)),
//                   ),
//                   DropdownMenuItem(
//                     value: '12',
//                     child: Text('Yearly', style: TextStyle(fontSize: 12)),
//                   ),
//                 ],
//                 onChanged: (val) {
//                   // if (val != null) {
//                   controller.updateCartItem(
//                     itemId: itemEntity.id!,
//                     frequency: val,
//                   );
//                   // }
//                 },
//               ),
//             ),
//           ),
//           const Gap(20),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Step Up Amount',
//                   style: UTextStyles.small.copyWith(
//                     color: const Color(0xff5B5B5B),
//                     fontSize: 11,
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 // We REMOVE the _box() wrapper here because CustomTextField
//                 // provides its own border and background.
//                 CustomTextField(
//                   bgColor: Colors.white,
//                   height: 55, // Matches your other inputs
//                   borderRadius: 11, // Matches your _box decoration
//                   key: ValueKey('topup_${itemEntity.id}_$currentTopUp'),
//                   controller: TextEditingController(text: currentTopUp),
//                   keyboardType: TextInputType.number,
//                   validationType: ValidationType.custom,
//                   // Match your app's theme colors
//                   borderColor: Colors.grey.shade300,

//                   focusedBorderColor: Ucolors.primary,
//                   onChanged: (value) {
//                     final amt = int.tryParse(value) ?? 0;
//                     bool hasError = amt < minTopUp || amt % 100 != 0;
//                     controller.setItemError(-itemEntity.id!, hasError);
//                   },
//                   customValidator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'Required';
//                     }
//                     final amt = int.tryParse(value) ?? 0;
//                     if (amt < minTopUp) {
//                       return 'Min ₹$minTopUp';
//                     }
//                     if (amt % 100 != 0) {
//                       return 'Multiple of ₹100';
//                     }

//                     return null;
//                   },

//                   onSubmitted: (val) {
//                     final amt = int.tryParse(val);
//                     if (amt != null && amt >= minTopUp && amt % 100 == 0) {
//                       controller.updateCartItem(
//                         itemId: itemEntity.id!,
//                         topUpAmount: amt,
//                       );
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),

//           // Expanded(
//           //   child: _buildColumn(
//           //     'Step Up Amount',
//           //     CustomTextField(
//           //       borderRadius: 11, // Matches your _box decoration

//           //       height: 44,
//           //       borderColor: Colors.grey.shade300,
//           //       key: ValueKey('topup_${itemEntity.id}_$currentTopUp'),
//           //       controller: TextEditingController(text: currentTopUp),
//           //       keyboardType: TextInputType.number,
//           //       validationType: ValidationType.custom,
//           //       customValidator: (value) {
//           //         if (value == null || value.trim().isEmpty) return 'Required';
//           //         final amt = int.tryParse(value) ?? 0;
//           //         if (amt < minTopUp) return 'Min ₹$minTopUp';
//           //         if (amt % minTopUp != 0) return 'Multiple of ₹$minTopUp';
//           //         return null;
//           //       },
//           //       onSubmitted: (val) {
//           //         final amt = int.tryParse(val);
//           //         if (amt != null && amt >= minTopUp && amt % minTopUp == 0) {
//           //           controller.updateCartItem(
//           //             itemId: itemEntity.id!,
//           //             topUpAmount: amt,
//           //           );
//           //         }
//           //       },
//           //     ),

//           //     // TextField(
//           //     //   key: ValueKey('topup_${itemEntity.id}_$currentTopUp'),
//           //     //   // controller: TextEditingController(

//           //     //   //   text: stepUpAmt,
//           //     //   // ),
//           //     //   // controller: TextEditingController(
//           //     //   //   text: currentTopUp == '0'
//           //     //   //       ? minTopUp.toString()
//           //     //   //       : currentTopUp,
//           //     //   // ),
//           //     //   controller: TextEditingController(text: currentTopUp),
//           //     //   keyboardType: TextInputType.number,
//           //     //   decoration: const InputDecoration(
//           //     //     border: InputBorder.none,
//           //     //     isDense: true,
//           //     //   ),

//           //     //   onSubmitted: (val) {
//           //     //     // final stepAmt = int.tryParse(val);
//           //     //     // if (stepAmt != null) {
//           //     //     //   controller.updateCartItem(
//           //     //     //     itemId: itemEntity.id!,
//           //     //     //     topUpAmount: stepAmt,
//           //     //     //   );
//           //     //     // }
//           //     //     final amt = int.tryParse(val);

//           //     //     // TOPUP VALIDATION
//           //     //     if (amt != null
//           //     //     // && amt >= minTopUp
//           //     //     ) {
//           //     //       controller.updateCartItem(
//           //     //         itemId: itemEntity.id!,
//           //     //         topUpAmount: amt,
//           //     //       );
//           //     //     }
//           //     //   },
//           //     // ),
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }
// }

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
