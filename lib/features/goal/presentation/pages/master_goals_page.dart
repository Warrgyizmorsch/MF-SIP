// ignore_for_file: dead_null_aware_expression, dead_code

import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../common/widget/animated/custom_footer.dart';
import '../../../../common/widget/appbar/custom_appbar_normal.dart';
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
import '../../../cart/presentation/controllers/cart_controller.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../../../explore/presentation/controller/fundhouse_controller.dart';
import '../../../explore/presentation/controller/mutual_fund_controller.dart';
import '../../../explore/presentation/pages/explore.dart';
import '../../../fund_details/data/models/return_model.dart';
import '../../../fund_details/presentation/pages/fund_deatails.dart';
import '../../../fund_details/presentation/widgets/return.dart';
import '../../../home/presentation/widgets/product_tool/widget/sipslidertile.dart';
import '../../../sip_process/presentation/widgets/sip_projection_chart.dart';
import '../../domain/entity/goal_entity.dart';
import '../controller/goal_sip_controller.dart';

class MasterGoalsPage extends GetView<GoalSipController> {
  const MasterGoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GoalSipController>(
      initState: (_) async {
        controller.isHome.value = false;
        await controller.getMasterGoals();

        final args = Get.arguments ?? {};

        final String initialType = args['goalType'] ?? 'custom';

        controller.isEdit.value = args['isEdit'] ?? false;

        controller.isHome.value = args['isHome'] ?? false;
        controller.isAddFund.value = args['isAddFund'] ?? false;

        final UserGoalEntity? goal = args['goal'];

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!controller.isEdit.value) {
            controller.resetStateForNewGoal();
          }

          controller.updateGoalType(initialType);

          // EDIT GOAL
          if (controller.isEdit.value && goal != null) {
            controller.loadGoalForEdit(goal);
          }
          if (controller.isAddFund.value && goal != null) {
            controller.loadGoalForAddFund(goal);
          }
          // HOME GOAL
          if (controller.isHome.value) {
            final masterGoal = controller.masterGoals.firstWhereOrNull(
              (e) => e.goalType == initialType,
            );

            if (masterGoal != null) {
              controller.handleHomeGoal(masterGoal);
            }
          }
        });

        controller.update();
      },
      builder: (controller) {
        if (controller.isEdit.value ||
            controller.isHome.value ||
            controller.isAddFund.value) {
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

class GoalDetailsScreen extends GetView<GoalSipController> {
  GoalDetailsScreen({super.key});

  final CartController cartController = Get.find<CartController>();
  final GlobalKey popularFundsKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final currentGoal = controller.goalResponse.value?.data
            .firstWhereOrNull(
              (e) => e.goalId == controller.savedDatabaseId.value,
            );
        debugPrint("Current Goal Status: ${currentGoal?.status}");
        if (currentGoal?.status == "pending" ||
            currentGoal?.status == null ||
            !controller.isGoalSaved.value ||
            currentGoal?.mfuOrderStatus == "not_ordered" ||
            currentGoal?.mfuOrderStatus == null) {
          final shouldLeave = await Get.dialog<bool>(
            AlertDialog(
              title: const Text("Discard Changes?"),
              content: const Text(
                "Your goal is not saved yet. Do you want to leave this page?",
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(result: false),
                  child: const Text("Stay", style: TextStyle(color: Ucolors.primary)),
                ),
                ElevatedButton(
                  onPressed: () => Get.back(result: true),
                  child: const Text("Leave",style: TextStyle(color: Ucolors.primary)),
                ),
              ],
            ),
          );

          if (shouldLeave == true) {
            Get.back();
            Get.back();
          }

          return;
        }

        Get.back();
      },
      child: Scaffold(
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
                      Get.find<NavigationBarController>().selectedIndex.value =
                          3;
                    }
                  });
                },
                child: Text(
                  "View All Goals",
                  style: TextStyle(
                    fontFamily: FontFamily.medium,
                    color: Ucolors.primary,
                  ),
                ),
              );
            }),
          ],
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
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
                          child: Obx(
                                () => controller.isSavingGoal.value
                                ? const Center(
                              child: CircularProgressIndicator(color: Ucolors.primary,),
                            )
                                : UElevatedBUtton(
                              onPressed: () async {
                                if (isEdit) {
                                  // await controller.updateGoal();
                                } else {
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
                                }
                              },
                              child: Center(
                                child: Text(
                                  isEdit ? "Update Goal" : "Save Goal",
                                  style: AppTextStyles.bodyMedium(
                                    color: Colors.white,
                                  ),
                                ),
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
            ),
          ],
        ),
        bottomNavigationBar: Obx(() {
          if (!controller.isGoalSaved.value) {
            return const CustomFooter();
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CustomFooter(),
              SafeArea(
                top: false,
                child: CartBottomBar(
                  isValid: controller.selectedPopularFund.isNotEmpty,
                  ontap: () {

                    if (controller.selectedPopularFund.isEmpty ||
                        controller.amountControllers.isEmpty ||
                        controller.amountControllers.values.any(
                              (c) => c.text.trim().isEmpty,
                        )) {
                      Get.snackbar(
                        "Error",
                        "Please select funds and enter amount to start SIP",
                      );
                      return;
                    }

                    final mutualController = Get.find<MutualFundController>();

                    final selectedFunds = mutualController.searchFund
                        .where(
                          (fund) => controller.selectedPopularFund.contains(
                            fund.baseSchemeName,
                          ),
                        )
                        .toList();

                    debugPrint("Selected Funds Count: ${selectedFunds.length}");

                    for (final fund in selectedFunds) {
                      debugPrint("""
                    Fund Name : ${fund.baseSchemeName}
                    Scheme Code : ${fund.schemeCode}
                    AMC Name : ${fund.amc?.amcName}
                    Min SIP : ${fund.minSipAmount}
                    Goal Fund Id : ${controller.getGoalFundId(fund.schemeCode?.toString() ?? '')}
                    Amount : ${controller.getAmountController(fund.schemeCode?.toString() ?? '').text}
                    Goal Id : ${controller.savedDatabaseId.value}
                    Investment Type : ${controller.savedInvestmentType.value}
                    ----------------------------------
                    """);
                    }
                  },
                  amount: controller.savedInvestmentType.value == 'lumpsum'
                      ? controller.lumpsumAmount.value.toStringAsFixed(0)
                      : controller.monthlySip.value.toStringAsFixed(0),
                  amountColor: Ucolors.blue,
                ),
              ),
            ],
          );
        }),
      ),
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
            onPressed: () {
              _showExploreMoreBottomSheet(context);
            },
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
    final FocusNode searchFocus = FocusNode();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                /// Drag Handle
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

                /// Header
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
                              fontFamily: FontFamily.medium,
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
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                /// Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: SizedBox(
                    height: 44,
                    child: SearchBar(
                      focusNode: searchFocus,

                      onTap: () {
                        mutualController.setSearchFocus(true);
                      },

                      onTapOutside: (event) {
                        searchFocus.unfocus();
                        mutualController.setSearchFocus(false);
                      },

                      backgroundColor: WidgetStateProperty.all(
                        Colors.grey.shade50,
                      ),

                      leading: Icon(Icons.search, color: Colors.grey.shade600),

                      hintText: "Search mutual funds...",

                      hintStyle: WidgetStateProperty.all(
                        TextStyle(
                          fontFamily: FontFamily.medium,
                          color: Colors.grey.shade500,
                          fontSize: 14,
                        ),
                      ),

                      elevation: WidgetStateProperty.all(0),

                      side: WidgetStateProperty.all(
                        BorderSide(color: Colors.grey.shade200),
                      ),

                      onChanged: (value) {
                        mutualController.onSearchQueryChanged(value);
                      },
                    ),
                  ),
                ),

                Divider(color: Colors.grey.shade200, height: 20),

                /// Fund List
                Expanded(
                  child: Obx(() {
                    if (mutualController.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Ucolors.primary,
                        ),
                      );
                    }

                    if (mutualController.searchFund.isEmpty) {
                      return Center(
                        child: Text(
                          "No mutual funds found",
                          style: TextStyle(
                            fontFamily: FontFamily.medium,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.only(bottom: 20),
                      itemCount: mutualController.searchFund.length,

                      itemBuilder: (context, index) {
                        final fund = mutualController.searchFund[index];

                        final name = fund.baseSchemeName ?? "Unknown Name";

                        return Obx(() {
                          final isSelected = goalSipController.isSelectedFund(
                            name,
                          );

                          return Stack(
                            children: [
                              /// Fund Card
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 6),

                                child: MutualFundCard(
                                  entity: fund,
                                  showTrainlings: false,

                                  onTapOverride: () async {
                                    FocusScope.of(context).unfocus();

                                    final isSelected = goalSipController
                                        .isSelectedFund(name);

                                    try {
                                      if (goalSipController
                                                  .savedInvestmentType
                                                  .value ==
                                              "lumpsum" ||
                                          goalSipController
                                                  .savedInvestmentType
                                                  .value ==
                                              "sip") {
                                        goalSipController.showLoading();
                                      }

                                      /// ================= DELETE FUND =================
                                      if (isSelected) {
                                        final goalFundId = goalSipController
                                            .getGoalFundId(
                                              fund.schemeCode?.toString() ?? '',
                                            );

                                        if (goalFundId != null) {
                                          await goalSipController
                                              .deleteGoalFund(
                                                id: goalFundId,
                                                isEdit: false,
                                                schemeName:
                                                    fund.schemeCode
                                                        ?.toString() ??
                                                    '',
                                              );

                                          goalSipController.toggleFund(name);

                                          if (goalSipController
                                              .selectedPopularFund
                                              .isNotEmpty) {
                                            if (goalSipController
                                                    .savedInvestmentType
                                                    .value ==
                                                "lumpsum") {
                                              await goalSipController
                                                  .distributeMonthlyAmount();
                                            } else if (goalSipController
                                                    .savedInvestmentType
                                                    .value ==
                                                "sip") {
                                              await goalSipController
                                                  .distributeSipAmount();
                                            }
                                          }
                                        }

                                        return;
                                      }

                                      /// ================= SIP DATE =================
                                      if (goalSipController
                                                  .savedInvestmentType
                                                  .value ==
                                              "sip" &&
                                          goalSipController
                                              .selectedPopularFund
                                              .isEmpty) {
                                        final confirmed =
                                            await _showSipDateDialog(
                                              context,
                                              goalSipController,
                                            );

                                        if (confirmed != true) return;
                                      }

                                      /// ================= ADD FUND =================
                                      goalSipController.toggleFund(name);

                                      await goalSipController.saveGoalFund(
                                        goalId:
                                            goalSipController
                                                .savedDatabaseId
                                                .value ??
                                            0,
                                        schemeCode:
                                            fund.schemeCode?.toString() ?? '',
                                        schemeName: fund.baseSchemeName ?? '',
                                        sipAmount: (fund.minSipAmount ?? 0)
                                            .toDouble(),
                                        sipDay: goalSipController
                                            .selectedSipDay
                                            .value,
                                      );

                                      if (goalSipController
                                              .savedInvestmentType
                                              .value ==
                                          "lumpsum") {
                                        await goalSipController
                                            .distributeMonthlyAmount();
                                      } else if (goalSipController
                                              .savedInvestmentType
                                              .value ==
                                          "sip") {
                                        await goalSipController
                                            .distributeSipAmount();
                                      }
                                    } catch (e, stackTrace) {
                                      debugPrint("Error: $e");
                                      debugPrintStack(stackTrace: stackTrace);
                                    } finally {
                                      goalSipController.hideLoading();
                                    }
                                  },
                                ),
                              ),

                              /// Selected Border
                              if (isSelected)
                                Positioned.fill(
                                  child: IgnorePointer(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),

                                      decoration: BoxDecoration(
                                        color: Ucolors.primary.withValues(
                                          alpha: 0.05,
                                        ),

                                        borderRadius: BorderRadius.circular(16),

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
                    );
                  }),
                ),

                /// Bottom Button
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),

                  child: Obx(() {
                    final selectedCount =
                        goalSipController.selectedPopularFund.length;

                    return UElevatedBUtton(
                      onPressed: () {
                        Get.back();
                      },

                      child: Center(
                        child: Text(
                          selectedCount > 0
                              ? "Add $selectedCount Funds"
                              : "Done",

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
      });
    });
  }

  Future<bool?> _showSipDateDialog(
    BuildContext context,
    GoalSipController controller,
  ) {
    RxString selectedSipDay = (controller.selectedSipDay.value).toString().obs;

    return Get.dialog<bool>(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Select SIP Date"),
              const SizedBox(height: 16),
              Obx(
                () => DropdownButton<String>(
                  value: selectedSipDay.value,
                  isExpanded: true,
                  items: List.generate(
                    28,
                    (i) => DropdownMenuItem(
                      value: '${i + 1}',
                      child: Text('${i + 1}'),
                    ),
                  ),
                  onChanged: (val) {
                    if (val != null) {
                      selectedSipDay.value = val;
                      controller.selectedSipDay.value = int.parse(val);
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(result: false),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () => Get.back(result: true),
                    child: const Text("Confirm"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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

class PopularFundCardMobSelected extends StatelessWidget {
  const PopularFundCardMobSelected({
    super.key,
    required this.imgPath,
    required this.name,
    this.onTap,
    this.isNetwork = false,
    this.borderColor = Ucolors.borderColor,
    this.threeYear,
    this.tenYear,
    this.oneYear,
    this.fiveYear,
    this.isSelected = false,
    this.showAmountField = false,
    this.amountController,
    this.onAmountSubmitted,
  });
  final Function(String)? onAmountSubmitted;
  final String imgPath;
  final String name;
  final VoidCallback? onTap;
  final bool isNetwork;
  final Color borderColor;
  final String? threeYear;
  final String? tenYear;
  final String? oneYear;
  final String? fiveYear;
  final bool isSelected;
  final bool showAmountField;
  final TextEditingController? amountController;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
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
                    ? Ucolors.primary.withValues(alpha: 0.12)
                    : Colors.black.withValues(alpha: 0.04),
                blurRadius: isSelected ? 12 : 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: image + name + badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: isSelected ? 34 : 30,
                    width: isSelected ? 34 : 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade50,
                      border: isSelected
                          ? Border.all(color: Ucolors.primary, width: 1.5)
                          : null,
                    ),
                    child: ClipOval(
                      child: isNetwork
                          ? CustomCachedImage(imageUrl: imgPath, size: 40)
                          : Image.asset(imgPath, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      name,
                      maxLines: 2,
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
                  if (isSelected)
                    AnimatedScale(
                      duration: const Duration(milliseconds: 250),
                      scale: 1,
                      child: Container(
                        margin: const EdgeInsets.only(left: 4),
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Ucolors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _returnColumn('1Y', oneYear),
                  if (showAmountField) Gap(20),
                  _returnColumn('3Y', threeYear),
                  if (!showAmountField) ...[
                    _returnColumn('5Y', fiveYear),
                    _returnColumn('10Y', tenYear),
                  ],
                  if (showAmountField) ...[
                    Gap(20),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: SizedBox(
                          height: 36,
                          child: TextFormField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            onFieldSubmitted: onAmountSubmitted,
                            decoration: InputDecoration(
                              hintText: "Amount",
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _returnColumn(String label, String? value) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: UTextStyles.bodySmallW500.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.arrow_drop_up_rounded,
              color: Ucolors.success,
              size: 20,
            ),
            Text(
              '${value ?? 0}%',
              style: UTextStyles.bodySmallW500.copyWith(
                color: Ucolors.success,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class PopularAndSelectedFund extends StatelessWidget {
  PopularAndSelectedFund({super.key});

  final MutualFundController mutualController = Get.find();
  final GoalSipController goalSipController = Get.find();

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final int crossAxisCount = isDesktop ? 3 : 1;

    return Obx(() {
      final allFunds = mutualController.searchFund;

      final selectedFunds = allFunds
          .where(
            (f) => goalSipController.isSelectedFund(f.baseSchemeName ?? ''),
          )
          .toList();

      final popularFunds = allFunds
          .where(
            (f) => !goalSipController.isSelectedFund(f.baseSchemeName ?? ''),
          )
          .toList();

      final List<dynamic> displayFunds = selectedFunds.isNotEmpty
          ? [...selectedFunds, ...popularFunds]
          : popularFunds.take(6).toList();

      if (displayFunds.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  size: 42,
                  color: Ucolors.primary,
                ),
                const SizedBox(height: 12),
                Text(
                  "No Funds Available",
                  style: TextStyle(
                    fontFamily: FontFamily.medium,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Ucolors.dark,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Please add funds",
                  style: TextStyle(
                    fontFamily: FontFamily.medium,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      final double screenWidth = MediaQuery.of(context).size.width;
      final double horizontalPadding = isDesktop ? 96 : 32;
      final double spacing = 16;
      final double cardWidth =
          (screenWidth - horizontalPadding - (spacing * (crossAxisCount - 1))) /
          crossAxisCount;

      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: List.generate(displayFunds.length, (index) {
          final fund = displayFunds[index];
          final name = fund.baseSchemeName ?? 'Unknown Name';
          final img = "${Appurl.baseUrl}${fund.amc?.amcLogoUrl}";
          final threeYear = fund.returnsEntity?.threeYear ?? "";
          final oneYear = fund.returnsEntity?.oneYear ?? "";
          final fiveYear = fund.returnsEntity?.fiveYear ?? "";
          final tenYear = fund.returnsEntity?.tenYear ?? "";

          return Obx(() {
            final isSelected = goalSipController.isSelectedFund(name);

            return SizedBox(
              width: cardWidth,
              child: AnimatedScale(
                duration: const Duration(milliseconds: 250),
                scale: isSelected ? 1.02 : 1,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    FocusScope.of(context).unfocus();

                    final isSelected = goalSipController.isSelectedFund(name);

                    try {
                      if (goalSipController.savedInvestmentType.value ==
                              "lumpsum" ||
                          goalSipController.savedInvestmentType.value ==
                              "sip") {
                        goalSipController.showLoading();
                      }

                      /// ================= DELETE FUND =================
                      if (isSelected) {
                        final goalFundId = goalSipController.getGoalFundId(
                          fund.schemeCode?.toString() ?? '',
                        );

                        if (goalFundId != null) {
                          await goalSipController.deleteGoalFund(
                            id: goalFundId,
                            isEdit: false,
                            schemeName: fund.schemeCode?.toString() ?? '',
                          );

                          goalSipController.toggleFund(name);

                          if (goalSipController
                              .selectedPopularFund
                              .isNotEmpty) {
                            if (goalSipController.savedInvestmentType.value ==
                                "lumpsum") {
                              await goalSipController.distributeMonthlyAmount();
                            } else if (goalSipController
                                    .savedInvestmentType
                                    .value ==
                                "sip") {
                              await goalSipController.distributeSipAmount();
                            }
                          }
                        }

                        return;
                      }

                      /// ================= SIP DATE =================
                      if (goalSipController.savedInvestmentType.value ==
                              "sip" &&
                          goalSipController.selectedPopularFund.isEmpty) {
                        final confirmed = await _showSipDateDialog(
                          context,
                          goalSipController,
                        );

                        if (confirmed != true) return;
                      }

                      /// ================= ADD FUND =================
                      goalSipController.toggleFund(name);

                      await goalSipController.saveGoalFund(
                        goalId: goalSipController.savedDatabaseId.value ?? 0,
                        schemeCode: fund.schemeCode?.toString() ?? '',
                        schemeName: fund.baseSchemeName ?? '',
                        sipAmount: (goalSipController.monthlySip.value).toDouble(),
                        sipDay: goalSipController.selectedSipDay.value,
                      );

                      if (goalSipController.savedInvestmentType.value ==
                          "lumpsum") {
                        await goalSipController.distributeMonthlyAmount();
                      } else if (goalSipController.savedInvestmentType.value ==
                          "sip") {
                        await goalSipController.distributeSipAmount();
                      }
                    } catch (e, stackTrace) {
                      debugPrint("Error: $e");
                      debugPrintStack(stackTrace: stackTrace);
                    } finally {
                      goalSipController.hideLoading();
                    }
                  },
                  child: PopularFundCardMobSelected(
                    borderColor: isSelected
                        ? Ucolors.primary
                        : Ucolors.borderColor,
                    isNetwork: true,
                    imgPath: img,
                    name: name,
                    threeYear: threeYear,
                    oneYear: oneYear,
                    fiveYear: fiveYear,
                    tenYear: tenYear,
                    isSelected: isSelected,
                    showAmountField:
                        isSelected &&
                        (goalSipController.savedInvestmentType.value ==
                                "lumpsum" ||
                            goalSipController.savedInvestmentType.value ==
                                "sip"),
                    amountController: goalSipController.getAmountController(
                      fund.schemeCode?.toString() ?? '',
                    ),
                    onAmountSubmitted: (value) async {
                      final amount = double.tryParse(value) ?? 0;

                      if (goalSipController.savedInvestmentType.value ==
                          "lumpsum") {
                        await goalSipController.redistributeRemainingAmount(
                          editedSchemeCode: fund.schemeCode?.toString() ?? '',
                          editedAmount: amount,
                        );
                      } else if (goalSipController.savedInvestmentType.value ==
                          "sip") {
                        await goalSipController.redistributeSipAmountAfterEdit(
                          editedSchemeCode: fund.schemeCode?.toString() ?? '',
                          editedAmount: amount,
                        );
                      }
                    },
                  ),
                ),
              ),
            );
          });
        }),
      );
    });
  }

  Future<bool?> _showSipDateDialog(
    BuildContext context,
    GoalSipController controller,
  ) {
    RxString selectedSipDay = (controller.selectedSipDay.value).toString().obs;

    return Get.dialog<bool>(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Select SIP Date"),
              const SizedBox(height: 16),
              Obx(
                () => DropdownButton<String>(
                  value: selectedSipDay.value,
                  isExpanded: true,
                  items: List.generate(
                    28,
                    (i) => DropdownMenuItem(
                      value: '${i + 1}',
                      child: Text('${i + 1}'),
                    ),
                  ),
                  onChanged: (val) {
                    if (val != null) {
                      selectedSipDay.value = val;
                      controller.selectedSipDay.value = int.parse(val);
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(result: false),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () => Get.back(result: true),
                    child: const Text("Confirm"),
                  ),
                ],
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
          /// Header
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

          /// ================= CHART VIEW =================
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
              final rows = controller.savedInvestmentType.value == "lumpsum"
                  ? controller.buildLumpsumYearlyReport()
                  : controller.buildYearlyReport();

              if (rows.isEmpty) {
                return const SizedBox(
                  height: 250,
                  child: Center(child: CircularProgressIndicator()),
                );
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
          ]
          /// ================= TABLE VIEW =================
          else
            Obx(() {
              final result = controller.savedInvestmentType.value == "lumpsum"
                  ? controller.buildLumpsumYearlyReport()
                  : controller.buildYearlyReport();

              if (result.isEmpty) {
                return const SizedBox(
                  height: 250,
                  child: Center(child: Text("No projection data available")),
                );
              }

              return Column(
                children: [
                  const TableHeader(
                    heading1: 'Year',
                    heading2: 'Invest',
                    heading3: 'Current',
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

// =============================================================================
// SIPSectionGoal — SIP + Lumpsum Tab
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Goal Title Field ──────────────────────────────────────────────
          Obx(
            () => IgnorePointer(
              ignoring: controller.isGoalSaved.value,
              child: TextFormFieldCustom(
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
                  readOnly: controller.isGoalSaved.value,
                  textInputType: TextInputType.text,
                  backgroundColor: Colors.transparent,
                  controller: controller.goalNameTextEditingController,
                  onTap: () {
                    if (controller.isGoalSaved.value) {
                      FocusScope.of(context).unfocus();
                    }
                  },
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
                      style: TextStyle(
                        fontFamily: FontFamily.medium,
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Obx(
            () => controller.goalError.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      controller.goalError.value,
                      style: TextStyle(
                        fontFamily: FontFamily.medium,
                        fontSize: 12,
                        color: Ucolors.red,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          const Gap(20),

          // ── SIP / Lumpsum Tab Toggle ──────────────────────────────────────
          Obx(() {
            final isSip = controller.investmentMode.value == 'sip';
            return Container(
              decoration: BoxDecoration(
                color: const Color(0xffF3F4F6),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  _TabButton(
                    label: 'SIP',
                    isSelected: isSip,
                    onTap: () => controller.investmentMode.value = 'sip',
                  ),
                  _TabButton(
                    label: 'Lumpsum',
                    isSelected: !isSip,
                    onTap: () {
                      controller.investmentMode.value = 'lumpsum';
                      controller.recalculateLumpsum();
                    },
                  ),
                ],
              ),
            );
          }),

          const Gap(20),

          // ── Tab Content ───────────────────────────────────────────────────
          Obx(() {
            final isSip = controller.investmentMode.value == 'sip';
            return isSip ? const _SipTabContent() : const _LumpsumTabContent();
          }),
        ],
      ),
    );
  }
}

// ── Tab Button ────────────────────────────────────────────────────────────────
class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: FontFamily.medium,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Ucolors.primary : Colors.grey.shade500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// _SipTabContent  — Daily / Weekly / Monthly sliders + value cards
// =============================================================================
class _SipTabContent extends GetView<GoalSipController> {
  const _SipTabContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Target Amount
        Obx(
          () => IgnorePointer(
            ignoring: controller.isGoalSaved.value,
            child: SipSliderTile2(
              prefix: '₹',
              title: 'I Need',
              value: controller.targetAmount.value < 1000
                  ? 1000
                  : controller.targetAmount.value,
              min: 1000,
              max: 10000000,
              suffix: '',
              onChanged: controller.setTarget,
            ),
          ),
        ),
        const Gap(16),

        // Duration
        Obx(
          () => IgnorePointer(
            ignoring: controller.isGoalSaved.value,
            child: SipSliderTile2(
              title: 'Duration',
              value: controller.years.value,
              min: 1,
              max: 30,
              suffix: 'Yrs',
              onChanged: controller.setYears,
            ),
          ),
        ),
        const Gap(16),

        // Expected Return
        Obx(
          () => IgnorePointer(
            ignoring: controller.isGoalSaved.value,
            child: SipSliderTile2(
              title: 'Expected Return',
              value: controller.annualRate.value,
              min: 1,
              max: 30,
              suffix: '%',
              onChanged: controller.setRate,
            ),
          ),
        ),
        const Gap(20),

        // Value Cards
        Obx(
          () => Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              SizedBox(
                width: Get.width * .40 - 12,
                child: _ValueCard(
                  title: 'Daily SIP',
                  value: formatCurrency(controller.dailySipAmount.value),
                  accent: false,
                ),
              ),
              SizedBox(
                width: Get.width * .40 - 12,
                child: _ValueCard(
                  title: 'Weekly SIP',
                  value: formatCurrency(controller.weeklySipAmount.value),
                  accent: false,
                ),
              ),
              SizedBox(
                width: Get.width * .40 - 12,
                child: _ValueCard(
                  title: 'Monthly SIP',
                  value: formatCurrency(controller.monthlySip.value.toDouble()),
                  accent: true, // highlight monthly
                ),
              ),

              // Edit mode only
              if (controller.hasChanges.value && controller.isEdit.value) ...[
                SizedBox(
                  width: Get.width * .40 - 12,
                  child: _ValueCard(
                    title: 'Existing SIP',
                    value: formatCurrency(
                      controller.existingSipAmount.value.toDouble(),
                    ),
                    accent: false,
                  ),
                ),
                SizedBox(
                  width: Get.width * .40 - 12,
                  child: _ValueCard(
                    title: 'Additional SIP',
                    value: formatCurrency(
                      controller.additionalSipAmount.value.toDouble(),
                    ),
                    accent: false,
                  ),
                ),
              ],

              SizedBox(
                width: Get.width * .40 - 12,
                child: _ValueCard(
                  title: 'Invested',
                  value: formatCurrency(controller.invested.value.toDouble()),
                  accent: false,
                ),
              ),
              SizedBox(
                width: Get.width * .40 - 12,
                child: _ValueCard(
                  title: 'Future Value',
                  value: formatCurrency(
                    controller.targetAmount.value.toDouble(),
                  ),
                  accent: false,
                ),
              ),
              SizedBox(
                width: Get.width * .40 - 12,
                child: _ValueCard(
                  title: 'Total Return',
                  value: formatCurrency(
                    controller.totalReturn.value.toDouble(),
                  ),
                  accent: false,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// _LumpsumTabContent  — One-time invest amount + duration + return sliders
// =============================================================================
class _LumpsumTabContent extends GetView<GoalSipController> {
  const _LumpsumTabContent();

  @override
  Widget build(BuildContext context) {
    debugPrint("build${controller.lumpsumAmount.value.toString()}");
    final double lumpsumAmount = controller.smartRoundOff(
      controller.lumpsumAmount.value,
    );
    debugPrint("after build${lumpsumAmount.toString()}");
    return Column(
      children: [
        // Lumpsum Amount
        Obx(() {
          debugPrint("Obx build${controller.lumpsumAmount.value.toString()}");
          final double lumpsumAmount = controller.smartRoundOff(
            controller.lumpsumAmount.value,
          );
          debugPrint("Obx after build${lumpsumAmount.toString()}");
          return IgnorePointer(
            ignoring: controller.isGoalSaved.value,
            child: SipSliderTile2(
              prefix: '₹',
              title: 'Invest Amount',
              value: lumpsumAmount < 500 ? 500 : lumpsumAmount,
              min: 500,
              max: controller.lumpsumFutureValue.value.toDouble(),
              suffix: '',
              onChanged: (value) {
                debugPrint(
                  "onchange ${controller.lumpsumAmount.value},value $value",
                );
                controller.setLumpsumAmount(value);
                debugPrint(
                  "onchange2 ${controller.lumpsumAmount.value},value $value",
                );
              },
            ),
          );
        }),
        const Gap(16),

        // Duration
        Obx(
          () => IgnorePointer(
            ignoring: controller.isGoalSaved.value,
            child: SipSliderTile2(
              title: 'Duration',
              value: controller.years.value,
              min: 1,
              max: 30,
              suffix: 'Yrs',
              onChanged: controller.setYears,
            ),
          ),
        ),
        const Gap(16),

        // Expected Return
        Obx(
          () => IgnorePointer(
            ignoring: controller.isGoalSaved.value,
            child: SipSliderTile2(
              title: 'Expected Return',
              value: controller.annualRate.value,
              min: 1,
              max: 30,
              suffix: '%',
              onChanged: controller.setRate,
            ),
          ),
        ),
        const Gap(20),

        // Value Cards
        Obx(
          () => Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              SizedBox(
                width: Get.width * .40 - 12,
                child: _ValueCard(
                  title: 'Invest Once',
                  value: formatCurrency(
                    controller.lumpsumAmount.value.toDouble(),
                  ),
                  accent: true,
                ),
              ),
              SizedBox(
                width: Get.width * .40 - 12,
                child: _ValueCard(
                  title: 'Duration',
                  value: '${controller.years.value.toInt()} Yrs',
                  accent: false,
                ),
              ),
              SizedBox(
                width: Get.width * .40 - 12,
                child: _ValueCard(
                  title: 'Future Value',
                  value: formatCurrency(
                    controller.lumpsumFutureValue.value.toDouble(),
                  ),
                  accent: false,
                ),
              ),
              SizedBox(
                width: Get.width * .40 - 12,
                child: _ValueCard(
                  title: 'Total Return',
                  value: formatCurrency(
                    controller.lumpsumTotalReturn.value.toDouble(),
                  ),
                  accent: false,
                ),
              ),
              SizedBox(
                width: Get.width * .40 - 12,
                child: _ValueCard(
                  title: 'Return %',
                  value:
                      '${controller.lumpsumReturnPercent.value.toStringAsFixed(1)}%',
                  accent: false,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// _ValueCard — updated with optional accent highlight
// =============================================================================
class _ValueCard extends StatelessWidget {
  const _ValueCard({
    required this.title,
    required this.value,
    this.accent = false,
  });

  final String title;
  final String value;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accent
            ? Ucolors.primary.withValues(alpha: 0.06)
            : const Color(0xffF5F7FB),
        borderRadius: BorderRadius.circular(14),
        border: accent
            ? Border.all(
                color: Ucolors.primary.withValues(alpha: 0.35),
                width: 1.2,
              )
            : null,
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: FontFamily.medium,
              color: accent ? Ucolors.primary : Colors.grey.shade600,
              fontSize: 12,
              fontWeight: accent ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontFamily: FontFamily.medium,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: accent ? Ucolors.primary : Colors.black,
            ),
          ),

          Text(
            "Approx",
            style: TextStyle(
              fontFamily: FontFamily.medium,
              fontSize: 8,
              fontWeight: FontWeight.w400,
              color: accent
                  ? Ucolors.primary.withValues(alpha: 0.65)
                  : Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

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
            body: Center(
              child: CircularProgressIndicator(color: Ucolors.primary),
            ),
          );
        }

        if (controller.masterGoals.isEmpty) {
          return const Scaffold(body: Center(child: Text("No Goals Found")));
        }

        final bool isDesktop = ResponsiveBreakpoints.of(
          context,
        ).largerThan(TABLET);

        return Scaffold(
          backgroundColor: isDesktop
              ? const Color(0xFFF5F7FA)
              : Colors.grey[50],
          appBar: CustomAppBarNormal(
            backgroundColor: isDesktop
                ? const Color(0xFFF5F7FA)
                : const Color(0xffF3F4F6),
            title: 'Goals',
            backIcon: true,
            actionsPadding: 10,
          ),
          bottomNavigationBar: isDesktop ? null : CustomFooter(),
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
                  debugPrint("goal: ${goal.goalType}");
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
                                      .withValues(alpha: .75),
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
                                      .withValues(alpha: .20)
                                : Colors.black.withValues(alpha: .04),
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
                            const Duration(milliseconds: 200),
                          );

                          controller.goalId.value = goal.id;
                          controller.selectedGoalType.value = goal.goalType;
                          final goalType = goal.goalType.toLowerCase() ?? '';

                          if (!['custom', 'other'].contains(goalType)) {
                            controller.goalNameTextEditingController.text =
                                goal.goalType ;
                          }
                          controller.setTarget(goal.targetAmount);

                          controller.setYears(goal.goalTenure.toDouble());
                          controller.setRate(goal.expectedReturnRate);
                          // ── Lumpsum
                          final double r = goal.expectedReturnRate / 100;
                          final int n = goal.goalTenure.toInt();
                          final double pv =
                              goal.targetAmount / pow(1 + r, n); // PV calculate

                          controller.lumpsumAmount.value = controller
                              .smartRoundOff(pv);
                          debugPrint(
                            "onTap${controller.lumpsumAmount.value}",
                          ); // invest amount
                          controller.lumpsumFutureValue.value =
                              goal.targetAmount; // fixed FV
                          controller.lumpsumTotalReturn.value =
                              goal.targetAmount - pv;
                          controller.update();

                          await Future.delayed(
                            const Duration(milliseconds: 200),
                          );

                          Get.to(() => GoalDetailsScreen());
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: width < 500 ? 42 : 52,
                                    width: width < 500 ? 42 : 52,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.white.withValues(alpha: .18)
                                          : controller
                                                .getGoalColor(goal.goalType)
                                                .withValues(alpha: .10),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Icon(
                                      getGoalIcon(goal.goalType),
                                      color: isSelected
                                          ? Colors.white
                                          : controller.getGoalColor(
                                              goal.goalType,
                                            ),
                                      size: width < 500 ? 22 : 28,
                                    ),
                                  ),
                                  const Spacer(),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
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
                                            color: controller.getGoalColor(
                                              goal.goalType,
                                            ),
                                          )
                                        : null,
                                  ),
                                ],
                              ),
                              SizedBox(height: width < 500 ? 6 : 14),
                              Text(
                                goal.goalType.capitalizeFirst ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: FontFamily.medium,
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
                                  fontFamily: FontFamily.medium,
                                  fontSize: width < 500 ? 11 : 13,
                                  color: isSelected
                                      ? Colors.white.withValues(alpha: .9)
                                      : Colors.grey.shade600,
                                  height: 1.4,
                                ),
                              ),
                              SizedBox(height: width < 500 ? 4 : 10),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(width < 500 ? 8 : 20),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white.withValues(alpha: .15)
                                      : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Target Amount",
                                      style: TextStyle(
                                        fontFamily: FontFamily.medium,
                                        fontSize: 10,
                                        color: isSelected
                                            ? Colors.white70
                                            : Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      formatCurrency(goal.targetAmount),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: FontFamily.medium,
                                        fontSize: width < 500 ? 13 : 16,
                                        fontWeight: FontWeight.w700,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: width < 500 ? 4 : 10),
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
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontFamily: FontFamily.medium,
                                              fontSize: width < 500 ? 11 : 13,
                                              fontWeight: FontWeight.w600,
                                              color: isSelected
                                                  ? Colors.white
                                                  : Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: width < 500 ? 4 : 10),
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
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontFamily: FontFamily.medium,
                                              fontSize: width < 500 ? 11 : 13,
                                              fontWeight: FontWeight.w600,
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
