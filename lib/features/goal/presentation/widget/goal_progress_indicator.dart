import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/utils/constant/appUrl.dart';
import '../../../../core/utils/constant/text_style.dart';

double calculateGoalProgress({
  required double targetAmount,
  required double investedAmount,
  double? progressPercent,
}) {
  final value =
      progressPercent != null && progressPercent.isFinite && progressPercent > 0
      ? progressPercent / 100
      : (targetAmount.isFinite && targetAmount > 0 && investedAmount.isFinite
            ? investedAmount / targetAmount
            : 0.0);
  return value.clamp(0.0, 1.0);
}

/// Shared geometry keeps the marker on the painted arc throughout animation.
class GoalProgressIndicator extends StatelessWidget {
  const GoalProgressIndicator({
    super.key,
    required this.progress,
    this.iconUrl,
    this.emoji = '🎯',
    this.fallbackIcon = Icons.flag_rounded,
    this.animateMarker = false,
    this.showPercentage = false,
    this.color = defaultColor,
    this.duration = const Duration(milliseconds: 500),
  });

  static const defaultColor = Color(0xFF213C73);
  static const _startAngle = 3 * math.pi / 4;
  static const _sweepAngle = 3 * math.pi / 2;
  static const _center = Offset(88.5, 88.5);
  static const _radius = 67.5;

  final double progress;
  final String? iconUrl;
  final String emoji;
  final IconData fallbackIcon;
  final bool animateMarker;
  final bool showPercentage;
  final Color color;
  final Duration duration;

  String _percentage(double value) {
    final percent = value * 100;
    final decimals = percent > 0 && percent < 1
        ? 2
        : (percent > 0 && percent < 10 ? 1 : 0);
    return '${percent.toStringAsFixed(decimals)}%';
  }

  @override
  Widget build(BuildContext context) {
    final safeProgress = progress.isFinite ? progress.clamp(0.0, 1.0) : 0.0;
    final height = showPercentage ? 183.0 : 164.0;
    return Semantics(
      label: '${_percentage(safeProgress)} complete',
      child: ExcludeSemantics(
        child: AspectRatio(
          aspectRatio: 177 / height,
          child: FittedBox(
            child: SizedBox(
              width: 177,
              height: height,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: safeProgress),
                duration: duration,
                curve: Curves.easeOutCubic,
                child: _buildImage(),
                builder: (context, value, image) {
                  final angle = _startAngle + _sweepAngle * value;
                  final marker =
                      _center +
                      Offset(math.cos(angle), math.sin(angle)) * _radius;
                  return Stack(
                    children: [
                      Positioned(
                        left: 16,
                        top: 16,
                        width: 145,
                        height: 145,
                        child: CustomPaint(
                          painter: _GoalArcPainter(value, color),
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
                                  colors: [
                                    color,
                                    color,
                                    const Color(0xFFBDBDBD),
                                    const Color(0xFFBDBDBD),
                                  ],
                                  stops: [0, value, value, 1],
                                ).createShader(bounds),
                                child: image,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (animateMarker)
                        Positioned(
                          left: marker.dx - 16,
                          top: marker.dy - 16,
                          child: Container(
                            width: 32,
                            height: 32,
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x1A000000),
                                  blurRadius: 5,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: _buildEmoji(),
                          ),
                        )
                      else
                        Positioned(
                          left: 20,
                          top: 120,
                          width: 34,
                          height: 29,
                          child: _buildEmoji(),
                        ),
                      if (showPercentage)
                        Positioned(
                          left: 15,
                          right: 12,
                          top: 140,
                          height: 29,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              _percentage(value),
                              style: TextStyle(
                                fontFamily: FontFamily.medium,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: color,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmoji() => FittedBox(
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
  );

  Widget _buildImage() {
    final source = iconUrl?.trim() ?? '';
    final fallback = Icon(fallbackIcon, size: 43, color: Colors.black);
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
  const _GoalArcPainter(this.progress, this.color);

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final bounds = Rect.fromCircle(
      center: center,
      radius: GoalProgressIndicator._radius,
    );
    final track = Paint()
      ..color = const Color(0xFFEDEDED)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      bounds,
      GoalProgressIndicator._startAngle,
      GoalProgressIndicator._sweepAngle,
      false,
      track,
    );
    if (progress > 0) {
      canvas.drawArc(
        bounds,
        GoalProgressIndicator._startAngle,
        GoalProgressIndicator._sweepAngle * progress,
        false,
        track..color = color,
      );
    }
    final dots = Paint()..color = const Color(0xFFEDEDED);
    for (var i = 0; i <= 20; i++) {
      final angle =
          GoalProgressIndicator._startAngle +
          GoalProgressIndicator._sweepAngle * i / 20;
      canvas.drawCircle(
        center +
            Offset(math.cos(angle), math.sin(angle)) *
                (GoalProgressIndicator._radius - 16),
        1.2,
        dots,
      );
    }
  }

  @override
  bool shouldRepaint(_GoalArcPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
