

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../common/widget/appbar/custom_appbar_normal.dart';
import '../../../../common/widget/appbar/widget/compact_icon.dart';
import '../../../../common/widget/button/elevated_button.dart';
import '../../../../common/widget/images/custom_cached_image.dart';
import '../../../../common/widget/table/table_header.dart';
import '../../../../common/widget/text/view_all.dart';
import '../../../../common/widget/text_form/custom_text_field.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/constant/appUrl.dart';
import '../../../../core/utils/constant/colors.dart';
import '../../../../core/utils/constant/text_style.dart';
import '../../../../core/utils/helper/helpers.dart';
import '../../../../navigation_menu_bar.dart';
import '../../../cart/domain/usecases/cart_usecases.dart';
import '../../../cart/presentation/controllers/cart_controller.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../../../explore/presentation/controller/fundhouse_controller.dart';
import '../../../explore/presentation/controller/mutual_fund_controller.dart';
import '../../../explore/presentation/pages/explore.dart';
import '../../../fund_details/data/models/return_model.dart';
import '../../../fund_details/presentation/pages/fund_deatails.dart';
import '../../../fund_details/presentation/widgets/return.dart';
import '../../../home/presentation/pages/home.dart';
import '../../../home/presentation/widgets/product_tool/widget/sipslidertile.dart';
import '../../../sip_process/presentation/widgets/sip_projection_chart.dart';
import '../../domain/entity/goal_entity.dart';
import '../controller/goal_sip_controller.dart';

// =============================================================================
// MasterGoalsPage
// Entry point — routes to edit or create flow
// =============================================================================
class MasterGoalsPage extends GetView<GoalSipController> {
  const MasterGoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GoalSipController>(
      initState: (_) async {
        await controller.getMasterGoals();

        final args = Get.arguments ?? {};
        final String initialType = args['goalType'] ?? 'custom';
        controller.isEdit.value = args['isEdit'] ?? false;
        final UserGoalEntity? goal = args['goal'];

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!controller.isEdit.value) {
            controller.resetStateForNewGoal();
          }
          controller.updateGoalType(initialType);
          if (controller.isEdit.value && goal != null) {
            controller.loadGoalForEdit(goal);
          }
        });

        controller.update();
      },
      builder: (controller) {
        // EDIT MODE → go directly to details
        if (controller.isEdit.value) {
          return GoalDetailsScreen();
        }

        // CREATE MODE → animated grid
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 450),
          transitionBuilder: (child, animation) {
            final offsetAnimation = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation);
            return SlideTransition(
              position: offsetAnimation,
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: const GoalsGridScreen(key: ValueKey("grid")),
        );
      },
    );
  }
}

// =============================================================================
// GoalDetailsScreen
// Fixed: removed duplicate UI blocks, unified post-save/edit logic
// =============================================================================
class GoalDetailsScreen extends GetView<GoalSipController> {
  GoalDetailsScreen({super.key});

  final CartController cartController = Get.find<CartController>();
  final GlobalKey popularFundsKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      backgroundColor: isDesktop ? const Color(0xFFF5F7FA) : Colors.grey[50],
      appBar: CustomAppBarNormal(
        backgroundColor: Ucolors.light,
        title: controller.selectedGoalType.value.capitalizeFirst ?? '',
        backIcon: true,
        actionsPadding: 10,
        action: [
          Obx(() {
            if (!controller.isGoalSaved.value) return const SizedBox.shrink();
            return TextButton(
              onPressed: () {
                Get.offAllNamed(AppRoutes.navMenuBar);
                Future.delayed(const Duration(milliseconds: 100), () {
                  if (Get.isRegistered<NavigationBarController>()) {
                    Get.find<NavigationBarController>().selectedIndex.value = 3;
                  }
                });
              },
              child: Text(
                "View All Goals",
                style: TextStyle(color: Ucolors.primary),
              ),
            );
          }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SIPSectionGoal(),
                  const Gap(4),
                  Obx(() {
                    final bool isEdit = controller.isEdit.value;
                    final bool hasChanges = controller.hasChanges.value;
                    final bool isGoalSaved = controller.isGoalSaved.value;

                    // ─────────────────────────────────────────────────────
                    // CASE 1: Edit mode, nothing changed yet
                    //   → Show projection + funds, no save button
                    // ─────────────────────────────────────────────────────
                    if (isEdit && !hasChanges) {
                      return _buildProjectionAndFunds(context);
                    }

                    // ─────────────────────────────────────────────────────
                    // CASE 2: New goal not saved yet  OR  edit with changes
                    //   → Show save / update button only
                    // ─────────────────────────────────────────────────────
                    if (!isGoalSaved || (isEdit && hasChanges)) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: UElevatedBUtton(
                          onPressed: () async {
                            if (isEdit) {
                              // await controller.updateGoal();
                            } else {
                              await controller.saveGoalToDb();
                              // Scroll to popular funds after save
                              WidgetsBinding.instance
                                  .addPostFrameCallback((_) {
                                if (popularFundsKey.currentContext != null) {
                                  Scrollable.ensureVisible(
                                    popularFundsKey.currentContext!,
                                    duration:
                                    const Duration(milliseconds: 800),
                                    curve: Curves.easeInOutCubic,
                                    alignment: 0.1,
                                  );
                                }
                              });
                              await Get.find<MutualFundController>()
                                  .fetchData();
                            }
                          },
                          child: Center(
                            child: Text(
                              isEdit ? "Update Goal" : "Save Goal",
                              style:
                              AppTextStyles.bodyMedium(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    }

                    // ─────────────────────────────────────────────────────
                    // CASE 3: Goal saved successfully
                    //   → Show projection + funds
                    // ─────────────────────────────────────────────────────
                    return _buildProjectionAndFunds(context);
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() {
        if (!controller.isGoalSaved.value) return const SizedBox.shrink();
        return SafeArea(
          top: false,
          child: CartBottomBar(
            isValid: controller.selectedPopularFund.isNotEmpty,
            ontap: () {
              if (controller.selectedPopularFund.isEmpty) {
                Get.snackbar("Error", "Please select funds to start SIP");
                return;
              }

              // OLD INSTANCE REMOVE
              if (Get.isRegistered<CartController>()) {
                Get.delete<CartController>(force: true);
              }

              // NEW INSTANCE CREATE
              final CartController cartCont = Get.put(
                CartController(Get.find<CartUsecases>()),
              );

              cartCont.clearCart();

              cartCont.filterGoalId.value =
                  controller.savedDatabaseId.value;

              cartCont.monthlyAmount.value =
                  controller.monthlySip.value.toInt();

              Get.toNamed(
                AppRoutes.cart,
                arguments: {
                  'monthlyAmount':
                  controller.monthlySip.value.toInt(),
                  'goal_id':
                  controller.savedDatabaseId.value,
                  'isFromGoal': true,
                },
              );
            },
            amount: controller.monthlySip.value.toStringAsFixed(0),
            amountColor: Ucolors.blue,
            title: 'Installment Amount',
            buttonText: 'Start SIP',
          ),
        );
      }),
    );
  }

  // ── Shared UI: Projection chart + fund heading + fund grid ──────────────────
  Widget _buildProjectionAndFunds(BuildContext context) {
    return Column(
      children: [
        const ProjectionGraph(),
        const Gap(9),
        Obx(() {
          final selectedCount = controller.selectedPopularFund.length;
          return USectionHeading(
            key: popularFundsKey,
            title: selectedCount > 0
                ? 'Selected Funds ($selectedCount)'
                : 'Popular Funds',
            showActionButton: true,
            buttonTitle: selectedCount > 0 ? 'Add Funds' : 'View All',
            onPressed: () => _showExploreMoreBottomSheet(context),
          );
        }),
        const Gap(10),
        PopularAndSelectedFund(),
        const Gap(10),
      ],
    );
  }

  // =============================================================================
  // Explore More Bottom Sheet
  // Fixed: consistent amount (minSipAmount), no duplicate card render
  // =============================================================================
  void _showExploreMoreBottomSheet(BuildContext context) {
    final mutualController = Get.find<MutualFundController>();
    final goalSipController = Get.find<GoalSipController>();
    final cartController = Get.find<CartController>();
    final FocusNode searchFocus = FocusNode();

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
                // Drag handle
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

                // Header
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

                // Search + Filter
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Obx(() {
                        final fundController =
                        Get.find<FundhouseController>();
                        final int filterCount =
                            fundController.activeFilterCount;
                        return Badge(
                          isLabelVisible: filterCount > 0,
                          backgroundColor: Ucolors.primary,
                          label: Text(
                            '$filterCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          padding:
                          const EdgeInsets.symmetric(horizontal: 4),
                          alignment: const Alignment(0.7, -0.7),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border:
                              Border.all(color: Colors.grey.shade300),
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
                        margin:
                        const EdgeInsets.symmetric(horizontal: 12),
                        height: 30,
                        width: 1,
                        color: Colors.grey.shade300,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 44,
                          child: SearchBar(
                            onTap: () =>
                                mutualController.setSearchFocus(true),
                            onTapOutside: (event) {
                              searchFocus.unfocus();
                              mutualController.setSearchFocus(false);
                            },
                            focusNode: searchFocus,
                            backgroundColor:
                            MaterialStateProperty.all(
                                Colors.grey.shade50),
                            leading: Icon(Icons.search,
                                color: Colors.grey.shade600),
                            hintText: 'Search mutual funds...',
                            hintStyle: MaterialStateProperty.all(
                              TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 14),
                            ),
                            onChanged: (value) =>
                                mutualController
                                    .onSearchQueryChanged(value),
                            elevation:
                            MaterialStateProperty.all(0),
                            side: MaterialStateProperty.all(
                              BorderSide(color: Colors.grey.shade200),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.grey.shade200, height: 20),

                // Fund list
                Expanded(
                  child: Obx(() {
                    if (mutualController.isLoading.value) {
                      return const Align(
                        alignment: Alignment.topCenter,
                        child: CircularProgressIndicator(
                            color: Ucolors.primary),
                      );
                    }

                    if (mutualController.searchFund.isEmpty) {
                      return Center(
                        child: Text(
                          "No mutual funds found",
                          style:
                          TextStyle(color: Colors.grey.shade600),
                        ),
                      );
                    }

                    return NotificationListener<ScrollNotification>(
                      onNotification: (scrollInfo) {
                        if (scrollInfo.metrics.pixels >=
                            scrollInfo.metrics.maxScrollExtent - 200) {
                          if (!mutualController.isMoreLoading.value &&
                              mutualController.canLoadMore) {
                            mutualController.loadNextPage();
                          }
                        }
                        return false;
                      },
                      child: ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.only(bottom: 20),
                        itemCount: mutualController.searchFund.length +
                            (mutualController.isMoreLoading.value
                                ? 1
                                : 0),
                        itemBuilder: (context, index) {
                          // Loading indicator at end
                          if (index ==
                              mutualController.searchFund.length) {
                            return const Padding(
                              padding:
                              EdgeInsets.symmetric(vertical: 24),
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

                          final fund =
                          mutualController.searchFund[index];
                          final name =
                              fund.baseSchemeName ?? 'Unknown Name';
                          final schemeCodeStr =
                          fund.schemeCode.toString();

                          return Obx(() {
                            final isSelected =
                            goalSipController
                                .isSelectedFund(name);

                            return Stack(
                              children: [
                                // ── Fund card (no duplicate render) ──
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 6),
                                  child: MutualFundCard(
                                    entity: fund,
                                    showTrainlings: false,
                                    onTapOverride: () {
                                      FocusScope.of(context).unfocus();
                                      _toggleFundInBottomSheet(
                                        goalSipController:
                                        goalSipController,
                                        cartController: cartController,
                                        fund: fund,
                                        name: name,
                                        schemeCodeStr: schemeCodeStr,
                                        isSelected: isSelected,
                                      );
                                    },
                                  ),
                                ),

                                // ── Selected highlight overlay ──
                                if (isSelected)
                                  Positioned.fill(
                                    child: IgnorePointer(
                                      child: Container(
                                        margin:
                                        const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 10),
                                        decoration: BoxDecoration(
                                          color: Ucolors.primary
                                              .withOpacity(0.05),
                                          borderRadius:
                                          BorderRadius.circular(16),
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

                // Done button
                Container(
                  padding:
                  const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Obx(() {
                    final selectedCount =
                        goalSipController.selectedPopularFund.length;
                    return UElevatedBUtton(
                      onPressed: () => Get.back(),
                      child: Center(
                        child: Text(
                          selectedCount > 0
                              ? 'Add $selectedCount Funds'
                              : 'Done',
                          style: AppTextStyles.bodyMedium(
                              color: Colors.white),
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
      });
    });
  }

  /// Fund toggle logic extracted — used by both bottom sheet and grid
  void _toggleFundInBottomSheet({
    required GoalSipController goalSipController,
    required CartController cartController,
    required dynamic fund,
    required String name,
    required String schemeCodeStr,
    required bool isSelected,
  }) {
    final int? currentGoalId = goalSipController.savedDatabaseId.value;

    if (!isSelected) {
      goalSipController.toggleFund(name);
      cartController.addToCart(
        title: 'Goal',
        fund.schemeCode ?? '',
        name,
        fund.minSipAmount ?? 0, // Always use minSipAmount here
        currentGoalId,
      );
    } else {
      final cartItem = cartController.cartResponseEntity.value?.items
          .firstWhereOrNull(
            (item) => item.schemeCode.toString() == schemeCodeStr,
      );
      if (cartItem != null && cartItem.id != null) {
        cartController.deleteCartItem(cartItem.id!, name);
        goalSipController.toggleFund(name);
      }
    }
  }
}

// =============================================================================
// PopularAndSelectedFund
// Fixed:
//   1. selectedFunds derived from goalSipController.selectedFundNames (stable)
//      instead of filtering the volatile searchFund list
//   2. Removed duplicate Stack/GestureDetector — single GestureDetector only
// =============================================================================
class PopularAndSelectedFund extends StatelessWidget {
  PopularAndSelectedFund({super.key});

  final MutualFundController mutualController = Get.find();
  final GoalSipController goalSipController = Get.find();
  final CartController cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    final bool isDesktop =
    ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final int crossAxisCount = isDesktop ? 3 : 2;
    final double childAspectRatio = isDesktop ? 1.4 : 1.55;

    return Obx(() {
      final allFunds = mutualController.searchFund;

      // ── Stable selected list from controller's name set ──────────────────
      final selectedFunds = allFunds
          .where((f) => goalSipController.isSelectedFund(f.baseSchemeName ?? ''))
          .toList();

      final popularFunds = allFunds
          .where((f) =>
      !goalSipController.isSelectedFund(f.baseSchemeName ?? ''))
          .toList();

      // Selected first, then popular, capped at 6
      final List<dynamic> displayFunds = selectedFunds.isEmpty
          ? popularFunds.take(6).toList()
          : [...selectedFunds, ...popularFunds].take(6).toList();

      if (displayFunds.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.account_balance_wallet,
                    size: 42, color: Ucolors.primary),
                const SizedBox(height: 12),
                Text(
                  "No Funds Available",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Ucolors.dark),
                ),
                const SizedBox(height: 6),
                Text(
                  "Please add funds",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        );
      }

      return GridView.builder(
        itemCount: displayFunds.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          final fund = displayFunds[index];
          final name = fund.baseSchemeName ?? 'Unknown Name';
          final schemeCodeStr = fund.schemeCode.toString();
          final img = "${Appurl.baseUrl}${fund.amc?.amcLogoUrl}";
          final returns = fund.returnsEntity?.threeYear ?? "";
          final int? currentGoalId = goalSipController.savedDatabaseId.value;

          return Obx(() {
            final isSelected = goalSipController.isSelectedFund(name);

            return AnimatedScale(
              duration: const Duration(milliseconds: 250),
              scale: isSelected ? 1.02 : 1,
              // ── Single GestureDetector, no duplicate card ──────────────
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  FocusScope.of(context).unfocus();
                  if (!isSelected) {
                    goalSipController.toggleFund(name);
                    cartController.addToCart(
                      title: 'Goal',
                      fund.schemeCode ?? '',
                      name,
                      fund.minSipAmount ?? 0, // consistent: minSipAmount
                      currentGoalId,
                    );
                  } else {
                    final cartItem = cartController
                        .cartResponseEntity.value?.items
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
                child: PopularFundCardMobSelected(
                  borderColor:
                  isSelected ? Ucolors.primary : Ucolors.borderColor,
                  isNetwork: true,
                  imgPath: img,
                  name: name,
                  threeYear: returns,
                  isSelected: isSelected,
                ),
              ),
            );
          });
        },
      );
    });
  }
}

// =============================================================================
// PopularFundCardMobSelected — unchanged, already correct
// =============================================================================
class PopularFundCardMobSelected extends StatelessWidget {
  const PopularFundCardMobSelected({
    super.key,
    required this.imgPath,
    required this.name,
    this.onTap,
    this.isNetwork = false,
    this.borderColor = Ucolors.borderColor,
    this.threeYear,
    this.isSelected = false,
  });

  final String imgPath;
  final String name;
  final VoidCallback? onTap;
  final bool isNetwork;
  final Color borderColor;
  final String? threeYear;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? Ucolors.primary : Colors.grey.shade100,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? Ucolors.primary.withOpacity(0.12)
                    : Colors.black.withOpacity(0.04),
                blurRadius: isSelected ? 12 : 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            height: isSelected ? 34 : 30,
                            width: isSelected ? 34 : 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade50,
                              border: isSelected
                                  ? Border.all(
                                  color: Ucolors.primary, width: 1.5)
                                  : null,
                            ),
                            child: ClipOval(
                              child: isNetwork
                                  ? CustomCachedImage(
                                  imageUrl: imgPath, size: 40)
                                  : Image.asset(imgPath,
                                  fit: BoxFit.cover),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              name,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: UTextStyles.medium.copyWith(
                                color: Colors.black,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                fontSize: 11,
                                height: 1.1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '3Y',
                            style: UTextStyles.bodySmallW500.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.arrow_drop_up_rounded,
                                color: Ucolors.success, size: 20),
                            Text(
                              '${threeYear ?? 0}%',
                              style: UTextStyles.bodySmallW500.copyWith(
                                color: Ucolors.success,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Selected badge
              if (isSelected)
                Positioned(
                  top: 4,
                  right: 4,
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 250),
                    scale: isSelected ? 1 : 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Ucolors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check,
                          size: 12, color: Colors.white),
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

// =============================================================================
// ProjectionGraph — unchanged, already correct
// =============================================================================
class ProjectionGraph extends StatefulWidget {
  const ProjectionGraph({super.key});

  @override
  State<ProjectionGraph> createState() => _ProjectionGraphState();
}

class _ProjectionGraphState extends State<ProjectionGraph> {
  int selectedView = 0;

  List<FlSpot> investedSpotsFromRows(List<ReturnRow> rows) =>
      rows.map((e) => FlSpot(double.parse(e.period), e.scheme)).toList();

  List<FlSpot> valueSpotsFromRows(List<ReturnRow> rows) =>
      rows.map((e) => FlSpot(double.parse(e.period), e.category)).toList();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GoalSipController>();
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Container(
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
                style:
                UTextStyles.medium.copyWith(fontWeight: FontWeight.w700),
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
                Text('● Invest',
                    style: UTextStyles.small
                        .copyWith(color: const Color(0xff868686))),
                Text('● Value',
                    style: UTextStyles.small
                        .copyWith(color: const Color(0xff213C73))),
              ],
            ),
            const Gap(25),
            Obx(() {
              final rows = controller.buildYearlyReport();
              if (rows.isEmpty) {
                return const SizedBox(
                    height: 250,
                    child: Center(child: CircularProgressIndicator()));
              }
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
                          color4: Colors.green, data: row, percentage: false);
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

// =============================================================================
// SIPSectionGoal — unchanged logic, minor const fix
// =============================================================================
class SIPSectionGoal extends GetView<GoalSipController> {
  const SIPSectionGoal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextFormFieldCustom(
            title: "Goal Title",
            hintTextColor: Ucolors.black,
            hintTextSize: 12,
            borderWidth: 1,
            backgroundColor: Ucolors.light,
            borderColor: Ucolors.darkgrey,
            method: TextFieldCustom(
              height: 50,
              width: double.infinity,
              hintText: "Enter Full Name",
              textInputType: TextInputType.text,
              backgroundColor: Colors.transparent,
              controller: controller.goalNameTextEditingController,
              onChanged: (value) {
                controller.setGoalName(value ?? "");
                return null;
              },
              onEditingComplete: () => FocusScope.of(context).unfocus(),
              suffixIcon: Container(
                width: 30,
                alignment: Alignment.center,
                child: const Text(
                  "*",
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            ),
          ),
          Obx(() => controller.goalError.isNotEmpty
              ? Padding(
            padding: const EdgeInsets.only(top: 4, left: 0),
            child: Text(
              controller.goalError.value,
              style: TextStyle(fontSize: 12, color: Ucolors.red),
            ),
          )
              : const SizedBox.shrink()),
          const Gap(20),

          Obx(() => SipSliderTile2(
            prefix: '₹',
            title: 'I Need',
            value: controller.targetAmount.value < 100
                ? 100
                : controller.targetAmount.value,
            min: 100,
            max: 10000000,
            suffix: '',
            onChanged: controller.setTarget,
          )),
          const Gap(16),

          Obx(() => SipSliderTile2(
            title: 'Duration',
            value: controller.years.value,
            min: 1,
            max: 30,
            suffix: 'Yrs',
            onChanged: controller.setYears,
          )),
          const Gap(16),

          Obx(() => SipSliderTile2(
            title: 'Expected Return',
            value: controller.annualRate.value,
            min: 1,
            max: 30,
            suffix: '%',
            onChanged: controller.setRate,
          )),
          const Gap(20),

          Obx(() => Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              SizedBox(
                width: Get.width * .40 - 12,
                child: _ValueCard(
                  title: 'Daily SIP',
                  value: formatCurrency(
                      controller.dailySipAmount.value),
                ),
              ),
              SizedBox(
                width: Get.width * .40 - 12,
                child: _ValueCard(
                  title: 'Weekly SIP',
                  value: formatCurrency(
                      controller.weeklySipAmount.value),
                ),
              ),
              SizedBox(
                width: Get.width * .40 - 12,
                child: _ValueCard(
                  title: 'Monthly SIP',
                  value: formatCurrency(
                      controller.monthlySip.value.toDouble()),
                ),
              ),

              // Edit mode only: existing + additional SIP
              if (controller.hasChanges.value &&
                  controller.isEdit.value) ...[
                SizedBox(
                  width: Get.width * .20 - 12,
                  child: _ValueCard(
                    title: 'Existing SIP',
                    value: formatCurrency(controller
                        .existingSipAmount.value
                        .toDouble()),
                  ),
                ),
                SizedBox(
                  width: Get.width * .40 - 12,
                  child: _ValueCard(
                    title: 'Additional SIP',
                    value: formatCurrency(controller
                        .additionalSipAmount.value
                        .toDouble()),
                  ),
                ),
              ],

              SizedBox(
                width: Get.width * .40 - 12,
                child: _ValueCard(
                  title: 'Invested',
                  value: formatCurrency(
                      controller.invested.value.toDouble()),
                ),
              ),
              SizedBox(
                width: Get.width * .40 - 12,
                child: _ValueCard(
                  title: 'Future Value',
                  value: formatCurrency(
                      controller.targetAmount.value.toDouble()),
                ),
              ),
              SizedBox(
                width: Get.width * .40 - 12,
                child: _ValueCard(
                  title: 'Total Return',
                  value: formatCurrency(
                      controller.totalReturn.value.toDouble()),
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}

class _ValueCard extends StatelessWidget {
  const _ValueCard({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xffF5F7FB),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(title,
              style:
              TextStyle(color: Colors.grey.shade600, fontSize: 12)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// GoalsGridScreen — unchanged logic, minor const cleanup
// =============================================================================
class GoalsGridScreen extends GetView<GoalSipController> {
  const GoalsGridScreen({super.key});

  IconData getGoalIcon(String goalType) {
    switch (goalType.toLowerCase()) {
      case 'car':
        return Icons.directions_car_rounded;
      case 'house':
        return Icons.home_rounded;
      case 'education':
        return Icons.school_rounded;
      case 'marriage':
        return Icons.favorite_rounded;
      case 'retirement':
        return Icons.elderly_rounded;
      case 'vacation':
        return Icons.flight_takeoff_rounded;
      default:
        return Icons.flag_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GoalSipController>(
      builder: (controller) {
        if (controller.isMasterGoalLoading.value) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        if (controller.masterGoals.isEmpty) {
          return const Scaffold(
              body: Center(child: Text("No Goals Found")));
        }

        final bool isDesktop =
        ResponsiveBreakpoints.of(context).largerThan(TABLET);

        return Scaffold(
          backgroundColor:
          isDesktop ? const Color(0xFFF5F7FA) : Colors.grey[50],
          appBar: CustomAppBarNormal(
            backgroundColor: isDesktop
                ? const Color(0xFFF5F7FA)
                : const Color(0xffF3F4F6),
            title: 'Goals',
            backIcon: true,
            actionsPadding: 10,
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              int crossAxisCount = 2;
              double childAspectRatio = 0.80;

              if (width > 1400) {
                crossAxisCount = 4;
                childAspectRatio = 1.15;
              } else if (width > 1000) {
                crossAxisCount = 3;
                childAspectRatio = .95;
              } else if (width > 600) {
                crossAxisCount = 2;
                childAspectRatio = .82;
              }

              return GridView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: controller.masterGoals.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: childAspectRatio,
                ),
                itemBuilder: (context, index) {
                  final goal = controller.masterGoals[index];
                  final isSelected =
                      controller.selectedGoalIndex.value == index;

                  return AnimatedScale(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutBack,
                    scale: isSelected ? 1.05 : 1,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isSelected
                              ? [
                            controller.getGoalColor(goal.goalType),
                            controller
                                .getGoalColor(goal.goalType)
                                .withOpacity(.75),
                          ]
                              : [Colors.white, Colors.white],
                        ),
                        border: Border.all(
                          color: isSelected
                              ? controller.getGoalColor(goal.goalType)
                              : Colors.grey.shade200,
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isSelected
                                ? controller
                                .getGoalColor(goal.goalType)
                                .withOpacity(.20)
                                : Colors.black.withOpacity(.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () async {
                          controller.selectedGoalIndex.value = index;
                          controller.update();

                          await Future.delayed(
                              const Duration(milliseconds: 200));

                          controller.goalId.value = goal.id;
                          controller.selectedGoalType.value =
                              goal.goalType;
                          controller.setTarget(goal.targetAmount);
                          controller.setYears(
                              goal.goalTenure.toDouble());
                          controller.setRate(goal.expectedReturnRate);
                          controller.update();

                          await Future.delayed(
                              const Duration(milliseconds: 200));

                          Get.to(() => GoalDetailsScreen());
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: width < 500 ? 42 : 52,
                                    width: width < 500 ? 42 : 52,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.white
                                          .withOpacity(.18)
                                          : controller
                                          .getGoalColor(
                                          goal.goalType)
                                          .withOpacity(.10),
                                      borderRadius:
                                      BorderRadius.circular(14),
                                    ),
                                    child: Icon(
                                      getGoalIcon(goal.goalType),
                                      color: isSelected
                                          ? Colors.white
                                          : controller.getGoalColor(
                                          goal.goalType),
                                      size: width < 500 ? 22 : 28,
                                    ),
                                  ),
                                  const Spacer(),
                                  AnimatedContainer(
                                    duration: const Duration(
                                        milliseconds: 250),
                                    height: 22,
                                    width: 22,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.grey.shade400,
                                        width: 1.8,
                                      ),
                                    ),
                                    child: isSelected
                                        ? Icon(
                                      Icons.check,
                                      size: 14,
                                      color: controller
                                          .getGoalColor(
                                          goal.goalType),
                                    )
                                        : null,
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height: width < 500 ? 6 : 14),
                              Text(
                                goal.goalType.capitalizeFirst ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: width < 500 ? 15 : 20,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                goal.goalDescription,
                                maxLines: width < 500 ? 2 : 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: width < 500 ? 11 : 13,
                                  color: isSelected
                                      ? Colors.white.withOpacity(.9)
                                      : Colors.grey.shade600,
                                  height: 1.4,
                                ),
                              ),
                              SizedBox(
                                  height: width < 500 ? 4 : 10),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(
                                    width < 500 ? 8 : 20),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white
                                      .withOpacity(.15)
                                      : Colors.grey.shade100,
                                  borderRadius:
                                  BorderRadius.circular(14),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Target Amount",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: isSelected
                                            ? Colors.white70
                                            : Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      formatCurrency(
                                          goal.targetAmount),
                                      maxLines: 1,
                                      overflow:
                                      TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize:
                                        width < 500 ? 13 : 16,
                                        fontWeight: FontWeight.w700,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                        width < 500 ? 4 : 10),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.schedule_rounded,
                                          size: 14,
                                          color: isSelected
                                              ? Colors.white70
                                              : Colors.grey.shade600,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            "${goal.goalTenure} Years",
                                            maxLines: 1,
                                            overflow:
                                            TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: width < 500
                                                  ? 11
                                                  : 13,
                                              fontWeight:
                                              FontWeight.w600,
                                              color: isSelected
                                                  ? Colors.white
                                                  : Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                        height:
                                        width < 500 ? 4 : 10),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.trending_up_rounded,
                                          size: 14,
                                          color: isSelected
                                              ? Colors.white70
                                              : Colors.grey.shade600,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            "${goal.expectedReturnRate} %",
                                            maxLines: 1,
                                            overflow:
                                            TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: width < 500
                                                  ? 11
                                                  : 13,
                                              fontWeight:
                                              FontWeight.w600,
                                              color: isSelected
                                                  ? Colors.white
                                                  : Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          // Edit mode FAB
          floatingActionButton: controller.isEdit.value
              ? FloatingActionButton(
            onPressed: () => Get.to(() => GoalDetailsScreen()),
            backgroundColor: Ucolors.primary,
            child: const Icon(Icons.check, color: Colors.white),
          )
              : null,
        );
      },
    );
  }
}
// class MasterGoalsPage extends GetView<GoalSipController> {
//   const MasterGoalsPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<GoalSipController>(
//       initState: (_) async {
//         await controller.getMasterGoals();
//         final args = Get.arguments ?? {};
//         final String initialType = args['goalType'] ?? 'custom';
//         controller.isEdit.value = args['isEdit'] ?? false;
//         final int goalId = args['goalId'] ?? 0;
//         final UserGoalEntity? goal = args['goal'];
//         debugPrint(
//           "isEdit:${controller.isEdit.value}, goal id:$goalId, UserGoal:$goal",
//         );
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           /// reset only when create new goal
//           if (!controller.isEdit.value) {
//             controller.resetStateForNewGoal();
//           }
//
//           controller.updateGoalType(initialType);
//
//           /// edit data set
//           if (controller.isEdit.value && goal != null) {
//             controller.loadGoalForEdit(goal);
//           }
//         });
//         controller.update();
//       },
//       builder: (controller) {
//
//         /// EDIT MODE
//         /// DIRECT OPEN DETAILS SCREEN
//
//         if (controller.isEdit.value) {
//
//           return  GoalDetailsScreen();
//         }
//
//         /// CREATE MODE
//         return AnimatedSwitcher(
//
//           duration: const Duration(milliseconds: 450),
//
//           transitionBuilder: (child, animation) {
//
//             final offsetAnimation = Tween<Offset>(
//
//               begin: const Offset(1, 0),
//
//               end: Offset.zero,
//
//             ).animate(animation);
//
//             return SlideTransition(
//
//               position: offsetAnimation,
//
//               child: FadeTransition(
//
//                 opacity: animation,
//
//                 child: child,
//               ),
//             );
//           },
//
//           child: const GoalsGridScreen(
//             key: ValueKey("grid"),
//           ),
//         );
//       },
//     );
//   }
// }
//
// class GoalDetailsScreen extends GetView<GoalSipController> {
//   GoalDetailsScreen({super.key});
//   final CartController cartController = Get.find<CartController>();
//   final GlobalKey popularFundsKey = GlobalKey();
//   @override
//   Widget build(BuildContext context) {
//     final bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
//
//     return Scaffold(
//       backgroundColor: isDesktop ? const Color(0xFFF5F7FA) : Colors.grey[50],
//
//       appBar: CustomAppBarNormal(
//         backgroundColor: Ucolors.light,
//         title: controller.selectedGoalType.value.capitalizeFirst ?? '',
//         backIcon: true,
//         actionsPadding: 10,
//         action: [
//           Obx(()=> controller.isGoalSaved.value?
//             TextButton(
//               onPressed: () {
//
//                 /// GO TO BOTTOM NAV SCREEN
//                 Get.offAllNamed(AppRoutes.navMenuBar);
//
//                 /// SET INDEX
//                 Future.delayed(
//                   const Duration(milliseconds: 100),
//                       () {
//
//                     if (Get.isRegistered<NavigationBarController>()) {
//
//                       Get.find<NavigationBarController>()
//                           .selectedIndex.value = 3;
//                     }
//                   },
//                 );
//               },
//               child: Text(
//                 "View All Goals",
//                 style: TextStyle(color: Ucolors.primary),
//               ),
//             ):SizedBox.shrink(),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//
//         child: CustomScrollView(
//           slivers: [
//             SliverToBoxAdapter(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//
//                 children: [
//                   /// SIP
//                   SIPSectionGoal(),
//
//                   const Gap(4),
//                   Obx(() {
//                     /// ==============================
//                     /// BUTTON ENABLE LOGIC
//                     /// ==============================
//
//                     final bool isEdit = controller.isEdit.value;
//
//                     final bool hasChanges = controller.hasChanges.value;
//
//                     /// ==============================
//                     /// HIDE BUTTON IN EDIT MODE
//                     /// UNTIL USER CHANGES SOMETHING
//                     /// ==============================
//
//                     if (isEdit && !hasChanges) {
//                       return Column(
//                         children: [
//                           const ProjectionGraph(),
//
//                           const Gap(9),
//                           Obx(() {
//                             final selectedCount =
//                                 controller.selectedPopularFund.length;
//
//                             return USectionHeading(
//                               key: popularFundsKey,
//
//                               title: selectedCount > 0
//                                   ? 'Selected Funds ($selectedCount)'
//                                   : 'Popular Funds',
//
//                               showActionButton: true,
//
//                               onPressed: () {
//                                 log('goal create');
//
//                                 _showExploreMoreBottomSheet(context);
//                               },
//                             );
//                           }),
//
//                           const Gap(10),
//
//                           PopularAndSelectedFund(),
//
//                           const Gap(10),
//                         ],
//                       );
//                     }
//
//                     /// ==============================
//                     /// SHOW SAVE / UPDATE BUTTON
//                     /// ==============================
//
//                     if (!controller.isGoalSaved.value || isEdit) {
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 10,
//                           vertical: 10,
//                         ),
//
//                         child: UElevatedBUtton(
//                           onPressed: () async {
//                             /// ==============================
//                             /// EDIT MODE
//                             /// ==============================
//
//                             if (isEdit) {
//                               // await controller.updateGoal();
//                             } else {
//                               /// ==============================
//                               /// CREATE MODE
//                               /// ==============================
//
//                               await controller.saveGoalToDb();
//
//                               WidgetsBinding.instance.addPostFrameCallback((_) {
//                                 if (popularFundsKey.currentContext != null) {
//                                   Scrollable.ensureVisible(
//                                     popularFundsKey.currentContext!,
//                                     duration: const Duration(milliseconds: 800),
//                                     curve: Curves.easeInOutCubic,
//                                     alignment: 0.1,
//                                   );
//                                 }
//                               });
//
//                               await Get.find<MutualFundController>()
//                                   .fetchData();
//                             }
//                           },
//
//                           child: Center(
//                             child: Text(
//                               isEdit ? "Update Goal" : "Save Goal",
//
//                               style: AppTextStyles.bodyMedium(
//                                 color: Colors.white,
//                               ),
//
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                         ),
//                       );
//                     }
//
//                     /// ==============================
//                     /// AFTER SAVE UI
//                     /// ==============================
//
//                     return Column(
//                       children: [
//                         const ProjectionGraph(),
//
//                         const Gap(9),
//
//                         Obx(() {
//                           final selectedCount =
//                               controller.selectedPopularFund.length;
//
//                           return USectionHeading(
//                             key: popularFundsKey,
//
//                             title: selectedCount > 0
//                                 ? 'Selected Funds ($selectedCount)'
//                                 : 'Popular Funds',
//
//                             showActionButton: true,
//                             buttonTitle: selectedCount > 0
//                                 ? 'Add Funds'
//                                 : 'View All',
//
//                             onPressed: () {
//                               log('goal create');
//
//                               _showExploreMoreBottomSheet(context);
//                             },
//                           );
//                         }),
//
//                         PopularAndSelectedFund(),
//
//                         const Gap(10),
//                       ],
//                     );
//                   }),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: Obx(
//         () => controller.isGoalSaved.value
//             ? SafeArea(
//                 top: false,
//                 child: CartBottomBar(
//                   isValid: controller.selectedPopularFund.isNotEmpty,
//
//                   ontap: () {
//                     log(controller.savedDatabaseId.value.toString());
//                     final cartCont = Get.find<CartController>();
//                     cartCont.filterGoalId.value =
//                         controller.savedDatabaseId.value;
//                     cartController.monthlyAmount.value = controller
//                         .monthlySip
//                         .value
//                         .toInt();
//
//                     controller.selectedPopularFund.isNotEmpty
//                         ? Get.toNamed(
//                             AppRoutes.cart,
//                             arguments: {
//                               'monthlyAmount': controller.monthlySip.value.toInt(),
//                               'goal_id': controller
//                                   .savedDatabaseId
//                                   .value, // Pass the ID (e.g., 50)
//                             },
//                           )
//                         : Get.snackbar(
//                             "Error",
//                             "Please select funds to start SIP",
//                           );
//                   },
//                   amount: controller.monthlySip.value.toStringAsFixed(0),
//                   amountColor: Ucolors.blue,
//                   title: 'Installment Amount',
//                   buttonText: 'Start SIP',
//                 ),
//               )
//             : const SizedBox.shrink(),
//       ),
//     );
//   }
//
//
//   void _showExploreMoreBottomSheet(BuildContext context) {
//     final mutualController = Get.find<MutualFundController>();
//     final goalSipController = Get.find<GoalSipController>(); // ✅ Added
//     final cartController = Get.find<CartController>(); // ✅ Added
//     final FocusNode searchFocus = FocusNode();
//
//     // goalSipController.selectedPopularFund.clear();
//
//
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       useSafeArea: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
//       ),
//       builder: (BuildContext context) {
//         return DraggableScrollableSheet(
//           initialChildSize: 0.9,
//           minChildSize: 0.5,
//           maxChildSize: 0.96,
//           expand: false,
//           builder: (context, scrollController) {
//             return Column(
//               children: [
//                 // --- DRAG HANDLE ---
//                 Center(
//                   child: Container(
//                     margin: const EdgeInsets.only(top: 12, bottom: 16),
//                     height: 5,
//                     width: 48,
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade300,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),
//
//                 // --- HEADER & CLOSE BUTTON ---
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Explore Funds",
//                             style: AppTextStyles.h2(color: Ucolors.dark),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             "Search and select funds for your goal.",
//                             style: TextStyle(
//                               fontSize: 13,
//                               color: Colors.grey.shade500,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.close, color: Colors.grey),
//                         onPressed: () {
//                           FocusScope.of(context).unfocus();
//                           Navigator.of(context).pop();
//                         },
//                         style: IconButton.styleFrom(
//                           backgroundColor: Colors.grey.shade100,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//
//                 // --- SEARCH BAR & FILTERS (Unchanged) ---
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 8,
//                   ),
//                   child: Row(
//                     children: [
//                       Obx(() {
//                         final fundController = Get.find<FundhouseController>();
//                         final int filterCount =
//                             fundController.activeFilterCount;
//
//                         return Badge(
//                           isLabelVisible: filterCount > 0,
//                           backgroundColor: Ucolors.primary,
//                           label: Text(
//                             '$filterCount',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 10,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           padding: const EdgeInsets.symmetric(horizontal: 4),
//                           alignment: const Alignment(0.7, -0.7),
//                           child: Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Colors.grey.shade300),
//                               shape: BoxShape.circle,
//                             ),
//                             child: CompactIcon(
//                               icon: Icons.tune,
//                               onPressed: () async {
//                                 final result = await Get.toNamed(
//                                   AppRoutes.filterpage,
//                                 );
//                                 if (result != null &&
//                                     result is Map<String, dynamic>) {
//                                   mutualController.applyFilters(result);
//                                 }
//                               },
//                             ),
//                           ),
//                         );
//                       }),
//                       Container(
//                         margin: const EdgeInsets.symmetric(horizontal: 12),
//                         height: 30,
//                         width: 1,
//                         color: Colors.grey.shade300,
//                       ),
//                       Expanded(
//                         child: SizedBox(
//                           height: 44,
//                           child: Row(
//                               children: [
//                                 Expanded(
//                                   child: SearchBar(
//                                     onTap: () =>
//                                         mutualController.setSearchFocus(true),
//                                     onTapOutside: (event) {
//                                       searchFocus.unfocus();
//                                       mutualController.setSearchFocus(false);
//                                     },
//                                     focusNode: searchFocus,
//                                     backgroundColor: MaterialStateProperty.all(
//                                       Colors.grey.shade50,
//                                     ),
//                                     leading: Icon(
//                                       Icons.search,
//                                       color: Colors.grey.shade600,
//                                     ),
//                                     hintText: 'Search mutual funds...',
//                                     hintStyle: MaterialStateProperty.all(
//                                       TextStyle(
//                                         color: Colors.grey.shade500,
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                     onChanged: (value) => mutualController
//                                         .onSearchQueryChanged(value),
//                                     elevation: MaterialStateProperty.all(0),
//                                     side: MaterialStateProperty.all(
//                                       BorderSide(color: Colors.grey.shade200),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Divider(color: Colors.grey.shade200, height: 20),
//
//                 // --- 🚀 THE UPDATED FUNDS LISTVIEW ---
//                 Expanded(
//                   child: Obx(() {
//                     if (mutualController.isLoading.value) {
//                       return const Align(
//                         alignment: Alignment.topCenter,
//                         child: CircularProgressIndicator(
//                           color: Ucolors.primary,
//                         ),
//                       );
//                     }
//
//                     if (mutualController.searchFund.isEmpty) {
//                       return Center(
//                         child: Text(
//                           "No mutual funds found",
//                           style: TextStyle(color: Colors.grey.shade600),
//                         ),
//                       );
//                     }
//
//                     return NotificationListener<ScrollNotification>(
//                       onNotification: (ScrollNotification scrollInfo) {
//                         // Check if we scrolled near the bottom (within 200 pixels)
//                         if (scrollInfo.metrics.pixels >=
//                             scrollInfo.metrics.maxScrollExtent - 200) {
//                           // Prevent spamming the API if it's already loading or has no more data
//                           if (!mutualController.isMoreLoading.value &&
//                               mutualController.canLoadMore) {
//                             mutualController
//                                 .loadNextPage(); // Triggers your pagination API!
//                           }
//                         }
//                         return false; // Return false so the sheet can still drag up/down normally
//                       },
//                       child: ListView.builder(
//                         controller: scrollController,
//                         padding: const EdgeInsets.only(bottom: 20),
//                         itemCount:
//                         mutualController.searchFund.length +
//                             (mutualController.isMoreLoading.value ? 1 : 0),
//                         itemBuilder: (context, index) {
//                           if (index == mutualController.searchFund.length) {
//                             return const Padding(
//                               padding: EdgeInsets.symmetric(vertical: 24),
//                               child: Center(
//                                 child: SizedBox(
//                                   height: 24,
//                                   width: 24,
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 2.5,
//                                     color: Ucolors.primary,
//                                   ),
//                                 ),
//                               ),
//                             );
//                           }
//
//                           final fund = mutualController.searchFund[index];
//                           final name = fund.baseSchemeName ?? 'Unknown Name';
//                           final schemeCodeStr = fund.schemeCode.toString();
//
//                           return Obx(() {
//                             // ✅ 1. Use GoalSipController to check selection status
//                             final isSelected = goalSipController.isSelectedFund(
//                               name,
//                             );
//
//                             return Stack(
//                               children: [
//                                 Container(
//                                   //  2. Removed horizontal margins so it sits flush
//                                   margin: const EdgeInsets.symmetric(
//                                     horizontal: 0,
//                                     vertical: 6,
//                                   ),
//                                   child: MutualFundCard(
//                                     entity: fund,
//                                     showTrainlings:
//                                     false, //  3. Hides trailing returns
//                                     // 4. Replaced generic toggle with Cart + Goal logic
//                                     onTapOverride: () {
//                                       FocusScope.of(context).unfocus();
//                                       final int? currentGoalId =
//                                           goalSipController
//                                               .savedDatabaseId
//                                               .value;
//
//                                       if (!isSelected) {
//                                         // Add to Goal Cart
//                                         goalSipController.toggleFund(name);
//                                         cartController.addToCart(
//                                           title: 'Goal',
//                                           fund.schemeCode ?? '',
//                                           name,
//                                           fund.minSipAmount ?? 0,
//                                           currentGoalId,
//                                         );
//                                       } else {
//                                         // Remove from Goal Cart
//                                         final cartItem = cartController
//                                             .cartResponseEntity
//                                             .value
//                                             ?.items
//                                             .firstWhereOrNull(
//                                               (item) =>
//                                           item.schemeCode.toString() ==
//                                               schemeCodeStr,
//                                         );
//
//                                         if (cartItem != null &&
//                                             cartItem.id != null) {
//                                           cartController.deleteCartItem(
//                                             cartItem.id!,
//                                             name,
//                                           );
//                                           goalSipController.toggleFund(name);
//                                         }
//                                       }
//                                     },
//                                   ),
//                                 ),
//
//                                 if (isSelected)
//                                   Positioned.fill(
//                                     child: IgnorePointer(
//                                       child: Container(
//                                         margin: const EdgeInsets.symmetric(
//                                           horizontal: 16,
//                                           vertical: 10,
//                                         ),
//                                         decoration: BoxDecoration(
//                                           color: Ucolors.primary.withOpacity(
//                                             0.05,
//                                           ),
//                                           borderRadius: BorderRadius.circular(
//                                             16,
//                                           ),
//                                           border: Border.all(
//                                             color: Ucolors.primary,
//                                             width: 2,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                               ],
//                             );
//                           });
//                         },
//                       ),
//                     );
//                   }),
//                 ),
//
//                 // --- FLOATING "DONE" BUTTON ---
//                 Container(
//                   padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.05),
//                         blurRadius: 10,
//                         offset: const Offset(0, -5),
//                       ),
//                     ],
//                   ),
//                   child: Obx(() {
//                     // ✅ Updated to count from the GoalSipController!
//                     final selectedCount =
//                         goalSipController.selectedPopularFund.length;
//
//                     return UElevatedBUtton(
//                       onPressed: () => Get.back(), // Closes the bottom sheet
//                       child: Center(
//                         child: Text(
//                           selectedCount > 0
//                               ? 'Add $selectedCount Funds'
//                               : 'Done',
//                           style: AppTextStyles.bodyMedium(color: Colors.white),
//                         ),
//                       ),
//                     );
//                   }),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     ).whenComplete(() {
//       Future.delayed(const Duration(milliseconds: 300), () {
//         mutualController.setSearchFocus(false);
//         Get.find<FundhouseController>().clearAllFilters();
//         mutualController.silentReset();
//         // goalSipController.selectedPopularFund.clear();
//       });
//     });
//   }
// }
// class PopularAndSelectedFund extends StatelessWidget {
//   PopularAndSelectedFund({super.key});
//
//   final MutualFundController controller = Get.find();
//   final GoalSipController goalSipController = Get.find();
//   final CartController cartController = Get.find();
//
//   @override
//   Widget build(BuildContext context) {
//
//     final bool isDesktop =
//     ResponsiveBreakpoints.of(context)
//         .largerThan(TABLET);
//
//     final int crossAxisCount =
//     isDesktop ? 3 : 2;
//
//     final double childAspectRatio =
//     isDesktop ? 1.4 : 1.55;
//
//     return Obx(() {
//
//       /// =========================
//       /// SELECTED FUNDS
//       /// =========================
//
//       final selectedFunds =
//       controller.searchFund.where((fund) {
//
//         return goalSipController
//             .isSelectedFund(
//           fund.baseSchemeName ?? '',
//         );
//
//       }).toList();
//
//       /// =========================
//       /// POPULAR FUNDS
//       /// =========================
//
//       final popularFunds =
//       controller.searchFund.where((fund) {
//
//         return !goalSipController
//             .isSelectedFund(
//           fund.baseSchemeName ?? '',
//         );
//
//       }).toList();
//
//       /// =========================
//       /// DISPLAY FUNDS
//       /// =========================
//
//       List<dynamic> displayFunds = [];
//
//       /// IF NO FUND SELECTED
//       /// SHOW ONLY POPULAR FUNDS
//
//       if (selectedFunds.isEmpty) {
//
//         displayFunds =
//             popularFunds.take(6).toList();
//
//       }
//
//       /// IF FUND SELECTED
//       /// SHOW SELECTED FIRST
//       /// THEN POPULAR
//
//       else {
//
//         displayFunds = [
//
//           ...selectedFunds,
//
//           ...popularFunds,
//
//         ].take(6).toList();
//       }
//
//       /// =========================
//       /// EMPTY STATE
//       /// =========================
//
//       if (displayFunds.isEmpty) {
//
//         return Padding(
//
//           padding:
//           const EdgeInsets.symmetric(
//             vertical: 20,
//           ),
//
//           child: Center(
//             child: Column(
//               children: [
//
//                 Icon(
//                   Icons.account_balance_wallet,
//                   size: 42,
//                   color: Ucolors.primary,
//                 ),
//
//                 const SizedBox(height: 12),
//
//                 Text(
//                   "No Funds Available",
//                   style: TextStyle(
//                     fontWeight:
//                     FontWeight.w700,
//                     fontSize: 16,
//                     color: Ucolors.dark,
//                   ),
//                 ),
//
//                 const SizedBox(height: 6),
//
//                 Text(
//                   "Please add funds",
//                   style: TextStyle(
//                     color:
//                     Colors.grey.shade600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       }
//
//       return GridView.builder(
//
//         itemCount: displayFunds.length,
//
//         shrinkWrap: true,
//
//         physics:
//         const NeverScrollableScrollPhysics(),
//
//         gridDelegate:
//         SliverGridDelegateWithFixedCrossAxisCount(
//
//           crossAxisCount:
//           crossAxisCount,
//
//           childAspectRatio:
//           childAspectRatio,
//
//           mainAxisSpacing: 16,
//
//           crossAxisSpacing: 16,
//         ),
//
//         itemBuilder:
//             (context, index) {
//
//           final fund =
//           displayFunds[index];
//
//           final name =
//               fund.baseSchemeName ??
//                   'Unknown Name';
//
//           final schemeCodeStr =
//           fund.schemeCode.toString();
//
//           final img =
//               "${Appurl.baseUrl}${fund.amc?.amcLogoUrl}";
//
//           final returns =
//               fund.returnsEntity
//                   ?.threeYear ??
//                   "";
//
//           final isSelected =
//           goalSipController
//               .isSelectedFund(name);
//
//           final int?
//           currentGoalId =
//               goalSipController
//                   .savedDatabaseId
//                   .value;
//
//           return AnimatedScale(
//
//             duration:
//             const Duration(
//               milliseconds: 250,
//             ),
//
//             scale:
//             isSelected ? 1.02 : 1,
//
//             child: Stack(
//               children: [
//
//                 PopularFundCardMobSelected(
//
//                   borderColor:
//                   isSelected
//                       ? Ucolors.primary
//                       : Ucolors.borderColor,
//
//                   isNetwork: true,
//
//                   imgPath: img,
//
//                   name: name,
//
//                   threeYear: returns,
//
//                   isSelected: isSelected,
//                 ),
//
//                 Positioned.fill(
//
//                   child:
//                   GestureDetector(
//
//                     behavior:
//                     HitTestBehavior
//                         .translucent,
//
//                     onTap: () {
//
//                       FocusScope.of(context)
//                           .unfocus();
//
//                       /// ADD FUND
//
//                       if (!isSelected) {
//
//                         goalSipController
//                             .toggleFund(name);
//
//                         cartController
//                             .addToCart(
//
//                           title: 'Goal',
//
//                           fund.schemeCode ?? '',
//
//                           name,
//
//                           goalSipController
//                               .monthlySip
//                               .value,
//
//                           currentGoalId,
//                         );
//                       }
//
//                       /// REMOVE FUND
//
//                       else {
//
//                         final cartItem =
//                         cartController
//                             .cartResponseEntity
//                             .value
//                             ?.items
//                             .firstWhereOrNull(
//
//                               (item) =>
//                           item.schemeCode
//                               .toString() ==
//                               schemeCodeStr,
//                         );
//
//                         if (cartItem != null &&
//                             cartItem.id != null) {
//
//                           cartController
//                               .deleteCartItem(
//
//                             cartItem.id!,
//
//                             name,
//                           );
//
//                           goalSipController
//                               .toggleFund(name);
//                         }
//                       }
//                     },
//
//                     child:
//                     PopularFundCardMobSelected(
//
//                       borderColor:
//                       isSelected
//                           ? Ucolors.primary
//                           : Ucolors.borderColor,
//
//                       isNetwork: true,
//
//                       imgPath: img,
//
//                       name: name,
//
//                       threeYear: returns,
//
//                       isSelected: isSelected,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       );
//     });
//   }
// }
//
// class PopularFundCardMobSelected extends StatelessWidget {
//   const PopularFundCardMobSelected({
//     super.key,
//     required this.imgPath,
//     required this.name,
//     this.onTap,
//     this.isNetwork = false,
//     this.borderColor = Ucolors.borderColor,
//     this.threeYear,
//     this.isSelected = false,
//   });
//
//   final String imgPath;
//   final String name;
//   final VoidCallback? onTap;
//   final bool isNetwork;
//   final Color borderColor;
//   final String? threeYear;
//
//   /// NEW
//   final bool isSelected;
//
//   @override
//   Widget build(BuildContext context) {
//
//     return AnimatedContainer(
//
//       duration: const Duration(milliseconds: 250),
//
//       curve: Curves.easeInOut,
//
//       child: GestureDetector(
//
//         onTap: onTap,
//
//         child: Container(
//
//           padding: const EdgeInsets.all(4),
//
//           decoration: BoxDecoration(
//
//             color: Colors.white,
//
//             borderRadius: BorderRadius.circular(14),
//
//             border: Border.all(
//
//               color: isSelected
//                   ? Ucolors.primary
//                   : Colors.grey.shade100,
//
//               width: isSelected ? 2 : 1,
//             ),
//
//             boxShadow: [
//
//               BoxShadow(
//
//                 color: isSelected
//                     ? Ucolors.primary.withOpacity(0.12)
//                     : Colors.black.withOpacity(0.04),
//
//                 blurRadius: isSelected ? 12 : 6,
//
//                 offset: const Offset(0, 3),
//               ),
//             ],
//           ),
//
//           child: Stack(
//             children: [
//
//               /// CONTENT
//               Padding(
//
//                 padding: const EdgeInsets.all(4),
//
//                 child: Column(
//
//                   mainAxisSize: MainAxisSize.min,
//
//                   crossAxisAlignment:
//                   CrossAxisAlignment.start,
//
//                   children: [
//
//                     Expanded(
//                       child: Row(
//
//                         children: [
//
//                           /// IMAGE
//                           AnimatedContainer(
//
//                             duration:
//                             const Duration(
//                               milliseconds: 250,
//                             ),
//
//                             height: isSelected ? 34 : 30,
//
//                             width: isSelected ? 34 : 30,
//
//                             decoration: BoxDecoration(
//
//                               shape: BoxShape.circle,
//
//                               color: Colors.grey.shade50,
//
//                               border: isSelected
//                                   ? Border.all(
//                                 color:
//                                 Ucolors.primary,
//                                 width: 1.5,
//                               )
//                                   : null,
//                             ),
//
//                             child: ClipOval(
//                               child: isNetwork
//                                   ? CustomCachedImage(
//                                 imageUrl: imgPath,
//                                 size: 40,
//                               )
//                                   : Image.asset(
//                                 imgPath,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//
//                           const SizedBox(width: 8),
//
//                           /// NAME
//                           Expanded(
//                             child: Text(
//
//                               name,
//
//                               maxLines: 4,
//
//                               overflow:
//                               TextOverflow.ellipsis,
//
//                               style:
//                               UTextStyles.medium.copyWith(
//
//                                 color: Colors.black,
//
//                                 fontWeight: isSelected
//                                     ? FontWeight.w700
//                                     : FontWeight.w500,
//
//                                 fontSize: 11,
//
//                                 height: 1.1,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     const SizedBox(height: 6),
//
//                     /// RETURNS
//                     Row(
//
//                       mainAxisAlignment:
//                       MainAxisAlignment.spaceBetween,
//
//                       children: [
//
//                         Container(
//
//                           padding:
//                           const EdgeInsets.symmetric(
//                             horizontal: 8,
//                             vertical: 3,
//                           ),
//
//                           decoration: BoxDecoration(
//
//                             color: Colors.grey.shade100,
//
//                             borderRadius:
//                             BorderRadius.circular(20),
//                           ),
//
//                           child: Text(
//
//                             '3Y',
//
//                             style: UTextStyles.bodySmallW500
//                                 .copyWith(
//
//                               fontWeight: FontWeight.w600,
//
//                               color: Colors.grey.shade700,
//                             ),
//                           ),
//                         ),
//
//                         Row(
//
//                           mainAxisSize: MainAxisSize.min,
//
//                           children: [
//
//                             const Icon(
//                               Icons.arrow_drop_up_rounded,
//                               color: Ucolors.success,
//                               size: 20,
//                             ),
//
//                             Text(
//
//                               '${threeYear ?? 0}%',
//
//                               style: UTextStyles
//                                   .bodySmallW500
//                                   .copyWith(
//
//                                 color: Ucolors.success,
//
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//
//               /// SELECTED BADGE
//               if (isSelected)
//                 Positioned(
//
//                   top: 4,
//                   right: 4,
//
//                   child: AnimatedScale(
//
//                     duration:
//                     const Duration(milliseconds: 250),
//
//                     scale: isSelected ? 1 : 0,
//
//                     child: Container(
//
//                       padding: const EdgeInsets.all(4),
//
//                       decoration: const BoxDecoration(
//
//                         color: Ucolors.primary,
//
//                         shape: BoxShape.circle,
//                       ),
//
//                       child: const Icon(
//
//                         Icons.check,
//
//                         size: 12,
//
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class ProjectionGraph extends StatefulWidget {
//   const ProjectionGraph({super.key});
//
//   @override
//   State<ProjectionGraph> createState() => _ProjectionGraphState();
// }
//
// class _ProjectionGraphState extends State<ProjectionGraph> {
//   int selectedView = 0;
//
//   List<FlSpot> investedSpotsFromRows(List<ReturnRow> rows) {
//     return rows.map((e) => FlSpot(double.parse(e.period), e.scheme)).toList();
//   }
//
//   List<FlSpot> valueSpotsFromRows(List<ReturnRow> rows) {
//     return rows.map((e) => FlSpot(double.parse(e.period), e.category)).toList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<GoalSipController>();
//     final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
//
//     return Container(
//       // On mobile, the container has decoration. On Web, the parent card has decoration.
//       padding: isDesktop ? EdgeInsets.zero : const EdgeInsets.all(15),
//       decoration: isDesktop
//           ? null
//           : BoxDecoration(
//               color: Ucolors.light,
//               borderRadius: BorderRadius.circular(12),
//             ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Projection',
//                 style: UTextStyles.medium.copyWith(fontWeight: FontWeight.w700),
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                   color: const Color(0xffF3F4F6),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Row(
//                   children: [
//                     ProjectionIcon(
//                       onTap: () => setState(() => selectedView = 0),
//                       isSelected: selectedView == 0,
//                       icon: Icons.trending_up,
//                     ),
//                     ProjectionIcon(
//                       onTap: () => setState(() => selectedView = 1),
//                       isSelected: selectedView == 1,
//                       icon: Icons.grid_on_sharp,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const Gap(20),
//           if (selectedView == 0) ...[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   '● Invest',
//                   style: UTextStyles.small.copyWith(
//                     color: const Color(0xff868686),
//                   ),
//                 ),
//                 Text(
//                   '● Value',
//                   style: UTextStyles.small.copyWith(
//                     color: const Color(0xff213C73),
//                   ),
//                 ),
//               ],
//             ),
//             const Gap(25),
//             Obx(() {
//               final rows = controller.buildYearlyReport();
//               if (rows.isEmpty) {
//                 return const SizedBox(
//                   height: 250,
//                   child: CircularProgressIndicator(),
//                 );
//               }
//
//               return SizedBox(
//                 height: 250,
//                 child: SipProjectionChart(
//                   showLeftNumbers: true,
//                   textColor: Colors.black,
//                   investedSpots: investedSpotsFromRows(rows),
//                   projectedSpots: valueSpotsFromRows(rows),
//                 ),
//               );
//             }),
//           ] else
//             Obx(() {
//               final result = controller.buildYearlyReport();
//               return Column(
//                 children: [
//                   const TableHeader(
//                     heading1: 'Year',
//                     heading2: 'Invest',
//                     heading3: 'Curent',
//                     heading4: 'Profit',
//                   ),
//                   DashedLine(color: Ucolors.borderColor, dashSpace: 0),
//                   ListView.builder(
//                     physics: const NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     itemCount: result.length,
//                     itemBuilder: (context, index) {
//                       final row = result[index];
//                       return ReturnsTableRow(
//                         color4: Colors.green,
//                         data: row,
//                         percentage: false,
//                       );
//                     },
//                   ),
//                 ],
//               );
//             }),
//         ],
//       ),
//     );
//   }
// }
//
// class ProjectionIcon extends StatelessWidget {
//   const ProjectionIcon({
//     super.key,
//     required this.onTap,
//     required this.isSelected,
//     required this.icon,
//   });
//   final VoidCallback onTap;
//   final bool isSelected;
//   final IconData icon;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//       decoration: BoxDecoration(
//         color: isSelected ? Colors.white : Colors.transparent,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: IconButton(
//         onPressed: onTap,
//         icon: Icon(icon, color: isSelected ? Ucolors.blue : Colors.grey),
//       ),
//     );
//   }
// }
//
// class SIPSectionGoal extends GetView<GoalSipController> {
//   const SIPSectionGoal({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//       ),
//
//       child: Column(
//         children: [
//           TextFormFieldCustom(
//             title: "Goal Title",
//             hintTextColor: Ucolors.black,
//             hintTextSize: 12,
//             borderWidth: 1,
//             backgroundColor: Ucolors.light,
//             borderColor: Ucolors.darkgrey,
//             method: TextFieldCustom(
//               height: 50,
//               width: double.infinity,
//               hintText: "Enter Full Name",
//               textInputType: TextInputType.text,
//               backgroundColor: Colors.transparent,
//               controller: controller.goalNameTextEditingController,
//               onChanged: (value) {
//                 controller.setGoalName(value ?? "");
//                 return null;
//               },
//               onEditingComplete: () {
//                 FocusScope.of(context).unfocus();
//               },
//
//               suffixIcon: Container(
//                 width: 30,
//                 alignment: Alignment.center,
//                 child: Text(
//                   "*",
//                   style: TextStyle(color: Colors.red, fontSize: 16),
//                 ),
//               ),
//             ),
//           ),
//           Obx(
//             () => controller.goalError.isNotEmpty
//                 ? Padding(
//                     padding: const EdgeInsets.only(top: 4, left: 5),
//                     child: Text(
//                       controller.goalError.value,
//                       style: TextStyle(fontSize: 12, color: Ucolors.red),
//                     ),
//                   )
//                 : SizedBox.shrink(),
//           ),
//           const Gap(20),
//
//           /// TARGET
//           Obx(
//             () => SipSliderTile2(
//               prefix: '₹',
//               title: 'I Need',
//               value: controller.targetAmount.value < 100
//                   ? 100
//                   : controller.targetAmount.value,
//               min: 100,
//               max: 10000000,
//               suffix: '',
//               onChanged: (value) {
//                 controller.setTarget(value);
//               },
//             ),
//           ),
//
//           const Gap(16),
//
//           /// YEARS
//           Obx(
//             () => SipSliderTile2(
//               title: 'Duration',
//               value: controller.years.value,
//               min: 1,
//               max: 30,
//               suffix: 'Yrs',
//               onChanged: (value) {
//                 controller.setYears(value);
//               },
//             ),
//           ),
//
//           const Gap(16),
//
//           /// RETURN
//           Obx(
//             () => SipSliderTile2(
//               title: 'Expected Return',
//               value: controller.annualRate.value,
//               min: 1,
//               max: 30,
//               suffix: '%',
//               onChanged: (value) {
//                 controller.setRate(value);
//               },
//             ),
//           ),
//
//           const Gap(20),
//
//           Obx(
//             () => Wrap(
//               spacing: 10,
//               runSpacing: 10,
//               children: [
//                 /// =======================================
//                 /// SIPSectionGoal
//                 /// BELOW Additional SIP CARD
//                 /// =======================================
//
//                 SizedBox(
//                   width: Get.width * .40 - 12,
//                   child: _ValueCard(
//                     title: 'Daily SIP',
//                     value:
//                     formatCurrency(controller.dailySipAmount.value),
//                   ),
//                 ),
//                   SizedBox(
//                     width: Get.width * .40 - 12,
//                     child: _ValueCard(
//                       title: 'Weekly SIP',
//                       value:
//                       formatCurrency(controller.weeklySipAmount.value),
//                     ),
//                   ),
//
//
//
//                 SizedBox(
//                   width: Get.width * .40 - 12,
//                   child: _ValueCard(
//                     title: 'Monthly SIP',
//                       value: formatCurrency(controller.monthlySip.value.toDouble()),
//                   ),
//                 ),
//
//                 /// SHOW ONLY IN EDIT MODE
//                 if (controller.hasChanges.value && controller.isEdit.value)
//                   SizedBox(
//                     width: Get.width * .20 - 12,
//                     child: _ValueCard(
//                       title: 'Existing SIP',
//                       value: formatCurrency(controller.existingSipAmount.value.toDouble()),
//                     ),
//                   ),
//
//                 /// SHOW ONLY IN EDIT MODE
//                 if (controller.hasChanges.value && controller.isEdit.value)
//                   SizedBox(
//                     width: Get.width * .40 - 12,
//                     child: _ValueCard(
//                       title: 'Additional SIP',
//                       value: formatCurrency(controller.additionalSipAmount.value.toDouble()),
//                     ),
//                   ),
//
//                 SizedBox(
//                   width: Get.width * .40 - 12,
//                   child: _ValueCard(
//                     title: 'Invested',
//                     value: formatCurrency(controller.invested.value.toDouble()),
//                   ),
//                 ),
//
//                 SizedBox(
//                   width: Get.width * .40 - 12,
//                   child: _ValueCard(
//                     title: 'Future Value',
//                     value: formatCurrency(controller.targetAmount.value.toDouble()),
//                   ),
//                 ),
//
//                 SizedBox(
//                   width: Get.width * .40 - 12,
//                   child: _ValueCard(
//                     title: 'Total Return',
//                     value: formatCurrency(controller.totalReturn.value.toDouble()),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _ValueCard extends StatelessWidget {
//   const _ValueCard({required this.title, required this.value});
//
//   final String title;
//   final String value;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//
//       decoration: BoxDecoration(
//         color: const Color(0xffF5F7FB),
//         borderRadius: BorderRadius.circular(14),
//       ),
//
//       child: Column(
//         children: [
//           Text(
//             title,
//             style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
//           ),
//
//           const SizedBox(height: 8),
//
//           Text(
//             value,
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class GoalsGridScreen extends GetView<GoalSipController> {
//   const GoalsGridScreen({super.key});
//
//   IconData getGoalIcon(String goalType) {
//     switch (goalType.toLowerCase()) {
//       case 'car':
//         return Icons.directions_car_rounded;
//       case 'house':
//         return Icons.home_rounded;
//       case 'education':
//         return Icons.school_rounded;
//       case 'marriage':
//         return Icons.favorite_rounded;
//       case 'retirement':
//         return Icons.elderly_rounded;
//       case 'vacation':
//         return Icons.flight_takeoff_rounded;
//       default:
//         return Icons.flag_rounded;
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<GoalSipController>(
//       builder: (controller) {
//         if (controller.isMasterGoalLoading.value) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }
//
//         if (controller.masterGoals.isEmpty) {
//           return const Scaffold(body: Center(child: Text("No Goals Found")));
//         }
//         final bool isDesktop = ResponsiveBreakpoints.of(
//           context,
//         ).largerThan(TABLET);
//         return Scaffold(
//           backgroundColor: isDesktop
//               ? const Color(0xFFF5F7FA)
//               : Colors.grey[50],
//
//           appBar: CustomAppBarNormal(
//             backgroundColor: isDesktop
//                 ? const Color(0xFFF5F7FA)
//                 : const Color(0xffF3F4F6),
//             title: 'Goals',
//             backIcon: true,
//             actionsPadding: 10,
//           ),
//           body: LayoutBuilder(
//             builder: (context, constraints) {
//               final width = constraints.maxWidth;
//
//               int crossAxisCount = 1;
//               double childAspectRatio = 1;
//
//               if (width > 1400) {
//                 crossAxisCount = 4;
//                 childAspectRatio = 1.15;
//               } else if (width > 1000) {
//                 crossAxisCount = 3;
//                 childAspectRatio = .95;
//               } else if (width > 600) {
//                 crossAxisCount = 2;
//                 childAspectRatio = .82;
//               } else if (width > 300) {
//                 crossAxisCount = 2;
//                 childAspectRatio = .80;
//               }
//
//               return GridView.builder(
//                 padding: const EdgeInsets.all(10),
//                 itemCount: controller.masterGoals.length,
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: crossAxisCount,
//                   crossAxisSpacing: 12,
//                                             mainAxisSpacing: 12,
//                   childAspectRatio: childAspectRatio,
//                 ),
//                 itemBuilder: (context, index) {
//                   final goal = controller.masterGoals[index];
//
//                   final isSelected =
//                       controller.selectedGoalIndex.value == index;
//                   debugPrint("Selected Goal Index: ${controller.selectedGoalIndex.value}, Current Index: $index, Goal Type: ${goal.goalType}");
//                   return AnimatedScale(
//                     duration: const Duration(milliseconds: 500),
//                     curve: Curves.easeOutBack,
//                     scale: isSelected ? 1.05 : 1,
//                     child: AnimatedContainer(
//                       duration: const Duration(milliseconds: 300),
//                       curve: Curves.easeInOut,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(18),
//                         gradient: LinearGradient(
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                           colors: isSelected
//                               ? [
//                                   controller.getGoalColor(goal.goalType),
//                             controller.getGoalColor(goal.goalType).withOpacity(.75),
//                                 ]
//                               : [Colors.white, Colors.white],
//                         ),
//                         border: Border.all(
//                           color: isSelected
//                               ?  controller.getGoalColor(goal.goalType)
//                               : Colors.grey.shade200,
//                           width: 1.2,
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: isSelected
//                                 ?  controller.getGoalColor(goal.goalType).withOpacity(.20)
//                                 : Colors.black.withOpacity(.04),
//                             blurRadius: 10,
//                             offset: const Offset(0, 4),
//                           ),
//                         ],
//                       ),
//                       child: InkWell(
//                         borderRadius: BorderRadius.circular(18),
//                         onTap: () async {
//                           /// FIRST SELECT CARD
//                           controller.selectedGoalIndex.value = index;
//
//                           /// IMPORTANT
//                           /// rebuild first so animation visible
//                           controller.update();
//
//                           /// WAIT FOR ANIMATION
//                           await Future.delayed(
//                             const Duration(milliseconds: 200),
//                           );
//
//                           final goal = controller.masterGoals[index];
//                           controller.goalId.value = goal.id;
//                           controller.selectedGoalType.value = goal.goalType;
//
//                           /// UPDATE SIP VALUES
//                           controller.setTarget(goal.targetAmount);
//
//                           controller.setYears(goal.goalTenure.toDouble());
//
//                           controller.setRate(goal.expectedReturnRate);
//
//                           controller.update();
//
//                           /// OPEN NEXT SCREEN / SCROLL
//                           await Future.delayed(
//                             const Duration(milliseconds: 200),
//                           );
//
//                           if (controller.goalDetailsKey.currentContext !=
//                               null) {
//                             Scrollable.ensureVisible(
//                               controller.goalDetailsKey.currentContext!,
//                               duration: const Duration(milliseconds: 600),
//                               curve: Curves.easeInOut,
//                             );
//                           }
//                           Get.to(() => GoalDetailsScreen());
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.all(10),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               /// TOP ROW
//                               Row(
//                                 children: [
//                                   Container(
//                                     height: width < 500 ? 42 : 52,
//                                     width: width < 500 ? 42 : 52,
//                                     decoration: BoxDecoration(
//                                       color: isSelected
//                                           ? Colors.white.withOpacity(.18)
//                                           :  controller.getGoalColor(
//                                               goal.goalType,
//                                             ).withOpacity(.10),
//                                       borderRadius: BorderRadius.circular(14),
//                                     ),
//                                     child: Icon(
//                                       getGoalIcon(goal.goalType),
//                                       color: isSelected
//                                           ? Colors.white
//                                           :  controller.getGoalColor(goal.goalType),
//                                       size: width < 500 ? 22 : 28,
//                                     ),
//                                   ),
//
//                                   const Spacer(),
//
//                                   AnimatedContainer(
//                                     duration: const Duration(milliseconds: 250),
//                                     height: 22,
//                                     width: 22,
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: isSelected
//                                           ? Colors.white
//                                           : Colors.transparent,
//                                       border: Border.all(
//                                         color: isSelected
//                                             ? Colors.white
//                                             : Colors.grey.shade400,
//                                         width: 1.8,
//                                       ),
//                                     ),
//                                     child: isSelected
//                                         ? Icon(
//                                             Icons.check,
//                                             size: 14,
//                                             color:  controller.getGoalColor(goal.goalType),
//                                           )
//                                         : null,
//                                   ),
//                                 ],
//                               ),
//
//                               SizedBox(height: width < 500 ? 6 : 14),
//
//                               /// TITLE
//                               Text(
//                                 goal.goalType.capitalizeFirst ?? '',
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TextStyle(
//                                   fontSize: width < 500 ? 15 : 20,
//                                   fontWeight: FontWeight.w700,
//                                   color: isSelected
//                                       ? Colors.white
//                                       : Colors.black,
//                                 ),
//                               ),
//
//                               const SizedBox(height: 2),
//
//                               /// DESCRIPTION
//                               Text(
//                                 goal.goalDescription,
//                                 maxLines: width < 500 ? 2 : 3,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TextStyle(
//                                   fontSize: width < 500 ? 11 : 13,
//                                   color: isSelected
//                                       ? Colors.white.withOpacity(.9)
//                                       : Colors.grey.shade600,
//                                   height: 1.4,
//                                 ),
//                               ),
//
//                               SizedBox(height: width < 500 ? 4 : 10),
//
//                               /// TARGET BOX
//                               Container(
//                                 width: double.infinity,
//                                 padding: EdgeInsets.all(width < 500 ? 8 : 20),
//                                 decoration: BoxDecoration(
//                                   color: isSelected
//                                       ? Colors.white.withOpacity(.15)
//                                       : Colors.grey.shade100,
//                                   borderRadius: BorderRadius.circular(14),
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "Target Amount",
//                                       style: TextStyle(
//                                         fontSize: 10,
//                                         color: isSelected
//                                             ? Colors.white70
//                                             : Colors.grey.shade600,
//                                       ),
//                                     ),
//
//                                     const SizedBox(height: 2),
//
//                                     Text(
//                                       formatCurrency(goal.targetAmount),
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: TextStyle(
//                                         fontSize: width < 500 ? 13 : 16,
//                                         fontWeight: FontWeight.w700,
//                                         color: isSelected
//                                             ? Colors.white
//                                             : Colors.black,
//                                       ),
//                                     ),
//
//                                     SizedBox(height: width < 500 ? 4 : 10),
//
//                                     Row(
//                                       children: [
//                                         Icon(
//                                           Icons.schedule_rounded,
//                                           size: 14,
//                                           color: isSelected
//                                               ? Colors.white70
//                                               : Colors.grey.shade600,
//                                         ),
//
//                                         const SizedBox(width: 4),
//
//                                         Expanded(
//                                           child: Text(
//                                             "${goal.goalTenure} Years",
//                                             maxLines: 1,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: TextStyle(
//                                               fontSize: width < 500 ? 11 : 13,
//                                               fontWeight: FontWeight.w600,
//                                               color: isSelected
//                                                   ? Colors.white
//                                                   : Colors.black87,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(height: width < 500 ? 4 : 10),
//                                     Row(
//                                       children: [
//                                         Icon(
//                                           Icons.trending_up_rounded,
//                                           size: 14,
//                                           color: isSelected
//                                               ? Colors.white70
//                                               : Colors.grey.shade600,
//                                         ),
//
//                                         const SizedBox(width: 4),
//
//                                         Expanded(
//                                           child: Text(
//                                             "${goal.expectedReturnRate} %",
//                                             maxLines: 1,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: TextStyle(
//                                               fontSize: width < 500 ? 11 : 13,
//                                               fontWeight: FontWeight.w600,
//                                               color: isSelected
//                                                   ? Colors.white
//                                                   : Colors.black87,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//           floatingActionButton: controller.isEdit.value
//               ? FloatingActionButton(
//                   onPressed: () {
//                     Get.to(() => GoalDetailsScreen());
//                   },
//                   backgroundColor: Ucolors.primary,
//                   child: const Icon(Icons.check, color: Colors.white),
//                 )
//               : null,
//         );
//       },
//     );
//   }
// }
//
