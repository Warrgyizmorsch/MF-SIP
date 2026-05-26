import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:my_sip/features/fund_details/domain/entity/nav_history_entity.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../core/utils/constant/text_style.dart';

class SchemeLineChart extends StatefulWidget {
  final List<NavEntryEntity> navData;

  const SchemeLineChart({super.key, required this.navData});

  @override
  State<SchemeLineChart> createState() => _SchemeLineChartState();
}

class _SchemeLineChartState extends State<SchemeLineChart> {
  int? touchedSpotIndex;

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    // 1. Handle Empty State
    if (widget.navData.isEmpty) {
      return _buildEmptyState(isDesktop);
    }

    // 2. Prepare Data Points
    List<FlSpot> schemeSpots = widget.navData.asMap().entries.map((entry) {
      int index = entry.key;
      double value = entry.value.nav ?? 0.0;
      return FlSpot(index.toDouble(), value);
    }).toList();

    // 3. Calculate Dynamic Scaling
    double minY = schemeSpots.map((e) => e.y).reduce(min);
    double maxY = schemeSpots.map((e) => e.y).reduce(max);
    double range = maxY - minY;
    // Add 10% padding so the line doesn't touch the top/bottom edges
    double buffer = range * 0.1;

    return Container(
      height: isDesktop ? 280 : 220,
      padding: isDesktop ? const EdgeInsets.all(20) : const EdgeInsets.all(0),
      decoration: isDesktop
          ? BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      )
          : null,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (schemeSpots.length - 1).toDouble(),
          minY: minY - buffer,
          maxY: maxY + buffer,
          gridData: FlGridData(
            show: isDesktop,
            drawVerticalLine: false,
            horizontalInterval: (range <= 0) ? 1 : range / 5,
            getDrawingHorizontalLine: (value) =>
                FlLine(color: Colors.grey.shade100, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: isDesktop,
                reservedSize: 50,
                getTitlesWidget: (value, meta) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    '₹${value.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: FontFamily.medium,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: isDesktop,
                interval: schemeSpots.length > 10
                    ? (schemeSpots.length / 5).ceilToDouble()
                    : 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < widget.navData.length) {
                    final date = widget.navData[index].navDate ?? "";
                    final parts = date.split('-');
                    if (parts.length == 3) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '${parts[2]}/${parts[1]}',
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontFamily: FontFamily.medium),
                        ),
                      );
                    }
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            enabled: true,
            handleBuiltInTouches: true,
            touchSpotThreshold: 20,
            getTouchedSpotIndicator: (barData, spotIndexes) {
              return spotIndexes.map((index) {
                return TouchedSpotIndicatorData(
                  FlLine(
                    color: const Color(0xFF1E5DB9).withValues(alpha:0.5),
                    strokeWidth: 2,
                    dashArray: [5, 5],
                  ),
                  FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) =>
                        FlDotCirclePainter(
                          radius: 6,
                          color: Colors.white,
                          strokeWidth: 3,
                          strokeColor: const Color(0xFF1E5DB9),
                        ),
                  ),
                );
              }).toList();
            },
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => Colors.grey.shade900,
              tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              // tooltipRoundedRadius: 8,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final date = widget.navData[spot.x.toInt()].navDate ?? "";
                  return LineTooltipItem(
                    '$date\n₹${spot.y.toStringAsFixed(2)}',
                    const TextStyle(
                      color: Colors.white,
                      fontFamily: FontFamily.medium,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  );
                }).toList();
              },
            ),
            touchCallback: (event, response) {
              if (response?.lineBarSpots != null && response!.lineBarSpots!.isNotEmpty) {
                setState(() => touchedSpotIndex = response.lineBarSpots!.first.spotIndex);
              } else {
                setState(() => touchedSpotIndex = null);
              }
            },
          ),
          lineBarsData: [
            LineChartBarData(
              spots: schemeSpots,
              isCurved: true,
              curveSmoothness: 0.35,
              gradient: const LinearGradient(
                colors: [Color(0xFF1E5DB9), Color(0xFF3B82F6)],
              ),
              barWidth: isDesktop ? 3 : 2.5,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: isDesktop && schemeSpots.length <= 20,
                getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                  radius: 3,
                  color: Colors.white,
                  strokeWidth: 2,
                  strokeColor: const Color(0xFF1E5DB9),
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF1E5DB9).withValues(alpha:0.15),
                    const Color(0xFF1E5DB9).withValues(alpha:0.01),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
        // --- ANIMATION SETTINGS ---
        duration: const Duration(milliseconds: 1200), // Time for the line to draw
        curve: Curves.easeOutQuart, // Smooth easing effect
      ),
    );
  }

  Widget _buildEmptyState(bool isDesktop) {
    return SizedBox(
      height: isDesktop ? 280 : 220,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.show_chart, size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              "No data available",
              style: TextStyle(color: Colors.grey.shade500, fontSize: 14, fontFamily: FontFamily.medium),
            ),
          ],
        ),
      ),
    );
  }
}




// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'dart:math';
// import 'package:my_sip/features/fund_details/domain/entity/nav_history_entity.dart';
// import 'package:responsive_framework/responsive_framework.dart';
//
// class SchemeLineChart extends StatefulWidget {
//   final List<NavEntryEntity> navData;
//
//   const SchemeLineChart({super.key, required this.navData});
//
//   @override
//   State<SchemeLineChart> createState() => _SchemeLineChartState();
// }
//
// class _SchemeLineChartState extends State<SchemeLineChart> {
//   int? touchedSpotIndex;
//
//   @override
//   Widget build(BuildContext context) {
//     final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
//
//     if (widget.navData.isEmpty) {
//       return SizedBox(
//         height: isDesktop ? 280 : 220,
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.show_chart, size: 48, color: Colors.grey.shade300),
//               const SizedBox(height: 12),
//               Text(
//                 "No data available",
//                 style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     List<FlSpot> schemeSpots = widget.navData.asMap().entries.map((entry) {
//       int index = entry.key;
//       double value = entry.value.nav ?? 0.0;
//       return FlSpot(index.toDouble(), value);
//     }).toList();
//
//     double minY = schemeSpots.map((e) => e.y).reduce(min);
//     double maxY = schemeSpots.map((e) => e.y).reduce(max);
//     double buffer = (maxY - minY) * 0.1;
//
//     return Container(
//       height: isDesktop ? 280 : 220,
//       padding: isDesktop ? const EdgeInsets.all(20) : const EdgeInsets.all(12),
//       decoration: isDesktop
//           ? BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: Colors.grey.shade200),
//             )
//           : null,
//       child: LineChart(
//         LineChartData(
//           minX: 0,
//           maxX: (schemeSpots.length - 1).toDouble(),
//           minY: minY - buffer,
//           maxY: maxY + buffer,
//
//           gridData: FlGridData(
//             show: isDesktop,
//             drawVerticalLine: false,
//             horizontalInterval: ((maxY - minY) <= 0) ? null : (maxY - minY) / 5,
//             getDrawingHorizontalLine: (value) =>
//                 FlLine(color: Colors.grey.shade100, strokeWidth: 1),
//           ),
//           borderData: FlBorderData(show: false),
//           titlesData: FlTitlesData(
//             leftTitles: AxisTitles(
//               sideTitles: SideTitles(
//                 showTitles: isDesktop,
//                 reservedSize: 50,
//                 getTitlesWidget: (value, meta) {
//                   return Padding(
//                     padding: const EdgeInsets.only(right: 8),
//                     child: Text(
//                       '₹${value.toStringAsFixed(0)}',
//                       style: TextStyle(
//                         fontSize: 11,
//                         color: Colors.grey.shade600,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//             topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//             bottomTitles: AxisTitles(
//               sideTitles: SideTitles(
//                 showTitles: isDesktop,
//                 interval: schemeSpots.length > 10
//                     ? (schemeSpots.length / 5).ceilToDouble()
//                     : 1,
//                 getTitlesWidget: (value, meta) {
//                   final index = value.toInt();
//                   if (index >= 0 && index < widget.navData.length) {
//                     final date = widget.navData[index].navDate ?? "";
//                     final parts = date.split('-');
//                     if (parts.length == 3) {
//                       return Padding(
//                         padding: const EdgeInsets.only(top: 8),
//                         child: Text(
//                           '${parts[2]}/${parts[1]}',
//                           style: TextStyle(
//                             fontSize: 11,
//                             color: Colors.grey.shade600,
//                           ),
//                         ),
//                       );
//                     }
//                   }
//                   return const SizedBox();
//                 },
//               ),
//             ),
//           ),
//           lineTouchData: LineTouchData(
//             enabled: true,
//             handleBuiltInTouches: true,
//             touchSpotThreshold: 20,
//
//             getTouchedSpotIndicator:
//                 (LineChartBarData barData, List<int> spotIndexes) {
//                   return spotIndexes.map((index) {
//                     return TouchedSpotIndicatorData(
//                       FlLine(
//                         color: const Color(0xFF1E5DB9).withValues(alpha:0.5),
//                         strokeWidth: isDesktop ? 2 : 1.5,
//                         dashArray: [5, 5],
//                       ),
//                       FlDotData(
//                         show: true,
//                         getDotPainter: (spot, percent, barData, index) {
//                           return FlDotCirclePainter(
//                             radius: isDesktop ? 6 : 5,
//                             color: Colors.white,
//                             strokeWidth: isDesktop ? 3 : 2,
//                             strokeColor: const Color(0xFF1E5DB9),
//                           );
//                         },
//                       ),
//                     );
//                   }).toList();
//                 },
//             touchTooltipData: LineTouchTooltipData(
//               getTooltipColor: (_) => Colors.grey.shade900,
//               tooltipPadding: EdgeInsets.symmetric(
//                 horizontal: isDesktop ? 12 : 10,
//                 vertical: isDesktop ? 10 : 8,
//               ),
//               tooltipMargin: isDesktop ? 12 : 8,
//               tooltipBorderRadius: BorderRadius.circular(8),
//               getTooltipItems: (touchedSpots) {
//                 return touchedSpots.map((spot) {
//                   final date = widget.navData[spot.x.toInt()].navDate ?? "";
//                   return LineTooltipItem(
//                     '$date\n₹${spot.y.toStringAsFixed(2)}',
//                     TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                       fontSize: isDesktop ? 13 : 12,
//                     ),
//                   );
//                 }).toList();
//               },
//             ),
//             touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
//               setState(() {
//                 if (response?.lineBarSpots != null &&
//                     response!.lineBarSpots!.isNotEmpty) {
//                   touchedSpotIndex = response.lineBarSpots!.first.spotIndex;
//                 } else {
//                   touchedSpotIndex = null;
//                 }
//               });
//             },
//           ),
//           lineBarsData: [
//             LineChartBarData(
//               spots: schemeSpots,
//               isCurved: true,
//               curveSmoothness: 0.35,
//               gradient: const LinearGradient(
//                 colors: [Color(0xFF1E5DB9), Color(0xFF3B82F6)],
//               ),
//               barWidth: isDesktop ? 3 : 2.5,
//               dotData: FlDotData(
//                 show: isDesktop && schemeSpots.length <= 20,
//                 getDotPainter: (spot, percent, barData, index) {
//                   return FlDotCirclePainter(
//                     radius: 3,
//                     color: Colors.white,
//                     strokeWidth: 2,
//                     strokeColor: const Color(0xFF1E5DB9),
//                   );
//                 },
//               ),
//
//               belowBarData: BarAreaData(
//                 show: true,
//                 gradient: LinearGradient(
//                   colors: [
//                     const Color(0xFF1E5DB9).withValues(alpha:0.15),
//                     const Color(0xFF1E5DB9).withValues(alpha:0.05),
//                   ],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
