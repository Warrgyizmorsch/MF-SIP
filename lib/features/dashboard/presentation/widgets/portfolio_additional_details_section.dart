import 'package:flutter/material.dart';

import '../../../../core/utils/constant/text_style.dart';

/// Keeps the existing metrics and audit widgets accessible in the details sheet.
class PortfolioAdditionalDetailsSection extends StatelessWidget {
  const PortfolioAdditionalDetailsSection({
    super.key,
    required this.title,
    required this.child,
    this.initiallyExpanded = false,
  });

  final String title;
  final Widget child;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        shape: const Border(),
        collapsedShape: const Border(),
        iconColor: const Color(0xFF441D9E),
        collapsedIconColor: const Color(0xFF441D9E),
        childrenPadding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        title: Text(
          title,
          style: UTextStyles.homeText(
            family: FontFamily.plusJakartaSans,
            size: 14,
            weight: FontWeight.w700,
            color: const Color(0xFF1E293B),
          ),
        ),
        children: [child],
      ),
    ),
  );
}
