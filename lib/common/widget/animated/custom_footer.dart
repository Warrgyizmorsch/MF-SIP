import 'package:flutter/material.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';

class CustomFooter extends StatefulWidget {
  const CustomFooter({super.key});

  @override
  State<CustomFooter> createState() => _CustomFooterState();
}

class _CustomFooterState extends State<CustomFooter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final String _text =
      "AMFI registered mutual fund distributor   ||   ARN : 104807 | Kriti Hinger   ||   ";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 5),
      color: Ucolors.light,
      child: ClipRect(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return CustomPaint(
              painter: _MarqueePainter(
                text: _text,
                progress: _animation.value,
                textStyle: UTextStyles.small.copyWith(fontSize: 12),
                // TextStyle(
                //   fontSize: 12,
                //   color: Colors.grey.shade700,
                //   // fontWeight: FontWeight.w500,
                // ),
              ),
              size: const Size(double.infinity, 20),
            );
          },
        ),
      ),
    );
  }
}

class _MarqueePainter extends CustomPainter {
  final String text;
  final double progress;
  final TextStyle textStyle;

  _MarqueePainter({
    required this.text,
    required this.progress,
    required this.textStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();

    final textWidth = textPainter.width;
    final offset = -progress * textWidth;

    // Draw two copies for seamless loop
    textPainter.paint(
      canvas,
      Offset(offset, (size.height - textPainter.height) / 2),
    );
    textPainter.paint(
      canvas,
      Offset(offset + textWidth, (size.height - textPainter.height) / 2),
    );
  }

  @override
  bool shouldRepaint(_MarqueePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
