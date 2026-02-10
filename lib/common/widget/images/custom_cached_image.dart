import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'web_image_stub.dart'
if (dart.library.js_interop) 'web_image_helper.dart';

class CustomCachedImage extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final double radius;

  const CustomCachedImage({
    super.key,
    required this.imageUrl,
    this.size = 40.0,
    this.radius = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildErrorWidget();
    }

    // --- WEB IMPLEMENTATION ---
    if (kIsWeb) {
      // The compiler now knows WebCorsImage exists from one of the two imports above
      return WebCorsImage(
        imageUrl: imageUrl!,
        width: size,
        height: size,
        radius: radius,
        fit: BoxFit.cover,
      );
    }

    // --- MOBILE IMPLEMENTATION ---
    // (Your existing mobile logic)
    final double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final int cacheSize = (size * pixelRatio).toInt();

    return CachedNetworkImage(
      imageUrl: imageUrl!,
      width: size,
      height: size,
      fit: BoxFit.cover,
      memCacheHeight: cacheSize,
      memCacheWidth: cacheSize,
      fadeInDuration: const Duration(milliseconds: 300),
      placeholder: (context, url) => _buildPlaceholder(),
      errorWidget: (context, url, error) => _buildErrorWidget(),
    );
  }

  Widget _buildPlaceholder() {
    return Container(width: size, height: size, color: Colors.grey.shade100);
  }

  Widget _buildErrorWidget() {
    return Container(
      width: size,
      height: size,
      color: Colors.grey.shade200,
      child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
    );
  }
}