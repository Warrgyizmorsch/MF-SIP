// ignore_for_file: unnecessary_to_list_in_spreads, invalid_null_aware_operator, unnecessary_null_comparison, unused_local_variable

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/common/widget/text/small_heading.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/dashboard/presentation/pages/dashboard.dart';
import 'package:my_sip/features/goal/presentation/controller/goal_sip_controller.dart';
import 'package:my_sip/features/goal/presentation/pages/master_goals_page.dart';
import 'package:my_sip/features/goal/presentation/pages/web_master_goals_pages.dart';
import 'package:my_sip/features/goal/presentation/widget/GoalDetailsIndicator.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../domain/entity/goal_entity.dart';

/// ----------------------------------------------------------------------
/// Main Entry Page Router
/// ----------------------------------------------------------------------
class GoalDetailsPage extends GetView<GoalSipController> {
  // Removed 'const' from the constructor to accommodate the GlobalKey initialization
  GoalDetailsPage({super.key});

  static Map<String, dynamic>? tempData;

  // Added Scaffold key to control the drawer state
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final args = (Get.arguments as Map<String, dynamic>?) ?? tempData;
    tempData = null;

    if (args == null) {
      return const Scaffold(body: Center(child: Text("Error: No data found")));
    }

    final UserGoalEntity? goal = args['goal'];
    final String emoji = args['emoji'] ?? '🎯';
    final double target = args['target'] ?? 0.0;
    final double invested = args['invested'] ?? 0.0;
    final String logo = args['logo'] ?? "";

    final String title = goal?.goalName ?? 'Goal Details';
    final int currentGoalId = goal?.id ?? 0;

    final bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final double screenWidth = MediaQuery.of(context).size.width;

    // Dynamically calculate the drawer width (same as GoalScreen)
    final double responsiveDrawerWidth = (screenWidth * 0.45).clamp(450.0, 700.0);

    void onEdit() => _showEditGoalDialog(context, currentGoalId, goal, isDesktop);
    void onDelete() => _showDeleteGoalDialog(context, currentGoalId);

    void onAddFunds() {
      if (currentGoalId != 0) {
        MasterGoalsPage.tempArgs = {
          'isAddFund': true,
          "goalId": currentGoalId,
          "goal": goal,
        };

        // Open drawer on Desktop, navigate on Mobile
        if (isDesktop) {
          WebMasterGoalsPage.tempArgs = {
            'isAddFund': true,
            "goalId": currentGoalId,
            "goal": goal,
          };
          _scaffoldKey.currentState?.openEndDrawer();
        } else {
          Get.toNamed(
            AppRoutes.masterGoalsPage,
            arguments: MasterGoalsPage.tempArgs,
          );
        }
      } else {
        Get.snackbar("Error", "Goal ID is missing.");
      }
    }

    if (isDesktop) {
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFFF5F7FA),
        endDrawer: Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
          child: Drawer(
            width: responsiveDrawerWidth,
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(28),
                    bottomLeft: Radius.circular(28),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .06),
                      blurRadius: 40,
                      offset: const Offset(-10, 0),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Web Drawer Header & Close Mechanism
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 20, 20, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Manage Goals',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: FontFamily.medium,
                              fontWeight: FontWeight.w700,
                              color: Ucolors.dark,
                            ),
                          ),
                          IconButton(
                            hoverColor: Colors.grey.shade100,
                            splashRadius: 24,
                            icon: const Icon(Icons.close_rounded, size: 24),
                            color: Colors.grey.shade700,
                            onPressed: () {
                              _scaffoldKey.currentState?.closeEndDrawer();
                            },
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 1, color: Colors.grey.shade200),

                    // Main Content
                    const Expanded(
                      child: WebMasterGoalsPage(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: GoalDetailsWebView(
          title: title,
          goal: goal,
          emoji: emoji,
          target: target,
          invested: invested,
          logo: logo,
          onEdit: onEdit,
          onDelete: onDelete,
          onAddFunds: onAddFunds,
        ),
      );
    }

    // Mobile specific view
    return GoalDetailsMobileView(
      title: title,
      goal: goal,
      emoji: emoji,
      target: target,
      invested: invested,
      logo: logo,
      onEdit: onEdit,
      onDelete: onDelete,
      onAddFunds: onAddFunds,
    );
  }

  void _showDeleteGoalDialog(BuildContext context, int currentGoalId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.delete_outline, color: Colors.red),
              SizedBox(width: 10),
              Text("Delete Goal"),
            ],
          ),
          content: const Text(
            "Are you sure you want to delete this goal?",
            style: TextStyle(fontFamily: FontFamily.medium, fontSize: 15),
          ),
          actionsPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                Get.back();
                await controller.deleteGoal(currentGoalId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void _showEditGoalDialog(BuildContext context, int currentGoalId, UserGoalEntity? goal, bool isDesktop) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.edit_outlined, color: Colors.blue),
              SizedBox(width: 10),
              Text("Edit Goal"),
            ],
          ),
          content: const Text(
            "Are you sure you want to edit this goal?",
            style: TextStyle(fontFamily: FontFamily.medium, fontSize: 15),
          ),
          actionsPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                MasterGoalsPage.tempArgs = {
                  "goalId": currentGoalId,
                  "goal": goal,
                  "isEdit": true
                };

                // Trigger drawer on Desktop or routing on Mobile
                if (isDesktop) {
                  _scaffoldKey.currentState?.openEndDrawer();
                } else {
                  Get.toNamed(
                    AppRoutes.masterGoalsPage,
                    arguments: MasterGoalsPage.tempArgs,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text("Edit"),
            ),
          ],
        );
      },
    );
  }
}

/// ----------------------------------------------------------------------
/// Web View Layout (Side-by-Side Panels, No TabBar)
/// ----------------------------------------------------------------------
/// ----------------------------------------------------------------------
/// Web View Layout (Side-by-Side Panels, No TabBar)
/// ----------------------------------------------------------------------
class GoalDetailsWebView extends StatelessWidget {
  final String title;
  final UserGoalEntity? goal;
  final String emoji;
  final double target;
  final double invested;
  final String logo;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onAddFunds;

  const GoalDetailsWebView({
    super.key,
    required this.title,
    required this.goal,
    required this.emoji,
    required this.target,
    required this.invested,
    required this.logo,
    required this.onEdit,
    required this.onDelete,
    required this.onAddFunds,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F4F6),
      appBar: CustomAppBarNormal(
        title: title,
        action: [
          SizedBox(
            width: 140,
            height: 40,
            child: UElevatedBUtton(
              onPressed: onAddFunds,
              child: const Center(
                child: Text('Add Funds', style: TextStyle(color: Colors.white, fontSize: 13)),
              ),
            ),
          ),
          const SizedBox(width: 16),
          PopupMenuButton<String>(
            color: Ucolors.light,
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'edit') onEdit();
              if (value == 'delete') onDelete();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 18),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 18, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(fontFamily: FontFamily.medium, color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: Container(
          // FIX: Use BoxConstraints instead of maxWidth directly
          constraints: const BoxConstraints(maxWidth: 1200),
          padding: const EdgeInsets.all(24.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column: Main Goal Analytics & Info
              Expanded(
                flex: 6,
                child: SingleChildScrollView(
                  child: GoalDetailSection(
                    goal: goal,
                    target: target,
                    invested: invested,
                    emoji: emoji,
                    logo: logo,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              // Right Column: Independent Transaction Records Pane
              Expanded(
                flex: 5,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.78,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: SmallHeading(smallheading: 'Records & Transactions'),
                      ),
                      const Divider(height: 1, color: Colors.black12),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: 10,
                          // Make sure TransactionCard() is imported correctly in your actual file
                          itemBuilder: (context, index) => const TransactionCard(),
                        ),
                      ),
                    ],
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
/// ----------------------------------------------------------------------
/// Mobile View Layout (Tabbed Switching Container)
/// ----------------------------------------------------------------------
class GoalDetailsMobileView extends StatelessWidget {
  final String title;
  final UserGoalEntity? goal;
  final String emoji;
  final double target;
  final double invested;
  final String logo;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onAddFunds;

  const GoalDetailsMobileView({
    super.key,
    required this.title,
    required this.goal,
    required this.emoji,
    required this.target,
    required this.invested,
    required this.logo,
    required this.onEdit,
    required this.onDelete,
    required this.onAddFunds,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F4F6),
      appBar: CustomAppBarNormal(
        title: title,
        action: [
          PopupMenuButton<String>(
            color: Ucolors.light,
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'edit') onEdit();
              if (value == 'delete') onDelete();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 18),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 18, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(fontFamily: FontFamily.medium, color: Colors.red)),
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
                    labelPadding: const EdgeInsets.symmetric(vertical: 10),
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Ucolors.primary,
                    ),
                    tabs: const [Text('Goal'), Text('Record')],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    SingleChildScrollView(
                      child: GoalDetailSection(
                        goal: goal,
                        target: target,
                        invested: invested,
                        emoji: emoji,
                        logo: logo,
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: List.generate(10, (index) => const TransactionCard()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: UElevatedBUtton(
        onPressed: onAddFunds,
        child: Center(
          child: Text(
            'Add Funds',
            style: UTextStyles.buttonText.copyWith(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
    );
  }
}

/// ----------------------------------------------------------------------
/// Core Reusable UI Sections & Custom Metric Tiles
/// ----------------------------------------------------------------------
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

    final currentYear = DateTime.now().year;
    final deadlineYear = currentYear + (goal?.goalTenure ?? 0) / 12;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(8),
        Center(
          child: CircularGoalIndicatorDetails(
            percentage: true,
            goalName: goal?.goalName ?? '',
            goalType: goal?.goalType?.typeName ?? '',
            targetAmount: target,
            investedAmount: invested,
            emoji: emoji,
            imageUrl: logo != null && logo.isNotEmpty
                ? (logo.startsWith('http') ? logo : "${Appurl.baseUrl}/$logo")
                : "",
          ),
        ),
        const Gap(8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SmallHeading(smallheading: 'Saving'),
              const Gap(10),
              Row(
                children: [
                  ValueTitleGoal(value: _fmt(invested), title: 'Saved'),
                  ValueTitleGoal(value: _fmt(remaining), title: 'Remaining'),
                  ValueTitleGoal(value: _fmt(target), title: 'Goal'),
                ],
              ),
              const Gap(20),
              SmallHeading(smallheading: 'Deadline (Est. Year ${deadlineYear.floor()})'),
              const Gap(12),
              Row(
                children: [
                  ValueTitleGoal(value: _fmt(daily), title: 'Daily Savings'),
                  ValueTitleGoal(value: _fmt(weekly), title: 'Weekly Savings'),
                  ValueTitleGoal(value: _fmt(monthly), title: 'Monthly Savings'),
                ],
              ),
            ],
          ),
        ),
        const Gap(20),
        const SmallHeading(smallheading: 'Linked Mutual Funds'),
        const Gap(10),
        Obx(() {
          final goalSipController = Get.find<GoalSipController>();
          final currentGoalId = goal?.id ?? 0;
          final freshGoal = goalSipController.goalResponse.value?.data?.firstWhereOrNull(
                (g) => g.id == currentGoalId,
          ) ?? goal;

          final linkedFunds = freshGoal?.goalFunds ?? [];

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black12),
            ),
            child: Column(
              children: [
                if (linkedFunds.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'No mutual funds linked yet.',
                      style: TextStyle(fontFamily: FontFamily.medium, color: Colors.grey),
                    ),
                  ),
                ...linkedFunds.map((fund) {
                  return Obx(() {
                    final bool deleting = goalSipController.isDeleting[fund.id] ?? false;
                    final String imgUrl = "${Appurl.baseUrl}${fund.mutualFund?.amc?.amcLogo ?? ''}";

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 5),
                      dense: true,
                      leading: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(imgUrl),
                        onBackgroundImageError: (_, __) => const Icon(Icons.broken_image),
                      ),
                      title: Text(
                        fund.mutualFund?.schemeName ?? 'Unknown Fund',
                        style: UTextStyles.medium.copyWith(color: Ucolors.dark, fontWeight: FontWeight.w500),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            freshGoal?.txnType.toLowerCase() == 'sip' ? _fmt(fund.sipAmount) : _fmt(fund.lumpsumAmount),
                            style: UTextStyles.medium.copyWith(color: Ucolors.dark, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(width: 8),
                          deleting
                              ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                              : IconButton(
                            icon: const Icon(Iconsax.trash, color: Colors.red, size: 20),
                            onPressed: () {
                              Get.defaultDialog(
                                title: "Remove Fund",
                                middleText: "Are you sure you want to remove this fund from your goal?",
                                textConfirm: "Remove",
                                textCancel: "Cancel",
                                confirmTextColor: Colors.white,
                                onConfirm: () {
                                  Get.back();
                                  goalSipController.deleteGoalFund(
                                    id: fund.id,
                                    isEdit: true,
                                    schemeName: fund.mutualFund?.schemeCode.toString() ?? '',
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  });
                }).toList(),
              ],
            ),
          );
        }),
        const Gap(22),
      ],
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
            style: UTextStyles.large.copyWith(color: Colors.black, fontWeight: FontWeight.w600),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: UTextStyles.small.copyWith(color: Ucolors.darkgrey),
          ),
        ],
      ),
    );
  }
}







// // ignore_for_file: unnecessary_to_list_in_spreads, invalid_null_aware_operator, unnecessary_null_comparison, unused_local_variable
//
// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:my_sip/common/style/padding.dart';
// import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
// import 'package:my_sip/common/widget/appbar/widget/compact_icon.dart';
// import 'package:my_sip/common/widget/button/elevated_button.dart';
// import 'package:my_sip/common/widget/text/small_heading.dart';
// import 'package:my_sip/config/routes/app_routes.dart';
// import 'package:my_sip/core/utils/constant/appUrl.dart';
// import 'package:my_sip/core/utils/constant/colors.dart';
// import 'package:my_sip/core/utils/constant/text_style.dart';
// import 'package:my_sip/features/cart/presentation/controllers/cart_controller.dart';
// import 'package:my_sip/features/dashboard/presentation/pages/dashboard.dart';
// import 'package:my_sip/features/explore/presentation/controller/fundhouse_controller.dart';
// import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';
// import 'package:my_sip/features/explore/presentation/pages/explore.dart';
// import 'package:my_sip/features/goal/presentation/controller/goal_sip_controller.dart';
// import 'package:my_sip/features/goal/presentation/pages/master_goals_page.dart';
// import 'package:my_sip/features/goal/presentation/widget/GoalDetailsIndicator.dart';
// import 'package:responsive_framework/responsive_framework.dart';
//
// import '../../domain/entity/goal_entity.dart';
//
// class GoalDetailsPage extends GetView<GoalSipController> {
//   const GoalDetailsPage({super.key});
//
//   static Map<String, dynamic>? tempData;
//
//   @override
//   Widget build(BuildContext context) {
//     // final args = Get.arguments as Map<String, dynamic>? ?? {};
//     final args = (Get.arguments as Map<String, dynamic>?) ?? tempData;
//     tempData = null;
//     if (args == null) {
//       return Scaffold(body: Center(child: Text("Error: No data found")));
//     }
//     final UserGoalEntity? goal = args['goal'];
//     final String emoji = args['emoji'] ?? '🎯';
//     final double target = args['target'] ?? 0.0;
//     final double invested = args['invested'] ?? 0.0;
//     final String logo = args['logo'] ?? "";
//
//     final String title = goal?.goalName ?? 'Goal Details';
//     final int currentGoalId = goal?.id ?? 0;
//
//     final bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
//
//     return Scaffold(
//       backgroundColor: Color(0xffF3F4F6),
//
//       appBar: CustomAppBarNormal(
//         title: title,
//         action: [
//           PopupMenuButton<String>(
//             color: Ucolors.light,
//
//             icon: const Icon(Icons.more_vert),
//
//             onSelected: (value) {
//               if (value == 'edit') {
//                 showEditGoalDialog(
//                   context: context,
//                   currentGoalId: currentGoalId,
//                   goal: goal,
//                 );
//                 // edit
//               } else if (value == 'delete') {
//                 showDeleteGoalDialog(
//                   context: context,
//                   currentGoalId: currentGoalId,
//                 );
//               }
//             },
//
//             itemBuilder: (context) => [
//               PopupMenuItem(
//                 value: 'edit',
//
//                 child: const Row(
//                   children: [
//                     Icon(Icons.edit, size: 18),
//                     SizedBox(width: 8),
//                     Text('Edit'),
//                   ],
//                 ),
//               ),
//
//               PopupMenuItem(
//                 value: 'delete',
//
//                 child: const Row(
//                   children: [
//                     Icon(Icons.delete, size: 18, color: Colors.red),
//                     SizedBox(width: 8),
//                     Text(
//                       'Delete',
//                       style: TextStyle(
//                         fontFamily: FontFamily.medium,
//                         color: Colors.red,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: UPadding.screenPadding,
//         child: DefaultTabController(
//           length: 2,
//           child: Column(
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(15),
//                   color: Colors.white,
//                   border: Border.all(color: Colors.black12),
//                 ),
//
//                 child: Tab(
//                   child: TabBar(
//                     indicatorSize: TabBarIndicatorSize.tab,
//
//                     unselectedLabelColor: Colors.grey.shade700,
//                     dividerColor: Colors.transparent,
//                     labelColor: Ucolors.light,
//                     indicatorColor: Colors.transparent,
//                     labelPadding: EdgeInsets.symmetric(vertical: 10),
//
//                     indicator: BoxDecoration(
//                       borderRadius: BorderRadius.circular(15),
//
//                       color: Ucolors.primary,
//                     ),
//
//                     tabs: [Text('Goal'), Text('Record')],
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: TabBarView(
//                   children: [
//                     GoalDetailSection(
//                       goal: goal,
//                       target: target,
//                       invested: invested,
//                       emoji: emoji,
//                       logo: logo,
//                     ),
//                     SingleChildScrollView(
//                       child: Column(
//                         children: [
//                           ...List.generate(10, (index) => TransactionCard()),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: UElevatedBUtton(
//         onPressed: () {
//           if (currentGoalId != 0) {
//             MasterGoalsPage.tempArgs = {
//               'isAddFund': true,
//               "goalId": currentGoalId,
//               "goal": goal,
//             };
//             Get.toNamed(
//               AppRoutes.masterGoalsPage,
//               // arguments: {
//               //   'isAddFund': true,
//               //   "goalId": currentGoalId,
//               //   "goal": goal,
//               // },
//               arguments: MasterGoalsPage.tempArgs,
//               id: isDesktop ? 1 : null,
//             );
//           } else {
//             Get.snackbar("Error", "Goal ID is missing.");
//           }
//         },
//         child: Center(
//           child: Text(
//             'Add Funds',
//             style: UTextStyles.buttonText.copyWith(
//               color: Colors.white,
//               fontSize: 14,
//             ),
//           ),
//         ),
//       ),
//       // bottomNavigationBar: BottomBarButtonGoalDetails(
//       //   firstButtonP: () {},
//       //   firstButton: 'Add To Cart',
//       //   secondButton: 'Add Funds',
//       //   secondButtonP: () {
//       //     // _showExploreMoreBottomSheet(context);
//       //     if (currentGoalId != 0) {
//       //       Get.toNamed(
//       //         AppRoutes.masterGoalsPage,
//       //         arguments: {'goalType': 'car','isAddFund':true,"goalId":currentGoalId, "goal":goal,},
//       //       );
//       //       // _showExploreMoreBottomSheet(context, currentGoalId);
//       //     } else {
//       //       Get.snackbar("Error", "Goal ID is missing.");
//       //     }
//       //   },
//       // ),
//     );
//   }
//
//   void showDeleteGoalDialog({
//     required BuildContext context,
//     required currentGoalId,
//   }) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           title: const Row(
//             children: [
//               Icon(Icons.delete_outline, color: Colors.red),
//               SizedBox(width: 10),
//               Text("Delete Goal"),
//             ],
//           ),
//
//           content: const Text(
//             "Are you sure you want to delete this goal?",
//             style: TextStyle(fontFamily: FontFamily.medium, fontSize: 15),
//           ),
//
//           actionsPadding: const EdgeInsets.only(
//             left: 16,
//             right: 16,
//             bottom: 16,
//           ),
//
//           actions: [
//             OutlinedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//
//               style: OutlinedButton.styleFrom(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 20,
//                   vertical: 12,
//                 ),
//               ),
//
//               child: const Text("Cancel"),
//             ),
//
//             ElevatedButton(
//               onPressed: () async {
//                 Get.back();
//                 await controller.deleteGoal(currentGoalId);
//               },
//
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 foregroundColor: Colors.white,
//
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 20,
//                   vertical: 12,
//                 ),
//               ),
//
//               child: const Text("Delete"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void showEditGoalDialog({
//     required BuildContext context,
//     required int currentGoalId,
//     required UserGoalEntity? goal,
//   }) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//
//           title: const Row(
//             children: [
//               Icon(Icons.edit_outlined, color: Colors.blue),
//               SizedBox(width: 10),
//               Text("Edit Goal"),
//             ],
//           ),
//
//           content: const Text(
//             "Are you sure you want to edit this goal?",
//             style: TextStyle(fontFamily: FontFamily.medium, fontSize: 15),
//           ),
//
//           actionsPadding: const EdgeInsets.only(
//             left: 16,
//             right: 16,
//             bottom: 16,
//           ),
//
//           actions: [
//             OutlinedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//
//               style: OutlinedButton.styleFrom(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 20,
//                   vertical: 12,
//                 ),
//               ),
//
//               child: const Text("Cancel"),
//             ),
//
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//
//                 // OPEN EDIT SCREEN
//                 Get.toNamed(
//                   AppRoutes.masterGoalsPage,
//                   arguments: {
//                     "goalId": currentGoalId,
//                     "goal": goal,
//                     "isEdit": true,
//                   },
//                 );
//               },
//
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 foregroundColor: Colors.white,
//
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 20,
//                   vertical: 12,
//                 ),
//               ),
//
//               child: const Text("Edit"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _showExploreMoreBottomSheet(BuildContext context, int goal) {
//     final mutualController = Get.find<MutualFundController>();
//     final goalSipController = Get.find<GoalSipController>();
//     final cartController = Get.find<CartController>();
//     final FocusNode searchFocus = FocusNode();
//     goalSipController.selectedPopularFund.clear();
//
//     // final freshGoal = goalSipController.goalResponse.value?.data
//     //     ?.firstWhereOrNull((g) => g.id == goal);
//     // if (freshGoal != null) {
//     //   for (var fund in freshGoal.goalFunds) {
//     //     final name = fund.mutualFund?.schemeName;
//     //     if (name != null) {
//     //       goalSipController.selectedPopularFund.add(name);
//     //     }
//     //   }
//     // }
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
//                               fontFamily: FontFamily.medium,
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
//                               fontFamily: FontFamily.medium,
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
//                           child: Obx(() {
//                             final bool isSearching =
//                                 mutualController.hasSearchFocus.value;
//                             return Row(
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
//                                     backgroundColor: WidgetStateProperty.all(
//                                       Colors.grey.shade50,
//                                     ),
//                                     leading: Icon(
//                                       Icons.search,
//                                       color: Colors.grey.shade600,
//                                     ),
//                                     hintText: 'Search mutual funds...',
//                                     hintStyle: WidgetStateProperty.all(
//                                       TextStyle(
//                                         fontFamily: FontFamily.medium,
//                                         color: Colors.grey.shade500,
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                     onChanged: (value) => mutualController
//                                         .onSearchQueryChanged(value),
//                                     elevation: WidgetStateProperty.all(0),
//                                     side: WidgetStateProperty.all(
//                                       BorderSide(color: Colors.grey.shade200),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             );
//                           }),
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
//                           style: TextStyle(
//                             fontFamily: FontFamily.medium,
//                             color: Colors.grey.shade600,
//                           ),
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
//                             mutualController.searchFund.length +
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
//                                         false, //  3. Hides trailing returns
//                                     // 4. Replaced generic toggle with Cart + Goal logic
//                                     onTapOverride: () {
//                                       FocusScope.of(context).unfocus();
//                                       // final int? currentGoalId =
//                                       //     goalSipController.savedDatabaseId.value;
//
//                                       if (!isSelected) {
//                                         goalSipController.saveFundToGoal(
//                                           goalId: goal,
//                                           schemeCode: schemeCodeStr,
//                                           fundName: name,
//                                         );
//                                       } else {
//                                         goalSipController.deleteGoalFund(
//                                           id: goal,
//                                           isEdit: true,
//                                           schemeName:
//                                               fund.schemeCode?.toString() ?? '',
//                                         );
//                                         goalSipController.toggleFund(name);
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
//                                           color: Ucolors.primary.withValues(
//                                             alpha: 0.05,
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
//                         color: Colors.black.withValues(alpha: 0.05),
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
//         goalSipController.selectedPopularFund.clear();
//       });
//     });
//   }
// }
//
// class GoalDetailSection extends StatelessWidget {
//   final UserGoalEntity? goal;
//   final double target;
//   final double invested;
//   final String emoji;
//   final String logo;
//   const GoalDetailSection({
//     super.key,
//     required this.goal,
//     required this.target,
//     required this.invested,
//     required this.emoji,
//     required this.logo,
//   });
//
//   String _fmt(double amount) {
//     return '₹ ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final double remaining = (target - invested).clamp(0.0, double.infinity);
//     final double monthly = goal?.monthlyInvestment ?? 0.0;
//     final double weekly = (monthly * 12) / 52;
//     final double daily = (monthly * 12) / 365;
//
//     // Calculate deadline year
//     final currentYear = DateTime.now().year;
//     final deadlineYear = currentYear + (goal?.goalTenure ?? 0) / 12;
//
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           Gap(15),
//
//           CircularGoalIndicatorDetails(
//             percentage: true, // Uses the large layout
//             goalName: goal?.goalName ?? '',
//             goalType: goal?.goalType?.typeName ?? '',
//             targetAmount: target,
//             investedAmount: invested,
//             emoji: emoji,
//             imageUrl: logo != null && logo.isNotEmpty
//                 ? (logo.startsWith('http') ? logo : "${Appurl.baseUrl}/$logo")
//                 : "",
//             // If they uploaded a cover image, pass the URL here!
//             // imageUrl: goal?.goalCover != null && goal!.goalCover.isNotEmpty
//             //     ? "${Appurl.baseUrl}${goal!.goalCover}"
//             //     : null,
//           ),
//           // SizedBox(
//           //   height: 200, // Give it constraints
//           //   child: CircularUploadIndicator(
//
//           //     goalName: goal?.goalName ?? '',
//           //     targetAmount: target,
//           //     investedAmount: invested,
//           //     iconEmoji: emoji,
//           //   ),
//           // ),
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SmallHeading(smallheading: 'Saving'),
//                 Gap(10),
//                 Row(
//                   children: [
//                     ValueTitleGoal(value: _fmt(invested), title: 'Saved'),
//                     ValueTitleGoal(value: _fmt(remaining), title: 'Remaining'),
//                     ValueTitleGoal(value: _fmt(target), title: 'Goal'),
//                   ],
//                 ),
//                 Gap(20),
//                 SmallHeading(
//                   smallheading: 'Deadline (Est. Year ${deadlineYear.floor()})',
//                 ),
//                 Gap(12),
//                 Row(
//                   children: [
//                     ValueTitleGoal(value: _fmt(daily), title: 'Daily Savings'),
//                     ValueTitleGoal(
//                       value: _fmt(weekly),
//                       title: 'Weekly Savings',
//                     ),
//                     ValueTitleGoal(
//                       value: _fmt(monthly),
//                       title: 'Monthly Savings',
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const Gap(15),
//           const Row(
//             children: [SmallHeading(smallheading: 'Linked Mutual Funds')],
//           ),
//           const Gap(10),
//           // Container(
//           //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//           //   decoration: BoxDecoration(
//           //     color: Colors.white,
//           //     borderRadius: BorderRadius.circular(10),
//           //   ),
//           //   child: Column(
//           //     children: [
//           //       if (goal?.goalFunds.isEmpty ?? true)
//           //         const Text(
//           //           'No mutual funds linked yet.',
//           //           style: TextStyle(fontFamily: FontFamily.medium,color: Colors.grey),
//           //         ),
//           //       // ...List.generate(
//           //       //   5,
//           //       //   (index) => ListTile(
//           //       //     contentPadding: EdgeInsets.symmetric(vertical: 5),
//           //       //     dense: true,
//
//           //       //     leading: CircleAvatar(
//           //       //       backgroundImage: AssetImage(UImages.sbi),
//           //       //     ),
//           //       //     title: Text(
//           //       //       'Parag Parikh Flexi Cap Fund',
//           //       //       style: UTextStyles.medium.copyWith(
//           //       //         color: Ucolors.dark,
//           //       //         fontWeight: FontWeight.w500,
//           //       //       ),
//           //       //     ),
//           //       //     trailing: Text(
//           //       //       '1,500',
//           //       //       style: UTextStyles.medium.copyWith(
//           //       //         color: Ucolors.dark,
//           //       //         fontWeight: FontWeight.w500,
//           //       //       ),
//           //       //     ),
//           //       //   ),
//           //       // ),
//           //       ...?goal?.goalFunds.map((fund) {
//           //         final String imgUrl =
//           //             "${Appurl.baseUrl}${fund.mutualFund?.amc?.amcLogo ?? ''}";
//
//           //         return ListTile(
//           //           contentPadding: const EdgeInsets.symmetric(vertical: 5),
//           //           dense: true,
//           //           leading: CircleAvatar(
//           //             backgroundColor: Colors.transparent,
//           //             // Ensure you have a CachedNetworkImage here in reality for remote images
//           //             backgroundImage: NetworkImage(imgUrl),
//           //             onBackgroundImageError: (_, __) =>
//           //                 const Icon(Icons.broken_image),
//           //           ),
//           //           title: Text(
//           //             fund.mutualFund?.schemeName ?? 'Unknown Fund',
//           //             style: UTextStyles.medium.copyWith(
//           //               color: Ucolors.dark,
//           //               fontWeight: FontWeight.w500,
//           //             ),
//           //           ),
//           //           trailing: Text(
//           //             _fmt(fund.sipAmount),
//           //             style: UTextStyles.medium.copyWith(
//           //               color: Ucolors.dark,
//           //               fontWeight: FontWeight.w500,
//           //             ),
//           //           ),
//           //         );
//           //       }),
//           //     ],
//           //   ),
//           // ),
//           Obx(() {
//             final goalSipController = Get.find<GoalSipController>();
//
//             final currentGoalId = goal?.id ?? 0;
//             final freshGoal =
//                 goalSipController.goalResponse.value?.data?.firstWhereOrNull(
//                   (g) => g.id == currentGoalId,
//                 ) ??
//                 goal;
//
//             final linkedFunds = freshGoal?.goalFunds ?? [];
//             final amount = freshGoal?.monthlyInvestment;
//
//             return Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Column(
//                 children: [
//                   if (linkedFunds.isEmpty)
//                     const Text(
//                       'No mutual funds linked yet.',
//                       style: TextStyle(
//                         fontFamily: FontFamily.medium,
//                         color: Colors.grey,
//                       ),
//                     ),
//
//                   ...linkedFunds.map((fund) {
//                     // ... inside your linkedFunds.map((fund) { ...
//
//                     return Obx(() {
//                       final bool deleting =
//                           goalSipController.isDeleting[fund.id] ?? false;
//                       final String imgUrl =
//                           "${Appurl.baseUrl}${fund.mutualFund?.amc?.amcLogo ?? ''}";
//
//                       return ListTile(
//                         contentPadding: const EdgeInsets.symmetric(vertical: 5),
//                         dense: true,
//                         leading: CircleAvatar(
//                           backgroundColor: Colors.transparent,
//                           backgroundImage: NetworkImage(imgUrl),
//                           onBackgroundImageError: (_, __) =>
//                               const Icon(Icons.broken_image),
//                         ),
//                         title: Text(
//                           fund.mutualFund?.schemeName ?? 'Unknown Fund',
//                           style: UTextStyles.medium.copyWith(
//                             color: Ucolors.dark,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         trailing: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text(
//                               freshGoal?.txnType.toLowerCase() == 'sip'
//                                   ? _fmt(fund.sipAmount)
//                                   : _fmt(fund.lumpsumAmount),
//                               style: UTextStyles.medium.copyWith(
//                                 color: Ucolors.dark,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             const SizedBox(width: 8),
//                             // ✅ Delete Trigger
//                             deleting
//                                 ? const SizedBox(
//                                     width: 20,
//                                     height: 20,
//                                     child: CircularProgressIndicator(
//                                       strokeWidth: 2,
//                                     ),
//                                   )
//                                 : IconButton(
//                                     icon: const Icon(
//                                       Iconsax.trash,
//                                       color: Colors.red,
//                                       size: 20,
//                                     ),
//                                     onPressed: () {
//                                       // Show confirmation dialog or delete directly
//                                       Get.defaultDialog(
//                                         title: "Remove Fund",
//                                         middleText:
//                                             "Are you sure you want to remove this fund from your goal?",
//                                         textConfirm: "Remove",
//                                         textCancel: "Cancel",
//                                         confirmTextColor: Colors.white,
//                                         onConfirm: () {
//                                           Get.back();
//                                           goalSipController.deleteGoalFund(
//                                             id: fund.id,
//                                             isEdit: true,
//                                             schemeName:
//                                                 fund.mutualFund?.schemeCode
//                                                     .toString() ??
//                                                 '',
//                                           ); // Passing GoalFundEntity.id
//                                         },
//                                       );
//                                     },
//                                   ),
//                           ],
//                         ),
//                       );
//                     });
//
//                     // final String imgUrl =
//                     //     "${Appurl.baseUrl}${fund.mutualFund?.amc?.amcLogo ?? ''}";
//
//                     // return ListTile(
//                     //   contentPadding: const EdgeInsets.symmetric(vertical: 5),
//                     //   dense: true,
//                     //   leading: CircleAvatar(
//                     //     backgroundColor: Colors.transparent,
//                     //     backgroundImage: NetworkImage(imgUrl),
//                     //     onBackgroundImageError: (_, __) =>
//                     //         const Icon(Icons.broken_image),
//                     //   ),
//                     //   title: Text(
//                     //     fund.mutualFund?.schemeName ?? 'Unknown Fund',
//                     //     style: UTextStyles.medium.copyWith(
//                     //       color: Ucolors.dark,
//                     //       fontWeight: FontWeight.w500,
//                     //     ),
//                     //   ),
//                     //   trailing: Text(
//                     //     // _fmt(fund.sipAmount ?? 0), // Made safe with ?? 0
//                     //     _fmt(
//                     //       fund.mutualFund?.minSipAmount ?? 0,
//                     //     ), // Made safe with ?? 0
//                     //     style: UTextStyles.medium.copyWith(
//                     //       color: Ucolors.dark,
//                     //       fontWeight: FontWeight.w500,
//                     //     ),
//                     //   ),
//                     // );
//                   }).toList(), // Add .toList() when spreading maps in columns
//                 ],
//               ),
//             );
//           }),
//           const Gap(22),
//         ],
//       ),
//     );
//   }
// }
//
// class ValueTitleGoal extends StatelessWidget {
//   const ValueTitleGoal({super.key, required this.value, required this.title});
//   final String value;
//   final String title;
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Column(
//         children: [
//           Text(
//             value,
//             style: UTextStyles.large.copyWith(
//               color: Colors.black,
//               // fontSize: 16,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           Text(
//             textAlign: TextAlign.center,
//             title,
//             style: UTextStyles.small.copyWith(color: Ucolors.darkgrey),
//           ),
//         ],
//       ),
//     );
//   }
// }
