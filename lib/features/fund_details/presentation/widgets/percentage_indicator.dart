// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:responsive_framework/responsive_framework.dart';

// class PercentageBar extends StatelessWidget {
//   final String title;
//   final double percentage; // 0–100
//   final Color color;

//   const PercentageBar({
//     super.key,
//     required this.title,
//     required this.percentage,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Text(
//                 title,
//                 style:  TextStyle(fontFamily: FontFamily.medium,
//                   fontSize: isDesktop ? 15 : 14,
//                   fontWeight: isDesktop ? FontWeight.w500 : FontWeight.w500,
//                   color: Colors.grey.shade800,
//                 ),
//               ),
//             ),
//             Text(
//               '${percentage.toStringAsFixed(2)}%',
//               style:  TextStyle(fontFamily: FontFamily.medium,
//                 fontSize: isDesktop ? 15 : 14,
//                 fontWeight: FontWeight.w600,
//                 color: color,
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: isDesktop ? 12 : 8),
//         Container(
//           height: isDesktop ? 10 : 8,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(isDesktop ? 12 : 10),
//             color: color.withValues(alpha:0.1),
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(isDesktop ? 12 : 10),
//             child: Stack(
//               children: [
//                 // Background
//                 Container(width: double.infinity, color: Colors.grey.shade100),
//                 // Progress with gradient
//                 FractionallySizedBox(
//                   // widthFactor: percentage / 100,
//                   widthFactor: ((percentage ?? 0) / 100).clamp(0.0, 1.0),

//                   child: Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [color, color.withValues(alpha:0.8)],
//                         begin: Alignment.centerLeft,
//                         end: Alignment.centerRight,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Gap(isDesktop ? 16 : 10),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../core/utils/constant/text_style.dart';

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
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    final progress = (percentage / 100).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style:  TextStyle(fontFamily: FontFamily.medium,
                  fontSize: isDesktop ? 15 : 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            Text(
              '${percentage.toStringAsFixed(2)}%',
              style:  TextStyle(fontFamily: FontFamily.medium,
                fontSize: isDesktop ? 15 : 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),

        SizedBox(height: isDesktop ? 12 : 8),

        Container(
          height: isDesktop ? 10 : 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(isDesktop ? 12 : 10),
            color: color.withValues(alpha:0.1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(isDesktop ? 12 : 10),
            child: Stack(
              children: [
                Container(width: double.infinity, color: Colors.grey.shade100),

                /// Animated Progress
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOutCubic,
                  tween: Tween(begin: 0, end: progress),
                  builder: (context, value, child) {
                    return FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: value,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [color, color.withValues(alpha:0.8)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),

        Gap(isDesktop ? 16 : 10),
      ],
    );
  }
}
