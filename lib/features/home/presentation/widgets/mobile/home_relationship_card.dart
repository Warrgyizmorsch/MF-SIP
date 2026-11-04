import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/shadows.dart';
import 'package:my_sip/core/utils/constant/sizes.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/personalization/presentation/widgets/help_support.dart';

import 'home_design.dart';

/// Uses the reference contact-card layout. An assigned RM is not present in the
/// profile contract, so the card identifies the existing support team instead.
class HomeRelationshipCard extends StatelessWidget {
  const HomeRelationshipCard({super.key, required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) => Container(
    constraints: BoxConstraints(minHeight: 142 * scale),
    padding: EdgeInsets.fromLTRB(
      28 * scale,
      15 * scale,
      33 * scale,
      15 * scale,
    ),
    decoration: BoxDecoration(
      color: Ucolors.homePanel,
      border: Border.all(color: Ucolors.homePanelBorder, width: 0.636),
      borderRadius: BorderRadius.circular(USizes.homePanelRadius * scale),
      boxShadow: UShadows.homePanel,
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Here to help 👋',
                style: UTextStyles.homeText(
                  size: (16 * scale).clamp(14.0, 19.0).toDouble(),
                  weight: FontWeight.w600,
                  color: Ucolors.homeInk,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 3 * scale),
              SizedBox(
                width: 159 * scale,
                child: Text(
                  'Your investment support team, just a tap away!',
                  style: UTextStyles.homeText(
                    size: (11 * scale).clamp(10.0, 13.0).toDouble(),
                    color: Ucolors.homeSupportDescription,
                    height: 18 / 11,
                  ),
                ),
              ),
              SizedBox(height: 5 * scale),
              Semantics(
                button: true,
                label: 'Contact support',
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Get.to(() => const HelpSupportScreen()),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 108,
                      minHeight: 44,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      widthFactor: 1,
                      heightFactor: 1,
                      child: Container(
                        constraints: BoxConstraints(minHeight: 31 * scale),
                        padding: EdgeInsets.symmetric(
                          horizontal: 11 * scale,
                          vertical: 7 * scale,
                        ),
                        alignment: Alignment.center,
                        width: math.max(
                          (108 * scale).clamp(108.0, 130.0).toDouble(),
                          HomeTextLayout.measure(
                                context,
                                'Contact support',
                                style: UTextStyles.homeText(
                                  family: FontFamily.regular,
                                  size: (10 * scale)
                                      .clamp(10.0, 12.0)
                                      .toDouble(),
                                  weight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ).width +
                              22 * scale,
                        ),
                        decoration: BoxDecoration(
                          color: Ucolors.homeInk,
                          borderRadius: BorderRadius.circular(8 * scale),
                          boxShadow: UShadows.homeSupportButton,
                        ),
                        child: Text(
                          'Contact support',
                          textAlign: TextAlign.center,
                          style: UTextStyles.homeText(
                            family: FontFamily.regular,
                            size: (10 * scale).clamp(10.0, 12.0).toDouble(),
                            weight: FontWeight.w600,
                            color: Ucolors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 14 * scale),
        ExcludeSemantics(
          child: SizedBox.square(
            dimension: 82 * scale,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: Transform.translate(
                    offset: Offset(-10 * scale, 0),
                    child: Transform.rotate(
                      angle: -math.pi / 12,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: Ucolors.homeSupportBackdropGradient,
                          border: Border.all(
                            color: Ucolors.homeSupportBackdropBorder,
                          ),
                          borderRadius: BorderRadius.circular(10 * scale),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Ucolors.white,
                      borderRadius: BorderRadius.circular(10 * scale),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8 * scale),
                      child: Image.asset(
                        UImages.homeRelationshipManager,
                        fit: BoxFit.cover,
                        alignment: const Alignment(0.22, 0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
