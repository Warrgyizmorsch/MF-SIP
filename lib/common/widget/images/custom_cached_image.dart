import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_sip/core/utils/constant/images.dart';

import '../shimmer/shimmer.dart';

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
    final double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    // Calculate memory cache size based on physical pixels
    final int cacheSize = (size * pixelRatio).toInt();

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        imageUrl: imageUrl ?? '',
        width: size,
        height: size,
        fit: BoxFit.cover,

        memCacheHeight: cacheSize,
        memCacheWidth: cacheSize,

        fadeInDuration: const Duration(milliseconds: 300),
        placeholder: (context, url) =>
            UShimmerEffect(width: size, height: size, radius: radius),
        errorWidget: (context, url, error) => Container(
          width: size,
          height: size,
          color: Colors.grey.shade200,
          child: Image.asset(UImages.imp),
        ),
      ),
    );
  }
}
