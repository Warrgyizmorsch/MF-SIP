import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/constant/appUrl.dart';
import '../../../../core/utils/constant/colors.dart';
import '../../../../core/utils/constant/text_style.dart';

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
  static const progressColor = Color(0xFF213C73);

  final String goalName;
  final double targetAmount;
  final double investedAmount;
  final double? progressPercent;
  final String? iconUrl;
  final String emoji;
  final IconData fallbackIcon;
  final VoidCallback? onTap;

  double get progress {
    final supplied = progressPercent;
    final value = supplied != null && supplied.isFinite && supplied > 0
        ? supplied / 100
        : (targetAmount.isFinite && targetAmount > 0 && investedAmount.isFinite
              ? investedAmount / targetAmount
              : 0.0);
    return value.clamp(0.0, 1.0);
  }

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
                      left: 16,
                      top: 16,
                      width: 145,
                      height: 145,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: progress),
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) => CustomPaint(
                          painter: _GoalArcPainter(value),
                          child: Center(
                            child: Container(
                              width: 71,
                              height: 71,
                              decoration: const BoxDecoration(
                                color: Color(0xFFEDEDED),
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(14),
                              child: ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (bounds) => LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: const [
                                    progressColor,
                                    progressColor,
                                    Color(0xFFBDBDBD),
                                    Color(0xFFBDBDBD),
                                  ],
                                  stops: [0, value, value, 1],
                                ).createShader(bounds),
                                child: child,
                              ),
                            ),
                          ),
                        ),
                        child: _buildImage(),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      top: 120,
                      width: 34,
                      height: 29,
                      child: FittedBox(
                        child: Text(
                          emoji,
                          style: const TextStyle(
                            fontSize: 28,
                            height: 1,
                            fontFamilyFallback: [
                              'Apple Color Emoji',
                              'Segoe UI Emoji',
                              'Noto Color Emoji',
                            ],
                          ),
                        ),
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

  Widget _buildImage() {
    final source = iconUrl?.trim() ?? '';
    final fallback = Icon(
      fallbackIcon,
      size: 43,
      color: const Color(0xFF171717),
    );
    if (source.isEmpty) return fallback;

    final url = source.startsWith('http')
        ? source
        : '${Appurl.baseUrl.replaceFirst(RegExp(r'/+$'), '')}/${source.replaceFirst(RegExp(r'^/+'), '')}';
    return Image.network(
      url,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => fallback,
    );
  }
}

class _GoalArcPainter extends CustomPainter {
  const _GoalArcPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2 - 5;
    final bounds = Rect.fromCircle(center: center, radius: radius);
    const start = 3 * math.pi / 4;
    const sweep = 3 * math.pi / 2;
    final track = Paint()
      ..color = const Color(0xFFEDEDED)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(bounds, start, sweep, false, track);
    if (progress > 0) {
      canvas.drawArc(
        bounds,
        start,
        sweep * progress,
        false,
        track..color = GoalCard.progressColor,
      );
    }

    final dotPaint = Paint()..color = const Color(0xFFEDEDED);
    for (var i = 0; i <= 20; i++) {
      final angle = start + sweep * i / 20;
      canvas.drawCircle(
        center + Offset(math.cos(angle), math.sin(angle)) * (radius - 16),
        1.2,
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_GoalArcPainter oldDelegate) =>
      oldDelegate.progress != progress;
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
