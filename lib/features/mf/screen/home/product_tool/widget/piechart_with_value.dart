import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';

class PieChartWithValue extends StatelessWidget {
  const PieChartWithValue({
    super.key,
    required this.list,
    required this.piechartvalue1,
    required this.piechartvalue2,
    required this.piechartcolor1,
    required this.piechartcolor2, required this.title1, required this.title2,
  });
  final List<Widget> list;

  final double piechartvalue1;
  final double piechartvalue2;
  final Color piechartcolor1;
  final Color piechartcolor2;
  final String title1;
  final String title2;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...list,

        Gap(20),

        SizedBox(
          height: 200,
          width: 200,
          child: PieChart(
            // curve: Curves.bounceIn,
            PieChartData(
              pieTouchData: PieTouchData(enabled: true),
              sectionsSpace: 0,
              sections: [
                PieChartSectionData(
                  // showTitle: false,
                  // badgeWidget: Text('data'),
                  showTitle: false,
                  value: piechartvalue1,
                  color: piechartcolor1,
                ),
                PieChartSectionData(
                  showTitle: false,
                  // color: Ucolors.primary.withOpacity(0.1),
                  color: piechartcolor2,
                  value: piechartvalue2,
                ),
              ],
            ),
          ),
        ),

        Gap(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Container(
                  width: 20,
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // color: Ucolors.primary.withOpacity(0.1),
                    color: piechartcolor1,
                  ),
                ),
                Gap(5),
                Text(title1, style: UTextStyles.caption),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 20,
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // color: Ucolors.primary,
                    color: piechartcolor2,
                  ),
                ),
                Gap(5),
                Text(title2, style: UTextStyles.caption),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
