
import 'package:flutter/material.dart';
import 'dart:ui_web' as ui_web; // Available in Flutter 3.38+
import 'package:web/web.dart' as web; // Standard web package

/// A widget that renders an image using an HTML <img> tag on Web
/// to bypass CORS restrictions in CanvasKit.
class WebCorsImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final double radius;
  final BoxFit fit;

  const WebCorsImage({
    super.key,
    required this.imageUrl,
    this.width = 40,
    this.height = 40,
    this.radius = 0,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Register a unique view factory for this image URL
    // We use the URL as part of the key to ensure uniqueness if needed,
    // or better: register a generic factory and pass the URL as params.
    // For simplicity in this example, we register a generic 'img-cors' type.

    // Note: We only register this once per app session usually, but re-registering
    // with the same key is safe or ignored in modern Flutter web.
    ui_web.platformViewRegistry.registerViewFactory(
      'img-cors-$imageUrl', // Unique key per image URL to avoid state conflicts
          (int viewId) {
        final web.HTMLImageElement img = web.HTMLImageElement();
        img.src = imageUrl;
        img.style.width = '100%';
        img.style.height = '100%';

        // Handle "object-fit" CSS property to match Flutter's BoxFit
        String objectFit = 'cover';
        if (fit == BoxFit.contain) objectFit = 'contain';
        if (fit == BoxFit.fill) objectFit = 'fill';
        img.style.objectFit = objectFit;

        return img;
      },
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: width,
        height: height,
        child: HtmlElementView(viewType: 'img-cors-$imageUrl'),
      ),
    );
  }
}