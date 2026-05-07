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
