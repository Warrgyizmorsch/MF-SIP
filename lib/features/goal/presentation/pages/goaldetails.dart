import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/appbar/widget/compact_icon.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/common/widget/text/small_heading.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/cart/presentation/controllers/cart_controller.dart';
import 'package:my_sip/features/dashboard/presentation/pages/comparison_screen.dart';
import 'package:my_sip/features/dashboard/presentation/pages/dashboard.dart';
import 'package:my_sip/features/explore/presentation/controller/fundhouse_controller.dart';
import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';
import 'package:my_sip/features/explore/presentation/pages/explore.dart';
import 'package:my_sip/features/goal/presentation/controller/goal_sip_controller.dart';
import 'package:my_sip/features/goal/presentation/widget/GoalDetailsIndicator.dart';

import '../../domain/entity/goal_entity.dart';

class GoaldetailsPage extends GetView<GoalSipController> {
  const GoaldetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final UserGoalEntity? goal = args['goal'];
    final String emoji = args['emoji'] ?? '🎯';
    final double target = args['target'] ?? 0.0;
    final double invested = args['invested'] ?? 0.0;
    final String logo = args['logo'] ??"";

    final String title = goal?.goalName ?? 'Goal Details';
    final int currentGoalId = goal?.id ?? 0;

    return Scaffold(
      backgroundColor: Color(0xffF3F4F6),

      appBar: CustomAppBarNormal(
        title: title,
        action: [
          PopupMenuButton<String>(
            color:Ucolors.light,

            icon: const Icon(Icons.more_vert),

            onSelected: (value) {
              if (value == 'edit') {
                showEditGoalDialog(context:context,currentGoalId: currentGoalId, goal: goal);
                // edit
              } else if (value == 'delete') {
                showDeleteGoalDialog(context: context,currentGoalId: currentGoalId);
              }
            },

            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',

                child: const Row(
                  children: [
                    Icon(Icons.edit, size: 18),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),

              PopupMenuItem(
                value: 'delete',

                child: const Row(
                  children: [
                    Icon(
                      Icons.delete,
                      size: 18,
                      color: Colors.red,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: UPadding.screenPadding,
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  border: Border.all(color: Colors.black12),
                ),

                child: Tab(
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,

                    unselectedLabelColor: Colors.grey.shade700,
                    dividerColor: Colors.transparent,
                    labelColor: Ucolors.light,
                    indicatorColor: Colors.transparent,
                    labelPadding: EdgeInsets.symmetric(vertical: 10),

                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),

                      color: Ucolors.primary,
                    ),

                    tabs: [Text('Goal'), Text('Record')],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    GoalDetailSection(
                      goal: goal,
                      target: target,
                      invested: invested,
                      emoji: emoji,
                      logo: logo,
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          ...List.generate(10, (index) => TransactionCard()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBarButtonGoalDetails(
        firstButtonP: () {},
        firstButton: 'Add To Cart',
        secondButton: 'Add Funds',
        secondButtonP: () {
          // _showExploreMoreBottomSheet(context);
          if (currentGoalId != 0) {
            _showExploreMoreBottomSheet(context, currentGoalId);
          } else {
            Get.snackbar("Error", "Goal ID is missing.");
          }
        },
      ),
    );

  }
  void showDeleteGoalDialog({required BuildContext context, required currentGoalId}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
              SizedBox(width: 10),
              Text("Delete Goal"),
            ],
          ),

          content: const Text(
            "Are you sure you want to delete this goal?",
            style: TextStyle(fontSize: 15),
          ),

          actionsPadding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16,
          ),

          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },

              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),

              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () async {


                // DELETE API / CONTROLLER CALL
               await  controller.deleteGoal(currentGoalId);

              },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),

                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),

              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
  void showEditGoalDialog({required BuildContext context, required int currentGoalId ,required UserGoalEntity? goal}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          title: const Row(
            children: [
              Icon(
                Icons.edit_outlined,
                color: Colors.blue,
              ),
              SizedBox(width: 10),
              Text("Edit Goal"),
            ],
          ),

          content: const Text(
            "Are you sure you want to edit this goal?",
            style: TextStyle(
              fontSize: 15,
            ),
          ),

          actionsPadding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16,
          ),

          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },

              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),

                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),

              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                // OPEN EDIT SCREEN
                Get.toNamed(AppRoutes.masterGoalsPage,arguments: {"goalId":currentGoalId, "goal":goal, "isEdit":true});

              },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),

                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),

              child: const Text("Edit"),
            ),
          ],
        );
      },
    );
  }
  void _showExploreMoreBottomSheet(BuildContext context, int goal) {
    final mutualController = Get.find<MutualFundController>();
    final goalSipController = Get.find<GoalSipController>();
    final cartController = Get.find<CartController>();
    final FocusNode searchFocus = FocusNode();
    goalSipController.selectedPopularFund.clear();

    // final freshGoal = goalSipController.goalResponse.value?.data
    //     ?.firstWhereOrNull((g) => g.id == goal);
    // if (freshGoal != null) {
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
                                    backgroundColor: MaterialStateProperty.all(
                                      Colors.grey.shade50,
                                    ),
                                    leading: Icon(
                                      Icons.search,
                                      color: Colors.grey.shade600,
                                    ),
                                    hintText: 'Search mutual funds...',
                                    hintStyle: MaterialStateProperty.all(
                                      TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 14,
                                      ),
                                    ),
                                    onChanged: (value) => mutualController
                                        .onSearchQueryChanged(value),
                                    elevation: MaterialStateProperty.all(0),
                                    side: MaterialStateProperty.all(
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
                                      // final int? currentGoalId =
                                      //     goalSipController.savedDatabaseId.value;

                                      if (!isSelected) {
                                        // Add to Goal Cart
                                        // goalSipController.toggleFund(name);
                                        // cartController.addToCart(
                                        //   title: 'Goal',
                                        //   fund.schemeCode ?? '',
                                        //   name,
                                        //   fund.minSipAmount ?? 0,
                                        //   currentGoalId,
                                        // );
                                        goalSipController.saveFundToGoal(
                                          goalId: goal,
                                          schemeCode: schemeCodeStr,
                                          fundName: name,
                                        );
                                      } else {
                                        // Remove from Goal Cart
                                        // final cartItem = cartController
                                        //     .cartResponseEntity
                                        //     .value
                                        //     ?.items
                                        //     .firstWhereOrNull(
                                        //       (item) =>
                                        //           item.schemeCode.toString() ==
                                        //           schemeCodeStr,
                                        //     );

                                        // if (cartItem != null &&
                                        //     cartItem.id != null) {
                                        //   cartController.deleteCartItem(
                                        //     cartItem.id!,
                                        //     name,
                                        //   );
                                        //   goalSipController.toggleFund(name);
                                        // }
                                        goalSipController.toggleFund(name);
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
                                          color: Ucolors.primary.withOpacity(
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
                        color: Colors.black.withOpacity(0.05),
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
        goalSipController.selectedPopularFund.clear();
      });
    });
  }
}

class GoalDetailSection extends StatelessWidget {
  final UserGoalEntity? goal;
  final double target;
  final double invested;
  final String emoji;
  final String logo;
  const GoalDetailSection({
    super.key,
    required this.goal,
    required this.target,
    required this.invested,
    required this.emoji,
    required this.logo,
  });

  String _fmt(double amount) {
    return '₹ ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  @override
  Widget build(BuildContext context) {
    final double remaining = (target - invested).clamp(0.0, double.infinity);
    final double monthly = goal?.monthlyInvestment ?? 0.0;
    final double weekly = (monthly * 12) / 52;
    final double daily = (monthly * 12) / 365;

    // Calculate deadline year
    final currentYear = DateTime.now().year;
    final deadlineYear = currentYear + (goal?.goalTenure ?? 0) / 12;

    return SingleChildScrollView(
      child: Column(
        children: [
          Gap(15),

          CircularGoalIndicatorDetails(
            percentage: true, // Uses the large layout
            goalName: goal?.goalName ?? '',
            goalType: goal?.goalType?.typeName ?? '',
            targetAmount: target,
            investedAmount: invested,
            emoji: emoji,
            imageUrl: logo != null && logo.isNotEmpty
                ? (logo.startsWith('http')
                ? logo
                : "${Appurl.baseUrl}/$logo")
                : "",
            // If they uploaded a cover image, pass the URL here!
            // imageUrl: goal?.goalCover != null && goal!.goalCover.isNotEmpty
            //     ? "${Appurl.baseUrl}${goal!.goalCover}"
            //     : null,
          ),
          // SizedBox(
          //   height: 200, // Give it constraints
          //   child: CircularUploadIndicator(

          //     goalName: goal?.goalName ?? '',
          //     targetAmount: target,
          //     investedAmount: invested,
          //     iconEmoji: emoji,
          //   ),
          // ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SmallHeading(smallheading: 'Saving'),
                Gap(10),
                Row(
                  children: [
                    ValueTitleGoal(value: _fmt(invested), title: 'Saved'),
                    ValueTitleGoal(value: _fmt(remaining), title: 'Remaining'),
                    ValueTitleGoal(value: _fmt(target), title: 'Goal'),
                  ],
                ),
                Gap(20),
                SmallHeading(
                  smallheading: 'Deadline (Est. Year ${deadlineYear.floor()})',
                ),
                Gap(12),
                Row(
                  children: [
                    ValueTitleGoal(value: _fmt(daily), title: 'Daily Savings'),
                    ValueTitleGoal(
                      value: _fmt(weekly),
                      title: 'Weekly Savings',
                    ),
                    ValueTitleGoal(
                      value: _fmt(monthly),
                      title: 'Monthly Savings',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Gap(15),
          const Row(
            children: [SmallHeading(smallheading: 'Linked Mutual Funds')],
          ),
          const Gap(10),
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     borderRadius: BorderRadius.circular(10),
          //   ),
          //   child: Column(
          //     children: [
          //       if (goal?.goalFunds.isEmpty ?? true)
          //         const Text(
          //           'No mutual funds linked yet.',
          //           style: TextStyle(color: Colors.grey),
          //         ),
          //       // ...List.generate(
          //       //   5,
          //       //   (index) => ListTile(
          //       //     contentPadding: EdgeInsets.symmetric(vertical: 5),
          //       //     dense: true,

          //       //     leading: CircleAvatar(
          //       //       backgroundImage: AssetImage(UImages.sbi),
          //       //     ),
          //       //     title: Text(
          //       //       'Parag Parikh Flexi Cap Fund',
          //       //       style: UTextStyles.medium.copyWith(
          //       //         color: Ucolors.dark,
          //       //         fontWeight: FontWeight.w500,
          //       //       ),
          //       //     ),
          //       //     trailing: Text(
          //       //       '1,500',
          //       //       style: UTextStyles.medium.copyWith(
          //       //         color: Ucolors.dark,
          //       //         fontWeight: FontWeight.w500,
          //       //       ),
          //       //     ),
          //       //   ),
          //       // ),
          //       ...?goal?.goalFunds.map((fund) {
          //         final String imgUrl =
          //             "${Appurl.baseUrl}${fund.mutualFund?.amc?.amcLogo ?? ''}";

          //         return ListTile(
          //           contentPadding: const EdgeInsets.symmetric(vertical: 5),
          //           dense: true,
          //           leading: CircleAvatar(
          //             backgroundColor: Colors.transparent,
          //             // Ensure you have a CachedNetworkImage here in reality for remote images
          //             backgroundImage: NetworkImage(imgUrl),
          //             onBackgroundImageError: (_, __) =>
          //                 const Icon(Icons.broken_image),
          //           ),
          //           title: Text(
          //             fund.mutualFund?.schemeName ?? 'Unknown Fund',
          //             style: UTextStyles.medium.copyWith(
          //               color: Ucolors.dark,
          //               fontWeight: FontWeight.w500,
          //             ),
          //           ),
          //           trailing: Text(
          //             _fmt(fund.sipAmount),
          //             style: UTextStyles.medium.copyWith(
          //               color: Ucolors.dark,
          //               fontWeight: FontWeight.w500,
          //             ),
          //           ),
          //         );
          //       }),
          //     ],
          //   ),
          // ),
          Obx(() {
            final goalSipController = Get.find<GoalSipController>();

            final currentGoalId = goal?.id ?? 0;
            final freshGoal =
                goalSipController.goalResponse.value?.data?.firstWhereOrNull(
                  (g) => g.id == currentGoalId,
                ) ??
                goal;

            final linkedFunds = freshGoal?.goalFunds ?? [];
            final amount = freshGoal?.monthlyInvestment;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  if (linkedFunds.isEmpty)
                    const Text(
                      'No mutual funds linked yet.',
                      style: TextStyle(color: Colors.grey),
                    ),

                  ...linkedFunds.map((fund) {
                    // ... inside your linkedFunds.map((fund) { ...

                    return Obx(() {
                      final bool deleting =
                          goalSipController.isDeleting[fund.id] ?? false;
                      final String imgUrl =
                          "${Appurl.baseUrl}${fund.mutualFund?.amc?.amcLogo ?? ''}";

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 5),
                        dense: true,
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(imgUrl),
                          onBackgroundImageError: (_, __) =>
                              const Icon(Icons.broken_image),
                        ),
                        title: Text(
                          fund.mutualFund?.schemeName ?? 'Unknown Fund',
                          style: UTextStyles.medium.copyWith(
                            color: Ucolors.dark,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _fmt(fund.sipAmount),
                              style: UTextStyles.medium.copyWith(
                                color: Ucolors.dark,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // ✅ Delete Trigger
                            deleting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : IconButton(
                                    icon: const Icon(
                                      Iconsax.trash,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      // Show confirmation dialog or delete directly
                                      Get.defaultDialog(
                                        title: "Remove Fund",
                                        middleText:
                                            "Are you sure you want to remove this fund from your goal?",
                                        textConfirm: "Remove",
                                        textCancel: "Cancel",
                                        confirmTextColor: Colors.white,
                                        onConfirm: () {
                                          Get.back(); // Close dialog
                                          goalSipController.deleteGoalFund(
                                            fund.id,
                                          ); // Passing GoalFundEntity.id
                                        },
                                      );
                                    },
                                  ),
                          ],
                        ),
                      );
                    });

                    // final String imgUrl =
                    //     "${Appurl.baseUrl}${fund.mutualFund?.amc?.amcLogo ?? ''}";

                    // return ListTile(
                    //   contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    //   dense: true,
                    //   leading: CircleAvatar(
                    //     backgroundColor: Colors.transparent,
                    //     backgroundImage: NetworkImage(imgUrl),
                    //     onBackgroundImageError: (_, __) =>
                    //         const Icon(Icons.broken_image),
                    //   ),
                    //   title: Text(
                    //     fund.mutualFund?.schemeName ?? 'Unknown Fund',
                    //     style: UTextStyles.medium.copyWith(
                    //       color: Ucolors.dark,
                    //       fontWeight: FontWeight.w500,
                    //     ),
                    //   ),
                    //   trailing: Text(
                    //     // _fmt(fund.sipAmount ?? 0), // Made safe with ?? 0
                    //     _fmt(
                    //       fund.mutualFund?.minSipAmount ?? 0,
                    //     ), // Made safe with ?? 0
                    //     style: UTextStyles.medium.copyWith(
                    //       color: Ucolors.dark,
                    //       fontWeight: FontWeight.w500,
                    //     ),
                    //   ),
                    // );
                  }).toList(), // Add .toList() when spreading maps in columns
                ],
              ),
            );
          }),
          const Gap(22),
        ],
      ),
    );
  }
}

class ValueTitleGoal extends StatelessWidget {
  const ValueTitleGoal({super.key, required this.value, required this.title});
  final String value;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: UTextStyles.large.copyWith(
              color: Colors.black,
              // fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            textAlign: TextAlign.center,
            title,
            style: UTextStyles.small.copyWith(color: Ucolors.darkgrey),
          ),
        ],
      ),
    );
  }
}
class BottomBarButtonGoalDetails extends StatelessWidget {
  const BottomBarButtonGoalDetails({
    super.key,
    required this.firstButton,
    required this.secondButton,
    this.firstButtonP,
    this.secondButtonP,
    this.isLoading = false, // <--- Add this
  });

  final String firstButton;
  final String secondButton;
  final VoidCallback? firstButtonP;
  final VoidCallback? secondButtonP;
  final bool isLoading; // <--- Add this

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset),
      child: Row(
        children: [
          Expanded(
            child: UElevatedBUtton(
              onPressed: isLoading ? null : firstButtonP, // Disable if loading
              // height: 52,
              // outlined: true,
              child: Center(
                child: Text(firstButton, style:  UTextStyles.buttonText),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: UElevatedBUtton(
              onPressed: isLoading ? null : secondButtonP, // Disable if loading
              // height: 52,
              child: isLoading
                  ? const SizedBox(
                height: 10,
                width: 10,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              )
                  : Center(
                child: Text(secondButton, style: UTextStyles.buttonText),
              ),
            ),
          ),
        ],
      ),
    );
  }
}