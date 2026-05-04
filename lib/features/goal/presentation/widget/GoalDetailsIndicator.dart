import 'package:flutter/material.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CircularGoalIndicatorDetails extends StatelessWidget {
  final bool percentage;
  final String goalName;
  final double targetAmount;
  final double investedAmount;
  final String emoji;
  final String? imageUrl; // For the center image

  const CircularGoalIndicatorDetails({
    super.key,
    this.percentage = false,
    required this.goalName,
    required this.targetAmount,
    required this.investedAmount,
    this.emoji = '🎯',
    this.imageUrl,
  });

  // Helper method to format currency
  String _fmt(double amount) {
    return '₹ ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // 1. Calculate actual progress (0.0 to 1.0)
    final double actualProgress = targetAmount > 0
        ? (investedAmount / targetAmount).clamp(0.0, 1.0)
        : 0.0;

    final String percentStr = "${(actualProgress * 100).toStringAsFixed(0)}%";

    final double trackPercent = 0.77;
    final double fillPercent =
        actualProgress * trackPercent; // Scales progress to fit the arc

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: percentage ? Colors.transparent : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              /// Outer Circular Arc (Grey Track)
              CircularPercentIndicator(
                radius: size.width <= 320 ? 60 : 80,
                lineWidth: 15,
                percent: trackPercent,
                startAngle: 220,
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: Colors.transparent,
                progressColor: Colors.grey.shade200,
              ),

              /// Inner Circular Arc (Blue Progress)
              CircularPercentIndicator(
                center: Container(
                  width: size.width <= 320 ? 60 : 80,
                  height: size.width <= 320 ? 60 : 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                    // Load the user's cover image if it exists
                    image: imageUrl != null && imageUrl!.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(imageUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: imageUrl == null || imageUrl!.isEmpty
                      ? const Icon(Icons.image, color: Colors.grey, size: 30)
                      : null,
                ),
                radius: size.width <= 320 ? 60 : 80,
                lineWidth: 15,
                percent: fillPercent, // Uses the scaled percentage
                startAngle: 220,
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: Colors.transparent,
                progressColor: Ucolors.blue,
              ),

              if (!percentage) ...[
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: Text(_fmt(investedAmount), style: UTextStyles.small),
                ),
                Positioned(
                  right: 15,
                  bottom: 0,
                  child: Text(percentStr, style: UTextStyles.small),
                ),
              ],

              Positioned(
                left: 10,
                bottom: 10,
                child: Text(emoji, style: const TextStyle(fontSize: 30)),
              ),

              if (percentage)
                Positioned(
                  bottom: 0,
                  child: Text(
                    percentStr,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),

          if (!percentage) ...[
            Text(goalName, style: UTextStyles.large),
            Text(
              _fmt(targetAmount),
              style: UTextStyles.medium.copyWith(color: Colors.black),
            ),
          ],
        ],
      ),
    );
  }
}
