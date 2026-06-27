// ignore_for_file: unnecessary_to_list_in_spreads, invalid_null_aware_operator, unnecessary_null_comparison, unused_local_variable

import 'dart:math' as math;

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
  const GoalDetailsPage({super.key});

  static Map<String, dynamic>? tempData;

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
    final String logo = goal?.goalType?.logo ?? "";
    debugPrint("logo$logo");

    final String title = goal?.goalName ?? 'Goal Details';
    final int currentGoalId = goal?.id ?? 0;

    final bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    void onEdit() =>
        _showEditGoalDialog(context, currentGoalId, goal, isDesktop);
    void onDelete() => _showDeleteGoalDialog(context, currentGoalId);

    void onAddFunds() {
      if (currentGoalId != 0) {
        final payload = {
          'isAddFund': true,
          'goalId': currentGoalId,
          'goal': goal,
          'goalType': goal?.goalType ?? 'custom',
        };

        MasterGoalsPage.tempArgs = payload;

        if (isDesktop) {
          WebMasterGoalsPage.tempArgs = payload;
          controller.isAddFund.value = true;
          controller.loadGoalForAddFund(goal);
          Get.toNamed(AppRoutes.webMasterGoalsPage, id: 1, arguments: payload);
        } else {
          controller.isAddFund.value = true;
          controller.loadGoalForAddFund(goal);
          Get.toNamed(AppRoutes.masterGoalsPage, arguments: payload);
        }
      } else {
        Get.snackbar("Error", "Goal ID is missing.");
      }
    }

    if (isDesktop) {
      return Scaffold(
        backgroundColor: Ucolors.white,
        body: GoalDetailsWebView(
          title: title,
          goal: goal,
          emoji: logo,
          target: target,
          invested: invested,
          logo: logo,
          onEdit: onEdit,
          onDelete: onDelete,
          onAddFunds: onAddFunds,
          controller: controller,
        ),
      );
    }

    return GoalDetailsMobileView(
      title: title,
      goal: goal,
      emoji: logo,
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
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
          actionsPadding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16,
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
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
                Get.back();
                await controller.deleteGoal(currentGoalId);
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

  void _showEditGoalDialog(
    BuildContext context,
    int currentGoalId,
    UserGoalEntity? goal,
    bool isDesktop,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
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
          actionsPadding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16,
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
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
                MasterGoalsPage.tempArgs = {
                  "goalId": currentGoalId,
                  "goal": goal,
                  "isEdit": true,
                };

                if (isDesktop) {
                  Get.toNamed(AppRoutes.webMasterGoalsPage, id: 1);
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
}

/// ----------------------------------------------------------------------
/// Web Custom Reusable App Bar Component
/// ----------------------------------------------------------------------
class WebCustomAppBarNormal extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final String emoji;
  final VoidCallback onAddFunds;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const WebCustomAppBarNormal({
    super.key,
    required this.title,
    required this.emoji,
    required this.onAddFunds,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 14,
                  color: Color(0xFF64748B),
                ),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFF8FAFC),
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                  padding: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              const Gap(12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                  fontFamily: FontFamily.regular,
                ),
              ),
              const Gap(12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  "On Track",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF15803D),
                    fontFamily: FontFamily.regular,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: onAddFunds,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Ucolors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Add Funds",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    fontFamily: FontFamily.regular,
                  ),
                ),
              ),
              const Gap(12),
              PopupMenuButton<String>(
                color: Colors.white,
                icon: const Icon(Icons.more_vert, color: Color(0xFF64748B)),
                onSelected: (value) {
                  if (value == 'edit') onEdit();
                  if (value == 'delete') onDelete();
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Edit',
                          style: TextStyle(fontFamily: FontFamily.regular),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 18, color: Colors.red),
                        SizedBox(width: 8),
                        Text(
                          'Delete',
                          style: TextStyle(
                            color: Colors.red,
                            fontFamily: FontFamily.regular,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(115);
}

/// ----------------------------------------------------------------------
/// Web View Layout Core Configuration
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
  final GoalSipController controller;

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
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Ucolors.white,
      appBar: WebCustomAppBarNormal(
        title: title,
        emoji: emoji,
        onAddFunds: onAddFunds,
        onEdit: onEdit,
        onDelete: onDelete,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Main Column Workspace Grid Pane
                    Expanded(
                      flex: 7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GoalOverviewCard(
                            goal: goal,
                            target: target,
                            invested: invested,
                            emoji: emoji,
                            logo: logo,
                            controller: controller,
                          ),
                          const Gap(24),
                          LinkedFundsCard(goal: goal),
                        ],
                      ),
                    ),
                    const Gap(24),

                    // Right Summary Analytics Column Panel
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          const RecentContributionsCard(),
                          const Gap(24),
                          NextMilestoneCard(invested: invested, target: target),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ----------------------------------------------------------------------
/// Redesigned Goal Overview UI Block Widget (Grid Approach to Prevent Overflow)
/// ----------------------------------------------------------------------
class GoalOverviewCard extends StatelessWidget {
  final UserGoalEntity? goal;
  final double target;
  final double invested;
  final String emoji;
  final String logo;
  final GoalSipController controller;

  const GoalOverviewCard({
    super.key,
    required this.goal,
    required this.target,
    required this.invested,
    required this.emoji,
    required this.logo,
    required this.controller,
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

    final double safeTarget = target > 0 ? target : 1;
    final double percentage = (invested / safeTarget).clamp(0.0, 1.0);
    final String percentStr = "${(percentage * 100).toStringAsFixed(0)}%";
    final Color progressColor = controller.getGoalColor(
      goal?.goalType?.typeName ?? '',
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header Title
          const Text(
            "Goal Overview",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
              fontFamily: FontFamily.regular,
            ),
          ),
          const SizedBox(height: 24),

          // 2. Main Dashboard Panel Split
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0.0, end: percentage),
                          duration: const Duration(milliseconds: 1200),
                          curve: Curves.fastOutSlowIn,
                          builder: (context, animatedPercentage, child) {
                            return Transform.rotate(
                              angle: -math.pi * 0.75,
                              child: SizedBox(
                                width: 120,
                                height: 120,
                                child: CircularProgressIndicator(
                                  value: animatedPercentage,
                                  strokeWidth: 8,
                                  backgroundColor: const Color(0xFFEAEAEA),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    progressColor,
                                  ),
                                  strokeCap: StrokeCap.round,
                                ),
                              ),
                            );
                          },
                        ),

                        Positioned(
                          top: 35,
                          child: Container(
                            width: 55,
                            height: 55,
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(blurRadius: 8, color: Colors.black12),
                              ],
                            ),
                            child: logo.isNotEmpty
                                ? Image.network(
                                    logo.startsWith('http')
                                        ? logo
                                        : '${Appurl.baseUrl}/$logo',
                                    width: 40,
                                    height: 40,
                                    color: progressColor,
                                    colorBlendMode: BlendMode.srcIn,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) => Icon(
                                      Icons.flag,
                                      color: progressColor,
                                      size: 26,
                                    ),
                                  )
                                : Icon(
                                    Icons.flag,
                                    color: progressColor,
                                    size: 26,
                                  ),
                          ),
                        ),
                      ],
                    ),

                    // 3. Bottom Label Text System
                    Transform.translate(
                      offset: const Offset(0, -18),
                      child: Container(
                        color: Ucolors.white,
                        padding: const EdgeInsets.all(4),
                        child: Column(
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${(percentage * 100).round()}',
                                    style: TextStyle(
                                      color: progressColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: FontFamily.regular,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '%',
                                    style: TextStyle(
                                      color: progressColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: FontFamily.regular,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'of goal achieved',
                              style: TextStyle(
                                color: Color(0xFF666666),
                                fontSize: 8,
                                fontWeight: FontWeight.w500,
                                fontFamily: FontFamily.regular,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),

              // --- RIGHT: Grid Layout Box Panel (Zero Overflow Matrix) ---
              Expanded(
                flex: 7,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFF1F5F9)),
                  ),
                  child: GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.6,
                    children: [
                      _buildGridTile(
                        Iconsax.empty_wallet,
                        "Saved",
                        _fmt(invested),
                        hasRightBorder: true,
                        hasBottomBorder: true,
                      ),
                      _buildGridTile(
                        Iconsax.refresh_2,
                        "Remaining",
                        _fmt(remaining),
                        hasRightBorder: true,
                        hasBottomBorder: true,
                      ),
                      _buildGridTile(
                        Iconsax.radar,
                        "Target",
                        _fmt(target),
                        hasBottomBorder: true,
                      ),
                      _buildGridTile(
                        Iconsax.calendar_1,
                        "Deadline",
                        "Est. Year ${deadlineYear.floor()}",
                        hasRightBorder: true,
                        hasBottomBorder: true,
                      ),
                      _buildGridTile(
                        Iconsax.coin,
                        "Daily Savings",
                        _fmt(daily),
                        hasRightBorder: true,
                        hasBottomBorder: true,
                      ),
                      _buildGridTile(
                        Iconsax.wallet_3,
                        "Weekly Savings",
                        _fmt(weekly),
                        hasBottomBorder: true,
                      ),
                      const SizedBox.shrink(),
                      _buildGridTile(
                        Iconsax.card_send,
                        "Monthly Savings",
                        _fmt(monthly),
                        hasLeftBorder: true,
                        hasRightBorder: true,
                      ),
                      const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 3. Bottom Status Analytics Banner Track
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F7FC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Iconsax.trend_up,
                    color: Color(0xFF0066FF),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF1E293B),
                            fontFamily: FontFamily.regular,
                          ),
                          children: [
                            const TextSpan(
                              text: "You are ",
                              style: TextStyle(fontFamily: FontFamily.regular),
                            ),
                            const TextSpan(
                              text: "on track ",
                              style: TextStyle(
                                color: Color(0xFF0066FF),
                                fontWeight: FontWeight.w600,
                                fontFamily: FontFamily.regular,
                              ),
                            ),
                            TextSpan(
                              text:
                                  "to reach your goal by ${deadlineYear.floor()}",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: percentage,
                          minHeight: 8,
                          backgroundColor: Ucolors.white,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            progressColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  percentStr,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: FontFamily.regular,
                    color: progressColor,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridTile(
    IconData icon,
    String label,
    String value, {
    bool hasLeftBorder = false,
    bool hasRightBorder = false,
    bool hasBottomBorder = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: hasLeftBorder
              ? const BorderSide(color: Color(0xFFF1F5F9))
              : BorderSide.none,
          right: hasRightBorder
              ? const BorderSide(color: Color(0xFFF1F5F9))
              : BorderSide.none,
          bottom: hasBottomBorder
              ? const BorderSide(color: Color(0xFFF1F5F9))
              : BorderSide.none,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: const Color(0xFF0066FF)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                    fontFamily: FontFamily.regular,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              fontFamily: FontFamily.regular,
              color: Color(0xFF1E293B),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// ----------------------------------------------------------------------
/// Redesigned Linked Mutual Funds Grid Widget Blocks
/// ----------------------------------------------------------------------
class LinkedFundsCard extends StatelessWidget {
  final UserGoalEntity? goal;
  const LinkedFundsCard({super.key, this.goal});

  @override
  Widget build(BuildContext context) {
    final goalSipController = Get.find<GoalSipController>();
    final currentGoalId = goal?.id ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Linked Mutual Funds",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: FontFamily.regular,
                  color: Color(0xFF1E293B),
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: const Text(
                  "View All",
                  style: TextStyle(
                    color: Color(0xFF0066FF),
                    fontWeight: FontWeight.w600,
                    fontFamily: FontFamily.regular,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Grid View Block
          Obx(() {
            final freshGoal =
                goalSipController.goalResponse.value?.data?.firstWhereOrNull(
                  (g) => g.id == currentGoalId,
                ) ??
                goal;

            final linkedFunds = freshGoal?.goalFunds ?? [];

            if (linkedFunds.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 32.0),
                  child: Text(
                    'No mutual funds linked yet.',
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontWeight: FontWeight.w600,
                      fontFamily: FontFamily.regular,
                    ),
                  ),
                ),
              );
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: linkedFunds.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio:
                    1.60, // Adjusted to match vertical spacing distribution safely
              ),
              itemBuilder: (context, index) {
                final fund = linkedFunds[index];
                final String imgUrl =
                    "${Appurl.baseUrl}${fund.mutualFund?.amc?.amcLogo ?? ''}";
                final String displayAmount =
                    freshGoal?.txnType.toLowerCase() == 'sip'
                    ? '₹ ${fund.sipAmount.toStringAsFixed(0)} / month'
                    : '₹ ${fund.lumpsumAmount.toStringAsFixed(0)}';

                // Percentage dummy mock distribution matching image specs (40%, 33%, 27%)
                final mockPercentages = ["40%", "33%", "27%"];
                final String currentWeight = index < mockPercentages.length
                    ? mockPercentages[index]
                    : "0%";

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFF1F5F9)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Half Content Area
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFF1F5F9),
                                ),
                                color: Colors.white,
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.network(
                                imgUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.broken_image,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    fund.mutualFund?.schemeName ??
                                        'Unknown Fund',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: FontFamily.regular,
                                      fontSize: 14,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    fund.mutualFund?.schemeCategory ?? "",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF64748B),
                                      fontWeight: FontWeight.w500,
                                      fontFamily: FontFamily.regular,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Soft blue background badge capsule
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8F0FE),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      goal?.txnType ?? "",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF1A73E8),
                                        fontWeight: FontWeight.w600,
                                        fontFamily: FontFamily.regular,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),

                      // Bottom Split Strip Area (Matches image_8a4862.png design structure)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              goal?.txnType.toLowerCase() == 'sip'
                                  ? '₹${fund.sipAmount} / month'
                                  : '₹${fund.lumpsumAmount ?? 0.0}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF334155),
                                fontFamily: FontFamily.regular,
                              ),
                            ),
                            Text(
                              "${
                                fund.mutualFund?.mfPerformanceScheme
                                    ?.oneMonth ?? ""
                              }%",
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                fontFamily: FontFamily.regular,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
          const SizedBox(height: 24),

          // Bottom Dotted/Dashed Link Fund Panel Container Block
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              // Simulating realistic smooth dashed tracking footprint
              border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Plus Circle Icon Setup matches reference blueprint
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF0066FF),
                          style: BorderStyle.solid,
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Color(0xFF0066FF),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      "Add more mutual funds to diversify your goal",
                      style: TextStyle(
                        color: Color(0xFF475569),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: FontFamily.regular,
                      ),
                    ),
                  ],
                ),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color(0xFF0066FF),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                  child: const Text(
                    "Link Fund",
                    style: TextStyle(
                      color: Color(0xFF0066FF),
                      fontWeight: FontWeight.w600,
                      fontFamily: FontFamily.regular,
                      fontSize: 14,
                    ),
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

/// ----------------------------------------------------------------------
/// Vertical Contributions Ledger Interface Stream Panel
/// ----------------------------------------------------------------------
class RecentContributionsCard extends StatelessWidget {
  const RecentContributionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Recent Contributions",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: FontFamily.regular,
                  color: Color(0xFF1E293B),
                ),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                    ),
                    child: const Text(
                      "View All",
                      style: TextStyle(
                        color: Color(0xFF0066FF),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: FontFamily.regular,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Iconsax.filter,
                    size: 18,
                    color: Color(0xFF64748B),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Ledger List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6, // Matches the 6 items visible in the image
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              // Creating dynamic date variations just to mimic the image mockup perfectly
              final dates = [
                "Jan 10, 2024",
                "Jan 03, 2024",
                "Dec 27, 2023",
                "Dec 20, 2023",
                "Dec 13, 2023",
                "Dec 06, 2023",
              ];

              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left Side: Circular Calendar Icon + Text Info
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color(
                              0xFFF0F5FF,
                            ), // Soft blue background circle matching your UI
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Iconsax.calendar_2,
                            color: Color(0xFF0066FF),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dates[index],
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: FontFamily.regular,
                                fontSize: 14,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              "Funding from salary",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                                fontFamily: FontFamily.regular,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Right Side: Amount, Payment Source + Success Badge
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              "+ ₹1,000",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: FontFamily.regular,
                                fontSize: 14,
                                color: Color(0xFF16A34A),
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              "Local Bank 1",
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF94A3B8),
                                fontWeight: FontWeight.w600,
                                fontFamily: FontFamily.regular,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFE8F5E9,
                            ), // Soft green background capsule match
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "Success",
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF2E7D32),
                              fontWeight: FontWeight.w600,
                              fontFamily: FontFamily.regular,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// ----------------------------------------------------------------------
/// Next Milestone Completion Target Container Card
/// ----------------------------------------------------------------------
class NextMilestoneCard extends StatelessWidget {
  final double invested;
  final double target;

  const NextMilestoneCard({
    super.key,
    required this.invested,
    required this.target,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Next Milestone",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const Gap(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFEDD5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Iconsax.flag,
                      color: Color(0xFFEA580C),
                      size: 20,
                    ),
                  ),
                  const Gap(14),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "₹ 93,080 more to reach 60%",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: FontFamily.regular,
                          fontSize: 13,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Gap(2),
                      Text(
                        "Keep it up! You're doing great.",
                        style: TextStyle(
                          fontSize: 11,
                          fontFamily: FontFamily.regular,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  const SizedBox(
                    width: 44,
                    height: 44,
                    child: CircularProgressIndicator(
                      value: 0.60,
                      strokeWidth: 4,
                      backgroundColor: Color(0xFFF1F5F9),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFEA580C),
                      ),
                    ),
                  ),
                  Text(
                    "60%",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      fontFamily: FontFamily.regular,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ----------------------------------------------------------------------
/// Mobile View Layout (Tabbed Switching Container Remains Unchanged)
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
                    Text(
                      'Delete',
                      style: TextStyle(
                        fontFamily: FontFamily.medium,
                        color: Colors.red,
                      ),
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
                        children: List.generate(
                          10,
                          (index) => const TransactionCard(),
                        ),
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
            style: UTextStyles.buttonText.copyWith(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

/// ----------------------------------------------------------------------
/// Core Reusable UI Sections & Custom Metric Tiles (Fallback for Mobile)
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
              SmallHeading(
                smallheading: 'Deadline (Est. Year ${deadlineYear.floor()})',
              ),
              const Gap(12),
              Row(
                children: [
                  ValueTitleGoal(value: _fmt(daily), title: 'Daily Savings'),
                  ValueTitleGoal(value: _fmt(weekly), title: 'Weekly Savings'),
                  ValueTitleGoal(
                    value: _fmt(monthly),
                    title: 'Monthly Savings',
                  ),
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
          final freshGoal =
              goalSipController.goalResponse.value?.data?.firstWhereOrNull(
                (g) => g.id == currentGoalId,
              ) ??
              goal;

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
                      style: TextStyle(
                        fontFamily: FontFamily.medium,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ...linkedFunds.map((fund) {
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
                            freshGoal?.txnType.toLowerCase() == 'sip'
                                ? _fmt(fund.sipAmount)
                                : _fmt(fund.lumpsumAmount),
                            style: UTextStyles.medium.copyWith(
                              color: Ucolors.dark,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
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
                                    Get.defaultDialog(
                                      title: "Remove Fund",
                                      middleText:
                                          "Are you sure you want to remove this fund from your goal?",
                                      textConfirm: "Remove",
                                      textCancel: "Cancel",
                                      confirmTextColor: Colors.white,
                                      onConfirm: () {
                                        Get.back();
                                        goalSipController.deleteGoalFund(
                                          id: fund.id,
                                          isEdit: true,
                                          schemeName:
                                              fund.mutualFund?.schemeCode
                                                  .toString() ??
                                              '',
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
            style: UTextStyles.large.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
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
