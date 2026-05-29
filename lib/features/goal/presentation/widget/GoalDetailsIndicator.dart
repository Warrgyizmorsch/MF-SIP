import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../core/utils/constant/text_style.dart';
import '../controller/goal_sip_controller.dart';

class CircularGoalIndicatorDetails extends StatelessWidget {
  final bool percentage;
  final String goalName;
  final String goalType;
  final double targetAmount;
  final double investedAmount;
  final String emoji;
  final String imageUrl;

  const CircularGoalIndicatorDetails({
    super.key,
    this.percentage = false,
    required this.goalName,
    required this.goalType,
    required this.targetAmount,
    required this.investedAmount,
    this.emoji = '🎯',
    required this.imageUrl,
  });

  String _fmt(double amount) {
    return '₹ ${amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
    )}';
  }



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final GoalSipController controller = Get.find<GoalSipController>();
    final Color goalColor =controller. getGoalColor(goalType);

    final double actualProgress =
    targetAmount > 0 ? (investedAmount / targetAmount).clamp(0.0, 1.0) : 0.0;

    final String percentStr = "${(actualProgress * 100).toStringAsFixed(0)}%";

    final double radius = size.width <= 320 ? 60 : 80;
    final double lineWidth = 15;

    // Start angle of CircularPercentIndicator
    final double startAngle = 220;

    // Sweep angle in degrees
    final double sweepAngle = 360 * actualProgress * 0.77;

    // Convert end angle to radians for emoji positioning
    final double radians = (startAngle + sweepAngle - 90) * (math.pi / 180);

    // Emoji radius should include half lineWidth so it sits on stroke
    final double emojiRadius = radius - 2;

    final double emojiX = emojiRadius * math.cos(radians);
    final double emojiY = emojiRadius * math.sin(radians);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: percentage ? Colors.transparent : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          SizedBox(
            width: radius * 2.8,
            height: radius * 2.4,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Grey background track
                CircularPercentIndicator(
                  radius: radius,
                  lineWidth: lineWidth,
                  percent: 0.77,
                  startAngle: startAngle,
                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: Colors.grey.shade200,
                  progressColor: Colors.grey.shade200,
                ),

                // Colored progress
                CircularPercentIndicator(
                  radius: radius,
                  lineWidth: lineWidth,
                  percent: actualProgress * 0.77,
                  startAngle: startAngle,
                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: Colors.transparent,
                  progressColor: goalColor,
                  center: Container(
                    width: radius,
                    height: radius,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade100,
                    ),
                    child: ClipOval(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (imageUrl.isNotEmpty)
                            ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                Colors.grey.shade300,
                                BlendMode.modulate,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => Icon(
                                    Icons.flag,
                                    size: 35,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          if (imageUrl.isNotEmpty)
                            ShaderMask(
                              blendMode: BlendMode.srcIn,
                              shaderCallback: (Rect bounds) => LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                stops: [0.0, actualProgress, actualProgress, 1.0],
                                colors: [goalColor, goalColor, Colors.transparent, Colors.transparent],
                              ).createShader(bounds),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => Icon(
                                    Icons.flag,
                                    size: 35,
                                    color: goalColor,
                                  ),
                                ),
                              ),
                            ),
                          if (imageUrl.isEmpty)
                            Text(
                              emoji,
                              style: const TextStyle(fontFamily: FontFamily.medium,fontSize: 34),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Moving emoji along progress
                Transform.translate(
                  offset: Offset(emojiX, emojiY),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Text(
                      emoji,
                      style: const TextStyle(fontFamily: FontFamily.medium,fontSize: 22),
                    ),
                  ),
                ),

                if (percentage)
                  Positioned(
                    bottom: 0,
                    child: Text(
                      percentStr,
                      style: TextStyle(fontFamily: FontFamily.medium,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: goalColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (!percentage) ...[
            const SizedBox(height: 10),
            Text(
              goalName,
              style: const TextStyle(fontFamily: FontFamily.medium,fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text(
              _fmt(targetAmount),
              style: const TextStyle(fontFamily: FontFamily.medium,color: Colors.black, fontSize: 14),
            ),
          ],
        ],
      ),
    );
  }
}