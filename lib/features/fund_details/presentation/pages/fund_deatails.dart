import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/widget/animated/empty_filled.dart';
import 'package:my_sip/features/cart/presentation/controllers/cart_controller.dart';
import 'package:my_sip/features/wishlist/presentation/controller/wishlist_controller.dart';
import 'package:readmore/readmore.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../../../../common/widget/appbar/custom_appbar_normal.dart';
import '../../../../common/widget/appbar/widget/compact_icon.dart';
import '../../../../common/widget/images/custom_cached_image.dart';
import '../../../../common/widget/shimmer/shimmer.dart';
import '../../../../common/widget/table/table_header.dart';
import '../../../../common/widget/text/view_all.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/constant/colors.dart';
import '../../../../core/utils/constant/images.dart';
import '../../../../core/utils/constant/text_style.dart';
import '../../../dashboard/presentation/pages/comparison_screen.dart';
import '../../../dashboard/presentation/pages/dashboard.dart';
import '../controllers/fund_details_controller.dart';
import '../widgets/fund_performance_bar.dart';
import '../widgets/fund_performance_chart.dart';
import '../widgets/helper.dart';
import '../widgets/percentage_indicator.dart';
import '../widgets/return.dart';
import '../widgets/risk_indicator_ball.dart';
import '../widgets/schemeLineChart.dart';
import '../widgets/stock_allocation_items.dart';
import '../widgets/timeselecter.dart';

class FundDetailsScreen extends GetView<FundDetailsController> {
  static Map<String, dynamic>? navData;

  FundDetailsScreen({super.key});

  final CartController cartController = Get.find<CartController>();
  @override
  Widget build(BuildContext context) {
    final bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      backgroundColor: isDesktop ? const Color(0xFFF5F7FA) : Colors.grey[50],
      body: Obx(() {
        if (controller.isLoading.value)
          return _buildLoading(context, isDesktop);
        if (controller.hasError.value) return _buildError(context, isDesktop);
        if (controller.fundDetail.value?.riskStatisticsList.isEmpty ?? true) {
          return _buildEmpty(context, isDesktop);
        }

        return isDesktop
            ? _DesktopFundDetailsLayout(controller: controller)
            : _MobileFundDetailsLayout(controller: controller);
      }),
      bottomNavigationBar: isDesktop
          ? null
          : Obx(() {
              if (controller.isLoading.value || controller.hasError.value) {
                return const SizedBox.shrink();
              }
              return SafeArea(
                top: false,
                child:
                    controller.fundDetail.value!.riskStatisticsList.isNotEmpty
                    ? FundBottomBarButton(
                        firstButton: 'Lumpsum',
                        secondButton: 'Invest now',
                        firstButtonP: () async {
                          // await controller.addToCart(
                          //     entity.schemeCode ?? '',
                          //     entity.baseSchemeName ?? '',
                          //     entity.minSipAmount ?? 0,
                          //     null,
                          //   );
                          //   await controller.fetchCart();
                          await cartController.addToCart(
                            controller.schemeCode,
                            controller.schemeName,

                            controller.fundDetail.value?.minimumInvestment
                                    .toInt() ??
                                5000,
                            transType: 'lumpsum',

                            null,
                          );
                        },
                        secondButtonP: () async {
                          debugPrint(
                            "sip: ${controller.fundDetail.value?.sipMinimumAmount}",
                          );
                          await cartController.setInvestmentDetails(
                            code: controller.schemeCode,
                            name: controller.schemeName,
                            minAmount:
                                controller.fundDetail.value!.sipMinimumAmount,
                            fundDetailEntity: controller.fundDetail.value!, amcLogo:  controller.imgUrl,
                          );
                          Get.toNamed(
                            AppRoutes.investNow,
                            arguments: {
                              "investNow":
                                  controller.fundDetail.value?.sipMinimumAmount,
                            },
                          );

                          // await cartController.addToCart(
                          //   controller.schemeCode,
                          //   controller.schemeName,
                          //   controller.fundDetail.value?.sipMinimumAmount ??
                          //       1000,
                          //   transType: 'sip',
                          //
                          //   null,
                          // );
                          // Get.toNamed(AppRoutes.cart);
                        },
                      )
                    : const SizedBox.shrink(),
              );
            }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // floatingActionButton: isDesktop
      //     ? null
      //     : Obx(() {
      //         if (controller.isLoading.value || controller.hasError.value) {
      //           return const SizedBox.shrink();
      //         }
      //
      //         return Container(
      //           height: 48,
      //           width: 48,
      //           decoration: BoxDecoration(
      //             shape: BoxShape.circle,
      //             color: Colors.white,
      //             border: Border.all(color: Colors.grey.shade300, width: 1),
      //             boxShadow: [
      //               BoxShadow(
      //                 color: Colors.black.withOpacity(0.1),
      //                 blurRadius: 12,
      //                 offset: const Offset(0, 4),
      //               ),
      //             ],
      //           ),
      //           child: PopupMenuButton<int>(
      //             padding: EdgeInsets.zero,
      //             icon: const Icon(Icons.more_horiz, color: Ucolors.primary),
      //             offset: const Offset(0, -115),
      //             shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(12),
      //             ),
      //             color: Colors.white,
      //             elevation: 4,
      //             onSelected: (value) async {
      //               if (value == 0) {
      //                 await Get.find<WishlistController>().addToWishList(
      //                   controller.schemeCode.toString(),
      //                   controller.schemeName.toString(),
      //                 );
      //               } else if (value == 1) {
      //                 await cartController.addToCart(
      //                   controller.schemeCode,
      //                   controller.schemeName,
      //                   controller.fundDetail.value?.sipMinimumAmount ?? 1000,
      //                   transType: 'sip',
      //
      //                   null,
      //                 );
      //               }
      //             },
      //             itemBuilder: (context) => [
      //               PopupMenuItem(
      //                 value: 0,
      //                 child: Row(
      //                   children: [
      //                     Icon(
      //                       Icons.bookmark_border,
      //                       size: 20,
      //                       color: Colors.grey.shade800,
      //                     ),
      //                     const SizedBox(width: 12),
      //                     const Text(
      //                       'Add to Watchlist',
      //                       style: TextStyle(fontWeight: FontWeight.w500),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //               PopupMenuItem(
      //                 value: 1,
      //                 child: Row(
      //                   children: [
      //                     Icon(
      //                       Icons.shopping_cart_outlined,
      //                       size: 20,
      //                       color: Colors.grey.shade800,
      //                     ),
      //                     const SizedBox(width: 12),
      //                     const Text(
      //                       'Add to Cart',
      //                       style: TextStyle(fontWeight: FontWeight.w500),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             ],
      //           ),
      //         );
      //       }),
    );
  }

  Widget _buildLoading(BuildContext context, bool isDesktop) {
    if (isDesktop) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Ucolors.primary,
              ),
            ),
            const Gap(20),
            Text(
              'Loading fund details...',
              style: TextStyle(fontSize: 16, color: Ucolors.primary),
            ),
          ],
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        _buildAppBar(),
        SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Ucolors.primary),
                const Gap(16),
                Text(
                  'Loading fund details...',
                  style: TextStyle(color: Ucolors.darkgrey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildError(BuildContext context, bool isDesktop) {
    final errorWidget = Center(
      child: Container(
        padding: EdgeInsets.all(isDesktop ? 40 : 24),
        margin: EdgeInsets.all(isDesktop ? 24 : 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: isDesktop ? 64 : 48,
              color: Colors.red.shade400,
            ),
            Gap(isDesktop ? 20 : 16),
            Text(
              'Failed to load fund details',
              style: TextStyle(
                fontSize: isDesktop ? 20 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(8),
            Text(
              controller.errorMessage.value,
              style: TextStyle(
                fontSize: isDesktop ? 16 : 14,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            Gap(isDesktop ? 24 : 16),
            ElevatedButton.icon(
              onPressed: controller.retryFetchingDetails,
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 32 : 24,
                  vertical: isDesktop ? 16 : 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (isDesktop) return errorWidget;

    return CustomScrollView(
      slivers: [
        _buildAppBar(),
        SliverFillRemaining(child: errorWidget),
      ],
    );
  }

  Widget _buildEmpty(BuildContext context, bool isDesktop) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(isDesktop ? 40 : 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: isDesktop ? 80 : 64,
              color: Colors.grey.shade300,
            ),
            Gap(isDesktop ? 20 : 16),
            Text(
              "Data not available",
              style: TextStyle(
                fontSize: isDesktop ? 18 : 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      pinned: true,
      flexibleSpace: CustomAppBarNormal(
        backgroundColor: Ucolors.light,
        actionsPadding: 10,
        title: 'Fund Details',
        action: [
          // CompactIcon(
          //   icon: Iconsax.shopping_cart,
          //   onPressed: () => Get.toNamed(AppRoutes.cart),
          // ),
          Obx(() {
            final wishlistController = Get.find<WishlistController>();

            // Assuming controller is your Detail/Item controller
            final String code = controller.schemeCode;
            final String name = controller.schemeName;

            final bool isFav = wishlistController.isFavorite(code);

            return CompactIcon(
              icon: isFav ? Iconsax.heart5 : Iconsax.heart,
              iconColor: isFav ? Colors.red : Ucolors.darkgrey, // Using your Ucolors constant
              onPressed: () => wishlistController.toggleWishlist(code, name),
            );
          }),
          const SizedBox(width: 5),

          // CompactIcon(
          //   icon: Iconsax.archive_tick,
          //   onPressed: () => Get.toNamed(AppRoutes.watchlist),
          // ),
          const SizedBox(width: 5),
        ],
      ),
    );
  }
}

// ==========================================
// 💻 DESKTOP LAYOUT - No Tabs, Card Grid
// ==========================================
class _DesktopFundDetailsLayout extends StatelessWidget {
  final FundDetailsController controller;
  const _DesktopFundDetailsLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    final fund = controller.fundDetail.value;
    final bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Column(
      children: [
        // Desktop Header
        if (!isDesktop)
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                ),
                const Gap(16),
                Expanded(
                  child: Text(
                    "Fund Details",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Gap(16),
                IconButton(
                  onPressed: () => Get.toNamed(AppRoutes.watchlist),
                  icon: const Icon(Iconsax.archive_tick),
                ),
                const Gap(8),
                IconButton(
                  onPressed: () => Get.toNamed(AppRoutes.cart),
                  icon: const Icon(Iconsax.shopping_cart),
                ),
              ],
            ),
          ),

        // Main Content
        Expanded(
          child: SingleChildScrollView(
            controller: controller.scrollController,
            padding: const EdgeInsets.all(32),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1600),
                child: Column(
                  children: [
                    // Performance Section (Full Width)

                    // const Gap(32),

                    // Two Column Grid
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 20,
                      children: [
                        // LEFT COLUMN (60%)
                        Expanded(
                          flex: 6,
                          child: Column(
                            children: [
                              // Fund Header Card
                              _DesktopFundHeader(
                                fund: fund,
                                controller: controller,
                              ),
                              const Gap(24),
                              _DesktopPerformanceSection(
                                controller: controller,
                              ),
                              const Gap(24),
                              _DesktopOverviewCard(fund: fund),
                              const Gap(24),

                              // const Gap(24),
                            ],
                          ),
                        ),

                        // RIGHT COLUMN (40%)
                        Expanded(
                          flex: 4,
                          child: Column(
                            children: [
                              _DesktopQuickLookCard(fund: fund),
                              const Gap(24),
                              // const Gap(50),
                              _DesktopActionCard(fund: fund),
                              const Gap(24),

                              _DesktopAllocationCard(controller: controller),
                              const Gap(24),
                            ],
                          ),
                        ),
                      ],
                    ),
                    _DesktopReturnsCard(controller: controller),
                    const Gap(24),

                    const Gap(32),
                    _DesktopRiskCard(controller: controller),
                    const Gap(24),
                    _DesktopAboutCard(fund: fund),
                    const Gap(24),
                    _DesktopComparisonSection(controller: controller),
                    const Gap(24),
                    _DesktopInvestmentDetailsCard(fund: fund),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Desktop Header Card
class _DesktopFundHeader extends StatelessWidget {
  final dynamic fund;
  final FundDetailsController controller;

  const _DesktopFundHeader({required this.fund, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200, width: 2),
            ),
            child: ClipOval(
              child: CustomCachedImage(imageUrl: controller.imgUrl),
            ),
          ),
          const Gap(24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fund?.schemeName ?? '',
                  style: AppTextStyles.bodyLargeBold(color: Colors.black),
                ),
                const Gap(12),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    _buildBadge(
                      fund?.schemeCategory ?? 'Equity',
                      Ucolors.primary,
                    ),
                    _buildBadge(
                      fund?.riskometerValue ?? 'High',
                      _getRiskColor(fund?.riskometerValue ?? ''),
                    ),
                    _buildBadge('OPEN', Ucolors.success),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Color _getRiskColor(String risk) {
    final riskLower = risk.toLowerCase();
    if (riskLower.contains('very high')) return Ucolors.red;
    if (riskLower.contains('high')) return Colors.orange;
    if (riskLower.contains('moderate')) return Colors.yellow[700]!;
    if (riskLower.contains('low')) return Ucolors.success;
    return Ucolors.darkgrey;
  }
}

// Performance Section
class _DesktopPerformanceSection extends StatelessWidget {
  final FundDetailsController controller;

  const _DesktopPerformanceSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final fund = controller.fundDetail.value;

      return _DesktopCard(
        title: 'Performance Overview',
        child: Column(
          children: [
            // Stats Row
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade50, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'NAV',
                      '₹${fund?.nav.toStringAsFixed(2)}',
                      '',
                      Colors.blue.shade700,
                    ),
                  ),
                  Container(width: 1, height: 60, color: Colors.grey.shade200),
                  Expanded(
                    child: _buildStatCard(
                      'Returns (1Y)',
                      '${fund?.schemePerformanceList[0].oneYearReturn}',
                      '%',
                      Colors.green.shade700,
                    ),
                  ),
                  Container(width: 1, height: 60, color: Colors.grey.shade200),
                  Expanded(
                    child: _buildStatCard(
                      'Benchmark (1Y)',
                      '${fund?.navChangePercentage.toStringAsFixed(2)}',
                      '%',
                      Colors.green.shade700,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(24),

            // Chart
            Obx(() {
              final navEntity = controller.navHistorydata.value;
              if (controller.isNavHistoryLoading.value) {
                return const UShimmerEffect(
                  radius: 0,
                  width: double.infinity,
                  height: 280,
                );
              }
              if (controller.navHistoryHasError.value ||
                  navEntity == null ||
                  navEntity.data.isEmpty) {
                return Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 1. Modern Icon in a circular container
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons
                              .show_chart_rounded, // or Icons.bar_chart_rounded
                          size: 28,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 2. Clear Title
                      Text(
                        'Chart Unavailable',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // 3. Subtle Subtitle
                      Text(
                        'We couldn\'t fetch the NAV history right now.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // 4. Actionable Retry Button
                      TextButton.icon(
                        onPressed: () {
                          controller.getShcemeNavHistory(
                            scchemeCode: controller.schemeCode,
                            period: controller.selectedPeriod.value,
                          );
                        },
                        icon: Icon(
                          Icons.refresh_rounded,
                          size: 16,
                          color: Colors.blue.shade700,
                        ),
                        label: Text(
                          'Retry',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors
                                .blue
                                .shade700, // Change this to Ucolors.primary if you prefer
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor:
                              Colors.blue.shade50, // Subtle button background
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                );
              }
              // if (navEntity == null || navEntity.data.isEmpty) {
              //   return const SizedBox(
              //     height: 280,
              //     child: Center(child: Text('No Data Available')),
              //   );
              // }
              return SchemeLineChart(navData: navEntity.data);
            }),
            const Gap(16),
            const PeriodSelector(),
          ],
        ),
      );
    });
  }

  Widget _buildStatCard(
    String label,
    String value,
    String suffix,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Gap(8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            if (suffix.isNotEmpty)
              Text(
                suffix,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

// Overview Card
class _DesktopOverviewCard extends StatelessWidget {
  final dynamic fund;

  const _DesktopOverviewCard({required this.fund});

  @override
  Widget build(BuildContext context) {
    return _DesktopCard(
      title: 'Fund Overview',
      child: Column(
        children: [
          _buildInfoGrid([
            {'label': 'Min SIP', 'value': '₹ ${fund?.sipMinimumAmount}'},
            {'label': 'Min Lumpsum', 'value': '₹ ${fund?.minimumInvestment}'},
            {
              'label': 'Expense Ratio',
              'value': '${fund?.expenseRatioPercentage}%',
            },
            {'label': 'AUM', 'value': '₹ ${fund?.schemeAssets} Cr'},
            {'label': 'Lock In', 'value': 'No Lock-in'},
            {'label': 'Launch Date', 'value': '${fund?.schemeInceptionDate}'},
          ]),
          const Gap(20),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Exit Load:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const Gap(8),
                ReadMoreText(
                  fund?.exitLoad.toString() ?? '',
                  trimMode: TrimMode.Line,
                  trimLines: 2,
                  trimCollapsedText: 'Show More',
                  trimExpandedText: 'Show Less',
                  colorClickableText: Ucolors.primary,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoGrid(List<Map<String, dynamic>> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 7,
        crossAxisSpacing: 10,
        mainAxisSpacing: 25,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item['label'],
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            // const Gap(6),
            Text(
              item['value'],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade900,
              ),
            ),
          ],
        );
      },
    );
  }
}

// Returns Card
class _DesktopReturnsCard extends StatelessWidget {
  final FundDetailsController controller;

  const _DesktopReturnsCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final fund = controller.fundDetail.value;
      if (fund == null) return const SizedBox();

      final returnss = controller.buildTrailingReturns(fund);

      return _DesktopCard(
        title: 'Trailing Returns',
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Container(
                height: 44,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  labelColor: Colors.grey.shade900,
                  unselectedLabelColor: Colors.grey.shade600,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: const [
                    Tab(text: "Table"),
                    Tab(text: "Graph"),
                  ],
                ),
              ),
              const Gap(24),
              SizedBox(
                height: 450,
                child: TabBarView(
                  children: [
                    // Table View
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildTableHeader(),
                          const Divider(height: 1),
                          ...returnss.map((row) => ReturnsTableRow(data: row)),
                        ],
                      ),
                    ),
                    // Graph View
                    GroupedPerformanceBarChart(data: returnss),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(color: Colors.grey.shade50),
      child: Row(
        children: [
          const SizedBox(
            width: 120,
            child: Text(
              'Period',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
          ),
          const Expanded(
            child: Text(
              'Scheme',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
          ),
          const Expanded(
            child: Text(
              'Category',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
          ),
          const Expanded(
            child: Text(
              'Benchmark',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

// Risk Card
class _DesktopRiskCard extends StatelessWidget {
  final FundDetailsController controller;

  const _DesktopRiskCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final fund = controller.fundDetail.value;
      final risk = getRiskMeter(fund?.riskometerValue);
      final hasReturns = controller.yearlyReturns.isNotEmpty;

      if (fund == null) return const SizedBox();
      final data = controller.buildTrailingReturns(fund);
      return _DesktopCard(
        title: 'Risk Analysis',
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. LEFT SIDE: Yearly Returns (Only if data exists)
            if (hasReturns) ...[
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Yearly Returns',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const Gap(24),
                    // Give chart a fixed height or aspect ratio
                    SizedBox(
                      height: 300,
                      child: YearlyReturnsChart(yearlyData: data),
                    ),
                  ],
                ),
              ),
              // Spacer between the two columns
              const Gap(40),
              // Vertical Divider for visual separation (Optional)
              Container(width: 1, height: 300, color: Colors.grey.shade200),
              const Gap(40),
            ],

            // 2. RIGHT SIDE: Risk Meter
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Risk Level',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const Gap(24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [risk.color.withOpacity(0.08), Colors.white],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: risk.color.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 180, // Slightly reduced height for better fit
                          child: SfRadialGauge(
                            axes: [
                              RadialAxis(
                                minimum: 0,
                                maximum: 100,
                                showLabels: false,
                                showTicks: false,
                                startAngle: 180,
                                endAngle: 0,
                                radiusFactor: 0.9,
                                canScaleToFit: true,
                                axisLineStyle: const AxisLineStyle(
                                  thickness: 0.15,
                                  thicknessUnit: GaugeSizeUnit.factor,
                                  color: Colors.transparent,
                                ),
                                ranges: [
                                  GaugeRange(
                                    startValue: 0,
                                    endValue: 20,
                                    color: Colors.green,
                                    startWidth: 15,
                                    endWidth: 15,
                                  ),
                                  GaugeRange(
                                    startValue: 20,
                                    endValue: 40,
                                    color: Colors.lightGreen,
                                    startWidth: 15,
                                    endWidth: 15,
                                  ),
                                  GaugeRange(
                                    startValue: 40,
                                    endValue: 60,
                                    color: Colors.yellow,
                                    startWidth: 15,
                                    endWidth: 15,
                                  ),
                                  GaugeRange(
                                    startValue: 60,
                                    endValue: 80,
                                    color: Colors.orange,
                                    startWidth: 15,
                                    endWidth: 15,
                                  ),
                                  GaugeRange(
                                    startValue: 80,
                                    endValue: 100,
                                    color: Colors.red,
                                    startWidth: 15,
                                    endWidth: 15,
                                  ),
                                ],
                                pointers: [
                                  NeedlePointer(
                                    value: risk.needleValue.toDouble(),
                                    needleLength: 0.6,
                                    needleStartWidth: 1,
                                    needleEndWidth: 4,
                                    needleColor: Colors.black87,
                                    knobStyle: const KnobStyle(
                                      color: Colors.black87,
                                      knobRadius: 0.06,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Text(
                          risk.label,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: risk.color,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const Gap(8),
                        Text(
                          "Investors with high risk appetite",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(24),
                  // Legend
                  Center(
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: const [
                        RiskLegendItem(color: Colors.green, label: 'Very Low'),
                        RiskLegendItem(color: Colors.lightGreen, label: 'Low'),
                        RiskLegendItem(
                          color: Colors.yellow,
                          label: 'Moderate',
                        ), // Added Moderate for completeness
                        RiskLegendItem(
                          color: Colors.orange,
                          label: 'Medium',
                        ), // "Medium" often maps to "Moderately High" or distinct category
                        RiskLegendItem(color: Colors.redAccent, label: 'High'),
                        RiskLegendItem(color: Colors.red, label: 'Very High'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

// Action Card (CTA)
class _DesktopActionCard extends StatelessWidget {
  final dynamic fund;

  _DesktopActionCard({required this.fund});

  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Ucolors.primary, Ucolors.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Ucolors.primary.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Current NAV",
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Gap(8),
          Text(
            "₹ ${fund?.nav}",
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Gap(4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "${fund?.navChangePercentage}% (1D)",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          const Gap(28),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () =>
                  Get.find<FundDetailsController>().handleAddToCart(),
              // onPressed: () async {
              //   await cartController.addToCart(
              //     Get.find<FundDetailsController>().schemeCode,
              //     Get.find<FundDetailsController>().schemeName,
              //     Get.find<FundDetailsController>()
              //             .fundDetail
              //             .value
              //             ?.sipMinimumAmount ??
              //         1000,

              //     // fund.schemeCode ?? '',
              //     // fund.baseSchemeName ?? '',
              //     // fund.minSipAmount ?? 0,
              //     null,
              //   );
              //   // await cartController.fetchCart();

              //   Get.toNamed(AppRoutes.cart, id: 1);
              //   log('start sip');
              // },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Ucolors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Start SIP",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const Gap(12),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              // onPressed: () {
              //   log('lumpsum invest ');

              // },
              onPressed: () => Get.find<FundDetailsController>()
                  .handleAddToCart(isLumpsum: true),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white, width: 2),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Lumpsum Invest",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Quick Look Card
class _DesktopQuickLookCard extends StatelessWidget {
  final dynamic fund;

  const _DesktopQuickLookCard({required this.fund});

  @override
  Widget build(BuildContext context) {
    return _DesktopCard(
      title: 'Quick Look',
      child: Column(
        children: [
          _buildQuickStat('5Y CAGR', '20.23%', Colors.green.shade700),
          const Gap(20),
          _buildQuickStat(
            '5Y SIP Return',
            '${fund?.schemePerformanceList[0].fiveYearReturn}%',
            Colors.green.shade700,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}

// Allocation Card
class _DesktopAllocationCard extends StatelessWidget {
  final FundDetailsController controller;

  const _DesktopAllocationCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isPortfolioLoading.value) {
        return _DesktopCard(
          title: 'Fund Allocation',
          child: const SizedBox(
            height: 400,
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      }

      final entity = controller.portfolioAnalysis.value;
      final assetMap = entity?.assetAllocation ?? {};
      final assetList = assetMap.entries.where((e) => e.value > 0).toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      final mcap = entity?.mcapAllocation;
      final mcapList = [
        if ((mcap?.marketCapLargecapPercent ?? 0) > 0)
          MapEntry('Large Cap', mcap!.marketCapLargecapPercent),
        if ((mcap?.marketCapMidcapPercent ?? 0) > 0)
          MapEntry('Mid Cap', mcap!.marketCapMidcapPercent),
        if ((mcap?.marketCapSmallcapPercent ?? 0) > 0)
          MapEntry('Small Cap', mcap!.marketCapSmallcapPercent),
      ];

      return _DesktopCard(
        title: 'Fund Allocation',
        child: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              Container(
                height: 44,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  labelColor: Colors.grey.shade900,
                  unselectedLabelColor: Colors.grey.shade600,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: const [
                    Tab(text: "Assets"),
                    Tab(text: "Market Cap"),
                    Tab(text: "Holdings"),
                  ],
                ),
              ),
              const Gap(20),
              SizedBox(
                height: 500,
                child: TabBarView(
                  children: [
                    _buildPieChartTab(assetList, "Assets"),
                    _buildPieChartTab(mcapList, "Market\nCap"),
                    _buildTopHoldingsTab(controller),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildPieChartTab(
    List<MapEntry<String, double>> data,
    String centerText,
  ) {
    if (data.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    final colors = [
      Colors.indigo.shade900,
      Colors.blue.shade600,
      Colors.greenAccent.shade700,
      Colors.orangeAccent,
      Colors.purpleAccent,
      Colors.redAccent,
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 220,
            width: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    centerSpaceColor: Colors.grey.shade50,
                    sectionsSpace: 2,
                    centerSpaceRadius: 60,
                    sections: List.generate(data.length, (index) {
                      return PieChartSectionData(
                        showTitle: false,
                        value: data[index].value,
                        color: colors[index % colors.length],
                        radius: 50,
                      );
                    }),
                  ),
                ),
                Text(
                  centerText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const Gap(24),
          ...List.generate(data.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PercentageBar(
                title: data[index].key,
                percentage: data[index].value,
                color: colors[index % colors.length],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTopHoldingsTab(FundDetailsController controller) {
    final entity = controller.portfolioAnalysis.value;
    final names = entity?.schemePortfolioHoldingsNamesString ?? [];
    final values = entity?.schemePortfolioHoldingsValuesString ?? [];

    if (names.isEmpty || values.isEmpty) {
      return const Center(child: Text('No holdings data available'));
    }

    final count = names.length < values.length ? names.length : values.length;
    List<MapEntry<String, double>> holdings = [];

    for (int i = 0; i < count; i++) {
      String cleanName = _cleanStockName(names[i]);
      if (cleanName.isNotEmpty) {
        holdings.add(MapEntry(cleanName, values[i]));
      }
    }

    holdings.sort((a, b) => b.value.compareTo(a.value));
    final top5 = holdings.take(5).toList();

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Stock Name',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey,
                  ),
                ),
                const Text(
                  'Holding %',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...top5.map(
            (item) => StockAllocationItem(
              name: item.key,
              category: '',
              sector: '',
              percentage: item.value,
            ),
          ),
        ],
      ),
    );
  }

  String _cleanStockName(String raw) {
    final dateRegex = RegExp(r'\d{1,2}[/-]\d{1,2}[/-]\d{2,4}');
    final percentageRegex = RegExp(r'\d+(\.\d+)?\s*%');
    final faceValueRegex = RegExp(
      r'\s+(EQ|NEW|FV|RS\.?|RE\.?|Rs\.?|Re\.?)\b.*$',
      caseSensitive: false,
    );
    final punctuationRegex = RegExp(r'[()\[\]\-]');

    return raw
        .replaceAll(dateRegex, '')
        .replaceAll(percentageRegex, '')
        .replaceAll(faceValueRegex, '')
        .replaceAll(punctuationRegex, ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}

// About Card
class _DesktopAboutCard extends StatelessWidget {
  final dynamic fund;

  const _DesktopAboutCard({required this.fund});

  @override
  Widget build(BuildContext context) {
    final managers = parseFundManagers(fund?.schemeManager);

    return _DesktopCard(
      title: 'About This Fund',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReadMoreText(
            fund?.schemeObjective.toString() ?? '',
            trimMode: TrimMode.Line,
            trimLines: 3,
            trimCollapsedText: 'Show More',
            trimExpandedText: 'Show Less',
            colorClickableText: Ucolors.primary,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.grey.shade700,
            ),
          ),
          const Gap(24),
          const Text(
            'Fund Manager(s)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const Gap(16),
          if (managers.isNotEmpty)
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: managers
                  .map((name) => _buildManagerChip(name))
                  .toList(),
            )
          else
            Text(
              'No manager details available',
              style: TextStyle(color: Colors.grey.shade600),
            ),
        ],
      ),
    );
  }

  Widget _buildManagerChip(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.person, size: 18, color: Colors.blue.shade700),
          const Gap(8),
          Text(
            name,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

// Comparison Section
class _DesktopComparisonSection extends StatelessWidget {
  final FundDetailsController controller;

  const _DesktopComparisonSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final fund = controller.fundDetail.value;
      if (fund == null || fund.schemePeerComparisonList.isEmpty) {
        return const SizedBox();
      }

      return _DesktopCard(
        title: 'Fund Comparison',
        child: SizedBox(
          height: MediaQuery.of(context).size.height < 700 ? 182 : 267,

          child: ListView.builder(
            // itemCount: 10,
            itemCount: fund!.schemePeerComparisonList.length - 1,
            scrollDirection: Axis.horizontal,

            itemBuilder: (context, index) => SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: GestureDetector(
                onTap: () {
                  log('${fund.schemeName}--------------------');
                  log('${controller.imgUrl}--------------------');
                  log('tap fund comapare');
                  Get.toNamed(
                    AppRoutes.comparefund,

                    // arguments: {
                    //   'name': fund.schemeName,
                    //   'name2':
                    //       fund.schemePeerComparisonList[index + 1].schemeName,
                    // },
                    arguments: {
                      'name': controller.schemeName,
                      'imgUrl': controller.imgUrl,
                      'name2':
                          fund.schemePeerComparisonList[index + 1].schemeName,
                    },
                  );
                },
                child: CustomContainer(
                  bottomPadding: 8,
                  topPadding: 15,
                  child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      FundComparisonItem(
                        imgUrl: controller.imgUrl,
                        fund1: fund?.schemeName,
                        year: fund?.schemePerformanceList[0].threeYearReturn
                            .toString(),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          // Left dashed line
                          Expanded(
                            child: DashedLine(color: Colors.grey.shade300),
                          ),

                          // VS circlef
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.blue,
                                width: 1.5,
                              ),
                            ),
                            child: const Text(
                              'VS',
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          // Right dashed line
                          Expanded(
                            child: DashedLine(color: Colors.grey.shade300),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),

                      FundComparisonItem(
                        year: fund
                            .schemePeerComparisonList[index + 1]
                            .threeYearReturn
                            .toString(),
                        fund1: fund
                            ?.schemePeerComparisonList[index + 1]
                            .schemeName
                            .toString(),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          // horizontal: 60.0,
                          vertical: 15,
                        ),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Ucolors.primary.withOpacity(0.5),
                            ),
                          ),
                          // onPressed: () => Get.toNamed(AppRoutes.comparefund ),
                          onPressed: null,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Compare Funds',
                                style: UTextStyles.buttonText.copyWith(
                                  // color: Ucolors.primary.withOpacity(0.5),
                                  color: Ucolors.primary,
                                ),
                              ),
                              SizedBox(width: 10),
                              Icon(
                                Icons.arrow_forward,
                                color: Ucolors.primary.withOpacity(0.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildComparisonStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        const Gap(4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}

// Investment Details Card
class _DesktopInvestmentDetailsCard extends StatelessWidget {
  final dynamic fund;

  const _DesktopInvestmentDetailsCard({required this.fund});

  @override
  Widget build(BuildContext context) {
    return _DesktopCard(
      title: 'Investment Details',
      child: Column(
        children: [
          _buildDetailRow('Fund Size', '₹${fund?.schemeAssets} Cr.'),
          const Divider(height: 32),
          _buildDetailRow('Min. Investment', '₹${fund?.minimumInvestment}'),
          const Divider(height: 32),
          _buildDetailRow('Min. SIP Investment', '₹${fund?.sipMinimumAmount}'),
          const Divider(height: 32),
          _buildDetailRow('Min. Topup', '₹${fund?.minimumTopup}'),
          const Divider(height: 32),
          _buildDetailRow('Expense Ratio', '${fund?.expenseRatioPercentage}%'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

// Reusable Desktop Card
class _DesktopCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? action;

  const _DesktopCard({required this.title, required this.child, this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (action != null) action!,
            ],
          ),
          const Gap(20),
          child,
        ],
      ),
    );
  }
}

// Helper function
List<String> parseFundManagers(String? managerString) {
  if (managerString == null || managerString.isEmpty) return [];
  return managerString
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();
}

// ==========================================
// 📱 MOBILE LAYOUT (Keep your original)
// ==========================================

class _MobileFundDetailsLayout extends StatelessWidget {
  final FundDetailsController controller;
  const _MobileFundDetailsLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: controller.scrollController,
      slivers: [
        _buildAppBar(),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        _buildFundHeader(context),
        const SliverToBoxAdapter(child: SizedBox(height: 10)),

        GetBuilder<FundDetailsController>(
          id: 'tabs',
          builder: (controller) => SliverPersistentHeader(
            pinned: true,
            delegate: SliverPageTabs(
              selectedIndex: controller.tabController.index,
              onTap: (index) => controller.scrollToIndex(index),
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: OverviewScreen(
              overViewKey: controller.overViewKey,
              returnsKey: controller.returnsKey,
              riskKey: controller.riskKey,
              portfolioKey: controller.portfolioKey,
              infoKey: controller.infoKey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      pinned: true,
      flexibleSpace: CustomAppBarNormal(
        backgroundColor: Ucolors.light,
        actionsPadding: 10,
        title: 'Fund Details',
        action: [
          // Obx(
          //   () => Stack(
          //     children: [
          //       CompactIcon(
          //         icon: Iconsax.shopping_cart,
          //         onPressed: () {
          //           Get.find<CartController>().filterGoalId.value = null;
          //           Get.toNamed(AppRoutes.cart);
          //         },
          //         iconColor: Ucolors.dark,
          //       ),
          //       if (Get.find<CartController>().generalItemsCount > 0)
          //         Positioned(
          //           right: 0,
          //           top: -5,
          //           child: Container(
          //             padding: const EdgeInsets.all(5),
          //             decoration: const BoxDecoration(
          //               color: Ucolors.red,
          //               shape: BoxShape.circle,
          //             ),
          //             child: Text(
          //               Get.find<CartController>().generalItemsCount.toString(),
          //               style: UTextStyles.buttonText.copyWith(fontSize: 10),
          //             ),
          //           ),
          //         ),
          //     ],
          //   ),
          // ),

          const SizedBox(width: 8),

          Obx(() {
            final wishlistController = Get.find<WishlistController>();

            // Assuming controller is your Detail/Item controller
            final String code = controller.schemeCode;
            final String name = controller.schemeName;

            final bool isFav = wishlistController.isFavorite(code);

            return CompactIcon(
              icon: isFav ? Iconsax.heart5 : Iconsax.heart,
              iconColor: isFav ? Colors.red : Ucolors.darkgrey, // Using your Ucolors constant
              onPressed: () => wishlistController.toggleWishlist(code, name),
            );
          }),
          // CompactIcon(
          //   icon: Iconsax.archive_tick,
          //   onPressed: () => Get.toNamed(AppRoutes.watchlist),
          // ),
          const SizedBox(width: 5),
        ],
      ),
    );
  }

  Widget _buildFundHeader(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      sliver: SliverToBoxAdapter(
        child: Obx(() {
          final fund = controller.fundDetail.value;
          final bool isOpen = fund?.schemeStatus == 'Open Ended Schemes';

          return Card(
            elevation: 0, // Lower elevation + Border is more modern
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: Colors.grey.shade200,
                width: 1,
              ), // Clean border
            ),
            color: Ucolors.light,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Logo and Name Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey.shade100,
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: CustomCachedImage(
                            imageUrl: controller.imgUrl,
                            height: 48,
                            width: 48,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fund?.schemeName ?? 'Loading Fund Name...',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.w700,
                                    height: 1.2,
                                    color: Colors.black87,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              fund?.schemeCategory ?? 'Mutual Fund',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                _buildModernBadge(
                                  label: fund?.riskometerValue ?? 'High Risk',
                                  color: _getRiskColor(
                                    fund?.riskometerValue ?? '',
                                  ),
                                  icon: Icons.speed_rounded,
                                ),
                                const SizedBox(width: 10),
                                _buildModernBadge(
                                  label: isOpen ? 'OPEN' : 'CLOSED',
                                  color: isOpen ? Ucolors.success : Ucolors.red,
                                  icon: Icons.lens,
                                  isDot: true,
                                ),
                                const Spacer(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildModernBadge({
    required String label,
    required Color color,
    IconData? icon,
    bool isDot = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isDot)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Icon(Icons.circle, size: 8, color: color),
            )
          else if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Icon(icon, size: 14, color: color),
            ),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
  // Widget _buildFundHeader(BuildContext context) {
  //   return SliverPadding(
  //     padding: const EdgeInsets.symmetric(horizontal: 20),
  //     sliver: SliverToBoxAdapter(
  //       child: Obx(() {
  //         final fund = controller.fundDetail.value;
  //         return Column(
  //           children: [
  //             Row(
  //               children: [
  //                 ClipOval(
  //                   child: CustomCachedImage(imageUrl: controller.imgUrl),
  //                 ),
  //                 const SizedBox(width: 10),
  //                 Expanded(
  //                   child: Text(
  //                     fund?.schemeName ?? '',
  //                     maxLines: 2,
  //                     overflow: TextOverflow.ellipsis,
  //                     style: Theme.of(context).textTheme.bodyLarge!.copyWith(
  //                       fontWeight: FontWeight.w600,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             const SizedBox(height: 12),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               children: [
  //                 _metaText(fund?.schemeCategory ?? 'Equity'),
  //                 _dot(),
  //                 _metaText(
  //                   fund?.riskometerValue.toUpperCase() ?? 'Very High',
  //                   color: _getRiskColor(fund?.riskometerValue ?? ''),
  //                 ),
  //                 _dot(),
  //                 _metaText('STATUS:'),
  //                 _metaText(
  //                   fund?.schemeStatus.toUpperCase().split(" ")[0] ?? 'Open',
  //                   color: (fund?.schemeStatus == 'Open Ended Schemes')
  //                       ? Ucolors.success
  //                       : Ucolors.red,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ],
  //             ),
  //           ],
  //         );
  //       }),
  //     ),
  //   );
  // }

  Color _getRiskColor(String risk) {
    final riskLower = risk.toLowerCase();
    if (riskLower.contains('very high')) return Ucolors.red;
    if (riskLower.contains('high')) return Colors.orange;
    if (riskLower.contains('moderate')) return Colors.yellow[700]!;
    if (riskLower.contains('low')) return Ucolors.success;
    return Ucolors.darkgrey;
  }
}

class OverviewScreen extends GetView<FundDetailsController> {
  final GlobalKey overViewKey;
  final GlobalKey returnsKey;
  final GlobalKey riskKey;
  final GlobalKey portfolioKey;
  final GlobalKey infoKey;
  const OverviewScreen({
    super.key,
    required this.overViewKey,
    required this.returnsKey,
    required this.riskKey,
    required this.portfolioKey,
    required this.infoKey,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size;
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Obx(() {
      final fund = controller.fundDetail.value;

      final managers = parseFundManagers(fund?.schemeManager);
      final portfolio = controller.portfolioAnalysis.value;
      // Sector Data (Lists)

      final risk = getRiskMeter(fund?.riskometerValue);

      return Column(
        children: [
          CustomContainer(
            topPadding: 15,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StatItem1(
                      title: 'Nav',
                      amount: '₹${fund?.nav.toStringAsFixed(2)}',
                      percentage: '',
                    ),
                    StatItem1(
                      title: 'Returns (1Y)',
                      amount:
                          fund?.schemePerformanceList[0].oneYearReturn
                              .toString() ??
                          '',
                      amountColor: Ucolors.success,

                      percentage: '%',
                    ),
                    StatItem1(
                      title: 'BenchMark (1Y)',
                      amount:
                          fund?.navChangePercentage.toStringAsFixed(2) ?? '',
                      percentage: '%',
                      amountColor: Ucolors.success,
                    ),
                  ],
                ),
                // SchemeLineChart(),
                // Inside your screen/view
                Obx(() {
                  final navEntity = controller.navHistorydata.value;

                  // if (controller.isNavHistoryLoading.value) {
                  //   return UShimmerEffect(
                  //     radius: 0,
                  //     width: double.infinity,
                  //     height: 220,
                  //   );
                  // }

                  // // Check if data is loaded
                  // if (controller.navHistoryHasError.value ||
                  //     navEntity == null ||
                  //     navEntity.data.isEmpty) {
                  //   return SizedBox(
                  //     height: 220,
                  //     child: Center(child: Text('Chart Data Unavailable')),
                  //   );
                  // }
                  // Check if data is loaded
                  if (controller.navHistoryHasError.value ||
                      navEntity == null ||
                      navEntity.data.isEmpty) {
                    return Container(
                      height: 220,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 1. Modern Icon in a circular container
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons
                                  .show_chart_rounded, // or Icons.bar_chart_rounded
                              size: 28,
                              color: Colors.grey.shade400,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // 2. Clear Title
                          Text(
                            'Chart Unavailable',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 4),

                          // 3. Subtle Subtitle
                          Text(
                            'We couldn\'t fetch the NAV history right now.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // 4. Actionable Retry Button
                          TextButton.icon(
                            onPressed: () {
                              controller.getShcemeNavHistory(
                                scchemeCode: controller.schemeCode,
                                period: controller.selectedPeriod.value,
                              );
                            },
                            icon: Icon(
                              Icons.refresh_rounded,
                              size: 16,
                              color: Colors.blue.shade700,
                            ),
                            label: Text(
                              'Retry',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors
                                    .blue
                                    .shade700, // Change this to Ucolors.primary if you prefer
                              ),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors
                                  .blue
                                  .shade50, // Subtle button background
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return SchemeLineChart(
                    navData: navEntity.data.reversed.toList(),
                  );
                }),
                const Gap(12),
                const PeriodSelector(),
              ],
            ),
          ),

          // --- Fund Overview Section ---
          const Gap(8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Ucolors.light,
                border: Border.all(color: Ucolors.borderColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    key: overViewKey,
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: const USectionHeading(
                      title: 'Fund Overview',
                      showActionButton: false,
                    ),
                  ),
                  _twoColumnRow(
                    leftTitle: 'Min SIP',
                    leftValue: '₹ ${fund?.sipMinimumAmount.toString()}',
                    rightTitle: 'Min lumpsum',
                    rightValue: '₹ ${fund?.minimumInvestment.toString()}',
                  ),
                  const SizedBox(height: 10),
                  _twoColumnRow(
                    leftTitle: 'Expense Ratio',
                    leftValue: '${fund?.expenseRatioPercentage.toString()}%',
                    rightTitle: 'AUM',
                    rightValue: '₹ ${fund?.schemeAssets.toString()} Cr',
                  ),
                  const SizedBox(height: 10),
                  _twoColumnRow(
                    leftTitle: 'Lock In',
                    leftValue: 'No Lock-in',
                    rightTitle: 'Launch Date',
                    rightValue: fund?.schemeInceptionDate.toString() ?? '',
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Exit Load:',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  ReadMoreText(
                    fund?.exitLoad.toString() ??
                        '', // 'Nippon India Large Cap Fund – Growth charges 1.0% of sell value; if fund sold before 7 days. There are no other charges.',
                    trimMode: TrimMode.Line,
                    trimLines: 1,
                    trimCollapsedText: 'Show More',
                    trimExpandedText: 'Show Less',
                    colorClickableText: Ucolors.primary,
                  ),
                ],
              ),
            ),
          ),
          const Gap(8),
          CustomContainer(
            topPadding: 15,
            bottomPadding: 15,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: const USectionHeading(
                    title: 'Quick look',
                    showActionButton: false,
                  ),
                ),
                _twoColumnRow(
                  leftTitle: '5Y CAGR',
                  color: Ucolors.success,
                  leftValue: '20.23%',
                  rightTitle: '5Y SIP Return',
                  rightValue:
                      '${fund?.schemePerformanceList[0].fiveYearReturn.toString()} %',
                  color2: Ucolors.success,
                ),
              ],
            ),
          ),
          const Gap(8),

          // Obx(() {
          //   final fund = controller.fundDetail.value;
          //   if (fund == null) return SizedBox();

          //   final returnss = controller.buildTrailingReturns(fund);
          //   return CustomContainer(
          //     child: Column(
          //       children: [
          //         // returnsTableHeader(),
          //         SizedBox(height: 20),
          //         GroupedPerformanceBarChart(data: returnss),
          //         SizedBox(height: 20), // <--- Pass your list here
          //         TableHeader(
          //           heading1: 'Period',
          //           heading2: 'Scheme',
          //           heading3: 'Category',
          //           heading4: 'Benchmark',
          //         ),
          //         DashedLine(color: Colors.grey.shade200),

          //         ...returnss.map((row) => ReturnsTableRow(data: row)),
          //       ],
          //     ),
          //   );
          // }),
          Obx(() {
            final fund = controller.fundDetail.value;
            if (fund == null) return const SizedBox();

            final returnss = controller.buildTrailingReturns(fund);

            return CustomContainer(
              topPadding: 15,
              bottomPadding: 15,
              child: DefaultTabController(
                length: 2, // 1. Graph, 2. Table
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      key: returnsKey,
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: const USectionHeading(
                        title: 'Trailing Returns',
                        showActionButton: false,
                      ),
                    ),
                    // Pill Tab Bar
                    Container(
                      height: 35,
                      // width: 160,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(25),
                        // border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TabBar(
                        indicator: BoxDecoration(
                          color: Ucolors.primary,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.grey.shade600,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        dividerColor: Colors.transparent,
                        indicatorSize: TabBarIndicatorSize.tab,
                        padding: EdgeInsets.zero,
                        labelPadding: EdgeInsets.zero,
                        tabs: const [
                          Tab(text: "Table"),
                          Tab(text: "Graph"),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // --- TAB VIEW CONTENT ---
                    SizedBox(
                      height:
                          300, // Fixed height to accommodate the larger view (Table)
                      child: TabBarView(
                        children: [
                          // TAB 2: Graph VIEW
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                TableHeader(
                                  heading1: 'Period',
                                  heading2: 'Scheme',
                                  heading3: 'Category',
                                  heading4: 'Benchmark',
                                ),
                                DashedLine(color: Colors.grey.shade200),
                                ...returnss.map(
                                  (row) => ReturnsTableRow(data: row),
                                ),
                              ],
                            ),
                          ),
                          // TAB 1: Table VIEW
                          Padding(
                            padding: const EdgeInsets.only(bottom: 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GroupedPerformanceBarChart(data: returnss),
                                const SizedBox(height: 4),
                                Text(
                                  "Returns vs Benchmark",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          const Gap(8),
          CustomContainer(
            topPadding: 15,
            bottomPadding: 4,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: const USectionHeading(
                    title: 'Fund Performance',
                    showActionButton: false,
                  ),
                ),
                SizedBox(
                  height: isDesktop ? 500 : 300,
                  // child: ReturnsBarChart(data: yearlyData),
                  // child: ,
                  child: Obx(() {
                    final fund = controller.fundDetail.value;
                    if (fund == null) return const SizedBox();
                    final data = controller.buildTrailingReturns(fund);
                    if (data.isEmpty) {
                      return const CircularProgressIndicator(); // or loader
                    }
                    return YearlyReturnsChart(yearlyData: data);
                  }),
                ),
              ],
            ),
          ),

          // --- Risk Analysis Section ---
          const Gap(8),
          CustomContainer(
            topPadding: 15,
            bottomPadding: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  key: riskKey,
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: const USectionHeading(
                    title: 'Risk Analysis',
                    showActionButton: false,
                  ),
                ),
                // Gap(15),
                _twoColumnRow(
                  leftTitle: 'Risk-o-Meter',
                  leftValue: fund?.riskometerValue.toString() ?? '',
                  // leftValue: risk.label,
                  rightTitle: 'Volatile',
                  rightValue:
                      fund?.riskStatisticsList[0].volatilityCm3Year
                          .toString() ??
                      '',

                  color: risk.color,
                ),
                Gap(10),
                _twoColumnRow(
                  leftTitle: 'Shape Ratio:',
                  leftValue:
                      fund?.riskStatisticsList[0].sharpeRatioCm3Year
                          .toString() ??
                      '',
                  rightTitle: 'Beta',
                  rightValue:
                      fund?.riskStatisticsList[0].beteCm1Y.toString() ?? '',
                ),
                Gap(12),
                DashedLine(color: Colors.grey.shade400),

                SpeedometerGauge(
                  value: risk.needleValue.toDouble(),
                  scrollController: controller.scrollController,
                ), // Updated to show high risk
                Text(
                  'Your Principle Will be at:',
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 3),
                Text(
                  fund?.riskometerValue.toString() ?? '',
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    fontWeight: FontWeight.bold,

                    color: risk.color,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Suitable for aggressive investors and investors with very high-risk tolerance.',
                  textAlign: TextAlign.center,
                  style: UTextStyles.small.copyWith(color: Ucolors.darkgrey),
                ),
                const Gap(8),
                DashedLine(color: Colors.grey.shade400),
                Gap(8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RiskLegendItem(color: Colors.green, label: 'Very Low'),
                        SizedBox(height: 8),
                        RiskLegendItem(color: Colors.orange, label: 'Medium'),
                        SizedBox(height: 8),
                        RiskLegendItem(color: Colors.redAccent, label: 'High'),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RiskLegendItem(color: Colors.lightGreen, label: 'Low'),
                        SizedBox(height: 8),
                        RiskLegendItem(
                          color: Colors.amber,
                          label: 'Moderate High',
                        ),
                        SizedBox(height: 8),
                        RiskLegendItem(color: Colors.red, label: 'Very High'),
                      ],
                    ),
                  ],
                ),
                Gap(8),
              ],
            ),
          ),

          const Gap(8),
          CustomContainer(
            topPadding: 15,
            bottomPadding: 4,
            child: Column(
              children: [
                Padding(
                  key: portfolioKey,
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                  child: const USectionHeading(
                    title: 'Fund Allocation',
                    showActionButton: false,
                  ),
                ),
                Builder(
                  builder: (context) {
                    // 1. Get Data
                    final entity = controller.portfolioAnalysis.value;

                    // --- Data Set A: Assets ---
                    final assetMap = entity?.assetAllocation ?? {};
                    final assetList =
                        assetMap.entries.where((e) => e.value > 0).toList()
                          ..sort((a, b) => b.value.compareTo(a.value));

                    // --- Data Set B: Market Cap ---
                    final mcap = entity?.mcapAllocation;
                    final mcapList = [
                      if ((mcap?.marketCapLargecapPercent ?? 0) > 0)
                        MapEntry('Large Cap', mcap!.marketCapLargecapPercent),
                      if ((mcap?.marketCapMidcapPercent ?? 0) > 0)
                        MapEntry('Mid Cap', mcap!.marketCapMidcapPercent),
                      if ((mcap?.marketCapSmallcapPercent ?? 0) > 0)
                        MapEntry('Small Cap', mcap!.marketCapSmallcapPercent),
                    ];

                    // 2. Loading State
                    if (controller.isPortfolioLoading.value) {
                      return const SizedBox(
                        height: 250,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    // 3. Define the Reusable Chart Widget (Local Function)
                    Widget buildAllocationTab(
                      List<MapEntry<String, double>> data,
                      String centerText,
                    ) {
                      // if (data.isEmpty) {
                      //   return const Center(child: Text("No data available"));
                      // }
                      if (data.isEmpty) {
                        return AnimatedEmptyState(
                          icon: Iconsax.ghost,

                          title: 'No Market Cap Data',
                          message:
                              'The AMC hasnt disclosed the Market Cap for this fund, or it may not be applicable to this scheme',
                        ); // <-- So much cleaner!
                      }

                      final List<Color> colors = [
                        Colors.indigo.shade600,
                        Colors.blue.shade600,
                        Colors.greenAccent.shade700,
                        Colors.orangeAccent,
                        Colors.purpleAccent,
                        Colors.redAccent,
                      ];

                      return SingleChildScrollView(
                        padding: const EdgeInsets.only(top: 20, bottom: 10),
                        child: Column(
                          children: [
                            // --- PIE CHART ---
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  height: 200,
                                  width: 200,
                                  child: PieChart(
                                    PieChartData(
                                      centerSpaceColor: Colors.grey.shade200,
                                      sectionsSpace: 0,
                                      centerSpaceRadius: 50,
                                      sections: List.generate(data.length, (
                                        index,
                                      ) {
                                        return PieChartSectionData(
                                          showTitle: false,
                                          value: data[index].value,
                                          color: colors[index % colors.length],
                                          radius: 40,
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                                // Center Text
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      centerText,
                                      style: UTextStyles.medium.copyWith(
                                        color: Ucolors.dark,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Gap(8),
                            // --- LEGEND LIST ---
                            ...List.generate(data.length, (index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: marketCapPercentage(
                                  data[index].key,
                                  '${data[index].value.toStringAsFixed(2)}%',
                                  colors[index % colors.length],
                                ),
                              );
                            }),
                          ],
                        ),
                      );
                    }

                    // 4. Return the Tabbed UI
                    return DefaultTabController(
                      length: 2, // Two Tabs
                      child: Column(
                        children: [
                          // const Gap(4),
                          // --- TAB BAR ---
                          // Container(
                          //   height: 35,
                          //   decoration: BoxDecoration(
                          //     color: Colors.grey.shade100,
                          //     borderRadius: BorderRadius.circular(25),
                          //   ),
                          //   child: TabBar(
                          //     indicator: BoxDecoration(
                          //       color: Ucolors.primary, // Active Color
                          //       borderRadius: BorderRadius.circular(25),
                          //     ),
                          //     labelColor: Colors.white,
                          //     unselectedLabelColor: Colors.grey.shade600,
                          //     labelStyle: const TextStyle(
                          //       fontWeight: FontWeight.w600,
                          //       fontSize: 13,
                          //     ),
                          //     dividerColor:
                          //         Colors.transparent, // Remove underline
                          //     indicatorSize: TabBarIndicatorSize.tab,
                          //     tabs: const [
                          //       Tab(text: "Asset Allocation"),
                          //       Tab(text: "Market Cap"),
                          //     ],
                          //   ),
                          // ),
                          Container(
                            height: 35,
                            // width: 160,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(25),
                              // border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: TabBar(
                              indicator: BoxDecoration(
                                color: Ucolors.primary,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              labelColor: Colors.white,
                              unselectedLabelColor: Colors.grey.shade600,
                              labelStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                              dividerColor: Colors.transparent,
                              indicatorSize: TabBarIndicatorSize.tab,
                              padding: EdgeInsets.zero,
                              labelPadding: EdgeInsets.zero,
                              tabs: const [
                                Tab(text: "Asset Allocation"),
                                Tab(text: "Market Cap"),
                              ],
                            ),
                          ),

                          const Gap(10),
                          Divider(color: Colors.grey.shade200),

                          // --- TAB VIEWS ---
                          SizedBox(
                            height: 340, // Fixed height for the content area
                            child: TabBarView(
                              children: [
                                // Tab 1: Asset Allocation
                                buildAllocationTab(assetList, "Assets"),

                                // Tab 2: Market Cap
                                buildAllocationTab(mcapList, "Market\nCap"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                DashedLine(dashSpace: 0, color: Colors.grey.shade200),
                Gap(20),

                DefaultTabController(
                  animationDuration: Duration(milliseconds: 200),

                  length: 2,

                  child: Column(
                    children: [
                      // Container(
                      //   height: 40,
                      //   decoration: BoxDecoration(
                      //     color: Colors.grey.shade100,
                      //     borderRadius: BorderRadius.circular(25),
                      //   ),
                      //   child: TabBar(
                      //     indicator: BoxDecoration(
                      //       color: Ucolors.primary, // Active Color
                      //       borderRadius: BorderRadius.circular(25),
                      //     ),
                      //     labelColor: Colors.white,
                      //     unselectedLabelColor: Colors.grey.shade600,
                      //     labelStyle: const TextStyle(
                      //       fontWeight: FontWeight.w600,
                      //       fontSize: 13,
                      //     ),
                      //     dividerColor: Colors.transparent, // Remove underline
                      //     indicatorSize: TabBarIndicatorSize.tab,
                      //     tabs: const [
                      //       Tab(text: "Top 5 Sector"),
                      //       Tab(text: "Top 5 Stock"),
                      //     ],
                      //   ),
                      // ),
                      Container(
                        height: 35,
                        // width: 160,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(25),
                          // border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: TabBar(
                          indicator: BoxDecoration(
                            color: Ucolors.primary,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.grey.shade600,
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                          dividerColor: Colors.transparent,
                          indicatorSize: TabBarIndicatorSize.tab,
                          padding: EdgeInsets.zero,
                          labelPadding: EdgeInsets.zero,
                          tabs: const [
                            Tab(text: "Top 10 Sector"),
                            Tab(text: "Top 10 Stock"),
                          ],
                        ),
                      ),

                      /// Tab bar for top 5 sector and top 5 stock
                      SizedBox(
                        height: 400,
                        child: TabBarView(
                          children: [
                            // Top 5 sector
                            Builder(
                              builder: (context) {
                                // 1. Get Data
                                final entity =
                                    controller.portfolioAnalysis.value;
                                final names = entity?.sectorNamesString ?? [];
                                final values = entity?.sectorValuesString ?? [];

                                // 2. Loading State
                                if (controller.isPortfolioLoading.value) {
                                  return const SizedBox(
                                    height: 200,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }

                                // 3. Empty Check
                                // if (entity == null ||
                                //     names.isEmpty ||
                                //     values.isEmpty) {
                                //   return Container(
                                //     height: 200,
                                //     alignment: Alignment.center,
                                //     child: const Text(
                                //       "No Sector Data Available",
                                //       style: TextStyle(color: Colors.grey),
                                //     ),
                                //   );
                                // }

                                // 3. Empty State Check
                                if (entity == null ||
                                    names.isEmpty ||
                                    values.isEmpty) {
                                  return AnimatedEmptyState(
                                    title: 'No Sector Data',
                                    message:
                                        'The AMC hasnt disclosed the holdings for this fund, or it may not be applicable to this scheme',
                                  ); // <-- So much cleaner!
                                }
                                // 3. Empty State Check
                                // if (entity == null ||
                                //     names.isEmpty ||
                                //     values.isEmpty) {
                                //   return Container(
                                //     height:
                                //         300, // Give it enough height to look intentional
                                //     width: double.infinity,
                                //     padding: const EdgeInsets.symmetric(
                                //       horizontal: 24,
                                //       vertical: 32,
                                //     ),
                                //     child: Column(
                                //       mainAxisAlignment:
                                //           MainAxisAlignment.center,
                                //       children: [
                                //         // 1. Soft Icon Background
                                //         Container(
                                //           padding: const EdgeInsets.all(20),
                                //           decoration: BoxDecoration(
                                //             color: Ucolors.darkgrey.withOpacity(
                                //               0.05,
                                //             ), // Very subtle grey circle
                                //             shape: BoxShape.circle,
                                //           ),
                                //           child: Icon(
                                //             Iconsax
                                //                 .chart_fail, // Or Iconsax.document_text, Iconsax.box_remove
                                //             size: 48,
                                //             color: Ucolors.darkgrey.withOpacity(
                                //               0.5,
                                //             ),
                                //           ),
                                //         ),
                                //         const SizedBox(height: 20),

                                //         // 2. Friendly Heading
                                //         const Text(
                                //           "No Portfolio Data",
                                //           style: TextStyle(
                                //             fontSize: 16,
                                //             fontWeight: FontWeight.w600,
                                //             color: Colors.black87,
                                //           ),
                                //         ),
                                //         const SizedBox(height: 8),

                                //         // 3. Reassuring Subtitle
                                //         const Text(
                                //           "The AMC hasn't disclosed the holdings for this fund, or it may not be applicable to this scheme category.",
                                //           textAlign: TextAlign.center,
                                //           style: TextStyle(
                                //             fontSize: 13,
                                //             fontWeight: FontWeight.w400,
                                //             color: Colors.grey,
                                //             height:
                                //                 1.4, // Makes multi-line text easier to read
                                //           ),
                                //         ),
                                //       ],
                                //     ),
                                //   );
                                // }

                                // 4. Combine, Sort, and Limit to Top 5
                                // Safety: use the smaller length to avoid crashes
                                int count = names.length < values.length
                                    ? names.length
                                    : values.length;

                                // Create a list of pairs (Name, Value)
                                List<MapEntry<String, double>> combinedList =
                                    [];
                                for (int i = 0; i < count; i++) {
                                  combinedList.add(
                                    MapEntry(names[i], values[i]),
                                  );
                                }

                                // Sort by value (percentage) -> High to Low
                                combinedList.sort(
                                  (a, b) => b.value.compareTo(a.value),
                                );

                                // Take only the Top 5
                                final top10Items = combinedList
                                    .take(10)
                                    .toList();

                                // 5. Render
                                return SingleChildScrollView(
                                  child: Column(
                                    children: top10Items.map((entry) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          // bottom: 10,
                                          top: 10,
                                        ),
                                        child: PercentageBar(
                                          title: entry
                                              .key, // Name (e.g., Financial Services)
                                          percentage: entry
                                              .value, // Value (e.g., 30.62)
                                          color: Colors
                                              .blue, // Replace with Ucolors.primary
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                );
                              },
                            ),

                            /// Top 5 stock
                            Obx(
                              () => AnimatedPortfolioAllocation(
                                entity: controller.portfolioAnalysis.value,
                                isLoading: controller.isPortfolioLoading.value,
                                scrollController: controller.scrollController,
                              ),
                            ),
                            // Builder(
                            //   builder: (context) {
                            //     // 1. Get Data from Lists
                            //     final entity =
                            //         controller.portfolioAnalysis.value;
                            //     final names =
                            //         entity
                            //             ?.schemePortfolioHoldingsNamesString ??
                            //         [];
                            //     final values =
                            //         entity
                            //             ?.schemePortfolioHoldingsValuesString ??
                            //         [];
                            //
                            //     // 2. Loading State
                            //     if (controller.isPortfolioLoading.value) {
                            //       return const SizedBox(
                            //         height: 200,
                            //         child: Center(
                            //           child: CircularProgressIndicator(),
                            //         ),
                            //       );
                            //     }
                            //
                            //     // 3. Empty State Check
                            //     // if (entity == null ||
                            //     //     names.isEmpty ||
                            //     //     values.isEmpty) {
                            //     //   return Container(
                            //     //     height: 200,
                            //     //     alignment: Alignment.center,
                            //     //     child: const Text(
                            //     //       "No Holdings Data Available",
                            //     //       style: TextStyle(color: Colors.grey),
                            //     //     ),
                            //     //   );
                            //     // }
                            //     if (entity == null ||
                            //         names.isEmpty ||
                            //         values.isEmpty) {
                            //       return AnimatedEmptyState(
                            //         title: 'No Sector Data',
                            //         message:
                            //             'The AMC hasnt disclosed the holdings for this fund, or it may not be applicable to this scheme',
                            //       ); // <-- So much cleaner!
                            //     }
                            //
                            //     // 4. CLEAN, COMBINE & SORT
                            //     int count = names.length < values.length
                            //         ? names.length
                            //         : values.length;
                            //
                            //     // Regex 1: Matches Dates like (22/04/2024)
                            //     // Define Regex Patterns
                            //     final dateRegex = RegExp(
                            //       r'\d{1,2}[/-]\d{1,2}[/-]\d{2,4}',
                            //     );
                            //     final percentageRegex = RegExp(
                            //       r'\d+(\.\d+)?\s*%',
                            //     ); // Matches "7.44%" or "7.5 %"
                            //     final faceValueRegex = RegExp(
                            //       r'\s+(EQ|NEW|FV|RS\.?|RE\.?|Rs\.?|Re\.?)\b.*$',
                            //       caseSensitive: false,
                            //     );
                            //
                            //     // Matches Punctuation to remove: Brackets ( ) and Hyphens -
                            //     final punctuationRegex = RegExp(r'[()\[\]\-]');
                            //
                            //     List<MapEntry<String, double>> holdings = [];
                            //
                            //     for (int i = 0; i < count; i++) {
                            //       String rawName = names[i];
                            //
                            //       // Apply Cleaning:
                            //       // 1. Remove Dates
                            //       // 2. Remove "EQ/FV/RS" suffix
                            //       // 3. Trim extra spaces
                            //       String cleanName = rawName
                            //           .replaceAll(
                            //             dateRegex,
                            //             '',
                            //           ) // 1. Remove Dates
                            //           .replaceAll(
                            //             percentageRegex,
                            //             '',
                            //           ) // 2. Remove Percentages (ALL occurrences)
                            //           .replaceAll(
                            //             faceValueRegex,
                            //             '',
                            //           ) // 3. Remove Face Value junk
                            //           .replaceAll(
                            //             punctuationRegex,
                            //             ' ',
                            //           ) // 4. Replace Brackets & Hyphens with SPACE
                            //           .replaceAll(
                            //             RegExp(r'\s+'),
                            //             ' ',
                            //           ) // 5. Collapse multiple spaces into one
                            //           .trim();
                            //
                            //       // Only add if the name isn't empty (handles cases like just "EQ" which is unlikely)
                            //       if (cleanName.isNotEmpty) {
                            //         holdings.add(
                            //           MapEntry(cleanName, values[i]),
                            //         );
                            //       }
                            //     }
                            //
                            //     // Sort High to Low
                            //     holdings.sort(
                            //       (a, b) => b.value.compareTo(a.value),
                            //     );
                            //
                            //     // Take Top 5
                            //     final top10Items = holdings.take(10).toList();
                            //
                            //     // 5. Render
                            //     return SingleChildScrollView(
                            //       physics: BouncingScrollPhysics(),
                            //       child: Column(
                            //         children: [
                            //           const Gap(10),
                            //           const Row(
                            //             mainAxisAlignment:
                            //                 MainAxisAlignment.spaceBetween,
                            //             children: [
                            //               Text(
                            //                 'Stock Allocation',
                            //                 style: TextStyle(
                            //                   fontSize: 12,
                            //                   fontWeight: FontWeight.w400,
                            //                   color: Ucolors.darkgrey,
                            //                 ),
                            //               ),
                            //               Text(
                            //                 'Holding %',
                            //                 style: TextStyle(
                            //                   fontSize: 12,
                            //                   fontWeight: FontWeight.w400,
                            //                   color: Ucolors.darkgrey,
                            //                 ),
                            //               ),
                            //             ],
                            //           ),
                            //           const Gap(10),
                            //
                            //           const DashedLine(
                            //             dashSpace: 0,
                            //
                            //             color: Ucolors.borderColor,
                            //           ),
                            //           const Gap(10),
                            //           ...top10Items.map((item) {
                            //             return
                            //             // StockAllocationItem(
                            //             //   name: item.key, // Clean Name
                            //             //   category: '', // Placeholder
                            //             //   sector: '', // Placeholder
                            //             //   percentage: item.value,
                            //             // );
                            //             Padding(
                            //               padding: const EdgeInsets.only(
                            //                 bottom: 10,
                            //               ),
                            //               child: PercentageBar(
                            //                 title: item
                            //                     .key, // Name (e.g., Financial Services)
                            //                 percentage: item
                            //                     .value, // Value (e.g., 30.62)
                            //                 color: Colors
                            //                     .blue, // Replace with Ucolors.primary
                            //               ),
                            //             );
                            //           }).toList(),
                            //         ],
                            //       ),
                            //     );
                            //   },
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // --- Fund Comparison Section ---
          const Gap(8),
          SizedBox(
            height: MediaQuery.of(context).size.height < 700 ? 182 : 260,

            child: ListView.builder(
              // itemCount: 10,
              itemCount: fund!.schemePeerComparisonList.length - 1,
              scrollDirection: Axis.horizontal,

              itemBuilder: (context, index) => SizedBox(
                width: MediaQuery.of(context).size.width * 0.97,
                child: GestureDetector(
                  onTap: () {
                    log('${fund.schemeName}--------------------');
                    log('${controller.imgUrl}--------------------');
                    log('tap fund comapare');
                    Get.toNamed(
                      AppRoutes.comparefund,

                      // arguments: {
                      //   'name': fund.schemeName,
                      //   'name2':
                      //       fund.schemePeerComparisonList[index + 1].schemeName,
                      // },
                      arguments: {
                        'name': controller.schemeName,
                        'imgUrl': controller.imgUrl,
                        'name2':
                            fund.schemePeerComparisonList[index + 1].schemeName,
                      },
                    );
                  },
                  child: CustomContainer(
                    bottomPadding: 0,
                    topPadding: 15,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: USectionHeading(
                            title: 'Fund Comparison',
                            showActionButton: false,
                          ),
                        ),
                        FundComparisonItem(
                          imgUrl: controller.imgUrl,
                          fund1: fund?.schemeName,
                          year: fund?.schemePerformanceList[0].threeYearReturn
                              .toString(),
                        ),
                        SizedBox(height: 3),
                        Row(
                          children: [
                            // Left dashed line
                            Expanded(
                              child: DashedLine(color: Colors.grey.shade300),
                            ),

                            // VS circlef
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.blue,
                                  width: 1.2,
                                ),
                              ),
                              child: const Text(
                                'VS',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            // Right dashed line
                            Expanded(
                              child: DashedLine(color: Colors.grey.shade300),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),

                        FundComparisonItem(
                          year: fund
                              .schemePeerComparisonList[index + 1]
                              .threeYearReturn
                              .toString(),
                          fund1: fund
                              ?.schemePeerComparisonList[index + 1]
                              .schemeName
                              .toString(),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                            // horizontal: 60.0,
                            vertical: 8,
                          ),
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: Ucolors.primary.withOpacity(0.5),
                              ),
                            ),
                            // onPressed: () => Get.toNamed(AppRoutes.comparefund ),
                            onPressed: null,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Compare Funds',
                                  style: UTextStyles.buttonText.copyWith(
                                    // color: Ucolors.primary.withOpacity(0.5),
                                    color: Ucolors.primary,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Ucolors.primary.withOpacity(0.5),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 15),
          //   child: OutlinedButton(
          //     style: OutlinedButton.styleFrom(
          //       side: BorderSide(color: Ucolors.primary.withOpacity(0.5)),
          //     ),
          //     onPressed: () => Get.toNamed(AppRoutes.comparefund),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Text(
          //           'Compare Funds',
          //           style: UTextStyles.buttonText.copyWith(
          //             color: Ucolors.primary.withOpacity(0.5),
          //           ),
          //         ),
          //         SizedBox(width: 10),
          //         Icon(
          //           Icons.arrow_forward,
          //           color: Ucolors.primary.withOpacity(0.5),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),

          // --- Related Funds Section ---
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
          //   child: const USectionHeading(
          //     title: 'Related Funds',
          //     showActionButton: false,
          //   ),
          // ),
          //
          // // Add your Related Funds list here
          // SizedBox(
          //   height: 150,
          //   child: ListView.separated(
          //     scrollDirection: Axis.horizontal,
          //     itemCount: fund.schemePeerComparisonList.length - 1,
          //     separatorBuilder: (context, index) => SizedBox(width: 0),
          //     itemBuilder: (context, index) => SizedBox(
          //       width: MediaQuery.of(context).size.width * 0.9,
          //
          //       child: GestureDetector(
          //         // onTap: () => Get.toNamed(AppRoutes.funddetails),
          //         onTap: () {
          //           final scheme = fund
          //               .schemePeerComparisonList[index + 1]
          //               .schemeName
          //               .toString();
          //           final schemeCode = fund.schemeAmfiCode;
          //           final controller = Get.find<FundDetailsController>();
          //
          //           controller.loadNewFund(scheme, schemeCode);
          //
          //           // Get.offNamed(
          //           //   AppRoutes.funddetails,
          //
          //           //   arguments: {'scheme': scheme, 'imgUrl': Appurl.baseUrl2},
          //           // );
          //           debugPrint("Opening ${fund.schemeName}");
          //         },
          //
          //         child: Container(
          //           margin: const EdgeInsets.symmetric(
          //             horizontal: 16,
          //             vertical: 8,
          //           ),
          //           padding: const EdgeInsets.all(14),
          //           decoration: BoxDecoration(
          //             color: Colors.white,
          //             borderRadius: BorderRadius.circular(16),
          //             boxShadow: [
          //               BoxShadow(
          //                 color: Colors.black.withOpacity(0.15),
          //                 blurRadius: 10,
          //                 offset: const Offset(0, 4),
          //               ),
          //             ],
          //           ),
          //           child: Column(
          //             children: [
          //               /// 🔹 Top Row (Icon + Title + Menu)
          //               Row(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   // / Fund Icon
          //                   Container(
          //                     height: 40,
          //                     width: 40,
          //                     decoration: BoxDecoration(
          //                       shape: BoxShape.circle,
          //                       color: Colors.grey.shade100,
          //                     ),
          //                     child: ClipOval(
          //                       child: Image.asset(
          //                         UImages.imp,
          //                         fit: BoxFit.contain,
          //                       ),
          //                     ),
          //                   ),
          //
          //                   // CircleAvatar(backgroundImage: AssetImage(UImages.sbi)),
          //                   const SizedBox(width: 12),
          //
          //                   /// Title + Subtitle
          //                   Expanded(
          //                     child: Column(
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       children: [
          //                         Text(
          //                           maxLines: 2,
          //                           fund
          //                               .schemePeerComparisonList[index + 1]
          //                               .schemeName,
          //                           // 'Nippon India Large Cap Fund- Growth Plan- Growth Option',
          //                           style: TextStyle(
          //                             fontSize: 14,
          //                             fontWeight: FontWeight.w600,
          //                             height: 1.3,
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //
          //                   /// Menu
          //                   // const Icon(Icons.more_vert, color: Colors.grey),
          //                 ],
          //               ),
          //
          //               const SizedBox(height: 10),
          //
          //               /// 🔹 Bottom Stats
          //               Row(
          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                 children: [
          //                   StatItem1(
          //                     title: '1Y Returns',
          //                     amount:
          //                         '${fund.schemePeerComparisonList[index].oneYearReturn.toString()}%',
          //                     //  fund
          //                     //     .schemePeerComparisonList[index]
          //                     //     .oneYearReturn
          //                     //     .toString(),
          //                     percentage: '',
          //                     amountColor: Colors.green.shade800,
          //
          //                     percentageColor: Ucolors.success,
          //                   ),
          //                   StatItem1(
          //                     percentage: '',
          //                     title: '3Y Returns',
          //                     // amount: '43%',
          //                     amount:
          //                         '${fund.schemePeerComparisonList[index].threeYearReturn.toString()}%',
          //                     amountColor: Colors.green.shade800,
          //                     percentageColor: Ucolors.success,
          //                   ),
          //
          //                   StatItem1(
          //                     percentage: '',
          //                     title: '5Y Returns',
          //                     amountColor: Colors.green.shade800,
          //
          //                     percentageColor: Ucolors.success,
          //
          //                     amount:
          //                         '${fund.schemePeerComparisonList[index].fiveYearReturn.toString()}%',
          //
          //                     // '35%',
          //                   ),
          //                 ],
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          const Gap(8),

          CustomContainer(
            topPadding: 15,
            bottomPadding: 15,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                  child: const USectionHeading(
                    title: 'Related Funds',
                    showActionButton: false,
                  ),
                ),

                /// 📜 The Horizontal List inside the card
                SizedBox(
                  height: 100, // Adjusted height
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: fund.schemePeerComparisonList.length - 1,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final item = fund.schemePeerComparisonList[index + 1];

                      return GestureDetector(
                        onTap: () {
                          final controller = Get.find<FundDetailsController>();
                          controller.loadNewFund(
                            item.schemeName,
                            fund.schemeAmfiCode,
                          );
                          debugPrint("Opening ${item.schemeName}");
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.75,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors
                                .grey
                                .shade50, // Subtle contrast from parent
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            children: [
                              /// Top Row (Icon + Title)
                              Row(
                                children: [
                                  Container(
                                    height: 32,
                                    width: 32,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipOval(
                                      child: Image.asset(UImages.imp),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      item.schemeName,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),

                              /// Stats Row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildMiniStat(
                                    '1Y',
                                    '${item.oneYearReturn}%',
                                  ),
                                  _buildMiniStat(
                                    '3Y',
                                    '${item.threeYearReturn}%',
                                  ),
                                  _buildMiniStat(
                                    '5Y',
                                    '${item.fiveYearReturn}%',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const Gap(8),

          CustomContainer(
            topPadding: 15,
            bottomPadding: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  key: infoKey,
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: const USectionHeading(
                    title: 'About this Fund',
                    showActionButton: false,
                  ),
                ),
                ReadMoreText(
                  style: UTextStyles.medium,
                  fund?.schemeObjective.toString() ?? '',
                  // 'Quant Small Cap Fund - Direct Plan - Growth is a Small Cap scheme. The fund is currently managed by Jeetu Vechha. This content is a placeholder — you can replace it with your API description.',
                  trimMode: TrimMode.Line,
                  trimLines: 2,
                  trimCollapsedText: 'Show More',
                  trimExpandedText: 'Show Less',
                  colorClickableText: Ucolors.primary,
                ),
                const SizedBox(height: 5),
                Text(
                  'Fund Manager',
                  style: UTextStyles.large.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),

                if (managers.isNotEmpty)
                  ...managers.asMap().entries.map((entry) {
                    int index = entry.key;
                    String name = entry.value;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Show Divider ONLY if it's NOT the first item
                        if (index > 0)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: DashedLine(
                              color: Colors.grey.shade300,
                              dashSpace: 4, // Adjust styling as needed
                            ),
                          ),

                        // Render the Manager Name Widget
                        fundManager(name),
                      ],
                    );
                  }).toList()
                else
                  // Optional: Handle empty state if needed
                  const Text("No manager details available"),
              ],
            ),
          ),

          ///Investment Details
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 0.0),
            child: Card(
              elevation: 0, // Lower elevation + Border is more modern
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ), // Clean border
              ),
              color: Ucolors.light,
              child: Theme(
                // This removes the splash/highlight and the persistent borders ExpansionTile adds
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  key: ValueKey(1),
                  initiallyExpanded:
                      controller.expandedInvestmentIndex.value == 1,
                  onExpansionChanged: (expanded) {
                    if (expanded) {
                      controller.expandedInvestmentIndex.value = 1;
                      controller.expandedBasicDetailsIndex.value = -1;
                    }
                  },
                  tilePadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 0,
                  ),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                  title: Text(
                    "Investment Details",
                    style: TextStyle(
                      fontSize: 15,
                      color: Ucolors.dark,
                      fontWeight: FontWeight.w600, // Semibold
                    ),
                  ),

                  children: [
                    // Clean Divider between Header and Content
                    Divider(height: 1, color: Colors.grey.shade100),
                    Container(
                      // decoration: BoxDecoration(
                      //   color: Colors.grey.shade50, // Subtle background for detail area
                      //   borderRadius: BorderRadius.circular(12),
                      // ),
                      // padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          _buildDetailRow(
                            'Fund Size',
                            '₹${fund?.schemeAssets} Cr.',
                            Icons.bar_chart_outlined,
                          ),
                          _buildDashedDivider(),
                          _buildDetailRow(
                            'Min. Inv',
                            '₹${fund?.minimumInvestment}',
                            Icons.circle_outlined,
                          ),
                          _buildDashedDivider(),
                          _buildDetailRow(
                            'Min. Sip Inv',
                            '₹${fund?.sipMinimumAmount}',
                            Icons.change_circle_outlined,
                          ),
                          _buildDashedDivider(),
                          _buildDetailRow(
                            'Expense Ratio',
                            '${fund?.expenseRatioPercentage}%',
                            Icons.pie_chart_outline,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // SizedBox(
          //   width: double.infinity,
          //   child: ExpansionTile(
          //     // maintainState: true,
          //     shape: Border(),
          //     collapsedShape: Border(),
          //     // dense: true,
          //     title: Text('Invesment Details'),
          //     children: [
          //       CustomContainer(
          //         bottomPadding: 0,
          //         child: Column(
          //           children: [
          //             investmentDetailSection(
          //               'Fund Size',
          //               '₹${fund?.schemeAssets?.toString()} Cr.' ?? '',
          //               Icons.bar_chart_outlined,
          //             ),
          //             // Divider(height: 0),
          //             DashedLine(dashSpace: 0, color: Colors.grey.shade300),
          //             investmentDetailSection(
          //               'Min. Inv',
          //               '₹ ${fund?.minimumInvestment.toString()}',
          //               Icons.circle,
          //             ),
          //
          //             DashedLine(dashSpace: 0, color: Colors.grey.shade300),
          //             investmentDetailSection(
          //               'Min. Sip Inv',
          //               '₹ ${fund?.sipMinimumAmount.toString()}',
          //               Icons.change_circle_outlined,
          //             ),
          //
          //             DashedLine(dashSpace: 0, color: Colors.grey.shade300),
          //             investmentDetailSection(
          //               'Min. Topup',
          //               '₹ ${fund?.minimumTopup.toString()}',
          //               Icons.curtains_closed_outlined,
          //             ),
          //
          //             DashedLine(dashSpace: 0, color: Colors.grey.shade300),
          //             investmentDetailSection(
          //               'Turn over',
          //               '23',
          //               Icons.lightbulb_circle_outlined,
          //             ),
          //             DashedLine(dashSpace: 0, color: Colors.grey.shade300),
          //             investmentDetailSection(
          //               'Expense Ratio',
          //               fund?.expenseRatioPercentage.toString() ?? '',
          //               Icons.pie_chart_outline,
          //             ),
          //             DashedLine(dashSpace: 0, color: Colors.grey.shade300),
          //             investmentDetailSection(
          //               'Exit Load',
          //               fund?.exitLoad.toString() ?? '',
          //               Icons.logout_outlined,
          //             ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          ///Basic Details
          // ExpansionTile(
          //   shape: Border(),
          //   collapsedShape: Border(),
          //   // dense: true,
          //   title: Text('Basic Details'),
          //   children: [
          //     CustomContainer(
          //       bottomPadding: 0,
          //       child: Column(
          //         children: [
          //           investmentDetailSection(
          //             'Category',
          //             // fund?.schemeCategory.split(':')[0].toString() ?? '',
          //             fund?.schemeCategory ?? '',
          //             Icons.category,
          //           ),
          //
          //           // DashedLine(dashSpace: 0, color: Colors.grey.shade300),
          //           // investmentDetailSection('KRA', 'KARVY', Icons.circle),
          //           DashedLine(dashSpace: 0, color: Colors.grey.shade300),
          //           investmentDetailSection(
          //             'Inv. Plan',
          //             // fund?.schemeName.split('-')[1].toString() ?? '',
          //             fund.schemeName.contains('-') == true
          //                 ? fund.schemeName.split('-')[1].trim()
          //                 : 'Nil',
          //
          //             // fund.schemeName,
          //             Icons.travel_explore_rounded,
          //           ),
          //           DashedLine(dashSpace: 0, color: Colors.grey.shade300),
          //           investmentDetailSection(
          //             'Launched IN',
          //             fund?.schemeInceptionDate.toString() ?? '',
          //             Icons.calendar_month_sharp,
          //           ),
          //           DashedLine(dashSpace: 0, color: Colors.grey.shade300),
          //           investmentDetailSection(
          //             'Bench Mark',
          //
          //             fund?.schemeBenchmark.toString() ?? '',
          //             Icons.track_changes,
          //           ),
          //           DashedLine(dashSpace: 0, color: Colors.grey.shade300),
          //           investmentDetailSection(
          //             'Fund Type',
          //
          //             fund?.schemeStatus.split(' ')[0].toString() ?? '',
          //             Icons.library_books,
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 0.0),
            child: Card(
              elevation: 0, // Lower elevation + Border is more modern
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ), // Clean border
              ),
              color: Ucolors.light,
              child: Theme(
                // This removes the splash/highlight and the persistent borders ExpansionTile adds
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  key: ValueKey(2),
                  initiallyExpanded:
                      controller.expandedBasicDetailsIndex.value == 2,
                  onExpansionChanged: (expanded) {
                    if (expanded) {
                      controller.expandedInvestmentIndex.value = -1;
                      controller.expandedBasicDetailsIndex.value = 2;
                    }
                  },
                  tilePadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 0,
                  ),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                  title: Text(
                    "Basic Details",
                    style: TextStyle(
                      fontSize: 15,
                      color: Ucolors.dark,
                      fontWeight: FontWeight.w600, // Semibold
                    ),
                  ),

                  children: [
                    Column(
                      children: [
                        investmentDetailSection(
                          'Category',
                          // fund?.schemeCategory.split(':')[0].toString() ?? '',
                          fund?.schemeCategory ?? '',
                          Icons.category,
                        ),

                        // DashedLine(dashSpace: 0, color: Colors.grey.shade300),
                        // investmentDetailSection('KRA', 'KARVY', Icons.circle),
                        DashedLine(dashSpace: 0, color: Colors.grey.shade300),
                        investmentDetailSection(
                          'Inv. Plan',
                          // fund?.schemeName.split('-')[1].toString() ?? '',
                          fund.schemeName.contains('-') == true
                              ? fund.schemeName.split('-')[1].trim()
                              : 'Nil',

                          // fund.schemeName,
                          Icons.travel_explore_rounded,
                        ),
                        DashedLine(dashSpace: 0, color: Colors.grey.shade300),
                        investmentDetailSection(
                          'Launched IN',
                          fund?.schemeInceptionDate.toString() ?? '',
                          Icons.calendar_month_sharp,
                        ),
                        DashedLine(dashSpace: 0, color: Colors.grey.shade300),
                        investmentDetailSection(
                          'Bench Mark',

                          fund?.schemeBenchmark.toString() ?? '',
                          Icons.track_changes,
                        ),
                        DashedLine(dashSpace: 0, color: Colors.grey.shade300),
                        investmentDetailSection(
                          'Fund Type',

                          fund?.schemeStatus.split(' ')[0].toString() ?? '',
                          Icons.library_books,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          //AMC Information
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 0.0),
            child: Card(
              elevation: 0, // Lower elevation + Border is more modern
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ), // Clean border
              ),
              color: Ucolors.light,
              child: Theme(
                // This removes the splash/highlight and the persistent borders ExpansionTile adds
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  key: ValueKey(3),
                  initiallyExpanded:
                      controller.expandedAMCInformationIndex.value == 3,
                  onExpansionChanged: (expanded) {
                    if (expanded) {
                      controller.expandedInvestmentIndex.value = -1;
                      controller.expandedAMCInformationIndex.value = 3;
                    }
                  },
                  tilePadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 0,
                  ),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                  title: Text(
                    "AMC Information",
                    style: TextStyle(
                      fontSize: 15,
                      color: Ucolors.dark,
                      fontWeight: FontWeight.w600, // Semibold
                    ),
                  ),

                  children: [
                    investmentDetailSection(
                      'AMC',
                      fund?.schemeCompany.toString() ?? '',
                      Icons.bar_chart_rounded,
                    ),
                    DashedLine(dashSpace: 0, color: Colors.grey.shade300),
                    investmentDetailSection(
                      'Email',
                      // 'abc.warrgyizmorch@gmail.com',
                      controller.email,
                      Icons.mail_outline,
                    ),

                    DashedLine(dashSpace: 0, color: Colors.grey.shade300),
                    investmentDetailSection(
                      'Office No',
                      // '1876471871',
                      controller.contact,
                      Icons.home_work_outlined,
                    ),
                    // DashedLine(dashSpace: 0, color: Colors.grey.shade300),
                    // investmentDetailSection(
                    //   'Website',
                    //   'http://www.google.com',
                    //   Iconsax.global,
                    // ),
                    DashedLine(dashSpace: 0, color: Colors.grey.shade300),
                    investmentDetailSection(
                      'Address',
                      // '',
                      controller.address,
                      Icons.location_on_outlined,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // ExpansionTile(
          //   shape: Border(),
          //   collapsedShape: Border(),
          //   // dense: true,
          //   title: Text('AMC Information'),
          //   children: [
          //     CustomContainer(
          //       bottomPadding: 0,
          //       child: Column(
          //         children: [
          //           investmentDetailSection(
          //             'AMC',
          //             fund?.schemeCompany.toString() ?? '',
          //             Icons.bar_chart_rounded,
          //           ),
          //           DashedLine(dashSpace: 0, color: Colors.grey.shade300),
          //           investmentDetailSection(
          //             'Email',
          //             // 'abc.warrgyizmorch@gmail.com',
          //             controller.email,
          //             Icons.mail_outline,
          //           ),
          //
          //           DashedLine(dashSpace: 0, color: Colors.grey.shade300),
          //           investmentDetailSection(
          //             'Office No',
          //             // '1876471871',
          //             controller.contact,
          //             Icons.home_work_outlined,
          //           ),
          //           // DashedLine(dashSpace: 0, color: Colors.grey.shade300),
          //           // investmentDetailSection(
          //           //   'Website',
          //           //   'http://www.google.com',
          //           //   Iconsax.global,
          //           // ),
          //           DashedLine(dashSpace: 0, color: Colors.grey.shade300),
          //           investmentDetailSection(
          //             'Address',
          //             // '',
          //             controller.address,
          //             Icons.location_on_outlined,
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
        ],
      );
    });
  }

  Widget _buildMiniStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            color: Colors.green.shade800,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Professional Helper Methods to keep code clean
  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildDashedDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: DashedLine(dashSpace: 3, color: Colors.grey.shade300),
    );
  }

  Widget marketCapPercentage(String title, String value, Color? color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '● $title',
          style: UTextStyles.medium.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: UTextStyles.medium.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // Widget investmentDetailSection(String title, String value, IconData icon) {
  //   return ListTile(
  //     contentPadding: EdgeInsets.zero,

  //     dense: true,
  //     isThreeLine: false,
  //     title: Row(
  //       children: [
  //         Icon(icon, color: Ucolors.blue),
  //         Gap(8),
  //         Text(
  //           title,
  //           style: UTextStyles.medium.copyWith(fontWeight: FontWeight.w400),
  //         ),
  //       ],
  //     ),
  //     trailing: Text(
  //       value,
  //       style: UTextStyles.medium.copyWith(
  //         fontWeight: FontWeight.w600,
  //         color: Ucolors.dark,
  //       ),
  //     ),
  //   );
  // }

  Widget investmentDetailSection(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue.shade800, size: 16),
          const SizedBox(width: 10),

          /// LEFT TITLE
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: UTextStyles.medium.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
          ),

          const SizedBox(width: 12),

          /// RIGHT VALUE (WRAPS)
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              softWrap: true,
              style: UTextStyles.medium.copyWith(
                fontWeight: FontWeight.w600,
                color: Ucolors.dark,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget fundManager(String name) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      leading: CircleAvatar(
        radius: 15,
        backgroundColor: Ucolors.skyblue1,
        child: Icon(Icons.person, color: Ucolors.dark, size: 13),
      ),
      title: Text(
        name,
        style: UTextStyles.medium.copyWith(
          fontWeight: FontWeight.w600,
          color: Ucolors.dark,
        ),
      ),
      trailing: CompactIcon(
        icon: Icons.arrow_forward_ios_rounded,
        iconColor: Ucolors.darkgrey,
        iconSize: 12,

        onPressed: () {},
      ),
    );
  }
}

class DashedLine extends StatelessWidget {
  const DashedLine({
    super.key,
    this.color = Colors.blue,
    this.height = 1,
    this.dashWidth = 6,
    this.dashSpace = 4,
  });

  final Color color;
  final double height;
  final double dashWidth;
  final double dashSpace;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dashCount = (constraints.maxWidth / (dashWidth + dashSpace))
            .floor();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: height,
              child: DecoratedBox(decoration: BoxDecoration(color: color)),
            );
          }),
        );
      },
    );
  }
}

class FundComparisonItem extends StatelessWidget {
  const FundComparisonItem({super.key, this.fund1, this.imgUrl, this.year});

  final String? fund1;
  final String? imgUrl;
  final String? year;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // / Fund Icon
            Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade100,
              ),
              child: ClipOval(
                // child: Image.asset(UImages.sbi, fit: BoxFit.cover),
                child: CustomCachedImage(imageUrl: '$imgUrl'),
              ),
            ),

            // CircleAvatar(backgroundImage: AssetImage(UImages.sbi)),
            const SizedBox(width: 12),

            /// Title + Subtitle
            Flexible(
              child: Text(
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,

                fund1 ??
                    'Nippon India Large Cap Fund- Growth Plan- Growth Option',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ),

            /// Menu
            // const Icon(Icons.more_vert, color: Colors.grey),
          ],
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '3Y Return :',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Ucolors.darkgrey,
                ),
              ),
              const TextSpan(text: '  '),
              TextSpan(
                text: '$year%',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Ucolors.success,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SpeedometerGauge extends StatefulWidget {
  final double value; // 0–100
  final ScrollController scrollController;

  const SpeedometerGauge({
    super.key,
    required this.value,
    required this.scrollController,
  });

  @override
  State<SpeedometerGauge> createState() => _SpeedometerGaugeState();
}

class _SpeedometerGaugeState extends State<SpeedometerGauge> {
  double currentPointerValue = 0;
  final GlobalKey _gaugeKey = GlobalKey();
  bool _isOnScreen = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_checkVisibility);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_checkVisibility);
    super.dispose();
  }

  void _checkVisibility() {
    if (!mounted) return;

    final RenderObject? renderObject = _gaugeKey.currentContext?.findRenderObject();
    if (renderObject is RenderBox) {
      final position = renderObject.localToGlobal(Offset.zero);
      final screenHeight = MediaQuery.of(context).size.height;


      bool currentlyVisible = position.dy < screenHeight - 50 && position.dy > -100;

      if (currentlyVisible && !_isOnScreen) {
        setState(() {
          _isOnScreen = true;
          currentPointerValue = widget.value;
        });
      } else if (!currentlyVisible && _isOnScreen) {
        setState(() {
          _isOnScreen = false;
          currentPointerValue = 0;
        });
      }
    }
  }

  @override
  void didUpdateWidget(covariant SpeedometerGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _isOnScreen) {
      setState(() {
        currentPointerValue = widget.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: _gaugeKey,
      height: 130,
      child: SfRadialGauge(
        axes: [
          RadialAxis(
            minimum: 0,
            maximum: 100,
            startAngle: 180,
            endAngle: 0,
            centerY: 0.8,
            radiusFactor: 1,
            showTicks: false,
            showLabels: false,
            axisLineStyle: const AxisLineStyle(thickness: 0),
            ranges: [
              _buildRange(0, 18, Colors.green),
              _buildRange(20, 38, Colors.lightGreen),
              _buildRange(40, 58, Colors.amber),
              _buildRange(60, 78, Colors.orange),
              _buildRange(80, 100, Colors.red),
            ],
            pointers: [
              NeedlePointer(
                value: currentPointerValue,
                enableAnimation: true,
                animationDuration: 2000,
                animationType: AnimationType.easeOutBack,
                needleLength: 0.7,
                needleStartWidth: 1,
                needleEndWidth: 5,
                needleColor: Colors.black,
                knobStyle: const KnobStyle(
                  color: Colors.black,
                  knobRadius: 0.07,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  GaugeRange _buildRange(double start, double end, Color color) {
    return GaugeRange(
      startValue: start,
      endValue: end,
      color: color,
      startWidth: 14,
      endWidth: 14,
    );
  }
}
// class SpeedometerGauge extends StatelessWidget {
//   final double value; // 0–100
//
//   const SpeedometerGauge({super.key, required this.value});
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 130,
//
//       child: SfRadialGauge(
//         axes: [
//           RadialAxis(
//             minimum: 0,
//             maximum: 100,
//             startAngle: 180,
//             endAngle: 0,
//             centerY: 0.8,
//             radiusFactor: 1,
//             showTicks: false,
//             showLabels: false,
//
//             axisLineStyle: const AxisLineStyle(
//               thickness: 0,
//               color: Colors.transparent,
//             ),
//
//             ranges: [
//               GaugeRange(
//                 startValue: 0,
//                 endValue: 18,
//                 color: Colors.green,
//                 startWidth: 14,
//                 endWidth: 14,
//               ),
//               GaugeRange(
//                 startValue: 18,
//                 endValue: 20,
//                 color: Colors.transparent,
//               ),
//
//               GaugeRange(
//                 startValue: 20,
//                 endValue: 38,
//                 color: Colors.lightGreen,
//                 startWidth: 14,
//                 endWidth: 14,
//               ),
//               GaugeRange(
//                 startValue: 38,
//                 endValue: 40,
//                 color: Colors.transparent,
//               ),
//
//               GaugeRange(
//                 startValue: 40,
//                 endValue: 58,
//                 color: Colors.amber,
//                 startWidth: 14,
//                 endWidth: 14,
//               ),
//               GaugeRange(
//                 startValue: 58,
//                 endValue: 60,
//                 color: Colors.transparent,
//               ),
//
//               GaugeRange(
//                 startValue: 60,
//                 endValue: 78,
//                 color: Colors.orange,
//                 startWidth: 14,
//                 endWidth: 14,
//               ),
//               GaugeRange(
//                 startValue: 78,
//                 endValue: 80,
//                 color: Colors.transparent,
//               ),
//
//               GaugeRange(
//                 startValue: 80,
//                 endValue: 100,
//                 color: Colors.red,
//                 startWidth: 14,
//                 endWidth: 14,
//               ),
//             ],
//
//             pointers: [
//               NeedlePointer(
//                 value: value,
//                 needleLength: 0.6,
//                 needleStartWidth: 1,
//                 needleEndWidth: 4,
//                 needleColor: Colors.black,
//                 knobStyle: const KnobStyle(
//                   color: Colors.black,
//                   knobRadius: 0.06,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//
//       //  SfRadialGauge(
//       //   // backgroundColor: Colors.green,
//       //   axes: [
//       //     RadialAxis(
//       //       // interval: 3,
//       //       radiusFactor: 1,
//       //       centerY: 0.8,
//
//       //       // centerX: 0,
//       //       minimum: 0,
//       //       maximum: 100,
//       //       startAngle: 180,
//       //       endAngle: 0,
//       //       showTicks: false,
//       //       showLabels: false,
//
//       //       axisLineStyle: const AxisLineStyle(
//       //         thickness: 0.15,
//
//       //         thicknessUnit: GaugeSizeUnit.factor,
//       //         color: Colors.transparent,
//       //       ),
//
//       //       // COLOR SEGMENTS
//       //       ranges: [
//       //         GaugeRange(
//       //           startValue: 0,
//       //           endValue: 20,
//       //           color: Colors.green,
//       //           startWidth: 15,
//       //           endWidth: 15,
//       //         ),
//       //         GaugeRange(
//       //           startValue: 20,
//       //           endValue: 40,
//       //           color: Colors.lightGreen,
//       //           startWidth: 15,
//       //           endWidth: 15,
//       //         ),
//       //         GaugeRange(
//       //           startValue: 40,
//       //           endValue: 60,
//       //           color: Colors.yellow,
//       //           startWidth: 15,
//       //           endWidth: 15,
//       //         ),
//       //         GaugeRange(
//       //           startValue: 60,
//       //           endValue: 80,
//       //           color: Colors.orange,
//       //           startWidth: 15,
//       //           endWidth: 15,
//       //         ),
//       //         GaugeRange(
//       //           startValue: 80,
//       //           endValue: 100,
//       //           color: Colors.red,
//       //           startWidth: 15,
//       //           endWidth: 15,
//       //         ),
//       //       ],
//
//       //       // NEEDLE
//       //       pointers: [
//       //         NeedlePointer(
//       //           value: value,
//       //           needleLength: 0.6,
//       //           needleStartWidth: 1,
//       //           needleEndWidth: 4,
//       //           needleColor: Colors.black,
//       //           knobStyle: const KnobStyle(
//       //             color: Colors.black,
//       //             knobRadius: 0.06,
//       //           ),
//       //         ),
//       //       ],
//       //     ),
//       //   ],
//       // ),
//     );
//   }
// }

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
    required this.child,
    this.topPadding = 4,
    this.bottomPadding = 15,
    this.height,
    this.width,
  });

  final Widget child;
  final double topPadding;
  final double bottomPadding;
  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
      child: Container(
        height: height,
        width: width,
        padding: EdgeInsets.fromLTRB(15, topPadding, 15, bottomPadding),
        decoration: BoxDecoration(
          color: Ucolors.light,
          border: Border.all(color: Ucolors.borderColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: child,
      ),
    );
  }
}

Widget _twoColumnRow({
  required String leftTitle,
  required String leftValue,
  required String rightTitle,
  required String rightValue,
  Color? color,
  Color? color2,
}) {
  return Row(
    children: [
      Expanded(child: _infoItem(leftTitle, leftValue, color)),
      Expanded(child: _infoItem(rightTitle, rightValue, color2)),
    ],
  );
}

Widget _infoItem(String title, String value, Color? color) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: TextStyle(fontSize: 10, color: Ucolors.darkgrey)),
      const SizedBox(height: 4),
      Text(
        value,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    ],
  );
}

// class SliverPageTabs extends SliverPersistentHeaderDelegate {
//   final int selectedIndex;
//   final ValueChanged<int> onTap;
//   static final ScrollController _scrollController = ScrollController();
//
//   SliverPageTabs({required this.selectedIndex, required this.onTap});
//
//   final tabs = const [
//     'Overview',
//     'Returns',
//     'Risk',
//     'Portfolio',
//     'Information',
//   ];
//
//   void _scrollToActiveTab() {
//     if (_scrollController.hasClients) {
//       double offset = selectedIndex * 90.0;
//       double target = offset.clamp(
//         0.0,
//         _scrollController.position.maxScrollExtent,
//       );
//
//       _scrollController.animateTo(
//         target,
//         duration: const Duration(milliseconds: 100),
//         curve: Curves.easeInOut,
//       );
//     }
//   }
//
//   @override
//   bool shouldRebuild(covariant SliverPageTabs oldDelegate) {
//     return oldDelegate.selectedIndex != selectedIndex;
//   }
//
//   @override
//   Widget build(
//     BuildContext context,
//     double shrinkOffset,
//     bool overlapsContent,
//   ) {
//     WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToActiveTab());
//
//     return Container(
//       // ---------------------------------------------------------
//       // 👇 FIX: Give it a fixed height so the ListView doesn't crash
//       // ---------------------------------------------------------
//       height: 50,
//       decoration: BoxDecoration(
//         color: Colors.grey[100],
//         borderRadius: BorderRadius.circular(25),
//       ),
//       margin: const EdgeInsets.symmetric(horizontal: 10),
//       child: ListView.separated(
//         controller: _scrollController,
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         itemCount: tabs.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 8),
//         itemBuilder: (context, index) {
//           final isSelected = index == selectedIndex;
//
//           return GestureDetector(
//             onTap: () => onTap(index),
//             child: Center(
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 10,
//                 ),
//                 decoration: BoxDecoration(
//                   color: isSelected ? Colors.white : Colors.transparent,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   tabs[index],
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
//                     color: isSelected ? Ucolors.primary : Colors.grey.shade700,
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   @override
//   double get maxExtent => 50;
//
//   @override
//   double get minExtent => 50;
// }
class SliverPageTabs extends SliverPersistentHeaderDelegate {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  static final ScrollController _scrollController = ScrollController();

  SliverPageTabs({required this.selectedIndex, required this.onTap});

  final tabs = const [
    'Overview',
    'Returns',
    'Risk',
    'Portfolio',
    'Information',
  ];

  void _scrollToActiveTab() {
    if (_scrollController.hasClients) {
      double offset = selectedIndex * 90.0;
      double target = offset.clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      );

      _scrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  bool shouldRebuild(covariant SliverPageTabs oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex;
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToActiveTab());

    return Material(
      color: Ucolors.light,
      elevation: overlapsContent ? 2 : 0,
      child: Container(
        height: 50,
        color: Colors.transparent,

        padding: const EdgeInsets.symmetric(
          vertical: 4,
        ), // Outer spacing from screen edges
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
          ), // Outer spacing from screen edges
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,

            padding: const EdgeInsets.symmetric(horizontal: 2),
            itemCount: tabs.length,
            separatorBuilder: (_, __) => const SizedBox(width: 4),
            itemBuilder: (context, index) {
              final isSelected = index == selectedIndex;

              return GestureDetector(
                onTap: () => onTap(index),
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tabs[index],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: isSelected
                            ? Ucolors.primary
                            : Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;
}

Widget _dot() {
  return const Text('•', style: TextStyle(fontSize: 12, color: Colors.grey));
}

Widget _metaText(
  String text, {
  Color color = Colors.grey,
  FontWeight fontWeight = FontWeight.normal,
}) {
  return Text(
    text,
    style: TextStyle(fontSize: 10, color: color, fontWeight: fontWeight),
  );
}

class AnimatedPortfolioAllocation extends StatefulWidget {
  final dynamic entity;
  final bool isLoading;
  final ScrollController scrollController;

  const AnimatedPortfolioAllocation({
    super.key,
    required this.entity,
    required this.isLoading,
    required this.scrollController,
  });

  @override
  State<AnimatedPortfolioAllocation> createState() =>
      _AnimatedPortfolioAllocationState();
}

class _AnimatedPortfolioAllocationState
    extends State<AnimatedPortfolioAllocation> {
  final GlobalKey _chartKey = GlobalKey();
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    // Scroll listener attach karna
    widget.scrollController.addListener(_checkVisibility);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_checkVisibility);
    super.dispose();
  }

  void _checkVisibility() {
    if (_hasAnimated) return;

    // Widget ki screen position check karna
    final RenderObject? renderObject = _chartKey.currentContext
        ?.findRenderObject();
    if (renderObject is RenderBox) {
      final position = renderObject.localToGlobal(Offset.zero);
      final screenHeight = MediaQuery.of(context).size.height;

      // Jab widget screen ke bottom se 100px andar aa jaye
      if (position.dy < screenHeight - 100) {
        setState(() {
          _hasAnimated = true; // Isse animation trigger hogi
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return const SizedBox(
        height: 250,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // --- Data Extraction Logic ---
    final assetMap = widget.entity?.assetAllocation ?? {};
    final assetList =
        assetMap.entries.where((e) => (e.value as num) > 0).toList()
          ..sort((a, b) => (b.value as num).compareTo(a.value as num));

    final mcap = widget.entity?.mcapAllocation;
    final mcapList = [
      if ((mcap?.marketCapLargecapPercent ?? 0) > 0)
        MapEntry('Large Cap', mcap!.marketCapLargecapPercent),
      if ((mcap?.marketCapMidcapPercent ?? 0) > 0)
        MapEntry('Mid Cap', mcap!.marketCapMidcapPercent),
      if ((mcap?.marketCapSmallcapPercent ?? 0) > 0)
        MapEntry('Small Cap', mcap!.marketCapSmallcapPercent),
    ];

    return DefaultTabController(
      length: 2,
      child: Column(
        key: _chartKey, // Is key se hum scroll position track karte hain
        children: [
          const Gap(8),
          _buildTabBarUI(),
          const Gap(4),
          Divider(color: Colors.grey.shade200),
          SizedBox(
            height: 330,
            child: TabBarView(
              children: [
                // Agar _hasAnimated false hai, toh empty list [] bhejenge
                _buildAllocationTab(_hasAnimated ? assetList : [], "Assets"),
                _buildAllocationTab(
                  _hasAnimated ? mcapList : [],
                  "Market\nCap",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllocationTab(
    List<MapEntry<String, dynamic>> data,
    String centerText,
  ) {
    // 1. Agar abhi tak scroll nahi hua ya data sach mein khali hai
    // Hum Sizedbox dikhayenge taki layout jump na kare
    if (!_hasAnimated) {
      return const SizedBox(
        height: 300,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    // 2. Agar scroll ho gaya aur data sach mein empty hai (API error/No data)
    if (data.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.ghost, size: 40, color: Colors.grey.shade400),
            const Gap(10),
            const Text(
              "No data available",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // Chart ke colors ki list
    final List<Color> colors = [
      const Color(0xff0280C0), // Aapka Primary Blue
      Colors.indigo.shade600,
      Colors.greenAccent.shade700,
      Colors.orangeAccent,
      Colors.purpleAccent,
      Colors.teal,
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      physics:
          const NeverScrollableScrollPhysics(), // Parent handle karega scroll
      child: Column(
        children: [
          // --- PIE CHART WITH STACK ---
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 200,
                width: 200,
                child: PieChart(
                  // Key badalne se animation force-start hoti hai
                  key: ValueKey(data.length + (_hasAnimated ? 1 : 0)),

                  duration: const Duration(
                    milliseconds: 1200,
                  ), // Animation speed
                  curve: Curves.easeInOutBack, // Smooth bounce effect

                  PieChartData(
                    centerSpaceRadius: 50,
                    sectionsSpace: 2,
                    centerSpaceColor: Colors.white,
                    sections: List.generate(data.length, (index) {
                      final value = (data[index].value as num).toDouble();
                      return PieChartSectionData(
                        showTitle: false,
                        value: value,
                        color: colors[index % colors.length],
                        radius: 40,
                        // Animation ke liye initial state handle karna zaroori nahi
                        // kyunki empty list se data list par aate hi fl_chart animate karta hai
                      );
                    }),
                  ),
                ),
              ),
              // Center Text
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    centerText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const Gap(24),

          // --- LEGEND LIST (NEECHE KI DETAILS) ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: List.generate(data.length, (index) {
                final String title = data[index].key;
                final String percentage =
                    '${(data[index].value as num).toStringAsFixed(2)}%';
                final Color color = colors[index % colors.length];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const Gap(10),
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        percentage,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBarUI() {
    return Container(
      height: 35,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        indicator: BoxDecoration(
          color: const Color(0xff0280C0),
          borderRadius: BorderRadius.circular(25),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey.shade600,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: const [
          Tab(text: "Asset Allocation"),
          Tab(text: "Market Cap"),
        ],
      ),
    );
  }

  Widget _buildLegendRow(String title, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const Gap(8),
          Text(title, style: const TextStyle(fontSize: 12)),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
