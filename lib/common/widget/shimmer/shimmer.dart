// import 'package:flutter/material.dart';
// import 'package:my_sip/core/utils/constant/colors.dart';
// import 'package:shimmer/shimmer.dart';

// class UShimmerEffect extends StatelessWidget {
//   const UShimmerEffect({
//     super.key,
//     required this.width,
//     required this.height,
//     this.radius = 15,
//     this.color,
//   });

//   final double width, height, radius;
//   final Color? color;
//   @override
//   Widget build(BuildContext context) {
//     // final dark = UHelperFunction.isDarkMode(context);
//     return Shimmer.fromColors(
//       // baseColor: dark ? Colors.grey[850]! : Colors.grey[300]!,
//       baseColor: Colors.grey.shade300,
//       // highlightColor: dark ? Colors.grey[700]! : Colors.grey[100]!,
//       highlightColor: Colors.grey.shade100,
//       child: Container(
//         width: width,
//         height: height,
//         decoration: BoxDecoration(
//           // color: color ?? (dark ? Ucolors.darkerGrey : Ucolors.white),
//           color: Ucolors.darkgrey,
//           borderRadius: BorderRadius.circular(radius),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shimmer/shimmer.dart';

class UShimmerEffect extends StatelessWidget {
  const UShimmerEffect({
    super.key,
    required this.width,
    required this.height,
    this.radius = 15,
    this.color,
    this.text, // 🚀 1. Add the optional text parameter
  });

  final double width, height, radius;
  final Color? color;
  final String? text; // 🚀 2. Declare the variable

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment:
          Alignment.center, // This perfectly centers the text inside the box
      children: [
        // --- 1. The Shimmering Background Box ---
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              // Notice I fixed a small bug here: using your 'color' parameter if provided!
              color: color ?? Ucolors.darkgrey,
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
        ),

        // --- 2. The Optional Text on Top ---
        if (text != null && text!.isNotEmpty)
          Text(
            text!,
            style: TextStyle(
              color: Colors
                  .grey
                  .shade600, // A nice subtle color so it doesn't look like an error
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }
}


class SchemeChartShimmer extends StatelessWidget {
  const SchemeChartShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    // Exact heights used in your SchemeLineChart
    final double chartHeight = isDesktop ? 280 : 220;

    return Container(
      height: chartHeight,
      width: double.infinity,
      padding: isDesktop ? const EdgeInsets.all(20) : const EdgeInsets.all(12),
      decoration: isDesktop
          ? BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        // border: Border.all(color: Colors.grey.shade200),
      )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mimic the Chart Title/Header area if any
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _BaseShimmer(width: 80, height: 15, radius: 4),
              _BaseShimmer(width: 60, height: 15, radius: 4),
            ],
          ),
          const Spacer(),
          // Mimic the Line Chart drawing area
          _BaseShimmer(
              width: double.infinity,
              height: chartHeight * 0.6,
              radius: 8
          ),
          const Spacer(),
          // Mimic the Bottom Labels (Dates)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) =>
                _BaseShimmer(width: 40, height: 10, radius: 2)
            ),
          )
        ],
      ),
    );
  }
}

// Simple wrapper for your existing UShimmerEffect or a basic Shimmer box
class _BaseShimmer extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const _BaseShimmer({required this.width, required this.height, required this.radius});

  @override
  Widget build(BuildContext context) {
    // Replace this with your actual UShimmerEffect widget
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}