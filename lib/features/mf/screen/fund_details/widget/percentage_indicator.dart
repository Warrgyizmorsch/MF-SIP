import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PercentageBar extends StatelessWidget {
  final String title;
  final double percentage; // 0–100
  final Color color;

  const PercentageBar({
    super.key,
    required this.title,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            Text(
              '${percentage.toStringAsFixed(2)}%',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 8,
            backgroundColor: Colors.blue.shade50,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
        Gap(10),
      ],
    );
  }
}
