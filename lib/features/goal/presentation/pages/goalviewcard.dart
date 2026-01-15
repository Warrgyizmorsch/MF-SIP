import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class GoalviewcardPage extends StatelessWidget {
  const GoalviewcardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarNormal(title: 'Goal'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [CircularUploadIndicator()],
        ),
      ),
    );
  }
}

class CircularUploadIndicator extends StatelessWidget {
  const CircularUploadIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          /// Outer Circular Arc
          CircularPercentIndicator(
            radius: 80,
            lineWidth: 20,

            percent: 0.75, // 75%
            startAngle: 220,
            // startAngle: 180,
            circularStrokeCap: CircularStrokeCap.round,
            backgroundColor: Colors.grey.shade300,
            progressColor: Color(0xff213C73),
          ),

          /// Dotted Circle
          // DottedBorder(

          //   borderType: BorderType.Circle,
          //   dashPattern: const [4, 6],
          //   color: Colors.grey.shade400,
          //   strokeWidth: 2,
          //   child: const SizedBox(
          //     width: 110,
          //     height: 110,
          //   ),
          // ),

          /// Inner Circle + Icon
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Color(0xffEDEDED),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.image, size: 28),
          ),
        ],
      ),
    );
  }
}
