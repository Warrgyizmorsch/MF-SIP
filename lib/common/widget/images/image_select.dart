import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';

class UCircularImage extends StatelessWidget {
  const UCircularImage({
    super.key,
    required this.image,
    this.radius = 60,
    this.isNetwork = false,
    this.fit = BoxFit.cover,
    this.onTap,
  });

  final String image;
  final double radius;
  final bool isNetwork;
  final BoxFit fit;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey.shade200,
        child: ClipOval(child: _buildImageLogic()),
      ),
    );
  }

  Widget _buildImageLogic() {
    final double size = radius * 2;

    // 1. Check if the file exists locally first (Priority for Image Picker)
    if (image.isNotEmpty &&
        !image.startsWith('http') &&
        File(image).existsSync()) {
      return Image.file(File(image), fit: fit, width: size, height: size);
    }

    // 2. Handle Network or Backend Storage Paths
    if (image.startsWith('http') ||
        image.startsWith('https') ||
        image.startsWith('storage/')) {
      final String fullUrl = image.startsWith('storage/')
          ? "${Appurl.baseUrl}/$image"
          : image;

      return Image.network(
        fullUrl,
        fit: fit,
        width: size,
        height: size,
        errorBuilder: (context, error, stackTrace) =>
            Icon(Icons.person, size: radius),
      );
    }

    // 3. Fallback to Asset Image
    return Image.asset(
      image.isEmpty ? 'assets/images/avatar.png' : image,
      fit: fit,
      width: size,
      height: size,
      errorBuilder: (context, error, stackTrace) =>
          Icon(Icons.person, size: radius),
    );
  }
}
