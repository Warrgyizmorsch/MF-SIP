import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/features/fund_details/presentation/widgets/timeselecter.dart';

import '../../../../core/utils/helper/helpers.dart';
import '../../data/models/return_model.dart';
import '../controllers/chartInvestment_controller.dart';


class YearlyReturnsChart extends StatelessWidget {
  const YearlyReturnsChart({
    super.key,
    this.height,
    required this.yearlyData,
  });

  final double? height;
  final List<ReturnRow> yearlyData;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChartInvestmentController(), permanent: false);
    final isDesktop = MediaQuery.of(context).size.width > 900;

    // X-axis labels for the 3 comparative bars
    final List<String> xLabels = ["Scheme", "Category", "Benchmark"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// 1. STACKED BAR CHART (AMOUNT-BASED Y-AXIS)
        Container(
          height: height ?? (isDesktop ? 320 : 150),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Obx(() {
            // Access observables inside Obx
            final currentInv = controller.investment.value;
            final selectedPeriod = controller.selectedPeriod.value;

            // Get the data for the active period
            final selectedData = yearlyData.firstWhere(
                  (e) => e.period == selectedPeriod,
              orElse: () => yearlyData.first,
            );

            // Calculate the actual currency amounts for each bar
            final List<double> returnPercents = [
              selectedData.scheme,
              selectedData.category,
              selectedData.benchmark,
            ];

            // List of actual total amounts (Investment + Gain Amount)
            final List<double> totalAmounts = returnPercents.map((p) {
              final gainAmount = (currentInv * p) / 100;
              return currentInv + gainAmount;
            }).toList();

            // Find max for Y-axis scaling (in Rupees)
            final maxAmount = totalAmounts.reduce(max);

            return BarChart(
              BarChartData(
                // Y-AXIS SCALE IN AMOUNT (₹)
                maxY: maxAmount > 0 ? maxAmount * 1.2 : (currentInv * 1.2),
                minY: 0,

                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),

                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 60,
                      getTitlesWidget: (value, _) {
                        int index = value.toInt();
                        if (index < 0 || index >= xLabels.length) return const SizedBox.shrink();

                        final percent = returnPercents[index];
                        final totalAmount = currentInv + (currentInv * percent / 100);

                        // Helper function to format 120000 to 1.2L


                        return Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                formatCurrency(totalAmount),
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ), Text(
                        "${returnPercents[index].toStringAsFixed(2)}%",
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                xLabels[index],
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 10),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),

                barGroups: List.generate(xLabels.length, (index) {
                  final totalValueInRupees = totalAmounts[index];

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        // THE ROD HEIGHT IS NOW THE TOTAL AMOUNT (₹)
                        toY: totalValueInRupees,
                        width: isDesktop ? 28 : 22,
                        borderRadius: BorderRadius.circular(4),
                        rodStackItems: [
                          // Investment Base (Yellow Segment)
                          BarChartRodStackItem(0, currentInv, Ucolors.primary),
                          // Gain Segment (Green Segment)
                          BarChartRodStackItem(currentInv, totalValueInRupees, Ucolors.blue),
                        ],
                      ),
                    ],
                  );
                }),
              ),
            );
          }),
        ),

        /// 2. PERIOD SELECTOR
        PeriodSelectorBarChart(yearlyData: yearlyData),

        const SizedBox(height: 4),

        /// 3. NUMERIC DATA DISPLAY
        Obx(() {
          final currentInv = controller.investment.value;
          final selectedData = yearlyData.firstWhere(
                (e) => e.period == controller.selectedPeriod.value,
            orElse: () => yearlyData.first,
          );

          final gainAmount = (currentInv * selectedData.scheme) / 100;
          final isLoss = gainAmount < 0;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Invested", style: TextStyle(color: Colors.grey, fontSize: 10)),
                    Text(isLoss ? "Loss" : "Gain", style: const TextStyle(color: Colors.grey, fontSize: 10)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("₹${currentInv.toStringAsFixed(0)}",
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("₹${gainAmount.toStringAsFixed(2)}",
                            style: TextStyle(
                                color: isLoss ? Colors.red : Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 14
                            )),
                        Text("(${selectedData.scheme.toStringAsFixed(2)}%)",
                            style: TextStyle(color: isLoss ? Colors.red : Colors.green, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        }),



        /// 4. SLIDER
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Obx(() => SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF66BB6A),
              thumbColor: Colors.orange,
              trackHeight: 2,
            ),
            child: Slider(
              value: controller.investment.value,
              min: controller.minInvestment,
              max: controller.maxInvestment,
              onChanged: (val) => controller.investment.value = val,
            ),
          )),
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