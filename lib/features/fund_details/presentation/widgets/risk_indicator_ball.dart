import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../core/utils/constant/text_style.dart';

class RiskLegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const RiskLegendItem({
    super.key,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: isDesktop ? 16 : 9,
          height: isDesktop ? 16 : 9,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: isDesktop
                ? [
              BoxShadow(
                color: color.withValues(alpha:0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ]
                : null,
          ),
        ),
        SizedBox(width: isDesktop ? 10 : 4),
        Text(
          label,
          style:  TextStyle(fontFamily: FontFamily.medium,
            fontSize: isDesktop ? 14 : 11,
            color: isDesktop ? Colors.grey.shade700 : Colors.grey,
            fontWeight: isDesktop ? FontWeight.w500 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}