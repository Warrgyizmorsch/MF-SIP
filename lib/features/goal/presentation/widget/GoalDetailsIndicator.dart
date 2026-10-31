import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/goal_sip_controller.dart';
import 'goal_card.dart';
import 'goal_progress_indicator.dart';

/// Adapts live goal details to the same visuals used by the goal cards.
class CircularGoalIndicatorDetails extends StatelessWidget {
  const CircularGoalIndicatorDetails({
    super.key,
    this.percentage = false,
    required this.goalName,
    required this.goalType,
    required this.targetAmount,
    required this.investedAmount,
    this.progressPercent,
    this.emoji = '🎯',
    required this.imageUrl,
    this.progressColor,
  });

  final bool percentage;
  final String goalName;
  final String goalType;
  final double targetAmount;
  final double investedAmount;
  final double? progressPercent;
  final String emoji;
  final String imageUrl;
  final Color? progressColor;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GoalSipController>();
    final type = '$goalType $goalName';
    final bike = type.toLowerCase().contains('bike');
    final fallback = bike
        ? Icons.two_wheeler_rounded
        : controller.getGoalIcon(type);
    if (!percentage) {
      return SizedBox(
        width: 224,
        child: AspectRatio(
          aspectRatio: GoalCard.aspectRatio,
          child: GoalCard(
            goalName: goalName,
            targetAmount: targetAmount,
            investedAmount: investedAmount,
            progressPercent: progressPercent,
            iconUrl: imageUrl,
            emoji: emoji,
            fallbackIcon: fallback,
          ),
        ),
      );
    }
    return SizedBox(
      width: 224,
      child: GoalProgressIndicator(
        progress: calculateGoalProgress(
          targetAmount: targetAmount,
          investedAmount: investedAmount,
          progressPercent: progressPercent,
        ),
        iconUrl: imageUrl,
        emoji: emoji,
        fallbackIcon: fallback,
        animateMarker: true,
        showPercentage: true,
        color: progressColor ?? GoalProgressIndicator.defaultColor,
        duration: const Duration(milliseconds: 1200),
      ),
    );
  }
}
