import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide FilterChip;
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/appbar/widget/compact_icon.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/common/widget/table/table_header.dart';
import 'package:my_sip/common/widget/text/small_heading.dart';
import 'package:my_sip/common/widget/text/view_all.dart';
import 'package:my_sip/common/widget/text_form/text_field_component.dart';
import 'package:my_sip/common/widget/text_form/text_form_field.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/cart/data/model/cartItem_model.dart';
import 'package:my_sip/features/cart/presentation/controllers/cart_controller.dart';
import 'package:my_sip/features/cart/presentation/pages/cart_page.dart';
import 'package:my_sip/features/explore/presentation/controller/fundhouse_controller.dart';
import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';
import 'package:my_sip/features/explore/presentation/pages/explore.dart';
import 'package:my_sip/features/fund_details/data/models/return_model.dart';
import 'package:my_sip/features/fund_details/presentation/widgets/return.dart';
import 'package:my_sip/features/goal/presentation/controller/goal_sip_controller.dart';
import 'package:my_sip/features/home/presentation/widgets/product_tool/widget/sipslidertile.dart';
import 'package:my_sip/features/sip_process/presentation/widgets/sip_projection_chart.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../services/image_picker_service.dart';
import '../../../fund_details/presentation/pages/fund_deatails.dart';
import '../../../home/presentation/pages/home.dart';
import '../../domain/entity/goal_entity.dart';

class IhavegoalPage extends GetView<GoalSipController> {
  IhavegoalPage({super.key});


  final CartController cartController = Get.find<CartController>();
  final GlobalKey popularFundsKey = GlobalKey();

  @override
  Widget build(BuildContext context) {

    final args = Get.arguments ?? {};
    final String initialType = args['goalType'] ?? 'custom';
    final bool isEdit =args['isEdit']??false;
    final int goalId =args['goalId']??0;
    final UserGoalEntity? goal =args['goal']??null;
    debugPrint("isEdit:$isEdit, goal id:$goalId, UserGoal:$goal");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      /// reset only when create new goal
      if (!isEdit) {
        controller.resetStateForNewGoal();
      }

      controller.updateGoalType(initialType);

      /// edit data set
      if (isEdit && goal != null) {
        controller.loadGoalForEdit(goal);
      }
    });

    final bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      backgroundColor: isDesktop
          ? const Color(0xFFF5F7FA)
          : const Color(0xffF3F4F6),
      // appBar: CustomAppBarNormal(
      //   title: 'Create $name Goal',
      //   action: [CompactIcon(icon: Iconsax.info_circle, onPressed: () {})],
      //   actionsPadding: 15,
      // ),
      appBar: isDesktop
          ? null
          : PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Obx(() {
          final activeName =
              controller.goalConfig[
              controller.selectedGoalType.value]?['name'] ??
                  'Custom';

          return CustomAppBarNormal(
            title: 'Create $activeName Goal',
            action: [
              CompactIcon(
                icon: Iconsax.info_circle,
                onPressed: () {},
              ),
            ],
            actionsPadding: 15,
          );
        }),
      ),

      body: Obx(() {
        final currentType = controller.selectedGoalType.value;
        final currentData = controller.goalConfig[currentType]!;
        final activeName = currentData['name']!;

        return isDesktop
            ? _WebLayout(
                name: activeName,
                goalData: currentData,
                controller: controller,
                popularFundsKey: popularFundsKey,
              )
            : _MobileLayout(
                name: activeName,
                goalData: currentData,
                controller: controller,
                popularFundsKey: popularFundsKey,
              );
      }),
      bottomNavigationBar: Obx(
        () => controller.isGoalSaved.value
            ? SafeArea(
                top: false,
                child: CartBottomBar(
                  isValid: controller.selectedPopularFund.isNotEmpty,

                  ontap: () {
                    log(controller.savedDatabaseId.value.toString());
                    final cartCont = Get.find<CartController>();
                    cartCont.filterGoalId.value =
                        controller.savedDatabaseId.value;
                    cartController.monthlyAmount.value = controller
                        .monthlySip
                        .value
                        .toInt();

                    controller.selectedPopularFund.isNotEmpty
                        ? Get.toNamed(
                            AppRoutes.cart,
                            arguments: {
                              'goal_id': controller
                                  .savedDatabaseId
                                  .value, // Pass the ID (e.g., 50)
                            },
                          )
                        : Get.snackbar(
                            "Error",
                            "Please select funds to start SIP",
                          );
                  },
                  amount: controller.monthlySip.value.toStringAsFixed(0),
                  amountColor: Ucolors.blue,
                  title: 'Installment Amount',
                  buttonText: 'Start SIP',
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

class _WebLayout extends StatefulWidget {
  final String name;
  final Map<String, dynamic> goalData;
  final GoalSipController controller;
  final GlobalKey popularFundsKey;

  const _WebLayout({
    required this.name,
    required this.goalData,
    required this.controller,
    required this.popularFundsKey,
  });

  @override
  State<_WebLayout> createState() => _WebLayoutState();
}

class _WebLayoutState extends State<_WebLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xffF5F7FA),

      endDrawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.42,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28),
                bottomLeft: Radius.circular(28),
              ),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha:.08),
                  blurRadius: 30,
                  offset: const Offset(-4, 10),
                ),
              ],
            ),

            child: GoalDetailsFormCard(
              name: widget.name,
              goalData: widget.goalData,
              controller: widget.controller,
            ),
          ),
        ),
      ),

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1500),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TOP HEADER
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.name} Goal Planning",
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff111827),
                          ),
                        ),

                        const Gap(6),

                        Text(
                          "Plan and track your investments professionally",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    /// CREATE GOAL BUTTON
                    SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Ucolors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          _scaffoldKey.currentState?.openEndDrawer();
                        },
                        icon: const Icon(Iconsax.add_circle),
                        label: const Text(
                          "Create Goal",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const Gap(28),

                /// MAIN CONTENT
                Expanded(
                  child: Obx(() {
                    if (!widget.controller.isGoalSaved.value) {
                      return _buildEmptyState();
                    }

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// SIP PROJECTION
                          Container(
                            padding: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: const Color(0xffE5E7EB),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha:.04),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: const [
                                Row(
                                  children: [
                                    Icon(Iconsax.chart_2),
                                    Gap(10),
                                    Text(
                                      "SIP Projection",
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                Gap(24),

                                ProjectionGraph(),
                              ],
                            ),
                          ),

                          const Gap(24),

                          /// RECOMMENDED FUNDS
                          Container(
                            padding: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: const Color(0xffE5E7EB),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha:.04),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Iconsax.medal_star),

                                    const Gap(10),

                                    const Text(
                                      "Recommended Funds",
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const Spacer(),

                                    Container(
                                      padding:
                                      const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green
                                            .withValues(alpha:.08),
                                        borderRadius:
                                        BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        "Top Performing Funds",
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontFamily: FontFamily.medium,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const Gap(24),

                                PopularFund(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xffE5E7EB),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              color: Ucolors.primary.withValues(alpha:.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Iconsax.chart_square,
              size: 54,
              color: Ucolors.primary,
            ),
          ),

          const Gap(28),

          const Text(
            "No Goal Created Yet",
            style: TextStyle(
              fontSize: 28,
              fontFamily: FontFamily.medium,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Gap(12),

          Text(
            "Click on 'Create Goal' button to start planning\nyour investment journey.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              fontFamily: FontFamily.medium,
              color: Colors.grey.shade600,
            ),
          ),

          const Gap(28),

          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Ucolors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
            icon: const Icon(Iconsax.add_circle),
            label: const Text("Create Goal"),
          ),
        ],
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final String name;
  final Map<String, dynamic> goalData;
  final GoalSipController controller;
  final GlobalKey popularFundsKey;

  const _MobileLayout({
    required this.name,
    required this.goalData,
    required this.controller,
    required this.popularFundsKey,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Gap(12),
            // ✅ UPDATED: Passing Controller to Cover Section
            CoverSection(controller: controller),
            GoalNameSelect(goalName: name, controller: controller),
            SIPSection(
              amount: goalData['amount'].toDouble(),
              duration: goalData['duration'].toInt(),
              rate: goalData['rate'].toDouble(),
            ),
            const Gap(12),
            Obx(() {
              if (!controller.isGoalSaved.value) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: UElevatedBUtton(
                    onPressed: () async {
                      await controller.saveGoalToDb();
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (popularFundsKey.currentContext != null) {
                          Scrollable.ensureVisible(
                            popularFundsKey.currentContext!,
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.easeInOutCubic,
                            alignment: 0.1,
                          );
                        }
                      });
                      await Get.find<MutualFundController>().fetchData();
                    },
                    child: Center(
                      child: Text(
                        "Save Goal",
                        style: AppTextStyles.bodyMedium(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  const ProjectionGraph(),
                  const Gap(9),
                  USectionHeading(
                    key: popularFundsKey,
                    title: 'Popular Funds',
                    showActionButton: true,
                    onPressed: () {
                      log('goal create');
                      _showExploreMoreBottomSheet(context);
                    },
                  ),
                  PopularFund(),
                  const Gap(10),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showExploreMoreBottomSheet(BuildContext context) {
    final mutualController = Get.find<MutualFundController>();
    final goalSipController = Get.find<GoalSipController>(); // ✅ Added
    final cartController = Get.find<CartController>(); // ✅ Added
    final FocusNode searchFocus = FocusNode();

    goalSipController.selectedPopularFund.clear();

    // final freshGoal = goalSipController.goalResponse.value?.data
    //     ?.firstWhereOrNull((g) => g.id == goalId);

    //     if (freshGoal != null) {
    //   for (var fund in freshGoal.goalFunds) {
    //     final name = fund.mutualFund?.schemeName;
    //     if (name != null) {
    //       goalSipController.selectedPopularFund.add(name);
    //     }
    //   }
    // }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.96,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                // --- DRAG HANDLE ---
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 16),
                    height: 5,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                // --- HEADER & CLOSE BUTTON ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Explore Funds",
                            style: AppTextStyles.h2(color: Ucolors.dark),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Search and select funds for your goal.",
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: FontFamily.medium,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          Navigator.of(context).pop();
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey.shade100,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // --- SEARCH BAR & FILTERS (Unchanged) ---
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Obx(() {
                        final fundController = Get.find<FundhouseController>();
                        final int filterCount =
                            fundController.activeFilterCount;

                        return Badge(
                          isLabelVisible: filterCount > 0,
                          backgroundColor: Ucolors.primary,
                          label: Text(
                            '$filterCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: FontFamily.medium,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          alignment: const Alignment(0.7, -0.7),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              shape: BoxShape.circle,
                            ),
                            child: CompactIcon(
                              icon: Icons.tune,
                              onPressed: () async {
                                final result = await Get.toNamed(
                                  AppRoutes.filterpage,
                                );
                                if (result != null &&
                                    result is Map<String, dynamic>) {
                                  mutualController.applyFilters(result);
                                }
                              },
                            ),
                          ),
                        );
                      }),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        height: 30,
                        width: 1,
                        color: Colors.grey.shade300,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 44,
                          child: Obx(() {
                            final bool isSearching =
                                mutualController.hasSearchFocus.value;
                            return Row(
                              children: [
                                Expanded(
                                  child: SearchBar(
                                    onTap: () =>
                                        mutualController.setSearchFocus(true),
                                    onTapOutside: (event) {
                                      searchFocus.unfocus();
                                      mutualController.setSearchFocus(false);
                                    },
                                    focusNode: searchFocus,
                                    backgroundColor: WidgetStateProperty.all(
                                      Colors.grey.shade50,
                                    ),
                                    leading: Icon(
                                      Icons.search,
                                      color: Colors.grey.shade600,
                                    ),
                                    hintText: 'Search mutual funds...',
                                    hintStyle: WidgetStateProperty.all(
                                      TextStyle(
                                        fontFamily: FontFamily.medium,
                                        color: Colors.grey.shade500,
                                        fontSize: 14,
                                      ),
                                    ),
                                    onChanged: (value) => mutualController
                                        .onSearchQueryChanged(value),
                                    elevation: WidgetStateProperty.all(0),
                                    side: WidgetStateProperty.all(
                                      BorderSide(color: Colors.grey.shade200),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.grey.shade200, height: 20),

                // --- 🚀 THE UPDATED FUNDS LISTVIEW ---
                Expanded(
                  child: Obx(() {
                    if (mutualController.isLoading.value) {
                      return const Align(
                        alignment: Alignment.topCenter,
                        child: CircularProgressIndicator(
                          color: Ucolors.primary,
                        ),
                      );
                    }

                    if (mutualController.searchFund.isEmpty) {
                      return Center(
                        child: Text(
                          "No mutual funds found",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      );
                    }

                    return NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        // Check if we scrolled near the bottom (within 200 pixels)
                        if (scrollInfo.metrics.pixels >=
                            scrollInfo.metrics.maxScrollExtent - 200) {
                          // Prevent spamming the API if it's already loading or has no more data
                          if (!mutualController.isMoreLoading.value &&
                              mutualController.canLoadMore) {
                            mutualController
                                .loadNextPage(); // Triggers your pagination API!
                          }
                        }
                        return false; // Return false so the sheet can still drag up/down normally
                      },
                      child: ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.only(bottom: 20),
                        itemCount:
                            mutualController.searchFund.length +
                            (mutualController.isMoreLoading.value ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == mutualController.searchFund.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: Center(
                                child: SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Ucolors.primary,
                                  ),
                                ),
                              ),
                            );
                          }

                          final fund = mutualController.searchFund[index];
                          final name = fund.baseSchemeName ?? 'Unknown Name';
                          final schemeCodeStr = fund.schemeCode.toString();

                          return Obx(() {
                            // ✅ 1. Use GoalSipController to check selection status
                            final isSelected = goalSipController.isSelectedFund(
                              name,
                            );

                            return Stack(
                              children: [
                                Container(
                                  //  2. Removed horizontal margins so it sits flush
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 0,
                                    vertical: 6,
                                  ),
                                  child: MutualFundCard(
                                    entity: fund,
                                    showTrainlings:
                                        false, //  3. Hides trailing returns
                                    // 4. Replaced generic toggle with Cart + Goal logic
                                    onTapOverride: () {
                                      FocusScope.of(context).unfocus();
                                      final int? currentGoalId =
                                          goalSipController
                                              .savedDatabaseId
                                              .value;

                                      if (!isSelected) {
                                        // Add to Goal Cart
                                        goalSipController.toggleFund(name);
                                        cartController.addToCart(
                                          title: 'Goal',
                                          fund.schemeCode ?? '',
                                          name,
                                          fund.minSipAmount ?? 0,
                                          currentGoalId,
                                        );
                                      } else {
                                        // Remove from Goal Cart
                                        final cartItem = cartController
                                            .cartResponseEntity
                                            .value
                                            ?.items
                                            .firstWhereOrNull(
                                              (item) =>
                                                  item.schemeCode.toString() ==
                                                  schemeCodeStr,
                                            );

                                        if (cartItem != null &&
                                            cartItem.id != null) {
                                          cartController.deleteCartItem(
                                            cartItem.id!,
                                            name,
                                          );
                                          goalSipController.toggleFund(name);
                                        }
                                      }
                                    },
                                  ),
                                ),

                                if (isSelected)
                                  Positioned.fill(
                                    child: IgnorePointer(
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Ucolors.primary.withValues(alpha:
                                            0.05,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          border: Border.all(
                                            color: Ucolors.primary,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          });
                        },
                      ),
                    );
                  }),
                ),

                // --- FLOATING "DONE" BUTTON ---
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha:0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Obx(() {
                    // ✅ Updated to count from the GoalSipController!
                    final selectedCount =
                        goalSipController.selectedPopularFund.length;

                    return UElevatedBUtton(
                      onPressed: () => Get.back(), // Closes the bottom sheet
                      child: Center(
                        child: Text(
                          selectedCount > 0
                              ? 'Add $selectedCount Funds'
                              : 'Done',
                          style: AppTextStyles.bodyMedium(color: Colors.white),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            );
          },
        );
      },
    ).whenComplete(() {
      Future.delayed(const Duration(milliseconds: 300), () {
        mutualController.setSearchFocus(false);
        Get.find<FundhouseController>().clearAllFilters();
        mutualController.silentReset();
        // goalSipController.selectedPopularFund.clear();
      });
    });
  }
}
class GoalDetailsFormCard extends StatelessWidget {
  final String name;
  final Map<String, dynamic> goalData;
  final GoalSipController controller;

  const GoalDetailsFormCard({
    super.key,
    required this.name,
    required this.goalData,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            /// HEADER
            Container(
              padding: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade200,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Ucolors.primary.withValues(alpha:.08),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Iconsax.flag,
                      color: Ucolors.primary,
                      size: 22,
                    ),
                  ),

                  const Gap(8),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Create Your Goal",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff111827),
                          ),
                        ),

                        const Gap(4),

                        Text(
                          "Plan your $name goal with smart SIP recommendations",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.close),
                    ),
                  ),
                ],
              ),
            ),

            /// BODY
            SizedBox(
              height: constraints.maxHeight - 50,
              child: ScrollConfiguration(
                behavior: const MaterialScrollBehavior().copyWith(
                  dragDevices: {
                    PointerDeviceKind.mouse,
                    PointerDeviceKind.touch,
                    PointerDeviceKind.trackpad,
                  },
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 4),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      CoverSection(controller: controller),

                      const Gap(4),

                      GoalNameSelect(
                        goalName: name,
                        controller: controller,
                      ),

                      const Gap(4),

                      SIPSection(
                        amount:
                        goalData['amount'].toDouble(),
                        duration:
                        goalData['duration'].toInt(),
                        rate: goalData['rate'].toDouble(),
                      ),

                      const Gap(4),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                            Ucolors.primary,
                            foregroundColor:
                            Colors.white,
                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(
                                14,
                              ),
                            ),
                          ),
                          onPressed: () async {
                            await controller
                                .saveGoalToDb();
                          },
                          child: const Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Icon(Iconsax.calculator),
                              Gap(10),
                              Text(
                                "Save Goal & Calculate",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                  FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const Gap(10),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
// ==========================================
// 🧩 WIDGETS (SIPSection, PopularFund, etc.)
// ==========================================

class PopularFund extends StatelessWidget {
  PopularFund({super.key});

  final MutualFundController controller = Get.find();
  final GoalSipController goalSipController = Get.find();
  final CartController cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    // Adapt Grid for Web Split View
    final bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    // On Desktop, since we are in a split view (60% width), we treat it like a Tablet
    final int crossAxisCount = isDesktop ? 3 : 2;
    final double childAspectRatio = isDesktop ? 1.4 : 1.55;

    return GridView.builder(
      itemCount: controller.searchFund.length.clamp(0, 6), // Limit items
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      // Inside PopularFund class -> GridView.builder -> itemBuilder
      itemBuilder: (context, index) {
        final fund = controller.searchFund[index];
        final name = fund.baseSchemeName ?? 'Unknown Name';
        final schemeCodeStr = fund.schemeCode.toString();
        final img = "${Appurl.baseUrl}${fund.amc?.amcLogoUrl}";
        final returns = fund.returnsEntity?.threeYear ?? "";

        return Obx(() {
          // ✅ 1. Check selection status
          final isSelected = goalSipController.isSelectedFund(name);
          final int? currentGoalId = goalSipController.savedDatabaseId.value;

          return Stack(
            children: [
              Container(
                // ✅ 2. Margin settings from your history
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                child: PopularFundCardMob(
                  // Or MutualFundCard depending on your grid design
                  borderColor: isSelected
                      ? Colors.transparent
                      : Ucolors.borderColor,
                  isNetwork: true,
                  imgPath: img,
                  name: name,
                  threeYear: returns,
                  // If using MutualFundCard, use onTapOverride.
                  // If using PopularFundCard with a GestureDetector:
                ),
              ),

              // Transparent tap layer
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    if (!isSelected) {
                      // ✅ 3. Add to Cart Logic
                      goalSipController.toggleFund(name);
                      cartController.addToCart(
                        title: 'Goal',
                        fund.schemeCode ?? '',
                        name,
                        goalSipController.monthlySip.value,
                        currentGoalId,
                      );
                    } else {
                      // ✅ 4. Remove from Cart Logic
                      final cartItem = cartController
                          .cartResponseEntity
                          .value
                          ?.items
                          .firstWhereOrNull(
                            (item) =>
                                item.schemeCode.toString() == schemeCodeStr,
                          );

                      if (cartItem != null && cartItem.id != null) {
                        cartController.deleteCartItem(cartItem.id!, name);
                        goalSipController.toggleFund(name);
                      }
                    }
                  },
                ),
              ),

              // ✅ 5. THE SELECTION OVERLAY (From your Github Diff)
              if (isSelected)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      // margin: const EdgeInsets.symmetric(
                      //   horizontal: 16,
                      //   vertical: 10,
                      // ),
                      decoration: BoxDecoration(
                        color: Ucolors.primary.withValues(alpha:0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Ucolors.primary, width: 2),
                      ),
                    ),
                  ),
                ),
            ],
          );
        });
      },

      // itemBuilder: (context, index) {
      //   final fund = controller.searchFund[index];
      //   final id = fund.amc?.id;
      //   if (id == null) return const SizedBox();
      //   final img = "${Appurl.baseUrl}${fund.amc?.amcLogoUrl}";
      //   final img1 = fund.amc?.amcLogoUrl ?? '';
      //   final name = fund.baseSchemeName ?? 'Unknown Name';
      //   final returns = fund.returnsEntity?.threeYear ?? "";

      //   return Obx(
      //     () => GestureDetector(
      //       onTap: () {
      //         final isSelected = goalSipController.isSelectedFund(name);
      //         final schemeCodeStr = fund.schemeCode.toString();
      //         final int? currentGoalId =
      //             goalSipController.savedDatabaseId.value;

      //         if (!isSelected) {
      //           // Check if goal is saved first

      //           goalSipController.toggleFund(name);

      //           cartController.addToCart(
      //             title: 'Goal',
      //             fund.schemeCode ?? '',
      //             fund.baseSchemeName ?? '',
      //             // fund.minSipAmount ?? 0,
      //             goalSipController.monthlySip.toInt(),

      //             currentGoalId,
      //           );
      //         } else {
      //           // REMOVE LOGIC
      //           final cartItem = cartController.cartResponseEntity.value?.items
      //               .firstWhereOrNull(
      //                 (item) => item.schemeCode.toString() == schemeCodeStr,
      //               );

      //           if (cartItem != null && cartItem.id != null) {
      //             cartController.deleteCartItem(cartItem.id!, name);
      //             goalSipController.toggleFund(name);
      //           }
      //         }
      //       },
      //       // onTap: () {
      //       //   final isSelected = goalSipController.isSelectedFund(name);
      //       //   final schemeCodeStr = fund.schemeCode.toString();

      //       //   if (!isSelected) {
      //       //     // ADD TO CART
      //       //     goalSipController.toggleFund(name);
      //       //     cartController.addToCart(
      //       //       fund.schemeCode ?? '',
      //       //       fund.baseSchemeName ?? '',
      //       //       fund.minSipAmount ?? 0,
      //       //       1
      //       //     );
      //       //   } else {
      //       //     // REMOVE FROM CART
      //       //     // 1. Find the item in the cart that matches this scheme code
      //       //     final cartItem = cartController.cartResponseEntity.value?.items
      //       //         .firstWhereOrNull(
      //       //           (item) => item.schemeCode.toString() == schemeCodeStr,
      //       //         );

      //       //     if (cartItem != null && cartItem.id != null) {
      //       //       // 2. Use the actual cart item ID to delete
      //       //       cartController.deleteCartItem(cartItem.id!, name);
      //       //       // 3. Untoggle the UI state
      //       //       goalSipController.toggleFund(name);
      //       //     } else {
      //       //       // Fallback: If not found in cart list, just untoggle UI
      //       //       goalSipController.toggleFund(name);
      //       //       log(
      //       //         "Item not found in cart response, couldn't delete from server.",
      //       //       );
      //       //     }
      //       //   }
      //       // },
      //       // onTap: () async {
      //       //   final isSelected = goalSipController.isSelectedFund(name);
      //       //   goalSipController.toggleFund(name);

      //       //   // !isSelected
      //       //   //     ?
      //       //   //       //  cartController.addItem(
      //       //   //       //     CartItem(
      //       //   //       //       fundId: id.toString(),
      //       //   //       //       fundName: name,
      //       //   //       //       logoUrl: img1,
      //       //   //       //     ),
      //       //   //       //   )
      //       //   //       await cartController.addToCart(
      //       //   //         fund.schemeCode ?? '',
      //       //   //         fund.baseSchemeName ?? '',
      //       //   //         fund.minSipAmount ?? 0,
      //       //   //         1
      //       //   //       )
      //       //   //     :
      //       //   //       // cartController.removeItemByName(name);
      //       //   //       await cartController.deleteCartItem(
      //       //   //         cartController
      //       //   //                 .cartResponseEntity
      //       //   //                 .value
      //       //   //                 ?.items[index]
      //       //   //                 .id ??
      //       //   //             0,
      //       //   //         fund.baseSchemeName ?? '',
      //       //   //       );
      //       //   if (!isSelected) {
      //       //     cartController.addItem(
      //       //       CartItem(
      //       //         fundId: id.toString(),
      //       //         fundName: name,
      //       //         logoUrl: img1,
      //       //       ),
      //       //     );
      //       //     // PASS THE GOAL ID HERE
      //       //     cartController.addToCart(
      //       //       fund.schemeCode ?? '',
      //       //       fund.baseSchemeName ?? '',
      //       //       fund.minSipAmount ?? 0,
      //       //       1, // Use the dynamic ID from your saved goal if available
      //       //     );
      //       //   } else {
      //       //     // cartController.deleteCartItem(
      //       //     //   // fund.amc?.id ?? 0,
      //       //     //   cartController.cartResponseEntity.value.items.indexWhere(fund.schemeCode.toString())
      //       //     //   fund.baseSchemeName ?? '',
      //       //     // );
      //       //     cartController.removeItemByName(name);
      //       //   }
      //       // },
      //       child: PopularFundCard(
      //         borderColor: goalSipController.isSelectedFund(name)
      //             ? Ucolors.primary
      //             : Ucolors.borderColor,
      //         isNetwork: true,
      //         imgPath: img,
      //         name: name,
      //         threeYear: returns,
      //       ),
      //     ),
      //   );
      // },
    );
  }
}

class ProjectionGraph extends StatefulWidget {
  const ProjectionGraph({super.key});

  @override
  State<ProjectionGraph> createState() => _ProjectionGraphState();
}

class _ProjectionGraphState extends State<ProjectionGraph> {
  int selectedView = 0;

  List<FlSpot> investedSpotsFromRows(List<ReturnRow> rows) {
    return rows.map((e) => FlSpot(double.parse(e.period), e.scheme)).toList();
  }

  List<FlSpot> valueSpotsFromRows(List<ReturnRow> rows) {
    return rows.map((e) => FlSpot(double.parse(e.period), e.category)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GoalSipController>();
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Container(
      // On mobile, the container has decoration. On Web, the parent card has decoration.
      padding: isDesktop ? EdgeInsets.zero : const EdgeInsets.all(15),
      decoration: isDesktop
          ? null
          : BoxDecoration(
              color: Ucolors.light,
              borderRadius: BorderRadius.circular(12),
            ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Projection',
                style: UTextStyles.medium.copyWith(fontWeight: FontWeight.w700),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xffF3F4F6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    ProjectionIcon(
                      onTap: () => setState(() => selectedView = 0),
                      isSelected: selectedView == 0,
                      icon: Icons.trending_up,
                    ),
                    ProjectionIcon(
                      onTap: () => setState(() => selectedView = 1),
                      isSelected: selectedView == 1,
                      icon: Icons.grid_on_sharp,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(20),
          if (selectedView == 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '● Invest',
                  style: UTextStyles.small.copyWith(
                    color: const Color(0xff868686),
                  ),
                ),
                Text(
                  '● Value',
                  style: UTextStyles.small.copyWith(
                    color: const Color(0xff213C73),
                  ),
                ),
              ],
            ),
            const Gap(25),
            Obx(() {
              final rows = controller.buildYearlyReport();
              if (rows.isEmpty)
                return const SizedBox(
                  height: 250,
                  child: CircularProgressIndicator(),
                );

              return SizedBox(
                height: 250,
                child: SipProjectionChart(
                  showLeftNumbers: true,
                  textColor: Colors.black,
                  investedSpots: investedSpotsFromRows(rows),
                  projectedSpots: valueSpotsFromRows(rows),
                ),
              );
            }),
          ] else
            Obx(() {
              final result = controller.buildYearlyReport();
              return Column(
                children: [
                  const TableHeader(
                    heading1: 'Year',
                    heading2: 'Invest',
                    heading3: 'Curent',
                    heading4: 'Profit',
                  ),
                  DashedLine(color: Ucolors.borderColor, dashSpace: 0),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: result.length,
                    itemBuilder: (context, index) {
                      final row = result[index];
                      return ReturnsTableRow(
                        color4: Colors.green,
                        data: row,
                        percentage: false,
                      );
                    },
                  ),
                ],
              );
            }),
        ],
      ),
    );
  }
}

class ProjectionIcon extends StatelessWidget {
  const ProjectionIcon({
    super.key,
    required this.onTap,
    required this.isSelected,
    required this.icon,
  });
  final VoidCallback onTap;
  final bool isSelected;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: isSelected ? Ucolors.blue : Colors.grey),
      ),
    );
  }
}

class AllValue extends StatelessWidget {
  const AllValue({
    super.key,
    required this.title,
    required this.value,
    this.textColor,
  });
  final String title;
  final double value;
  final Color? textColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Column(
        children: [
          Text(
            title,
            style: UTextStyles.medium.copyWith(fontWeight: FontWeight.w600),
          ),
          const Gap(5),
          Text(
            '₹${value.toDouble().toStringAsFixed(0)}',
            style: TextStyle(
              color: textColor ?? Ucolors.dark,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class SIPSection extends StatelessWidget {
  const SIPSection({
    super.key,
    required this.amount,
    required this.duration,
    this.rate = 12,
  });
  final double amount;
  final int duration;
  final double rate;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GoalSipController>();
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Ucolors.light,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SipSliderTile2(
            prefix: '₹',
            title: 'I need',
            value: amount,
            min: 100,
            max: 10000000,
            suffix: '',
            onChanged: (value) => controller.setTarget(value),
          ),
          SipSliderTile2(
            title: 'Duration',
            value: duration.toDouble(),
            min: 1,
            max: 30,
            suffix: 'Yrs',
            onChanged: (value) => controller.setYears(value),
          ),
          const Gap(15),
          SipSliderTile2(
            title: 'Expected Returns',
            value: rate,
            min: 1,
            max: 30,
            suffix: '%',
            onChanged: (value) => controller.setRate(value),
          ),
          Obx(
            () => Row(
              children: [
                Expanded(
                  child: AllValue(
                    title: 'Invested',
                    value: controller.invested.toDouble(),
                  ),
                ),
                Expanded(
                  child: AllValue(
                    title: 'Future Value',
                    value: controller.targetAmount.toDouble(),
                  ),
                ),
                Expanded(
                  child: AllValue(
                    title: 'Total Return',
                    value: controller.totalReturn.toDouble(),
                    textColor: Ucolors.success,
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

class GoalNameSelect extends StatelessWidget {
  final GoalSipController controller;
  final String
  goalName; // Still accepting to handle matching references if needed

  const GoalNameSelect({
    super.key,
    required this.goalName,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [const SmallHeading(smallheading: 'Goal Category')]),
        const Gap(5),

        // Dynamic Dropdown Input container matching White background card logic
        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.selectedGoalType.value,
                isExpanded: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Ucolors.darkgrey,
                ),
                dropdownColor: Colors.white,
                items: controller.goalConfig.keys.map((String key) {
                  final itemName =
                      controller.goalConfig[key]?['name'] ?? 'Custom';
                  return DropdownMenuItem<String>(
                    value: key,
                    child: Text(
                      itemName,
                      style: const TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    controller.updateGoalType(newValue);
                  }
                },
              ),
            ),
          ),
        ),

        const Gap(15),
        Row(children: [const SmallHeading(smallheading: 'Custom Goal Title')]),
        const Gap(5),
        Obx(() {
          final activeLabel =
              controller.goalConfig[controller
                  .selectedGoalType
                  .value]?['name'] ??
              'Custom';
          return UTextFormField(
            controller: controller.goalNameTextEditingController,
            backgroundColor: Colors.white,
            prefixIcon: null,
            hintText: 'Enter specific name for your $activeLabel',
          );
        }),
      ],
    );
  }
}

// class GoalNameSelect extends StatelessWidget {
//   final GoalSipController controller;
//   final String goalName;
//   const GoalNameSelect({
//     super.key,
//     required this.goalName,
//     required this.controller,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(children: [SmallHeading(smallheading: 'Goal Name')]),
//         const Gap(5),
//         UTextFormField(
//           readOnly: true,
//           prefixIcon: null,
//           controller: TextEditingController(text: goalName),
//           backgroundColor: Colors.white,
//         ),
//         UTextFormField(
//           controller: controller.goalNameTextEditingController,
//           backgroundColor: Colors.white,
//           prefixIcon: null,
//           hintText: 'Enter $goalName Name',
//         ),
//       ],
//     );
//   }
// }

class CoverSection extends StatelessWidget {
  final GoalSipController controller;
  const CoverSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // We assume 'coverImage' exists in your GoalSipController as Rx<XFile?>
    return Column(
      children: [
        Obx(() {
          if (controller.coverImage.value != null) {
            return GestureDetector(
              onTap: () => _showPicker(context),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: kIsWeb
                    ? Image.network(
                        controller.coverImage.value!.path,
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(controller.coverImage.value!.path),
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
              ),
            );
          }
          return AddCoverBottomSheet(
            recentPhoto: false,
            onTap: () => _showPicker(context),
          );
        }),
        const Gap(5),
        const Text('Add Cover', style: TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (context) => _PickerSheet(controller: controller),
    );
  }
}

class AddCoverBottomSheet extends StatelessWidget {
  final bool recentPhoto;
  final VoidCallback onTap;

  const AddCoverBottomSheet({
    super.key,
    required this.recentPhoto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final containerSize = isMobile ? 100.0 : 120.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: containerSize,
        width: containerSize,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.add, color: Colors.black, size: containerSize * 0.4),
      ),
    );
  }
}

class _PickerSheet extends StatelessWidget {
  final GoalSipController controller;
  final ImagePickerService _pickerService = ImagePickerService();

  _PickerSheet({required this.controller});

  // Future<void> _pick(BuildContext context, ImageSource source) async {
  //   final image = await _pickerService.pickImage(source);
  //   if (image != null) {
  //     controller.coverImage.value = image; // Save to controller
  //     Get.back(); // Close sheet
  //   }
  // }
  Future<void> _pick(BuildContext context, ImageSource source) async {
    // 1. Close the bottom sheet FIRST
    Get.back();

    // 2. Wait just a split second for the closing animation
    await Future.delayed(const Duration(milliseconds: 300));

    // 3. Use the raw ImagePicker directly (Bypass the buggy custom service!)
    try {
      final ImagePicker picker = ImagePicker(); // <-- Use official package

      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 80, // Optional compression
      );

      if (image != null) {
        controller.coverImage.value = image;
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              "Select Image Source",
              style: UTextStyles.medium.copyWith(fontWeight: FontWeight.bold),
            ),
            const Gap(24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOption(
                  icon: Iconsax.camera,
                  label: "Camera",
                  onTap: () => _pick(context, ImageSource.camera),
                ),
                _buildOption(
                  icon: Iconsax.gallery,
                  label: "Gallery",
                  onTap: () => _pick(context, ImageSource.gallery),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Ucolors.primary),
            const Gap(8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
