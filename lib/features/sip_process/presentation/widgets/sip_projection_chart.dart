// import 'dart:math' as math;

// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';

// class SipProjectionChart extends StatelessWidget {
//   final List<FlSpot> investedSpots;
//   final List<FlSpot> projectedSpots;

//   const SipProjectionChart({
//     super.key,
//     required this.investedSpots,
//     required this.projectedSpots,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (investedSpots.isEmpty || projectedSpots.isEmpty) {
//       return const SizedBox.shrink();
//     }

//     final double minX = investedSpots.first.x;
//     final double maxX = investedSpots.last.x;

//     final double maxInvested = investedSpots.map((e) => e.y).reduce(math.max);
//     final double maxProjected = projectedSpots.map((e) => e.y).reduce(math.max);
//     final double maxY = math.max(maxInvested, maxProjected);

//     final double maxYBuffer = maxY * 1.2;

//     return AspectRatio(
//       aspectRatio: 1.70,
//       child: Container(
//         color: Colors.transparent,
//         child: LineChart(
//           LineChartData(
//             gridData: const FlGridData(show: false),
//             borderData: FlBorderData(show: false),

//             clipData: const FlClipData.none(),

//             titlesData: FlTitlesData(
//               show: true,
//               rightTitles: const AxisTitles(
//                 sideTitles: SideTitles(showTitles: false),
//               ),
//               topTitles: const AxisTitles(
//                 sideTitles: SideTitles(showTitles: false),
//               ),
//               leftTitles: const AxisTitles(
//                 sideTitles: SideTitles(showTitles: false),
//               ),

//               bottomTitles: AxisTitles(
//                 sideTitles: SideTitles(
//                   showTitles: true,
//                   reservedSize: 30,
//                   interval: 1,
//                   getTitlesWidget: (value, meta) {
//                     final year = value.toInt();

//                     return SideTitleWidget(
//                       meta: meta,
//                       child: Text(
//                         year.toString(),
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 12,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),

//             minX: minX,
//             maxX: maxX,
//             minY: 0,
//             maxY: maxYBuffer,

//             lineBarsData: [
//               LineChartBarData(
//                 spots: investedSpots,
//                 isCurved: true,
//                 color: Colors.blueAccent,
//                 barWidth: 4,
//                 isStrokeCapRound: true,
//                 dotData: const FlDotData(show: true),
//                 belowBarData: BarAreaData(show: false),
//               ),

//               LineChartBarData(
//                 spots: projectedSpots,
//                 isCurved: true,
//                 color: Colors.greenAccent,
//                 barWidth: 4,
//                 isStrokeCapRound: true,
//                 dotData: const FlDotData(show: true),
//                 belowBarData: BarAreaData(show: false),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';

class SipProjectionChart extends StatelessWidget {
  final List<FlSpot> investedSpots;
  final List<FlSpot> projectedSpots;

  const SipProjectionChart({
    super.key,
    required this.investedSpots,
    required this.projectedSpots,
  });

  @override
  Widget build(BuildContext context) {
    if (investedSpots.isEmpty || projectedSpots.isEmpty) {
      return const SizedBox.shrink();
    }

    final double minX = investedSpots.first.x;
    final double maxX = investedSpots.last.x;

    final double maxInvested = investedSpots.map((e) => e.y).reduce(math.max);
    final double maxProjected = projectedSpots.map((e) => e.y).reduce(math.max);
    final double maxY = math.max(maxInvested, maxProjected);

    final double maxYBuffer = maxY * 1.2;

    return AspectRatio(
      aspectRatio: 1.70,
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            handleBuiltInTouches: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (touchedSpot) => Colors.black,
              // tooltipBgColor:  Color(0xFF213C73), // 🔥 box color
              tooltipBorderRadius: BorderRadius.circular(10),
              tooltipPadding: const EdgeInsets.all(12),
              fitInsideHorizontally: true,
              fitInsideVertically: true,

              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((spot) {
                  final isValueLine = spot.barIndex == 1;

                  return LineTooltipItem(
                    '${spot.y.toInt()}',
                    TextStyle(
                      color: isValueLine
                          ? Colors.greenAccent
                          : Colors.lightBlueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  );
                }).toList();
              },
            ),
          ),

          // backgroundColor: Colors.blueGrey.shade50,
          gridData: FlGridData(
            show: false,
            horizontalInterval: maxYBuffer / 4,
            getDrawingHorizontalLine: (value) =>
                const FlLine(color: Color(0xffe7e8ec), strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),

          minX: minX,
          maxX: maxX,
          minY: 0,
          maxY: maxYBuffer,

          titlesData: FlTitlesData(
            show: true,


            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),

            // ✅ X-axis (Years)
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  return SideTitleWidget(
                    // space: 5,
                    meta: meta,
                    child: Text(
                      '${value.toInt()}',
                      style: AppTextStyles.bodyMedium(color: Colors.white),
                    ),
                  );
                },
              ),
            ),

            // ✅ Y-axis (₹ in Lakhs)
            leftTitles: AxisTitles(
              sideTitles: SideTitles(

                showTitles: false,
                interval: maxYBuffer / 4,
                reservedSize: 48,
                getTitlesWidget: (value, meta) {
                  if (value == 0) {
                    return const Text(
                      '0',
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                    );
                  }

                  return Text(
                    '${(value / 100000).toStringAsFixed(1)}L',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
            ),
          ),


          lineBarsData: [
            // 🔵 Invested
            LineChartBarData(
              spots: investedSpots,
              isCurved: true,
              color: Colors.blueAccent,
              barWidth: 3,
              dotData: const FlDotData(show: true),
            ),

            // 🟢 Value
            LineChartBarData(
              // belowBarData: BarAreaData(
              //   // color: Colors.greenAccent.shade100.withOpacity(0.4),
              //   show: true,
              // ),
              spots: projectedSpots,
              isCurved: true,
              color: Colors.greenAccent,
              barWidth: 3,
              dotData: const FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }
}
