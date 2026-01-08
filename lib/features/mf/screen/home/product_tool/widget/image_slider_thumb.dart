import 'package:flutter/material.dart';

class ImageSliderThumb extends SliderComponentShape {
  final double thumbRadius;
  final ImageProvider image;

  const ImageSliderThumb({required this.thumbRadius, required this.image});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    /// Draw white circle
    final Paint paint = Paint()
      ..color = Colors.grey.shade100
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, thumbRadius, paint);

    /// Draw image inside
    final imageSize = thumbRadius * 1.2;

    final Rect imageRect = Rect.fromCenter(
      center: center,
      width: imageSize,
      height: imageSize,
    );

    final paintImage = Paint();

    paintImageShader(canvas, imageRect);
  }

  void paintImageShader(Canvas canvas, Rect rect) async {
    final imageStream = image.resolve(const ImageConfiguration());
    final listener = ImageStreamListener((imageInfo, _) {
      final paint = Paint();
      canvas.drawImageRect(
        imageInfo.image,
        Rect.fromLTWH(
          0,
          0,
          imageInfo.image.width.toDouble(),
          imageInfo.image.height.toDouble(),
        ),
        rect,
        paint,
      );
    });

    imageStream.addListener(listener);
  }
}
