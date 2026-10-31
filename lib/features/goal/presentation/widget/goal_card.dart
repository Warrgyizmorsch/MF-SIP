import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/constant/colors.dart';
import '../../../../core/utils/constant/text_style.dart';
import 'goal_progress_indicator.dart';

/// The reference card uses a 177 × 222 canvas, scaled to its parent's bounds.
class GoalCard extends StatelessWidget {
  const GoalCard({
    super.key,
    required this.goalName,
    required this.targetAmount,
    required this.investedAmount,
    this.progressPercent,
    this.iconUrl,
    this.emoji = '🎯',
    this.fallbackIcon = Icons.flag_rounded,
    this.onTap,
  });

  static const aspectRatio = 177 / 222;
  static const backgroundColor = Color(0xFFFAFAFA);
  static const progressColor = GoalProgressIndicator.defaultColor;

  final String goalName;
  final double targetAmount;
  final double investedAmount;
  final double? progressPercent;
  final String? iconUrl;
  final String emoji;
  final IconData fallbackIcon;
  final VoidCallback? onTap;

  double get progress => calculateGoalProgress(
    targetAmount: targetAmount,
    investedAmount: investedAmount,
    progressPercent: progressPercent,
  );

  String _currency(double amount) =>
      '₹ ${NumberFormat('#,##0', 'en_US').format(amount.isFinite ? amount : 0)}';

  @override
  Widget build(BuildContext context) {
    final invested = _currency(investedAmount);
    final target = _currency(targetAmount);
    final percentage = '${(progress * 100).toStringAsFixed(0)}%';

    return Semantics(
      button: onTap != null,
      onTap: onTap,
      label: '$goalName, $invested saved, target $target, $percentage complete',
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          excludeFromSemantics: true,
          hoverColor: progressColor.withValues(alpha: 0.03),
          child: ExcludeSemantics(
            child: FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: 177,
                height: 222,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      width: 177,
                      height: 164,
                      child: GoalProgressIndicator(
                        progress: progress,
                        iconUrl: iconUrl,
                        emoji: emoji,
                        fallbackIcon: fallbackIcon,
                      ),
                    ),
                    Positioned(
                      left: 21,
                      right: 21,
                      top: 148,
                      height: 15,
                      child: Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(invested, style: _labelStyle),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(percentage, style: _labelStyle),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 12,
                      right: 12,
                      top: 168,
                      height: 23,
                      child: Center(
                        child: Text(
                          goalName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: FontFamily.medium,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF171717),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 12,
                      right: 12,
                      top: 191,
                      height: 21,
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            target,
                            style: const TextStyle(
                              fontFamily: FontFamily.regular,
                              fontSize: 13,
                              color: Color(0xFF171717),
                            ),
                          ),
                        ),
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
  }

  static const _labelStyle = TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: 10,
    color: Color(0xFF9E9E9E),
  );
}

class AddNewGoalButton extends StatelessWidget {
  const AddNewGoalButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: const BoxDecoration(gradient: Ucolors.backgroundGradient),
          child: InkWell(
            onTap: onPressed,
            child: const SizedBox(
              height: 52,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Add New Goal',
                    style: TextStyle(
                      fontFamily: FontFamily.medium,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 12),
                  Icon(Icons.add, color: Colors.white, size: 22),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
