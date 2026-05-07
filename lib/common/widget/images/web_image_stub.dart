import 'package:flutter/material.dart';

// This class mimics the WebCorsImage interface but does nothing.
// It is used only on Mobile/Desktop (where CachedNetworkImage is used instead).
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
    return const SizedBox();
  }
}