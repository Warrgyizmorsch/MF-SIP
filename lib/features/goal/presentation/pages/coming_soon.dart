import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:get/get.dart';
import 'package:my_sip/navigation_menu_bar.dart';

class ComingSoon extends StatelessWidget {
  const ComingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isDesktop = size.width > 600;

    final List<Shadow> longShadow = List.generate(
      120,
      (index) => Shadow(
        color: const Color(0xFF1B3D4F),
        offset: Offset(0, (index + 1).toDouble()),
      ),
    );

    final navController = Get.find<NavigationBarController>();

    return Scaffold(
      backgroundColor: const Color(0xFF245167),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: size.height * (isDesktop ? 0.35 : 0.25),
            child: const _CloudLayers(),
          ),

          // Yellow Plane (Left)
          Positioned(
            left: size.width * (isDesktop ? 0.15 : 0.05),
            top: size.height * (isDesktop ? 0.35 : 0.20),
            child: _PaperPlane(
              width: isDesktop ? 80 : 50,
              mainColor: const Color(0xFFFDC02F),
              wingColor: const Color(0xFFE0A800),
              shadowLength: isDesktop ? 60 : 30,
            ),
          ),

          // Red Plane (Right)
          Positioned(
            right: size.width * (isDesktop ? 0.15 : 0.08),
            top: size.height * (isDesktop ? 0.55 : 0.65),
            child: _PaperPlane(
              width: isDesktop ? 60 : 45, // Mobile pe plane chhota
              mainColor: const Color(0xFFE74C3C),
              wingColor: const Color(0xFFC0392B),
              shadowLength: isDesktop ? 50 : 25,
            ),
          ),

          if (isDesktop)
            Positioned(
              right: size.width * 0.35,
              bottom: size.height * 0.25,
              child: const _PaperPlane(
                width: 40,
                mainColor: Color(0xFF48C9B0),
                wingColor: Color(0xFF1ABC9C),
                shadowLength: 30,
              ),
            ),

          // ==========================================
          Positioned.fill(
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // HEADING
                        Text(
                          "COMING\nSOON",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w900,
                            fontSize: isDesktop ? 80 : 48,
                            height: 1.1,
                            letterSpacing: isDesktop ? 10 : 5,
                            color: Colors.white,
                            shadows: longShadow,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // SUBHEADING
                        Text(
                          "Get ready! Something really cool is coming!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isDesktop ? 18 : 16,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // SUBSCRIPTION FORM
                        SizedBox(
                          width: isDesktop ? 450 : double.infinity,
                          child: isDesktop
                              ? Column(
                                  children: [
                                    IntrinsicHeight(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Expanded(child: _buildEmailInput()),
                                          _buildNotifyButton(),
                                        ],
                                      ),
                                    ),
                                    if (navController.selectedIndex.value != 3)
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.maybePop(context),
                                        // Navigator.pop(context),
                                        child: Text(
                                          'Back',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    _buildEmailInput(),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 56,
                                      child: _buildNotifyButton(),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 56,
                                      child: TextButton(
                                        onPressed: () =>
                                            Navigator.maybePop(context),
                                        child: Text(
                                          'Back',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),

                        // Bottom spacing
                        SizedBox(
                          height: size.height * (isDesktop ? 0.10 : 0.05),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Input Field Widget
  Widget _buildEmailInput() {
    return TextField(
      style: const TextStyle(color: Colors.white),
      cursorColor: const Color(0xFFFDC02F),
      decoration: InputDecoration(
        hintText: "Your Email",
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFFDC02F), width: 2),
          borderRadius: BorderRadius.zero,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2),
          borderRadius: BorderRadius.zero,
        ),
      ),
    );
  }

  // Button Widget
  Widget _buildNotifyButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFDC02F),
        foregroundColor: const Color(0xFF245167),
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
        side: const BorderSide(color: Color(0xFFFDC02F), width: 2),
      ),
      child: const Text(
        "Notify Me",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _PaperPlane extends StatelessWidget {
  final double width;
  final Color mainColor;
  final Color wingColor;
  final int shadowLength;

  const _PaperPlane({
    required this.width,
    required this.mainColor,
    required this.wingColor,
    required this.shadowLength,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, width * 1.5),
      painter: _PlanePainter(
        mainColor: mainColor,
        wingColor: wingColor,
        shadowLength: shadowLength,
      ),
    );
  }
}

class _PlanePainter extends CustomPainter {
  final Color mainColor;
  final Color wingColor;
  final int shadowLength;

  _PlanePainter({
    required this.mainColor,
    required this.wingColor,
    required this.shadowLength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final shadowPaint = Paint()..color = const Color(0xFF1B3D4F);
    final mainPaint = Paint()..color = mainColor;
    final wingPaint = Paint()..color = wingColor;

    Path bodyPath = Path()
      ..moveTo(size.width * 0.5, 0)
      ..lineTo(size.width, size.width)
      ..lineTo(size.width * 0.5, size.width * 0.75)
      ..lineTo(0, size.width)
      ..close();

    Path wingPath = Path()
      ..moveTo(size.width * 0.5, 0)
      ..lineTo(size.width, size.width)
      ..lineTo(size.width * 0.5, size.width * 0.75)
      ..close();

    for (int i = 1; i <= shadowLength; i += 2) {
      canvas.save();
      canvas.translate(0, i.toDouble());
      canvas.drawPath(bodyPath, shadowPaint);
      canvas.restore();
    }

    canvas.drawPath(bodyPath, mainPaint);
    canvas.drawPath(wingPath, wingPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CloudLayers extends StatelessWidget {
  const _CloudLayers();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.infinite, painter: _WavyCloudPainter());
  }
}

class _WavyCloudPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    _drawWave(
      canvas,
      size,
      const Color(0xFF7A9EB1),
      0.6,
      2.5,
      0,
    ); // Back Dark Layer
    _drawWave(
      canvas,
      size,
      const Color(0xA2B9C6).withOpacity(1),
      0.45,
      2.0,
      1.5,
    ); // Mid Layer
    _drawWave(
      canvas,
      size,
      const Color(0xFFE2E8F0),
      0.25,
      1.5,
      3.0,
    ); // Front Light Layer
  }

  void _drawWave(
    Canvas canvas,
    Size size,
    Color color,
    double heightFraction,
    double frequency,
    double phaseOffset,
  ) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final baseY = size.height * (1 - heightFraction);
    final amplitude = size.height * 0.15;

    path.moveTo(0, size.height);
    path.lineTo(0, baseY);

    for (double i = 0; i <= size.width; i++) {
      // Calculate sine wave
      final xRatio = i / size.width;
      final y =
          baseY +
          math.sin((xRatio * math.pi * 2 * frequency) + phaseOffset) *
              amplitude;
      path.lineTo(i, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
