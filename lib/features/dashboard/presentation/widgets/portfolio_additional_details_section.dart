import 'package:flutter/material.dart';

import '../../../../core/utils/constant/colors.dart';
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
      color: Ucolors.white,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        shape: const Border(),
        collapsedShape: const Border(),
        iconColor: Ucolors.portfolioAccent,
        collapsedIconColor: Ucolors.portfolioAccent,
        childrenPadding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        title: Text(
          title,
          style: UTextStyles.portfolioText(
            size: 14,
            weight: FontWeight.w700,
            color: Ucolors.portfolioHeading,
          ),
        ),
        children: [child],
      ),
    ),
  );
}
