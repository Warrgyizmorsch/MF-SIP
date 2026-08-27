// ignore_for_file: deprecated_member_use, unused_local_variable

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'package:my_sip/common/widget/animated/empty_filled.dart';
import 'package:my_sip/common/widget/animated/custom_toast.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/common/widget/images/custom_cached_image.dart';
import 'package:my_sip/common/widget/text_form/text_field_component.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/core/utils/enums/enums.dart';
import 'package:my_sip/core/utils/helper/purchase_scenario.dart';
import 'package:my_sip/features/authentication/presentation/widgets/term_policy.dart';
import 'package:my_sip/features/cart/domain/entities/cart_response_entity.dart';
import 'package:my_sip/features/cart/presentation/controllers/cart_controller.dart'
    hide showCustomToast;
import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';
import 'package:my_sip/features/fund_details/presentation/pages/fund_deatails.dart';
import 'package:my_sip/features/home/presentation/pages/home.dart';
import 'package:my_sip/features/mfu/presentation/controller/mfu_controller.dart';
import 'package:my_sip/features/personalization/presentation/controllers/personalisation_controller.dart';
import 'package:my_sip/features/personalization/presentation/widgets/bank_details.dart';

class CartPage extends GetView<CartController> {
  const CartPage({super.key});

  void _processInlineCartPayment() {
    final paymentCtrl = Get.find<MfuController>();

    if (paymentCtrl.selectedMethod.value == 'upi' &&
        paymentCtrl.upiId.value.trim().isEmpty) {
      showCustomToast(
        title: 'Enter UPI Id',
        message: '',
        backgroundColor: Colors.red,
        icon: Icons.warning,
      );
      return;
    }

    CustomSnackbar.info(
      title: 'Processing',
      message: 'Initializing secure cart checkout...',
    );
  }

  void _handlePurchase({bool isLumpsum = false}) {
    final targetItems = isLumpsum
        ? controller.lumpsumItems
        : controller.sipAndStepUpItems;
    if (!controller.isListValid(targetItems)) return;

    GatekeeperHelper.runWithPrerequisites(
      isLumpsum: isLumpsum,
      onSuccess: () {
        if (isLumpsum) {
          controller.checkoutLumpsum();
        } else {
          controller.checkoutSip();
        }
      },
    );
  }

  void _showPrerequisiteDialog({
    required String title,
    required String message,
    required String buttonText,
    required VoidCallback onTap,
  }) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: FontFamily.medium, // Use your custom font family
            fontWeight: FontWeight.w500,
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(
            fontFamily: FontFamily.medium,
            color: Colors.black87,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Close',
              style: TextStyle(
                fontFamily: FontFamily.medium,
                color: Colors.grey,
              ),
            ),
          ),
          TextButton(
            onPressed: onTap,
            child: Text(
              buttonText,
              style: const TextStyle(
                fontFamily: FontFamily.medium,
                color: Colors.blue, // Or use Ucolors.primary
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    return GetBuilder<CartController>(
      builder: (controller) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: isDesktop
                ? null
                : CustomAppBarNormal(
                    title: 'Cart',
                    bottom: TabBar(
                      onTap: (index) {
                        controller.activeTabIndex.value = index;
                      },
                      labelColor: Ucolors.primary,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Ucolors.primary,
                      tabs: const [
                        Tab(text: 'SIP & Step-Up'),
                        Tab(text: 'Lumpsum Orders'),
                      ],
                    ),
                  ),

            persistentFooterDecoration: isDesktop
                ? null
                : const BoxDecoration(),
            persistentFooterButtons: isDesktop
                ? null
                : [const TermAndPolicy(term: 'By Proceeding I accept the ')],
            bottomNavigationBar: isDesktop
                ? null
                : SafeArea(
                    top: false,
                    child: Obx(() {
                      final mfuCtrl = Get.find<MfuController>();
                      final isLumpsumTab = controller.activeTabIndex.value == 1;
                      final isSubmitting = isLumpsumTab
                          ? mfuCtrl.isSubmittingLumpsum.value
                          : mfuCtrl.isSubmittingSip.value;

                      final isLoading =
                          (controller.isLoading.value &&
                              controller.items.isEmpty) ||
                          controller.isInitLoading.value;
                      final targetItems = isLumpsumTab
                          ? controller.lumpsumItems
                          : controller.sipAndStepUpItems;
                      final targetAmount = isLumpsumTab
                          ? controller.totalLumpsumAmount
                          : controller.totalSipStepUpAmount;

                      return CartBottomBar(
                        isValid: controller.isListValid(targetItems),
                        isLoading: isSubmitting,
                        amount: isLoading ? '0' : targetAmount.toString(),
                        ontap: () => _handlePurchase(isLumpsum: isLumpsumTab),
                      );
                    }),
                  ),

            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              behavior: HitTestBehavior.translucent,
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Obx(
                    () => _buildTabCartView(
                      context,
                      controller.sipAndStepUpItems,
                      isDesktop,
                      isLumpsum: false,
                    ),
                  ),
                  Obx(
                    () => _buildTabCartView(
                      context,
                      controller.lumpsumItems,
                      isDesktop,
                      isLumpsum: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabCartView(
    BuildContext context,
    List<CartItemEntity> items,
    bool isDesktop, {
    required bool isLumpsum,
  }) {
    if (controller.isLoading.value && controller.items.isEmpty ||
        controller.isInitLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    // --- EMPTY STATE ---
    if (items.isEmpty) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Center(
              child: controller.filterGoalId.value != null
                  ? const Text("No funds for this goal")
                  : AnimatedEmptyState(
                      title: isLumpsum
                          ? "No Lumpsum Orders"
                          : "No SIP & Step-Up Orders",
                      message: isLumpsum
                          ? "You have no lumpsum investment orders in your cart."
                          : "You have no SIP or Step-Up orders in your cart. Go explore!",
                      icon: Icons.shopping_cart_outlined,
                    ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                Get.toNamed(AppRoutes.explorePage, id: kIsWeb ? 1 : null);
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

    // --- DESKTOP / WEB SINGLE CHECKOUT LAYOUT ---
    if (isDesktop) {
      return _buildDesktopCheckout(context, items);
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
              return CartItemCard(
                key: ValueKey(
                  items[index].id ?? items[index].schemeCode ?? index,
                ),
                index: index,
                itemEntity: items[index],
              );
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
                DistributionRemainderCard(),
                const SizedBox(height: 20),
                _buildRecentlyViewed(),
              ],
            ),
          ),
      ],
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
                    fontFamily: FontFamily.medium,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
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
                              fontFamily: FontFamily.medium,
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
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
  // 💻 WEB SINGLE CHECKOUT HELPERS
  // =========================================
  Widget _buildDesktopCheckout(
    BuildContext context,
    List<CartItemEntity> items,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          gradient: Ucolors.backgroundGradient,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Ucolors.primary.withOpacity(0.25),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.shopping_bag_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const Gap(14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Investment Checkout',
                              style: TextStyle(
                                fontFamily: FontFamily.medium,
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                                color: Ucolors.dark,
                                letterSpacing: -0.8,
                              ),
                            ),
                            const Gap(4),
                            Text(
                              '${items.length} fund${items.length == 1 ? '' : 's'} selected. Review details and complete payment on this page.',
                              style: TextStyle(
                                fontFamily: FontFamily.medium,
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(22),
                  _buildDesktopAmountCards(items),
                  const Gap(18),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Cart Items',
                              style: TextStyle(
                                fontFamily: FontFamily.medium,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Ucolors.dark,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Ucolors.primary.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                '${items.length} Items',
                                style: const TextStyle(
                                  fontFamily: FontFamily.medium,
                                  color: Ucolors.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(8),
                        ...List.generate(
                          items.length,
                          (index) => CartItemCard(
                            key: ValueKey(
                              items[index].id ??
                                  items[index].schemeCode ??
                                  index,
                            ),
                            index: index,
                            itemEntity: items[index],
                          ),
                        ),
                        DistributionRemainderCard(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Gap(24),
            Expanded(flex: 4, child: _buildWebCheckoutSummary(items)),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopAmountCards(List<CartItemEntity> items) {
    final sipTotal = _calculateSipTotal(items);
    final lumpsumTotal = _calculateLumpsumTotal(items);
    final payableAmount = sipTotal + lumpsumTotal;

    return Row(
      children: [
        Expanded(
          child: _AmountSummaryCard(
            title: 'SIP Total',
            amount: _formatAmount(sipTotal),
            icon: Icons.repeat_rounded,
            color: Ucolors.primary,
          ),
        ),
        const Gap(14),
        Expanded(
          child: _AmountSummaryCard(
            title: 'Lumpsum Total',
            amount: _formatAmount(lumpsumTotal),
            icon: Icons.bolt_rounded,
            color: const Color(0xFF8B5CF6),
          ),
        ),
        const Gap(14),
        Expanded(
          child: _AmountSummaryCard(
            title: 'Payable Now',
            amount: _formatAmount(payableAmount),
            icon: Icons.account_balance_wallet_rounded,
            color: Ucolors.success,
            highlighted: true,
          ),
        ),
      ],
    );
  }

  Widget _buildWebCheckoutSummary(List<CartItemEntity> items) {
    final sipTotal = _calculateSipTotal(items);
    final lumpsumTotal = _calculateLumpsumTotal(items);
    final payableAmount = sipTotal + lumpsumTotal;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Ucolors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  color: Ucolors.primary,
                  size: 22,
                ),
              ),
              const Gap(12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Summary',
                      style: TextStyle(
                        fontFamily: FontFamily.medium,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Ucolors.dark,
                      ),
                    ),
                    Gap(2),
                    Text(
                      'Complete payment without leaving cart',
                      style: TextStyle(
                        fontFamily: FontFamily.medium,
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(20),
          _CheckoutBreakupRow(
            label: 'SIP Investments',
            value: _formatAmount(sipTotal),
            icon: Icons.repeat_rounded,
          ),
          const Gap(10),
          _CheckoutBreakupRow(
            label: 'Lumpsum Investments',
            value: _formatAmount(lumpsumTotal),
            icon: Icons.bolt_rounded,
          ),
          const Gap(16),
          Divider(color: Colors.grey.shade200),
          const Gap(16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: Ucolors.backgroundGradient,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Ucolors.primary.withOpacity(0.25),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Overall Payable Amount',
                  style: TextStyle(
                    fontFamily: FontFamily.medium,
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.78),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(6),
                Text(
                  _formatAmount(payableAmount),
                  style: const TextStyle(
                    fontFamily: FontFamily.medium,
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: -1.0,
                  ),
                ),
              ],
            ),
          ),
          const Gap(22),
          const _InlinePaymentSection(),
          const Gap(18),
          const TermAndPolicy(term: 'By Proceeding I accept the '),
          const Gap(18),
          Obx(() {
            final isValid = controller.isCartValid1;
            return UElevatedBUtton(
              color: isValid ? Ucolors.primary : Colors.grey,
              height: 54,
              onPressed: isValid ? _handlePurchase : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_rounded, color: Colors.white, size: 17),
                  const Gap(8),
                  Text(
                    'Pay ${_formatAmount(payableAmount)}',
                    style: const TextStyle(
                      fontFamily: FontFamily.medium,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }),
          const Gap(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.verified_user_rounded, size: 14, color: Colors.grey),
              Gap(5),
              Text(
                'Payments are encrypted & secured',
                style: TextStyle(
                  fontFamily: FontFamily.medium,
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _calculateSipTotal(List<CartItemEntity> items) {
    return items.fold<int>(0, (sum, item) {
      final type = (item.transType ?? 'sip').toLowerCase();
      if (type == 'lumpsum') return sum;
      return sum + _cartItemPayableAmount(item);
    });
  }

  int _calculateLumpsumTotal(List<CartItemEntity> items) {
    return items.fold<int>(0, (sum, item) {
      final type = (item.transType ?? 'sip').toLowerCase();
      if (type != 'lumpsum') return sum;
      return sum + _cartItemPayableAmount(item);
    });
  }

  int _cartItemPayableAmount(CartItemEntity item) {
    if (item.amount != null && item.amount! > 0) return item.amount!;

    final type = (item.transType ?? 'sip').toLowerCase();
    if (type == 'lumpsum') {
      return _parseAmount(item.minLumpsum);
    }
    return _parseAmount(item.minSipAmount);
  }

  int _parseAmount(String? value, {int defaultVal = 0}) {
    if (value == null || value.isEmpty) return defaultVal;
    return double.tryParse(value)?.toInt() ?? defaultVal;
  }

  String _formatAmount(int value) {
    final text = value.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      final fromEnd = text.length - i;
      buffer.write(text[i]);
      if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
    }
    return '₹${buffer.toString()}';
  }
}

class _AmountSummaryCard extends StatelessWidget {
  const _AmountSummaryCard({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
    this.highlighted = false,
  });

  final String title;
  final String amount;
  final IconData icon;
  final Color color;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: highlighted ? color.withOpacity(0.08) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: highlighted ? color.withOpacity(0.25) : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: FontFamily.medium,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
                const Gap(4),
                Text(
                  amount,
                  style: TextStyle(
                    fontFamily: FontFamily.medium,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: color,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckoutBreakupRow extends StatelessWidget {
  const _CheckoutBreakupRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: Ucolors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, color: Ucolors.primary, size: 18),
        ),
        const Gap(10),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: FontFamily.medium,
              fontSize: 13,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: FontFamily.medium,
            fontSize: 15,
            color: Ucolors.dark,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _InlinePaymentSection extends StatefulWidget {
  const _InlinePaymentSection();

  @override
  State<_InlinePaymentSection> createState() => _InlinePaymentSectionState();
}

class _InlinePaymentSectionState extends State<_InlinePaymentSection> {
  final MfuController paymentController = Get.find<MfuController>();
  final PersonalisationController personalisationController =
      Get.find<PersonalisationController>();
  late final TextEditingController upiController;

  @override
  void initState() {
    super.initState();
    upiController = TextEditingController(text: paymentController.upiId.value);
  }

  @override
  void dispose() {
    upiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final banks = personalisationController.userData.value?.bankAccounts;
    final primaryBank = (banks != null && banks.isNotEmpty)
        ? banks.first
        : null;
    final bankName = primaryBank?.bankName ?? 'Saved Bank';
    final maskedAccount =
        primaryBank?.accountNumberEncrypted ?? '••••  ••••  1234';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Payment Mode',
          style: TextStyle(
            fontFamily: FontFamily.medium,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Ucolors.dark,
          ),
        ),
        const Gap(12),
        Obx(
          () => _CheckoutMethodSelectorRow(
            selected: paymentController.selectedMethod.value,
            onSelect: paymentController.selectMethod,
          ),
        ),
        const Gap(16),
        Obx(() {
          final method = paymentController.selectedMethod.value;
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 240),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.04),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
            child: method == 'upi'
                ? _CheckoutUpiPanel(
                    key: const ValueKey('checkout-upi'),
                    controller: paymentController,
                    textController: upiController,
                    bankName: bankName,
                    maskedAccount: maskedAccount,
                  )
                : _CheckoutNetBankingPanel(
                    key: const ValueKey('checkout-netbanking'),
                    bankName: bankName,
                    maskedAccount: maskedAccount,
                  ),
          );
        }),
      ],
    );
  }
}

class _CheckoutMethodSelectorRow extends StatelessWidget {
  const _CheckoutMethodSelectorRow({
    required this.selected,
    required this.onSelect,
  });

  final String selected;
  final void Function(String) onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _CheckoutMethodTab(
            label: 'UPI',
            icon: Icons.qr_code_2_rounded,
            isSelected: selected == 'upi',
            onTap: () => onSelect('upi'),
          ),
        ),
        const Gap(10),
        Expanded(
          child: _CheckoutMethodTab(
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

class _CheckoutMethodTab extends StatelessWidget {
  const _CheckoutMethodTab({
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          gradient: isSelected ? Ucolors.backgroundGradient : null,
          color: isSelected ? null : const Color(0xFFF7F8FC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Ucolors.primary : const Color(0xFFE7EAF3),
            width: 1.3,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Ucolors.primary.withOpacity(0.22),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 19,
              color: isSelected ? Colors.white : Colors.grey.shade600,
            ),
            const Gap(7),
            Text(
              label,
              style: TextStyle(
                fontFamily: FontFamily.medium,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckoutUpiPanel extends StatelessWidget {
  const _CheckoutUpiPanel({
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
      children: [
        _CheckoutPanelCard(
          child: _LinkedBankRow(
            icon: Icons.credit_card_rounded,
            bankName: bankName,
            maskedAccount: maskedAccount,
          ),
        ),
        const Gap(12),
        _CheckoutPanelCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter UPI ID',
                style: TextStyle(
                  fontFamily: FontFamily.medium,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Ucolors.dark,
                ),
              ),
              const Gap(10),
              Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textController,
                        onChanged: (value) {
                          controller.upiId.value = value;
                          controller.isVerified.value = false;
                        },
                        style: const TextStyle(
                          fontFamily: FontFamily.medium,
                          fontSize: 14,
                          color: Ucolors.dark,
                        ),
                        decoration: InputDecoration(
                          hintText: 'yourname@upi',
                          hintStyle: TextStyle(
                            fontFamily: FontFamily.medium,
                            color: Colors.grey.shade400,
                            fontSize: 13,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF6F7FB),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 13,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: controller.isVerified.value
                              ? const Icon(
                                  Icons.check_circle_rounded,
                                  color: Ucolors.success,
                                )
                              : null,
                        ),
                      ),
                    ),
                    const Gap(10),
                    if (!controller.isVerified.value)
                      GestureDetector(
                        onTap: controller.isVerifying.value
                            ? null
                            : controller.verifyUpi,
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            gradient: Ucolors.backgroundGradient,
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
                                : const Text(
                                    'Verify',
                                    style: TextStyle(
                                      fontFamily: FontFamily.medium,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const Gap(5),
              Text(
                'e.g. mobilenumber@upi, name@oksbi',
                style: TextStyle(
                  fontFamily: FontFamily.medium,
                  fontSize: 11,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CheckoutNetBankingPanel extends StatelessWidget {
  const _CheckoutNetBankingPanel({
    super.key,
    required this.bankName,
    required this.maskedAccount,
  });

  final String bankName;
  final String maskedAccount;

  @override
  Widget build(BuildContext context) {
    return _CheckoutPanelCard(
      child: _LinkedBankRow(
        icon: Icons.account_balance_rounded,
        bankName: bankName,
        maskedAccount: maskedAccount,
      ),
    );
  }
}

class _LinkedBankRow extends StatelessWidget {
  const _LinkedBankRow({
    required this.icon,
    required this.bankName,
    required this.maskedAccount,
  });

  final IconData icon;
  final String bankName;
  final String maskedAccount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Ucolors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: Ucolors.primary, size: 21),
        ),
        const Gap(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                bankName,
                style: const TextStyle(
                  fontFamily: FontFamily.medium,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Ucolors.dark,
                ),
              ),
              const Gap(2),
              Text(
                maskedAccount,
                style: TextStyle(
                  fontFamily: FontFamily.medium,
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(
            color: Ucolors.success.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'Linked',
            style: TextStyle(
              fontFamily: FontFamily.medium,
              color: Ucolors.success,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _CheckoutPanelCard extends StatelessWidget {
  const _CheckoutPanelCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFEFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE7EAF3)),
      ),
      child: child,
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
    this.isLoading = false,
  });

  final String? title;
  final String? buttonText;
  final Color? amountColor;
  final VoidCallback ontap;
  final String? amount;
  final String? goalAmount;
  final bool isValid;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: const BoxDecoration(color: Color(0xffE8F4FF)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title ?? 'Amount Payable',
                    style: UTextStyles.small.copyWith(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '₹ ${amount ?? 0}',
                    style: const TextStyle(
                      fontFamily: FontFamily.medium,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Ucolors.success,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: UElevatedBUtton(
                color: (isValid && !isLoading) ? Ucolors.primary : Colors.grey,
                onPressed: (isValid && !isLoading) ? ontap : null,
                child: Center(
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          buttonText ?? 'Purchase',
                          style: UTextStyles.buttonText,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartBottomBarWeb extends StatelessWidget {
  const CartBottomBarWeb({
    super.key,
    this.title,
    this.buttonText,
    this.amountColor,
    required this.ontap,
    this.amount,
    this.goalAmount,
    this.isValid = true,
    this.isLoading = false,
  });

  final String? title;
  final String? buttonText;
  final Color? amountColor;
  final VoidCallback ontap;
  final String? amount;
  final String? goalAmount;
  final bool isValid;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xffE8F4FF),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --- LEFT SIDE: Amount Details ---
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title ?? 'Amount Payable',
                    style: UTextStyles.small.copyWith(
                      fontSize: 14, // Slightly larger for readability on web
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹ ${amount ?? 0}',
                    style: TextStyle(
                      fontFamily: FontFamily.medium,
                      fontSize: 28, // Scaled up for desktop
                      fontWeight: FontWeight.w600,
                      color: Ucolors.success,
                    ),
                  ),
                ],
              ),
              // --- RIGHT SIDE: Purchase Button ---
              SizedBox(
                width: 250, // 🚀 Fixed width prevents comical stretching
                height: 52,
                child: UElevatedButtonWeb(
                  color: (isValid && !isLoading)
                      ? Ucolors.primary
                      : Colors.grey.shade400,
                  onPressed: (isValid && !isLoading) ? ontap : null,
                  child: Center(
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
                            buttonText ?? 'Purchase',
                            style: UTextStyles.buttonText.copyWith(
                              fontSize: 16,
                              color: Colors.white,
                            ),
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
                style: TextStyle(
                  fontFamily: FontFamily.medium,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
                                fontFamily: FontFamily.medium,
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
                              style: TextStyle(
                                fontFamily: FontFamily.medium,
                                fontSize: 14,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
        }),
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
                        child: Text(
                          'SIP',
                          style: TextStyle(
                            fontFamily: FontFamily.medium,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'lumpsum',
                        child: Text(
                          'Lumpsum',
                          style: TextStyle(
                            fontFamily: FontFamily.medium,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'stepup',
                        child: Text(
                          'Step Up',
                          style: TextStyle(
                            fontFamily: FontFamily.medium,
                            fontSize: 12,
                          ),
                        ),
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
                            style: const TextStyle(
                              fontFamily: FontFamily.medium,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      onChanged: (val) {
                        if (val != null) {
                          controller.updateCartItem(
                            itemId: widget.itemEntity.id!,
                            sipDay: int.parse(val),
                            frequency: null,
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
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }
                        final amount = int.tryParse(value) ?? 0;
                        if (amount < currentMinLimit) {
                          return 'Min ₹$currentMinLimit';
                        }
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
                        child: Text(
                          '6 Months',
                          style: TextStyle(
                            fontFamily: FontFamily.medium,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: '12',
                        child: Text(
                          'Yearly',
                          style: TextStyle(
                            fontFamily: FontFamily.medium,
                            fontSize: 12,
                          ),
                        ),
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
                                        fontFamily: FontFamily.medium,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
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
                                        fontFamily: FontFamily.medium,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
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
                            if (_debounce?.isActive ?? false) {
                              _debounce!.cancel();
                            }

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
                          if (value == null || value.trim().isEmpty) {
                            return 'Required';
                          }
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
                                      fontFamily: FontFamily.medium,
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
                                      fontFamily: FontFamily.medium,
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

                                if (!hasError) {
                                  if (_debounce?.isActive ?? false) {
                                    _debounce!.cancel();
                                  }
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
                                if (value == null || value.trim().isEmpty) {
                                  return 'Required';
                                }
                                final capAmt = int.tryParse(value) ?? 0;

                                final int minSip = _parseAmount(
                                  widget.itemEntity.minSipAmount,
                                );
                                final int minTopUp = _parseAmount(
                                  widget.itemEntity.minTopupAmount,
                                  defaultVal: 500,
                                );
                                final int absoluteMinCap = minSip + minTopUp;

                                if (capAmt <= absoluteMinCap) {
                                  return 'Must be > ₹$absoluteMinCap';
                                }
                                if (capAmt % 100 != 0) {
                                  return 'Multiple of ₹100';
                                }
                                return null;
                              },

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
                                        fontFamily: FontFamily.medium,
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

class InputBox extends StatelessWidget {
  final String label;
  final String value;

  const InputBox({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: FontFamily.medium,
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
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
            style: const TextStyle(
              fontFamily: FontFamily.medium,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class DistributionRemainderCard extends StatelessWidget {
  const DistributionRemainderCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();

    return Obx(() {
      final int remainder = controller.distributionRemainder.value;

      // Remainder 0 hai toh hide karo
      if (remainder == 0) return const SizedBox.shrink();

      final bool isExtra = remainder < 0; // assigned > total
      final bool isSaved = remainder > 0; // assigned < total

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isExtra ? const Color(0xFFFFF3F3) : const Color(0xFFF0FFF4),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isExtra ? Colors.red.shade200 : Colors.green.shade200,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isExtra ? Colors.red.shade50 : Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isExtra ? Icons.arrow_upward_rounded : Icons.savings_outlined,
                color: isExtra ? Colors.red : Colors.green,
                size: 18,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isSaved ? 'Unallocated Amount' : 'Amount Exceeded',
                    style: TextStyle(
                      fontFamily: FontFamily.medium,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isExtra
                          ? Colors.red.shade700
                          : Colors.green.shade700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isSaved
                        ? 'This amount ₹${remainder.abs()} remains undistributed'
                        : '₹${remainder.abs()} is above the minimum SIP requirement',
                    style: TextStyle(
                      fontFamily: FontFamily.medium,
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            Text(
              '${isSaved ? '+' : '-'}₹${remainder.abs()}',
              style: TextStyle(
                fontFamily: FontFamily.medium,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isExtra ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
      );
    });
  }
}
