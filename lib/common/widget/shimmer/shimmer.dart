import 'package:flutter/material.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:shimmer/shimmer.dart';

class UShimmerEffect extends StatelessWidget {
  const UShimmerEffect({
    super.key,
    required this.width,
    required this.height,
    this.radius = 15,
    this.color,
  });

  final double width, height, radius;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    // final dark = UHelperFunction.isDarkMode(context);
    return Shimmer.fromColors(
      // baseColor: dark ? Colors.grey[850]! : Colors.grey[300]!,
      baseColor: Colors.grey.shade300,
      // highlightColor: dark ? Colors.grey[700]! : Colors.grey[100]!,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          // color: color ?? (dark ? Ucolors.darkerGrey : Ucolors.white),
          color: Ucolors.darkgrey,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
