import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'web_image_stub.dart'
if (dart.library.js_interop) 'web_image_helper.dart';

class CustomCachedImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final double? size; // Keeps backward compatibility
  final double radius;
  final BoxFit fit;

  const CustomCachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.size,
    this.radius = 20.0,
    this.fit = BoxFit.cover, // Default to cover
  });

  @override
  Widget build(BuildContext context) {
    // 1. Determine effective dimensions
    // If width/height are provided, use them. Otherwise, fall back to size, then 40.0.
    final double effectiveWidth = width ?? size ?? 40.0;
    final double effectiveHeight = height ?? size ?? 40.0;

    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildErrorWidget(effectiveWidth, effectiveHeight);
    }

    // --- WEB IMPLEMENTATION ---
    if (kIsWeb) {
      return WebCorsImage(
        imageUrl: imageUrl!,
        width: effectiveWidth,
        height: effectiveHeight,
        radius: radius,
        fit: fit,
      );
    }

    // --- MOBILE IMPLEMENTATION ---
    final double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    // 2. CRITICAL FIX: Only set memCache if dimensions are finite (not infinity)
    // This prevents the "Infinity or NaN toInt" crash.
    final int? cacheWidth = effectiveWidth.isFinite
        ? (effectiveWidth * pixelRatio).toInt()
        : null;
    final int? cacheHeight = effectiveHeight.isFinite
        ? (effectiveHeight * pixelRatio).toInt()
        : null;

    return CachedNetworkImage(
      imageUrl: imageUrl!,
      width: effectiveWidth,
      height: effectiveHeight,
      fit: fit,
      // Only use memCache if we calculated a valid integer size
      memCacheWidth: cacheWidth,
      memCacheHeight: cacheHeight,
      fadeInDuration: const Duration(milliseconds: 300),
      placeholder: (context, url) => _buildPlaceholder(effectiveWidth, effectiveHeight),
      errorWidget: (context, url, error) => _buildErrorWidget(effectiveWidth, effectiveHeight),
    );
  }

  Widget _buildPlaceholder(double w, double h) {
    return Container(width: w, height: h, color: Colors.grey.shade100);
  }

  Widget _buildErrorWidget(double w, double h) {
    return Container(
      width: w,
      height: h,
      color: Colors.grey.shade200,
      child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
    );
  }
}