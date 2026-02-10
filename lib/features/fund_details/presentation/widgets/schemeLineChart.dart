import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// class SchemeLineChart extends StatelessWidget {
//   const SchemeLineChart({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final List<FlSpot> schemeSpots = [
//       FlSpot(0, 10),
//       FlSpot(1, 9.5),
//       FlSpot(2, 10.2),
//       FlSpot(3, 9.8),
//       FlSpot(4, 10.6),
//       FlSpot(5, 10.4),
//       FlSpot(6, 11.0),
//       FlSpot(7, 10.8),
//       FlSpot(8, 11.3),
//       FlSpot(9, 11.8),
//     ];
//     return SizedBox(
//       height: 220,
//       child: LineChart(
//         LineChartData(
//           minX: 0,
//           maxX: schemeSpots.length - 1,
//           gridData: FlGridData(show: false),
//           borderData: FlBorderData(show: false),
//           titlesData: FlTitlesData(
//             leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//             rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//             topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//             bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//           ),
//           lineTouchData: LineTouchData(
//             enabled: true,
//             handleBuiltInTouches: true,
//           ),
//           lineBarsData: [
//             LineChartBarData(
//               spots: schemeSpots,
//               isCurved: true,
//               color: const Color(0xFF1E5DB9), // BLUE LINE
//               barWidth: 2.5,
//               dotData: FlDotData(show: false),
//               belowBarData: BarAreaData(show: false),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:math'; // Required for min/max calculations
// Import your entity file
import 'package:my_sip/features/fund_details/domain/entity/nav_history_entity.dart';

class SchemeLineChart extends StatelessWidget {
  final List<NavEntryEntity> navData;

  const SchemeLineChart({super.key, required this.navData});

  @override
  Widget build(BuildContext context) {
    // 1. Handle Empty State
    if (navData.isEmpty) {
      return const SizedBox(
        height: 220,
        child: Center(child: Text("No data available")),
      );
    }

    // 2. Map Entity to FlSpot
    // We use the index (0, 1, 2...) as the X value for equidistant points.
    List<FlSpot> schemeSpots = navData.asMap().entries.map((entry) {
      int index = entry.key;
      double value = entry.value.nav ?? 0.0;
      return FlSpot(index.toDouble(), value);
    }).toList();

    // 3. Calculate Min/Max for dynamic Y-axis scaling
    // This ensures the line takes up the full height of the chart
    double minY = schemeSpots.map((e) => e.y).reduce(min);
    double maxY = schemeSpots.map((e) => e.y).reduce(max);
    double buffer = (maxY - minY) * 0.1; // Add 10% breathing room

    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          // Dynamic X and Y ranges
          minX: 0,
          maxX: (schemeSpots.length - 1).toDouble(),
          minY: minY - buffer,
          maxY: maxY + buffer,

          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineTouchData: LineTouchData(
            enabled: true,
            handleBuiltInTouches: true,
            touchTooltipData: LineTouchTooltipData(
              // Optional: Customize tooltip to show Date and Value
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final date = navData[spot.x.toInt()].navDate ?? "";
                  return LineTooltipItem(
                    "$date\n${spot.y.toStringAsFixed(2)}",
                    const TextStyle(color: Colors.white),
                  );
                }).toList();
              },
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: schemeSpots,
              isCurved: true,
              color: const Color(0xFF1E5DB9), // BLUE LINE
              barWidth: 2.5,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true, // Optional: nice gradient fill below line
                color: const Color(0xFF1E5DB9).withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}






