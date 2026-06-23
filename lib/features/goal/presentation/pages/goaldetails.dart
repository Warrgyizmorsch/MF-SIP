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
    final String logo = args['logo'] ?? "";

    final String title = goal?.goalName ?? 'Goal Details';
    final int currentGoalId = goal?.id ?? 0;

    final bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    void onEdit() => _showEditGoalDialog(context, currentGoalId, goal, isDesktop);
    void onDelete() => _showDeleteGoalDialog(context, currentGoalId);

    void onAddFunds() {
      if (currentGoalId != 0) {
        MasterGoalsPage.tempArgs = {
          'isAddFund': true,
          "goalId": currentGoalId,
          "goal": goal,
        };

        if (isDesktop) {
          WebMasterGoalsPage.tempArgs = {
            'isAddFund': true,
            "goalId": currentGoalId,
            "goal": goal,
          };
          // Navigates directly via clean nested platform shell container layout routing
          Get.toNamed(AppRoutes.webMasterGoalsPage, id: 1);
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
        backgroundColor: const Color(0xFFF8FAFC),
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
/// Web Custom Reusable App Bar Component
/// ----------------------------------------------------------------------
class WebCustomAppBarNormal extends StatelessWidget implements PreferredSizeWidget {
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
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: Color(0xFF64748B)),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFF8FAFC),
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                  padding: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const Gap(16),
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFFEF3C7),
                child: Text(emoji, style: const TextStyle(fontSize: 20)),
              ),
              const Gap(12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const Gap(12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                  backgroundColor: const Color(0xFF0066FF),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: const Text(
                  "Add Funds",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
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
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 18, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
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
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: WebCustomAppBarNormal(
        title: title,
        emoji: emoji,
        onAddFunds: onAddFunds,
        onEdit: onEdit,
        onDelete: onDelete,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 32.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1300),
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
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ----------------------------------------------------------------------
/// Redesigned Goal Overview UI Block Widget
/// ----------------------------------------------------------------------
class GoalOverviewCard extends StatelessWidget {
  final UserGoalEntity? goal;
  final double target;
  final double invested;
  final String emoji;
  final String logo;

  const GoalOverviewCard({
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

    final double safeTarget = target > 0 ? target : 1;
    final double percentage = (invested / safeTarget).clamp(0.0, 1.0);
    final String percentStr = "${(percentage * 100).toStringAsFixed(0)}%";

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Goal Overview",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
          const Gap(24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 150,
                          height: 150,
                          child: CircularProgressIndicator(
                            value: percentage,
                            strokeWidth: 12,
                            backgroundColor: const Color(0xFFF1F5F9),
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF97316)),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(emoji, style: const TextStyle(fontSize: 32)),
                            const Gap(4),
                            Text(
                              percentStr,
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                            ),
                            Text(
                              "of goal achieved",
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 7,
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    _buildMetricTile(Iconsax.empty_wallet, "Saved", _fmt(invested)),
                    _buildMetricTile(Iconsax.refresh_2, "Remaining", _fmt(remaining)),
                    _buildMetricTile(Iconsax.radar, "Target", _fmt(target)),
                    _buildMetricTile(Iconsax.calendar_1, "Deadline", "Est. Year ${deadlineYear.floor()}"),
                    _buildMetricTile(Iconsax.coin, "Daily Savings", _fmt(daily)),
                    _buildMetricTile(Iconsax.wallet_3, "Weekly Savings", _fmt(weekly)),
                    _buildMetricTile(Iconsax.card_send, "Monthly Savings", _fmt(monthly)),
                  ],
                ),
              )
            ],
          ),
          const Gap(32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Iconsax.trend_up, color: Color(0xFF0066FF), size: 20),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(fontSize: 13, color: Color(0xFF475569)),
                          children: [
                            const TextSpan(text: "You are "),
                            const TextSpan(text: "on track ", style: TextStyle(color: Color(0xFF0066FF), fontWeight: FontWeight.bold)),
                            TextSpan(text: "to reach your goal by ${deadlineYear.floor()}"),
                          ],
                        ),
                      ),
                      const Gap(8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: percentage,
                          minHeight: 6,
                          backgroundColor: const Color(0xFFE2E8F0),
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF97316)),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(16),
                Text(
                  percentStr,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFF97316), fontSize: 14),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMetricTile(IconData icon, String label, String value) {
    return SizedBox(
      width: 160,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF0066FF)),
          const Gap(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                const Gap(2),
                Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              ],
            ),
          )
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Linked Mutual Funds",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
              TextButton(
                onPressed: () {},
                child: const Text("View All", style: TextStyle(color: Color(0xFF0066FF), fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const Gap(16),
          Obx(() {
            final freshGoal = goalSipController.goalResponse.value?.data?.firstWhereOrNull(
                  (g) => g.id == currentGoalId,
            ) ?? goal;

            final linkedFunds = freshGoal?.goalFunds ?? [];

            if (linkedFunds.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Text('No mutual funds linked yet.', style: TextStyle(color: Colors.grey)),
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
                childAspectRatio: 2.1,
              ),
              itemBuilder: (context, index) {
                final fund = linkedFunds[index];
                final String imgUrl = "${Appurl.baseUrl}${fund.mutualFund?.amc?.amcLogo ?? ''}";
                final String displayAmount = freshGoal?.txnType.toLowerCase() == 'sip'
                    ? '₹ ${fund.sipAmount.toStringAsFixed(0)} / month'
                    : '₹ ${fund.lumpsumAmount.toStringAsFixed(0)}';

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(imgUrl),
                            onBackgroundImageError: (_, __) => const Icon(Icons.broken_image, size: 14),
                          ),
                          const Gap(10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  fund.mutualFund?.schemeName ?? 'Unknown Fund',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B)),
                                ),
                                Text(
                                  "Equity · Large Cap",
                                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(displayAmount, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: const Color(0xFFE0F2FE), borderRadius: BorderRadius.circular(4)),
                            child: const Text("SIP", style: TextStyle(fontSize: 10, color: Color(0xFF0369A1), fontWeight: FontWeight.bold)),
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
            );
          }),
          const Gap(20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFCBD5E1), style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.add_circle_outline, color: Color(0xFF64748B), size: 20),
                    Gap(12),
                    Text(
                      "Add more mutual funds to diversify your goal",
                      style: TextStyle(color: Color(0xFF475569), fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF0066FF)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  child: const Text("Link Fund", style: TextStyle(color: Color(0xFF0066FF), fontWeight: FontWeight.bold)),
                )
              ],
            ),
          )
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Recent Contributions",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text("View All", style: TextStyle(color: Color(0xFF0066FF), fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                  const Icon(Iconsax.filter, size: 16, color: Color(0xFF64748B)),
                ],
              )
            ],
          ),
          const Gap(10),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            separatorBuilder: (_, __) => const Gap(12),
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Iconsax.calendar_2, color: Color(0xFF0066FF), size: 20),
                        const Gap(12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Jan 10, 2024", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B))),
                            Text("Funding from salary", style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                          ],
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text("+ ₹1,000", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF16A34A))),
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(4)),
                          child: const Text("Success", style: TextStyle(fontSize: 9, color: Color(0xFF15803D), fontWeight: FontWeight.bold)),
                        )
                      ],
                    )
                  ],
                ),
              );
            },
          )
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

  const NextMilestoneCard({super.key, required this.invested, required this.target});

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
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
          const Gap(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(color: Color(0xFFFFEDD5), shape: BoxShape.circle),
                    child: const Icon(Iconsax.flag, color: Color(0xFFEA580C), size: 20),
                  ),
                  const Gap(14),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "₹ 93,080 more to reach 60%",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B)),
                      ),
                      Gap(2),
                      Text("Keep it up! You're doing great.", style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                    ],
                  )
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
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFEA580C)),
                    ),
                  ),
                  Text("60%", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade800))
                ],
              )
            ],
          )
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