import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';

/// A 44px action target with the reference's compact, vertically centred label.
class HomeSectionHeader extends StatelessWidget {
  const HomeSectionHeader({
    super.key,
    required this.title,
    required this.action,
    required this.onAction,
    required this.scale,
    this.actionSize = 13,
  });

  final String title;
  final String action;
  final VoidCallback onAction;
  final double scale;
  final double actionSize;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: BoxConstraints(
      minHeight: (44 * scale).clamp(44.0, 53.0).toDouble(),
    ),
    child: Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: UTextStyles.homeText(
              size: (16 * scale).clamp(14.0, 19.0).toDouble(),
              height: 1.5,
            ),
          ),
        ),
        TextButton(
          onPressed: onAction,
          style: TextButton.styleFrom(
            padding: EdgeInsets.only(left: 12 * scale),
            minimumSize: const Size(64, 44),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            foregroundColor: Ucolors.homeTextMuted,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                action,
                style: UTextStyles.homeText(
                  size: (actionSize * scale)
                      .clamp(actionSize - 1, actionSize + 2)
                      .toDouble(),
                  color: Ucolors.homeTextMuted,
                  height: 24 / actionSize,
                ),
              ),
              SizedBox(width: 7 * scale),
              SvgPicture.asset(
                UImages.homeSectionChevron,
                width: 4.5 * scale,
                height: 8 * scale,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
