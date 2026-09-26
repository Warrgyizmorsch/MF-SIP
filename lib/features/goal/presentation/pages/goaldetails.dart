// ignore_for_file: unnecessary_to_list_in_spreads, invalid_null_aware_operator, unnecessary_null_comparison, unused_local_variable

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
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

    final UserGoalEntity? initialGoal = args?['goal'] as UserGoalEntity?;
    final int currentGoalId =
        initialGoal?.id ??
        (args?['goalId'] as int?) ??
        int.tryParse(Get.parameters['id'] ?? '') ??
        0;

    if (args == null && currentGoalId == 0) {
      return const Scaffold(body: Center(child: Text("Error: No data found")));
    }

    if (currentGoalId != 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.currentGoalDetail.value?.id != currentGoalId) {
          controller.fetchSingleGoal(currentGoalId);
        }
      });
    }

    final bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Obx(() {
      final liveDetail = controller.currentGoalDetail.value;
      final bool isCurrentGoalMatch =
          liveDetail != null && liveDetail.id == currentGoalId;

      final UserGoalEntity? goal =
          initialGoal ??
          (isCurrentGoalMatch
              ? UserGoalEntity(
                  id: liveDetail.id,
                  userId: 0,
                  goalId: liveDetail.id,
                  goalName: liveDetail.goalName,
                  goalCover: liveDetail.goalCover,
                  txnType: 'lumpsum',
                  lumpsumAmount: 0.0,
                  targetAmount: liveDetail.targetAmount,
                  frequency: 'monthly',
                  monthlyInvestment: liveDetail.monthlySavings,
                  expectedReturnRate: 12.0,
                  goalTenure: liveDetail.goalTenure,
                  investedAmount: liveDetail.savedAmount,
                  status: liveDetail.status,
                  mfuOrderStatus: '',
                  progressPercent: liveDetail.progressPercent,
                  goalFunds: [],
                )
              : null);

      final String emoji = args?['emoji'] ?? '🎯';
      final double target = isCurrentGoalMatch && liveDetail.targetAmount > 0
          ? liveDetail.targetAmount
          : (args?['target'] ?? (goal?.targetAmount ?? 0.0));

      final double invested = isCurrentGoalMatch
          ? liveDetail.savedAmount
          : (args?['invested'] ??
                (goal != null && goal.investedAmount > 0
                    ? goal.investedAmount
                    : (target * ((goal?.progressPercent ?? 0) / 100))));

      final String logo =
          (isCurrentGoalMatch && liveDetail.goalCover.isNotEmpty)
          ? liveDetail.goalCover
          : ((goal != null && goal.goalCover.isNotEmpty)
                ? goal.goalCover
                : (goal?.goalType?.logo ?? ""));

      final String title = isCurrentGoalMatch && liveDetail.goalName.isNotEmpty
          ? liveDetail.goalName
          : (goal?.goalName ?? 'Goal Details');

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
            Get.toNamed(
              AppRoutes.webMasterGoalsPage,
              id: 1,
              arguments: payload,
            )?.then((_) {
              controller.fetchSingleGoal(currentGoalId);
              controller.getAllGoals();
            });
          } else {
            controller.isAddFund.value = true;
            controller.loadGoalForAddFund(goal);
            Get.toNamed(AppRoutes.masterGoalsPage, arguments: payload)?.then((
              _,
            ) {
              controller.fetchSingleGoal(currentGoalId);
              controller.getAllGoals();
            });
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
            emoji: logo.isNotEmpty ? logo : emoji,
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
        emoji: emoji,
        target: target,
        invested: invested,
        logo: logo,
        onEdit: onEdit,
        onDelete: onDelete,
        onAddFunds: onAddFunds,
      );
    });
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
                          LinkedFundsCard(goal: goal, onAddFunds: onAddFunds),
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
    return Obx(() {
      final liveDetail = controller.currentGoalDetail.value;
      final int currentGoalId = goal?.id ?? 0;
      final bool isMatch = liveDetail != null && liveDetail.id == currentGoalId;

      final double liveSaved = isMatch ? liveDetail.savedAmount : invested;
      final double liveTarget = isMatch && liveDetail.targetAmount > 0
          ? liveDetail.targetAmount
          : target;
      final double liveRemaining = isMatch
          ? liveDetail.remainingAmount
          : (liveTarget - liveSaved).clamp(0.0, double.infinity);

      final double monthly = goal?.monthlyInvestment ?? 0.0;
      final double liveMonthly = isMatch ? liveDetail.monthlySavings : monthly;
      final double liveWeekly = isMatch
          ? liveDetail.weeklySavings
          : ((liveMonthly * 12) / 52);
      final double liveDaily = isMatch
          ? liveDetail.dailySavings
          : ((liveMonthly * 12) / 365);

      final currentYear = DateTime.now().year;
      final dynamic rawDeadlineYear = isMatch && liveDetail.estYear > 0
          ? liveDetail.estYear
          : (currentYear + (goal?.goalTenure ?? 0) / 12);
      final int deadlineYearInt = rawDeadlineYear is int
          ? rawDeadlineYear
          : (rawDeadlineYear as num).floor();

      final String deadlineText = isMatch && liveDetail.deadlineLabel.isNotEmpty
          ? liveDetail.deadlineLabel
                .replaceAll("Deadline ", "")
                .replaceAll("(", "")
                .replaceAll(")", "")
          : "Est. Year $deadlineYearInt";

      final double safeTarget = liveTarget > 0 ? liveTarget : 1;
      final double percentage = isMatch && liveDetail.progressPercent > 0
          ? (liveDetail.progressPercent / 100).clamp(0.0, 1.0)
          : (liveSaved / safeTarget).clamp(0.0, 1.0);
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
                                  BoxShadow(
                                    blurRadius: 8,
                                    color: Colors.black12,
                                  ),
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
                          _fmt(liveSaved),
                          hasRightBorder: true,
                          hasBottomBorder: true,
                        ),
                        _buildGridTile(
                          Iconsax.refresh_2,
                          "Remaining",
                          _fmt(liveRemaining),
                          hasRightBorder: true,
                          hasBottomBorder: true,
                        ),
                        _buildGridTile(
                          Iconsax.radar,
                          "Target",
                          _fmt(liveTarget),
                          hasBottomBorder: true,
                        ),
                        _buildGridTile(
                          Iconsax.calendar_1,
                          "Deadline",
                          deadlineText,
                          hasRightBorder: true,
                          hasBottomBorder: true,
                        ),
                        _buildGridTile(
                          Iconsax.coin,
                          "Daily Savings",
                          _fmt(liveDaily),
                          hasRightBorder: true,
                          hasBottomBorder: true,
                        ),
                        _buildGridTile(
                          Iconsax.wallet_3,
                          "Weekly Savings",
                          _fmt(liveWeekly),
                          hasBottomBorder: true,
                        ),
                        const SizedBox.shrink(),
                        _buildGridTile(
                          Iconsax.card_send,
                          "Monthly Savings",
                          _fmt(liveMonthly),
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
                                style: TextStyle(
                                  fontFamily: FontFamily.regular,
                                ),
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
                                text: "to reach your goal by $deadlineYearInt",
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
    });
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
  final VoidCallback? onAddFunds;
  const LinkedFundsCard({super.key, this.goal, this.onAddFunds});

  @override
  Widget build(BuildContext context) {
    final goalSipController = Get.find<GoalSipController>();
    final currentGoalId = goal?.id ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Obx(() {
          final liveDetail = goalSipController.currentGoalDetail.value;
          final bool hasLiveFunds =
              liveDetail != null &&
              liveDetail.id == currentGoalId &&
              liveDetail.linkedFunds.isNotEmpty;

          final freshGoal =
              goalSipController.goalResponse.value?.data?.firstWhereOrNull(
                (g) => g.id == currentGoalId,
              ) ??
              goal;

          final int count = hasLiveFunds
              ? liveDetail.linkedFunds.length
              : (freshGoal?.goalFunds.length ?? 0);

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    "Linked Mutual Funds",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: FontFamily.regular,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: Text(
                      "$count",
                      style: const TextStyle(
                        color: Color(0xFF2563EB),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        fontFamily: FontFamily.regular,
                      ),
                    ),
                  ),
                ],
              ),
              if (onAddFunds != null)
                ElevatedButton.icon(
                  onPressed: onAddFunds,
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: const Text(
                    "Add Fund",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: FontFamily.regular,
                      fontSize: 13,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Ucolors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
            ],
          );
        }),
        const SizedBox(height: 20),

        // Funds Grid View Block
        Obx(() {
          final liveDetail = goalSipController.currentGoalDetail.value;
          final bool hasLiveFunds =
              liveDetail != null &&
              liveDetail.id == currentGoalId &&
              liveDetail.linkedFunds.isNotEmpty;

          final freshGoal =
              goalSipController.goalResponse.value?.data?.firstWhereOrNull(
                (g) => g.id == currentGoalId,
              ) ??
              goal;

          final linkedFunds = freshGoal?.goalFunds ?? [];

          if (!hasLiveFunds && linkedFunds.isEmpty) {
            if (goalSipController.isLoadingSingleGoal.value) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color(0xFFEFF6FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 32,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    "No mutual funds linked yet",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                      fontFamily: FontFamily.regular,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Link funds to start tracking your progress towards this goal.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                      fontFamily: FontFamily.regular,
                    ),
                  ),
                  if (onAddFunds != null) ...[
                    const SizedBox(height: 18),
                    OutlinedButton.icon(
                      onPressed: onAddFunds,
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text("Link Your First Fund"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF2563EB),
                        side: const BorderSide(color: Color(0xFF2563EB)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }

          if (hasLiveFunds) {
            final liveFunds = liveDetail.linkedFunds;
            return LayoutBuilder(
              builder: (context, constraints) {
                final int crossAxisCount = constraints.maxWidth > 900 ? 3 : 2;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: liveFunds.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: constraints.maxWidth > 900 ? 3.6 : 3.0,
                  ),
                  itemBuilder: (context, index) {
                    final fund = liveFunds[index];
                    final String imgUrl = fund.amcLogo.isNotEmpty
                        ? (fund.amcLogo.startsWith('http')
                              ? fund.amcLogo
                              : "${Appurl.baseUrl}/${fund.amcLogo}")
                        : (fund.amcImageUrl.isNotEmpty
                              ? (fund.amcImageUrl.startsWith('http')
                                    ? fund.amcImageUrl
                                    : "${Appurl.baseUrl}/${fund.amcImageUrl}")
                              : '');

                    final int fundId = fund.id != 0
                        ? fund.id
                        : fund.mfuOrderFundId;
                    final double gain = fund.gainLoss;
                    final double gainPercent = fund.gainLossPercent;

                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                              ),
                              color: Colors.white,
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: imgUrl.isNotEmpty
                                ? Image.network(
                                    imgUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.account_balance,
                                      size: 20,
                                      color: Colors.grey,
                                    ),
                                  )
                                : const Icon(
                                    Icons.account_balance,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  fund.fundName.isNotEmpty
                                      ? fund.fundName
                                      : 'Unknown Fund',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontFamily: FontFamily.regular,
                                    fontSize: 13,
                                    color: Color(0xFF0F172A),
                                    height: 1.25,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Text(
                                      "Invested: ",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF64748B),
                                        fontFamily: FontFamily.regular,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      '₹${(fund.fundInvested > 0 ? fund.fundInvested : fund.investedAmount).toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF1E293B),
                                        fontFamily: FontFamily.regular,
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 6,
                                      ),
                                      child: Text(
                                        "•",
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFFCBD5E1),
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      "Current: ",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF64748B),
                                        fontFamily: FontFamily.regular,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      fund.currentValue > 0
                                          ? '₹${fund.currentValue.toStringAsFixed(0)}'
                                          : (fund.currentNav > 0
                                                ? 'NAV ₹${fund.currentNav.toStringAsFixed(2)}'
                                                : '—'),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF0F172A),
                                        fontFamily: FontFamily.regular,
                                      ),
                                    ),
                                    if (gain != 0 || gainPercent != 0) ...[
                                      const SizedBox(width: 4),
                                      Text(
                                        "(${gain >= 0 ? '+' : ''}${gainPercent.toStringAsFixed(1)}%)",
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: gain >= 0
                                              ? const Color(0xFF16A34A)
                                              : const Color(0xFFDC2626),
                                          fontFamily: FontFamily.regular,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Obx(() {
                            final bool isDel =
                                goalSipController.isDeleting[fundId] ?? false;
                            return isDel
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
                                      size: 17,
                                      color: Color(0xFF94A3B8),
                                    ),
                                    hoverColor: const Color(0xFFFEE2E2),
                                    color: const Color(0xFFEF4444),
                                    tooltip: 'Remove Fund',
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () {
                                      Get.defaultDialog(
                                        title: "Remove Fund",
                                        middleText:
                                            "Are you sure you want to remove this fund from your goal?",
                                        textConfirm: "Remove",
                                        textCancel: "Cancel",
                                        confirmTextColor: Colors.white,
                                        buttonColor: Colors.red,
                                        onConfirm: () {
                                          Get.back();
                                          goalSipController.deleteGoalFund(
                                            id: fundId,
                                            isEdit: false,
                                            schemeName: fund.fundName,
                                            goalId: goal?.id,
                                          );
                                        },
                                      );
                                    },
                                  );
                          }),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final int crossAxisCount = constraints.maxWidth > 900 ? 3 : 2;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: linkedFunds.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: constraints.maxWidth > 900 ? 3.6 : 3.0,
                ),
                itemBuilder: (context, index) {
                  final fund = linkedFunds[index];
                  final String imgUrl =
                      "${Appurl.baseUrl}${fund.mutualFund?.amc?.amcLogo ?? ''}";
                  final String displayAmount =
                      freshGoal?.txnType.toLowerCase() == 'sip'
                      ? '₹${fund.sipAmount.toStringAsFixed(0)} / mo'
                      : '₹${fund.lumpsumAmount.toStringAsFixed(0)}';

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                            color: Colors.white,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.network(
                            imgUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.account_balance,
                              size: 20,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                fund.mutualFund?.schemeName ?? 'Unknown Fund',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontFamily: FontFamily.regular,
                                  fontSize: 13,
                                  color: Color(0xFF0F172A),
                                  height: 1.25,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Text(
                                    "Amount: ",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF64748B),
                                      fontFamily: FontFamily.regular,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    displayAmount,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF0F172A),
                                      fontFamily: FontFamily.regular,
                                    ),
                                  ),
                                  if (fund
                                          .mutualFund
                                          ?.mfPerformanceScheme
                                          ?.oneMonth !=
                                      null) ...[
                                    const SizedBox(width: 6),
                                    Text(
                                      "${fund.mutualFund!.mfPerformanceScheme!.oneMonth}% (1M)",
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF16A34A),
                                        fontFamily: FontFamily.regular,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                        Obx(() {
                          final bool isDel =
                              goalSipController.isDeleting[fund.id] ?? false;
                          return isDel
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
                                    size: 17,
                                    color: Color(0xFF94A3B8),
                                  ),
                                  hoverColor: const Color(0xFFFEE2E2),
                                  color: const Color(0xFFEF4444),
                                  tooltip: 'Remove Fund',
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    Get.defaultDialog(
                                      title: "Remove Fund",
                                      middleText:
                                          "Are you sure you want to remove this fund from your goal?",
                                      textConfirm: "Remove",
                                      textCancel: "Cancel",
                                      confirmTextColor: Colors.white,
                                      buttonColor: Colors.red,
                                      onConfirm: () {
                                        Get.back();
                                        goalSipController.deleteGoalFund(
                                          id: fund.id,
                                          isEdit: false,
                                          schemeName:
                                              fund.mutualFund?.schemeCode
                                                  ?.toString() ??
                                              '',
                                          goalId: goal?.id,
                                        );
                                      },
                                    );
                                  },
                                );
                        }),
                      ],
                    ),
                  );
                },
              );
            },
          );
        }),
      ],
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
                    RefreshIndicator(
                      onRefresh: () async {
                        final int currentGoalId = goal?.id ?? 0;
                        if (currentGoalId != 0) {
                          await Get.find<GoalSipController>().fetchSingleGoal(
                            currentGoalId,
                          );
                        }
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: GoalDetailSection(
                          goal: goal,
                          target: target,
                          invested: invested,
                          emoji: emoji,
                          logo: logo,
                          onAddFunds: onAddFunds,
                        ),
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
      // bottomNavigationBar: UElevatedBUtton(
      //   onPressed: onAddFunds,
      //   child: Center(
      //     child: Text(
      //       'Add Funds',
      //       style: UTextStyles.buttonText.copyWith(
      //         color: Colors.white,
      //         fontSize: 14,
      //       ),
      //     ),
      //   ),
      // ),
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
  final VoidCallback? onAddFunds;

  const GoalDetailSection({
    super.key,
    required this.goal,
    required this.target,
    required this.invested,
    required this.emoji,
    required this.logo,
    this.onAddFunds,
  });

  String _fmt(double amount) {
    return '₹ ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  @override
  Widget build(BuildContext context) {
    final goalSipController = Get.find<GoalSipController>();
    final int currentGoalId = goal?.id ?? 0;

    return Obx(() {
      final liveDetail = goalSipController.currentGoalDetail.value;
      final bool isMatch = liveDetail != null && liveDetail.id == currentGoalId;

      final double liveSaved = isMatch ? liveDetail.savedAmount : invested;
      final double liveTarget = isMatch && liveDetail.targetAmount > 0
          ? liveDetail.targetAmount
          : target;
      final double liveRemaining = isMatch
          ? liveDetail.remainingAmount
          : (liveTarget - liveSaved).clamp(0.0, double.infinity);

      final double monthly = goal?.monthlyInvestment ?? 0.0;
      final double liveMonthly = isMatch ? liveDetail.monthlySavings : monthly;
      final double liveWeekly = isMatch
          ? liveDetail.weeklySavings
          : ((liveMonthly * 12) / 52);
      final double liveDaily = isMatch
          ? liveDetail.dailySavings
          : ((liveMonthly * 12) / 365);

      final currentYear = DateTime.now().year;
      final dynamic rawDeadlineYear = isMatch && liveDetail.estYear > 0
          ? liveDetail.estYear
          : (currentYear + (goal?.goalTenure ?? 0) / 12);
      final int deadlineYearInt = rawDeadlineYear is int
          ? rawDeadlineYear
          : (rawDeadlineYear as num).floor();

      final String deadlineTitle =
          isMatch && liveDetail.deadlineLabel.isNotEmpty
          ? liveDetail.deadlineLabel
          : 'Deadline (Est. Year $deadlineYearInt)';

      final String effectiveLogo = isMatch && liveDetail.goalCover.isNotEmpty
          ? liveDetail.goalCover
          : logo;

      final bool hasLiveFunds = isMatch && liveDetail.linkedFunds.isNotEmpty;
      final freshGoal =
          goalSipController.goalResponse.value?.data?.firstWhereOrNull(
            (g) => g.id == currentGoalId,
          ) ??
          goal;
      final linkedFunds = freshGoal?.goalFunds ?? [];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(8),
          Center(
            child: CircularGoalIndicatorDetails(
              percentage: true,
              goalName: (isMatch && liveDetail.goalName.isNotEmpty)
                  ? liveDetail.goalName
                  : (goal?.goalName ?? ''),
              goalType: goal?.goalType?.typeName ?? '',
              targetAmount: liveTarget,
              investedAmount: liveSaved,
              emoji: emoji,
              imageUrl: effectiveLogo.isNotEmpty
                  ? (effectiveLogo.startsWith('http')
                        ? effectiveLogo
                        : "${Appurl.baseUrl}/$effectiveLogo")
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
                    ValueTitleGoal(value: _fmt(liveSaved), title: 'Saved'),
                    ValueTitleGoal(
                      value: _fmt(liveRemaining),
                      title: 'Remaining',
                    ),
                    ValueTitleGoal(value: _fmt(liveTarget), title: 'Goal'),
                  ],
                ),
                const Gap(20),
                SmallHeading(smallheading: deadlineTitle),
                const Gap(12),
                Row(
                  children: [
                    ValueTitleGoal(
                      value: _fmt(liveDaily),
                      title: 'Daily Savings',
                    ),
                    ValueTitleGoal(
                      value: _fmt(liveWeekly),
                      title: 'Weekly Savings',
                    ),
                    ValueTitleGoal(
                      value: _fmt(liveMonthly),
                      title: 'Monthly Savings',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Gap(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SmallHeading(smallheading: 'Linked Mutual Funds'),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "${hasLiveFunds ? liveDetail.linkedFunds.length : linkedFunds.length}",
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ),
                ],
              ),
              if (onAddFunds != null)
                TextButton.icon(
                  onPressed: onAddFunds,
                  icon: const Icon(
                    Icons.add_circle_outline,
                    size: 16,
                    color: Color(0xFF0066FF),
                  ),
                  label: const Text(
                    "Add",
                    style: TextStyle(
                      color: Color(0xFF0066FF),
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
            ],
          ),
          const Gap(10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!hasLiveFunds && linkedFunds.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 24.0,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: goalSipController.isLoadingSingleGoal.value
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                color: Color(0xFFEFF6FF),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.account_balance_wallet_outlined,
                                size: 26,
                                color: Color(0xFF2563EB),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'No mutual funds linked yet',
                              style: TextStyle(
                                fontFamily: FontFamily.medium,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Link a fund to start building towards this goal.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            if (onAddFunds != null) ...[
                              const SizedBox(height: 14),
                              ElevatedButton.icon(
                                onPressed: onAddFunds,
                                icon: const Icon(Icons.add, size: 16),
                                label: const Text("Link Fund"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Ucolors.primary,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                ),
              if (hasLiveFunds)
                ...liveDetail.linkedFunds.map((fund) {
                  final String imgUrl = fund.amcLogo.isNotEmpty
                      ? (fund.amcLogo.startsWith('http')
                            ? fund.amcLogo
                            : "${Appurl.baseUrl}/${fund.amcLogo}")
                      : (fund.amcImageUrl.isNotEmpty
                            ? (fund.amcImageUrl.startsWith('http')
                                  ? fund.amcImageUrl
                                  : "${Appurl.baseUrl}/${fund.amcImageUrl}")
                            : '');

                  final int fundId = fund.id != 0
                      ? fund.id
                      : fund.mfuOrderFundId;
                  final bool isAllotted = fund.isUnitAllotted;
                  final double gain = fund.gainLoss;
                  final double gainPercent = fund.gainLossPercent;

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.white,
                            backgroundImage: imgUrl.isNotEmpty
                                ? NetworkImage(imgUrl)
                                : null,
                            onBackgroundImageError: (_, __) {},
                            child: imgUrl.isEmpty
                                ? const Icon(
                                    Icons.account_balance,
                                    size: 18,
                                    color: Colors.grey,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  fund.fundName.isNotEmpty
                                      ? fund.fundName
                                      : 'Unknown Fund',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: UTextStyles.medium.copyWith(
                                    color: const Color(0xFF0F172A),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  children: [
                                    const Text(
                                      "Inv: ",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Color(0xFF64748B),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "₹${(fund.fundInvested > 0 ? fund.fundInvested : fund.investedAmount).toStringAsFixed(0)}",
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      child: Text(
                                        "•",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Color(0xFFCBD5E1),
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      "Cur: ",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Color(0xFF64748B),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      fund.currentValue > 0
                                          ? "₹${fund.currentValue.toStringAsFixed(0)}"
                                          : (fund.currentNav > 0
                                                ? "NAV ₹${fund.currentNav.toStringAsFixed(2)}"
                                                : "—"),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF0F172A),
                                      ),
                                    ),
                                    if (gain != 0 || gainPercent != 0) ...[
                                      const SizedBox(width: 4),
                                      Text(
                                        "(${gain >= 0 ? '+' : ''}${gainPercent.toStringAsFixed(1)}%)",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: gain >= 0
                                              ? const Color(0xFF16A34A)
                                              : const Color(0xFFDC2626),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Obx(() {
                            final bool deleting =
                                goalSipController.isDeleting[fundId] ?? false;
                            return deleting
                                ? const Padding(
                                    padding: EdgeInsets.only(left: 6),
                                    child: SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  )
                                : IconButton(
                                    icon: const Icon(
                                      Iconsax.trash,
                                      color: Color(0xFF94A3B8),
                                      size: 17,
                                    ),
                                    padding: const EdgeInsets.only(left: 6),
                                    constraints: const BoxConstraints(),
                                    onPressed: () {
                                      Get.defaultDialog(
                                        title: "Remove Fund",
                                        middleText:
                                            "Are you sure you want to remove this fund from your goal?",
                                        textConfirm: "Remove",
                                        textCancel: "Cancel",
                                        confirmTextColor: Colors.white,
                                        buttonColor: Colors.red,
                                        onConfirm: () {
                                          Get.back();
                                          goalSipController.deleteGoalFund(
                                            id: fundId,
                                            isEdit: false,
                                            schemeName: fund.fundName,
                                            goalId: freshGoal?.id,
                                          );
                                        },
                                      );
                                    },
                                  );
                          }),
                        ],
                      ),
                    ),
                  );
                })
              else
                ...linkedFunds.map((fund) {
                  return Obx(() {
                    final bool deleting =
                        goalSipController.isDeleting[fund.id] ?? false;
                    final String imgUrl =
                        "${Appurl.baseUrl}${fund.mutualFund?.amc?.amcLogo ?? ''}";
                    final String displayAmount =
                        freshGoal?.txnType.toLowerCase() == 'sip'
                        ? _fmt(fund.sipAmount)
                        : _fmt(fund.lumpsumAmount);

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        dense: true,
                        leading: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(imgUrl),
                          onBackgroundImageError: (_, __) =>
                              const Icon(Icons.broken_image, size: 18),
                        ),
                        title: Text(
                          fund.mutualFund?.schemeName ?? 'Unknown Fund',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: UTextStyles.medium.copyWith(
                            color: const Color(0xFF0F172A),
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        subtitle:
                            fund.mutualFund?.schemeCategory?.isNotEmpty == true
                            ? Text(
                                fund.mutualFund!.schemeCategory,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF64748B),
                                ),
                              )
                            : null,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              displayAmount,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(width: 8),
                            deleting
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : IconButton(
                                    icon: const Icon(
                                      Iconsax.trash,
                                      color: Color(0xFF94A3B8),
                                      size: 18,
                                    ),
                                    onPressed: () {
                                      Get.defaultDialog(
                                        title: "Remove Fund",
                                        middleText:
                                            "Are you sure you want to remove this fund from your goal?",
                                        textConfirm: "Remove",
                                        textCancel: "Cancel",
                                        confirmTextColor: Colors.white,
                                        buttonColor: Colors.red,
                                        onConfirm: () {
                                          Get.back();
                                          goalSipController.deleteGoalFund(
                                            id: fund.id,
                                            isEdit: true,
                                            schemeName:
                                                fund.mutualFund?.schemeCode
                                                    ?.toString() ??
                                                '',
                                            goalId: freshGoal?.id,
                                          );
                                        },
                                      );
                                    },
                                  ),
                          ],
                        ),
                      ),
                    );
                  });
                }).toList(),
            ],
          ),
          const Gap(22),
        ],
      );
    });
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
