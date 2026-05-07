import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/features/fund_details/data/models/fund_performance.dart';
import 'package:my_sip/features/fund_details/presentation/widgets/timeselecter.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../controllers/chartInvestment_controller.dart';

import 'dart:math';


class YearlyReturnsChart extends StatelessWidget {
  const YearlyReturnsChart({
    super.key,
    this.height,
    required this.yearlyData,
  });

  final double? height;
  final List<YearlyReturn> yearlyData;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChartInvestmentController(), permanent: false);
    final isDesktop =
    ResponsiveBreakpoints.of(context).largerThan(TABLET);

    final allValues = yearlyData.expand((e) {
      final gainPercent = controller.getGainPercent(
        e.value,
        e.year,
      );

      return [
        e.value,
        gainPercent,
      ];
    }).toList();

    final maxValue = allValues.reduce(max);
    final minValue = allValues.reduce(min);

    debugPrint("Max Value: $maxValue, Min Value: $minValue");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// CHART
        Container(
          height: height ?? (isDesktop ? 290 : 180),
          padding:
          isDesktop ? const EdgeInsets.all(20) : const EdgeInsets.all(8),
          decoration: isDesktop
              ? BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          )
              : null,
          child: Stack(
            children: [
              /// IMPORTANT: Wrap with Obx
              Obx(() => BarChart(
                BarChartData(
                  maxY: maxValue + 20,
                  minY: minValue < 0 ? minValue - 5 : 0,

                  ///  ZERO LINE
                  extraLinesData: ExtraLinesData(
                    horizontalLines: [
                      HorizontalLine(
                        y: 0,
                        color: Colors.grey,
                        strokeWidth: 1,
                      ),
                    ],
                  ),

                  gridData: FlGridData(
                    show: isDesktop,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.shade200,
                      strokeWidth: 1,
                    ),
                  ),

                  borderData: FlBorderData(show: false),

                  ///  TOUCH
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchCallback: (event, response) {
                      if (response?.spot != null) {
                        controller.selectedIndex.value =
                            response!.spot!.touchedBarGroupIndex;
                      }
                    },
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (_) => Colors.black87,
                      getTooltipItem:
                          (group, groupIndex, rod, rodIndex) {
                        final data =
                        yearlyData[group.x.toInt()];
                        final gainAmount = controller.getGainPercent(
                          data.value,
                          data.year,
                        );

                        return BarTooltipItem(
                              '${data.value.toStringAsFixed(2)}%\n'
                              '${gainAmount.toStringAsFixed(2)}%',
                          const TextStyle(color: Colors.white,fontSize: 8),
                        );
                      },
                    ),
                  ),

                  /// TITLES
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: isDesktop,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}%',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade600,
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          return Text(
                            yearlyData[value.toInt()].year,
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),

                  /// BARS
                  barGroups: List.generate(
                    yearlyData.length,
                        (index) {
                      final data = yearlyData[index];
                      final gainAmount = controller.getGainPercent(data.value, data.year);

                      final totalHeight = data.value + gainAmount;

                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: totalHeight,
                            width: isDesktop ? 16 : 12,
                            borderRadius: BorderRadius.circular(4),
                            rodStackItems: [

                              BarChartRodStackItem(
                                0,
                                data.value,
                                Ucolors.blue,
                              ),

                              BarChartRodStackItem(
                                data.value,
                                totalHeight,
                                Ucolors.primary,
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              )),

              ///  SAFE LABELS (NO CRASH)
              if (!isDesktop)
                Positioned.fill(
                  child: Row(
                    children: List.generate(yearlyData.length, (index) {
                      final value = yearlyData[index].value;

                      return Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (value >= 0)
                              Text(
                                '${value.toStringAsFixed(1)}%',
                                style: const TextStyle(
                                  fontSize: 8,
                                  color: Colors.green,
                                ),
                              ),
                            const Spacer(),
                            if (value < 0)
                              Text(
                                '${value.toStringAsFixed(1)}%',
                                style: const TextStyle(
                                  fontSize: 8,
                                  color: Colors.red,
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
            ],
          ),
        ),
        PeriodSelectorBarChart(yearlyData: yearlyData,),
        const SizedBox(height: 8),


        Obx(() {
          final selectedData = yearlyData.firstWhere(
                (e) => e.year == controller.selectedPeriod.value,
            orElse: () => yearlyData.first,
          );

          final gainAmount = controller.selectedGain.value;

          final gainPercent = controller.getGainPercent(
            selectedData.value,
            selectedData.year,
          );

          final isLoss = gainAmount < 0;

          return Column(
            children: [

              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Invested Amount",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                  ),

                  Text(
                    isLoss
                        ? "Loss Amount"
                        : "Gain Amount",
                    style: TextStyle(
                      color: isLoss
                          ? Colors.red
                          : Colors.green,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  /// INVESTMENT
                  Text(
                    "₹${controller.investment.value.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  /// GAIN
                  Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.end,
                    children: [
                      Text(
                        "₹${gainAmount.toStringAsFixed(2)}",
                        style: TextStyle(
                          color: isLoss
                              ? Colors.red
                              : Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),

                      Text(
                        "(${gainPercent.toStringAsFixed(2)}%)",
                        style: TextStyle(
                          color: isLoss
                              ? Colors.red
                              : Colors.green,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        }),
        const SizedBox(height: 4),

        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 4,
          ),
          child: Obx(
                () => SliderTheme(
              data: SliderTheme.of(context)
                  .copyWith(
                activeTrackColor: Ucolors.primary,
                inactiveTrackColor:
                Colors.grey.shade300,
                thumbColor: Ucolors.secondary,
                trackHeight: 5,

                thumbShape:
                const RoundSliderThumbShape(
                  enabledThumbRadius: 8,
                ),

                overlayShape:
                const RoundSliderOverlayShape(
                  overlayRadius: 16,
                ),
              ),

              child: Slider(
                value: controller.investment.value,
                activeColor: Ucolors.primary,
                min: controller.minInvestment,
                max: controller.maxInvestment,

                divisions:
                ((controller.maxInvestment -
                    controller
                        .minInvestment) ~/
                    1000)
                    .toInt(),

                label:
                "₹${controller.investment.value.toStringAsFixed(0)}",

                onChanged: (value) {

                  controller.investment.value =
                      value;

                  final selectedData =
                  yearlyData[
                  controller.selectedIndex
                      .value];

                  controller.selectedGain.value =
                      controller.getGainAmount(
                        selectedData.value,
                        selectedData.year,
                      );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}














// class YearlyReturnsChart extends StatelessWidget {
//   const YearlyReturnsChart({super.key, this.height, required this.yearlyData});
//
//   final double? height;
//   final List<YearlyReturn> yearlyData;
//
//   @override
//   Widget build(BuildContext context) {
//
//     final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
//     final maxValue =
//         yearlyData.map((e) => e.value).reduce((a, b) => a > b ? a : b) + 5;
//
//     return Container(
//       height: height ?? (isDesktop ? 290 : 180),
//       padding: isDesktop ? const EdgeInsets.all(20) : const EdgeInsets.all(8),
//       decoration: isDesktop
//           ? BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey.shade200),
//       )
//           : null,
//       child: Stack(
//         children: [
//           /// BAR CHART
//           BarChart(
//             BarChartData(
//               maxY: maxValue,
//               minY: 0,
//               gridData: FlGridData(
//                 show: isDesktop,
//                 drawVerticalLine: false,
//                 horizontalInterval: 10,
//                 getDrawingHorizontalLine: (value) => FlLine(
//                   color: Colors.grey.shade100,
//                   strokeWidth: 1,
//                 ),
//               ),
//               borderData: FlBorderData(show: false),
//               barTouchData: BarTouchData(
//                 enabled: true,
//                 touchTooltipData: BarTouchTooltipData(
//                   getTooltipColor: (_) => Colors.black87,
//                   tooltipPadding: const EdgeInsets.all(8),
//                   tooltipMargin: 8,
//                   getTooltipItem: (group, groupIndex, rod, rodIndex) {
//                     return BarTooltipItem(
//                       '${yearlyData[group.x.toInt()].year}\n${rod.toY.toStringAsFixed(2)}%',
//                       const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 12,
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               titlesData: FlTitlesData(
//                 leftTitles: AxisTitles(
//                   sideTitles: SideTitles(
//                     showTitles: isDesktop,
//                     reservedSize: 40,
//                     getTitlesWidget: (value, meta) {
//                       return Text(
//                         '${value.toInt()}%',
//                         style: TextStyle(
//                           fontSize: 11,
//                           color: Colors.grey.shade600,
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 rightTitles: AxisTitles(
//                   sideTitles: SideTitles(showTitles: false),
//                 ),
//                 topTitles: AxisTitles(
//                   sideTitles: SideTitles(showTitles: false),
//                 ),
//                 bottomTitles: AxisTitles(
//                   sideTitles: SideTitles(
//                     showTitles: true,
//                     getTitlesWidget: (value, _) {
//                       return Padding(
//                         padding: EdgeInsets.only(top: isDesktop ? 12 : 6),
//                         child: FittedBox(
//                           child: Text(
//                             yearlyData[value.toInt()].year,
//                             style: TextStyle(
//                               fontSize: isDesktop ? 11 : 11,
//                               fontWeight: isDesktop ? FontWeight.w500 : FontWeight.normal,
//                               color: Colors.black87,
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//               barGroups: List.generate(yearlyData.length, (index) {
//                 return BarChartGroupData(
//                   x: index,
//                   barRods: [
//                     BarChartRodData(
//                       toY: yearlyData[index].value,
//                       width: isDesktop ? 32 : Get.width * 0.07,
//                       gradient: LinearGradient(
//                         colors: [
//                           const Color(0xFF1B7A3A),
//                           const Color(0xFFFFF176),
//                         ],
//                         begin: Alignment.bottomCenter,
//                         end: Alignment.topCenter,
//                       ),
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(isDesktop ? 8 : 6),
//                         topRight: Radius.circular(isDesktop ? 8 : 6),
//                       ),
//                     ),
//                   ],
//                 );
//               }),
//             ),
//           ),
//
//           /// TEXT LABELS ABOVE BARS
//           if (!isDesktop)
//             Positioned.fill(
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: List.generate(yearlyData.length, (index) {
//                   final value = yearlyData[index].value;
//                   return Expanded(
//                     child: Padding(
//                       padding: EdgeInsets.only(
//                         bottom: (value / maxValue * 140) + 25,
//                       ),
//                       child: Text(
//                         '${value.toStringAsFixed(2)}%',
//                         textAlign: TextAlign.center,
//                         maxLines: 1,
//                         style: const TextStyle(
//                           overflow: TextOverflow.ellipsis,
//                           fontSize: 8,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF1B7A3A),
//                         ),
//                       ),
//                     ),
//                   );
//                 }),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }