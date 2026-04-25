import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/appbar/widget/compact_icon.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../controller/goal_sip_controller.dart';
import 'ihavegoal.dart';

class GoalScreen extends GetView<GoalSipController> {
  const GoalScreen({super.key});

  String _goalEmoji(String goalName) {
    final lower = goalName.toLowerCase();
    if (lower.contains('car')) return '🚗';
    if (lower.contains('bike')) return '🏍️';
    if (lower.contains('home') || lower.contains('house')) return '🏠';
    if (lower.contains('marriage') || lower.contains('wedding')) return '💍';
    if (lower.contains('vacation') || lower.contains('travel')) return '✈️';
    if (lower.contains('education') || lower.contains('study')) return '📚';
    if (lower.contains('retirement')) return '🏖️';
    return '🎯';
  }

  @override
  Widget build(BuildContext context) {
    // Fetch goals when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getAllGoals();
    });

    return Scaffold(
      backgroundColor: Ucolors.light,
      appBar: CustomAppBarNormal(
        backgroundColor: Ucolors.light,
        title: 'Goals',
        backIcon: false,
        actionsPadding: 10,
        action: [CompactIcon(icon: Iconsax.info_circle, onPressed: () {})],
      ),
      body: Obx(() {
        // ── Loading ──────────────────────────────────────────────
        if (controller.isLoadingGoals.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final goals = controller.goalResponse.value?.data ?? [];

        // ── Empty State ──────────────────────────────────────────
        if (goals.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Ucolors.skyblue1,
                    child: Icon(
                      Iconsax.note_remove5,
                      color: Ucolors.blue,
                      size: 35,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Ready to start saving?',
                  style: UTextStyles.large.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 4),
                Text(
                  'You haven\'t set any savings goals yet',
                  style: UTextStyles.bodySmall,
                ),
                const SizedBox(height: 25),
                UElevatedBUtton(
                  onPressed: () => Get.toNamed(AppRoutes.ihavegoal),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Create Your First Goal',
                        style: UTextStyles.buttonText,
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.add, color: Ucolors.light),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        // ── Goals Grid ───────────────────────────────────────────
        return RefreshIndicator(
          onRefresh: () => controller.getAllGoals(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Subtitle count
                Text(
                  '${goals.length} Active Goal${goals.length == 1 ? '' : 's'}',
                  style: UTextStyles.bodySmall,
                ),
                const SizedBox(height: 16),

                // 2-column grid
                Expanded(
                  child: GridView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: goals.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.88,
                        ),
                    itemBuilder: (context, index) {
                      final goal = goals[index];

                      final double target =
                          double.tryParse(
                            goal.goalType?.targetAmount.toString() ?? '0',
                          ) ??
                          0.0;
                      final double invested =
                          double.tryParse(
                            goal.goalType?.investedAmount.toString() ?? '0',
                          ) ??
                          0.0;
                      final String name = goal.goalName ?? 'Goal ${index + 1}';

                      return CircularUploadIndicator(
                        goalName: name,
                        targetAmount: target,
                        investedAmount: invested,
                        iconEmoji: _goalEmoji(goal.goalType?.typeName ?? ''),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }),

      // FAB only visible when goals exist
      floatingActionButton: Obx(() {
        final hasGoals = (controller.goalResponse.value?.data ?? []).isNotEmpty;
        if (!hasGoals || controller.isLoadingGoals.value)
          return const SizedBox.shrink();
        return FloatingActionButton(
          onPressed: () => Get.toNamed(AppRoutes.ihavegoal),
          backgroundColor: Ucolors.primary,
          child: const Icon(Icons.add, color: Colors.white),
        );
      }),
    );
  }
}

class CircularUploadIndicator extends StatelessWidget {
  final String goalName;
  final double targetAmount;
  final double investedAmount;
  final String? iconEmoji; // Optional: e.g., "🚗"

  const CircularUploadIndicator({
    super.key,
    required this.goalName,
    required this.targetAmount,
    required this.investedAmount,
    this.iconEmoji,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate percentage (0.0 to 1.0)
    final double percentage = targetAmount > 0
        ? (investedAmount / targetAmount).clamp(0.0, 1.0)
        : 0.0;

    // Format percentage string (e.g., "33%")
    final String percentString = "${(percentage * 100).toStringAsFixed(0)}%";

    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        // Navigate to details if needed, passing ID or data
        Get.toNamed(AppRoutes.goaldetails, arguments: {'goalName': goalName});
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Background Circle (Track)
                CircularPercentIndicator(
                  radius: size.width <= 320
                      ? 60
                      : 70, // Slightly adjusted radius
                  lineWidth: 12,
                  percent: 1.0, // Full circle for background
                  startAngle: 0,
                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: Colors.transparent,
                  progressColor: Colors.grey.shade100,
                ),
                // Progress Circle
                CircularPercentIndicator(
                  center: Container(
                    width: size.width <= 320 ? 80 : 90,
                    height: size.width <= 320 ? 80 : 90,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      iconEmoji ?? "🎯", // Default emoji if null
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                  radius: size.width <= 320 ? 60 : 70,
                  lineWidth: 12,
                  percent: percentage,
                  animation: true,
                  animationDuration: 1000,
                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: Colors.transparent,
                  progressColor: Ucolors.blue, // Ensure Ucolors is imported
                ),

                // Percentage Label (Bottom Right of Circle)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 4),
                      ],
                    ),
                    child: Text(
                      percentString,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // const Gap(12),
            FittedBox(
              child: Text(
                goalName,
                style: UTextStyles.large.copyWith(fontSize: 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // const Gap(4),
            FittedBox(
              child: Text(
                // Simple currency formatting
                '₹ ${targetAmount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                style: UTextStyles.medium.copyWith(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
