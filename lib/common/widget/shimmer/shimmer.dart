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
import 'package:gap/gap.dart';
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



class ShimmerListView extends StatelessWidget {
  const ShimmerListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8, // Jitne items dikhane hain
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            children: [
              // 1. Icon/Image Placeholder
              const CustomShimmer.rectangular(
                height: 50,
                width: 50,
              ),
              const SizedBox(width: 12),

              // 2. Text Column Placeholder
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomShimmer.rectangular(height: 14, width: 120), // Title
                    const SizedBox(height: 8),
                    const CustomShimmer.rectangular(height: 10), // Subtitle
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


class CustomShimmer extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  // Rectangular Shimmer
  const CustomShimmer.rectangular({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.shapeBorder = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  });

  // Circular Shimmer
  const CustomShimmer.circular({
    super.key,
    required this.width,
    required this.height,
    this.shapeBorder = const CircleBorder(),
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      period: const Duration(milliseconds: 1500),
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: Colors.grey[400]!, // Base color for the shape
          shape: shapeBorder,
        ),
      ),
    );
  }
}




class FundShimmerLoading extends StatelessWidget {
  final int crossAxisCount;
  const FundShimmerLoading({super.key, required this.crossAxisCount});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisExtent: 160,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade200,
            highlightColor: Colors.grey.shade100,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(height: 46, width: 46, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(height: 12, width: double.infinity, color: Colors.white),
                            const SizedBox(height: 8),
                            Container(height: 12, width: 120, color: Colors.white),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 46,
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
/// =========================================================

class FundShimmerCard extends StatelessWidget {
  const FundShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile =
        MediaQuery.of(context).size.width < 700;

    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        child: isMobile
            ? _mobileShimmer()
            : _desktopShimmer(),
      ),
    );
  }

  // =========================================================
  // DESKTOP SHIMMER
  // =========================================================

  Widget _desktopShimmer() {
    return Row(
      children: [
        // LOGO + TITLE
        Expanded(
          flex: 4,
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),

              const Gap(16),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 14,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(8),
                      ),
                    ),

                    const Gap(10),

                    Container(
                      height: 12,
                      width: 140,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // RISK
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: 34,
              width: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),

        // RETURNS
        Expanded(child: _returnBox()),
        Expanded(child: _returnBox()),
        Expanded(child: _returnBox()),

        // BUTTON
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 42,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // MOBILE SHIMMER
  // =========================================================

  Widget _mobileShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
            ),

            const Gap(14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(8),
                    ),
                  ),

                  const Gap(10),

                  Container(
                    height: 12,
                    width: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const Gap(20),

        Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            _miniBox(),
            _miniBox(),
            _miniBox(),
          ],
        ),

        const Gap(18),

        Row(
          children: [
            Expanded(
              child: Container(
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(30),
                ),
              ),
            ),

            const Gap(12),

            Expanded(
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // =========================================================
  // COMMON BOXES
  // =========================================================

  Widget _returnBox() {
    return Container(
      height: 14,
      width: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _miniBox() {
    return Column(
      children: [
        Container(
          height: 10,
          width: 30,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),

        const Gap(8),

        Container(
          height: 14,
          width: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
  }
}




class GoalShimmerGrid extends StatelessWidget {
  const GoalShimmerGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header shimmer
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: 120,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),

        // Grid shimmer
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: 9,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.82,
            ),
            itemBuilder: (context, index) => const _GoalShimmerCard(),
          ),
        ),
      ],
    );
  }
}

class _GoalShimmerCard extends StatelessWidget {
  const _GoalShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Circle shimmer
            Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),

            // Goal name shimmer
            Container(
              width: 80,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
            ),

            // Amount shimmer
            Container(
              width: 60,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}