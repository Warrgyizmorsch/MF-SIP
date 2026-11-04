import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/shadows.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';

import 'home_design.dart';

/// The navigation shell displays this reference styling while Home is active.
class HomeBottomNavigation extends StatelessWidget {
  const HomeBottomNavigation({
    super.key,
    required this.onSelected,
    this.selectedIndex = 0,
  });

  final ValueChanged<int> onSelected;
  final int selectedIndex;

  static const _items = [
    (label: 'Home', icon: UImages.homeNavHome),
    (label: 'Explore', icon: UImages.homeNavExplore),
    (label: 'Dashboard', icon: UImages.homeNavDashboard),
    (label: 'Goal', icon: UImages.homeNavGoals),
    (label: 'Profile', icon: UImages.homeNavProfile),
  ];

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(
      color: Ucolors.homeNavigation,
      border: Border(
        top: BorderSide(color: Ucolors.homeCardBorder, width: 0.636),
      ),
    ),
    child: SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: 13),
      child: Center(
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: HomeMetrics.maxContentWidth,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final scale = (constraints.maxWidth / HomeMetrics.referenceWidth)
                  .clamp(0.7, 1.2)
                  .toDouble();
              final labelWidth = HomeTextLayout.measure(
                context,
                'Dashboard',
                style: UTextStyles.homeText(
                  family: FontFamily.regular,
                  size: 10,
                  height: 1.5,
                  letterSpacing: -0.1,
                ),
              ).width;
              final inset = math.max(
                8 * scale,
                math.min(
                  28.65 * scale,
                  (constraints.maxWidth - (labelWidth + 8 * scale) * 5) / 2,
                ),
              );
              return Padding(
                padding: EdgeInsets.fromLTRB(inset, 12, inset, 0),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: List.generate(_items.length, (index) {
                      final selected = selectedIndex == index;
                      final item = _items[index];
                      final color = selected
                          ? Ucolors.homeSelectedNavigation
                          : Ucolors.homeNavigationText;
                      return Expanded(
                        child: Semantics(
                          selected: selected,
                          button: true,
                          label: item.label,
                          excludeSemantics: true,
                          onTap: () => onSelected(index),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: selected
                                  ? Ucolors.homeSelectedNavigationGradient
                                  : null,
                              boxShadow: selected
                                  ? UShadows.homeSelectedNavigation
                                  : null,
                            ),
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                onTap: () => onSelected(index),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        item.icon,
                                        width: 20,
                                        height: 20,
                                        colorFilter: ColorFilter.mode(
                                          color,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        item.label,
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: UTextStyles.homeText(
                                          family: FontFamily.regular,
                                          size: 10,
                                          height: 1.5,
                                          letterSpacing: -0.1,
                                          color: color,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    ),
  );
}
