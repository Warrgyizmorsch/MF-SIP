import 'package:flutter/material.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';

class HomeTrustFooter extends StatelessWidget {
  const HomeTrustFooter({super.key, required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: BoxConstraints(minHeight: 137 * scale),
    child: Stack(
      children: [
        Positioned(
          top: 0,
          right: 0,
          bottom: 0,
          width: 376 * scale,
          child: ExcludeSemantics(
            child: Transform.flip(
              flipX: true,
              child: ClipRect(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned(
                      left: -0.1 * scale,
                      top: -44.62 * scale,
                      width: 376.2 * scale,
                      height: 223 * scale,
                      child: Image.asset(
                        UImages.homeTrustBackground,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: Ucolors.homeTrustHorizontalGradient,
                      ),
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: Ucolors.homeTrustVerticalGradient,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            27 * scale,
            25 * scale,
            27 * scale,
            22 * scale,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Trusted by',
                style: UTextStyles.homeText(
                  size: (12 * scale).clamp(11.0, 14.0).toDouble(),
                  weight: FontWeight.w600,
                  color: Ucolors.homeTrustText,
                  height: 2,
                ),
              ),
              SizedBox(height: 8 * scale),
              Text(
                '10 Lakh+ Indians',
                style: UTextStyles.homeText(
                  size: (22 * scale).clamp(20.0, 26.0).toDouble(),
                  weight: FontWeight.w700,
                  color: Ucolors.homeInk,
                  height: 24 / 22,
                ),
              ),
              SizedBox(height: 10 * scale),
              Text(
                'Made with ❤️ by MF SIP',
                style: UTextStyles.homeText(
                  size: (13 * scale).clamp(12.0, 15.0).toDouble(),
                  color: Ucolors.homeTrustText,
                  height: 24 / 13,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
