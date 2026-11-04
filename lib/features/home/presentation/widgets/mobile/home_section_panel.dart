import 'package:flutter/material.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/shadows.dart';
import 'package:my_sip/core/utils/constant/sizes.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';

import 'home_section_header.dart';

class HomeSectionPanel extends StatelessWidget {
  const HomeSectionPanel({
    super.key,
    required this.title,
    required this.scale,
    required this.child,
    this.bottomPadding = 23,
    this.onSeeAll,
  });

  final String title;
  final double scale;
  final Widget child;
  final double bottomPadding;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Ucolors.white,
      borderRadius: BorderRadius.circular(USizes.homePanelRadius * scale),
      border: Border.all(color: Ucolors.homePanelBorder, width: 0.636),
      boxShadow: UShadows.homePanel,
    ),
    padding: EdgeInsets.fromLTRB(
      USizes.homePanelPadding * scale,
      (onSeeAll == null ? 15 : 5) * scale,
      USizes.homePanelPadding * scale,
      bottomPadding * scale,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onSeeAll != null)
          HomeSectionHeader(
            title: title,
            action: 'See all',
            actionSize: 11,
            onAction: onSeeAll!,
            scale: scale,
          )
        else
          Text(
            title,
            style: UTextStyles.homeText(
              size: (16 * scale).clamp(14.0, 19.0).toDouble(),
              height: 1.5,
            ),
          ),
        SizedBox(height: (onSeeAll == null ? 16 : 6) * scale),
        child,
      ],
    ),
  );
}
