import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class GoalviewcardPage extends StatelessWidget {
  const GoalviewcardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xffF3F4F6),

      appBar: CustomAppBarNormal(title: 'Goal'),
      body: GridView.count(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        crossAxisCount: 2,
        childAspectRatio: size.width <= 360 ? 0.59 : 0.7,
        children: [
          CircularUploadIndicator(),
          CircularUploadIndicator(),
          CircularUploadIndicator(),
          CircularUploadIndicator(),
          CircularUploadIndicator(),
          CircularUploadIndicator(),
          CircularUploadIndicator(),
          CircularUploadIndicator(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            16 + MediaQuery.of(context).viewPadding.bottom,
          ),
          child: UElevatedBUtton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Add new goal', style: UTextStyles.buttonText),
                const Gap(5),
                const Icon(Icons.add, color: Ucolors.light),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CircularUploadIndicator extends StatelessWidget {
  const CircularUploadIndicator({super.key, this.percentage = false});

  final bool percentage;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.goaldetails),
      child: Container(
        // padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: percentage ? Colors.transparent : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                /// Outer Circular Arc
                CircularPercentIndicator(
                  radius: size.width <= 320 ? 60 : 80,
                  lineWidth: 15,

                  percent: 0.77, // 75%
                  startAngle: 220,
                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: Colors.transparent,

                  progressColor: Colors.grey.shade200,
                ),
                CircularPercentIndicator(
                  center: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(16),
                    child: Icon(Icons.image),
                  ),
                  // radius: 80,
                  radius: size.width <= 350 ? 60 : 80,

                  lineWidth: 15,

                  percent: 0.1, // 75%
                  startAngle: 220,
                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: Colors.transparent,

                  progressColor: Ucolors.blue,
                ),
                if (!percentage) ...[
                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: Text('₹ 5,000', style: UTextStyles.small),
                  ),
                  Positioned(
                    right: 15,
                    bottom: 0,
                    child: Text('70%', style: UTextStyles.small),
                  ),
                ],
                Positioned(
                  left: 10,
                  bottom: 10,
                  child: Text('🚗', style: TextStyle(fontSize: 30)),
                ),
                percentage
                    ? Positioned(
                        // right: 0,
                        bottom: 0,
                        child: Text(
                          '33%',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
            if (!percentage) ...[
              Text('Car', style: UTextStyles.large),
              Text(
                '₹ 5,00,000',
                style: UTextStyles.medium.copyWith(color: Colors.black),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
