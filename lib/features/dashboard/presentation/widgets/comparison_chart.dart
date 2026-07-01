import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../core/utils/constant/text_style.dart'; // Import Responsive Framework

class FundComparisonChartWidget extends StatelessWidget {
  final bool showLegend;
  final bool showLeftTitles;
  final bool showRightTitles;
  final bool showTopTitles;
  final bool showBottomTitles;
  final bool showGrid;

  const FundComparisonChartWidget({
    super.key,
    this.showLegend = true,
    this.showLeftTitles = true,
    this.showRightTitles = false,
    this.showTopTitles = false,
    this.showBottomTitles = true,
    this.showGrid = true,
  });

  @override
  Widget build(BuildContext context) {
    // Detect Desktop
    final bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Container(
      // Responsive Height: Taller on desktop for better visibility
      height: isDesktop ? 350 : 300,
      padding: EdgeInsets.all(isDesktop ? 8 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),

      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Portfolio Performance",
                style: TextStyle(fontFamily: FontFamily.medium,
                  fontSize: isDesktop ? 18 : 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87
                ),
              ),
              if (showLegend) _buildLegend(isDesktop),
            ],
          ),
          SizedBox(height: isDesktop ? 24 : 16),

          // Chart
          Expanded(child: _buildChart(isDesktop)),
        ],
      ),
    );
  }

  Widget _buildLegend(bool isDesktop) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _legendItem("Portfolio", Colors.green.shade600, isDesktop),
        SizedBox(width: isDesktop ? 16 : 10),
        _legendItem("Benchmark", Colors.blue.shade400, isDesktop),
      ],
    );
  }

  Widget _legendItem(String label, Color color, bool isDesktop) {
    return Row(
      children: [
        Container(
          width: isDesktop ? 10 : 8,
          height: isDesktop ? 10 : 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(fontFamily: FontFamily.medium,
            fontSize: isDesktop ? 13 : 11,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildChart(bool isDesktop) {
    // Sample Data
    final List<FlSpot> yourSpots = [
      const FlSpot(0, 50000),
      const FlSpot(1, 62000),
      const FlSpot(2, 45000),
      const FlSpot(3, 77768),
      const FlSpot(4, 95000),
      const FlSpot(5, 82000),
    ];

    final List<FlSpot> suggestedSpots = [
      const FlSpot(0, 82000),
      const FlSpot(1, 75000),
      const FlSpot(2, 68000),
      const FlSpot(3, 82300),
      const FlSpot(4, 88000),
      const FlSpot(5, 90000),
    ];

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: showGrid,
          drawVerticalLine: true,
          horizontalInterval: 20000,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.shade100,
            strokeWidth: 1,
          ),
          getDrawingVerticalLine: (value) => FlLine(
            color: Colors.grey.shade100,
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          // Right Titles (Toggleable)
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: showRightTitles),
          ),
          // Top Titles (Toggleable)
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: showTopTitles),
          ),
          // Bottom Titles (Dynamic)
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: showBottomTitles,
              reservedSize: 32,
              interval: 1,
              getTitlesWidget: (value, meta) {
                const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                if (value.toInt() >= 0 && value.toInt() < months.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      months[value.toInt()],
                      style: TextStyle(fontFamily: FontFamily.medium,
                        fontSize: isDesktop ? 12 : 10,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          // Left Titles (Dynamic)
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: showLeftTitles,
              reservedSize: isDesktop ? 50 : 40,
              interval: 20000,
              getTitlesWidget: (value, meta) {
                if (value.toInt() % 20000 == 0) {
                  return Text(
                    '₹${(value / 1000).toStringAsFixed(0)}k',
                    style: TextStyle(fontFamily: FontFamily.medium,
                      fontSize: isDesktop ? 11 : 10,
                      color: Colors.grey.shade600,
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: 5,
        minY: 30000,
        maxY: 100000,
        lineBarsData: [
          // Your Portfolio (Green)
          LineChartBarData(
            spots: yourSpots,
            isCurved: true,
            curveSmoothness: 0.35,
            color: Colors.green.shade600,
            barWidth: isDesktop ? 3.5 : 2.8, // Thicker line on desktop
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, bar, index) {
                // Highlight specific point (e.g., current month)
                if (index == 3) {
                  return FlDotCirclePainter(
                    radius: isDesktop ? 8 : 6,
                    color: Colors.green.shade700,
                    strokeColor: Colors.white,
                    strokeWidth: 3,
                  );
                }
                return FlDotCirclePainter(radius: 0, color: Colors.transparent);
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.green.withValues(alpha:0.12),
            ),
          ),
          // Benchmark (Blue)
          LineChartBarData(
            spots: suggestedSpots,
            isCurved: true,
            curveSmoothness: 0.35,
            color: Colors.blue.shade400,
            barWidth: isDesktop ? 2.5 : 2.0,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blue.withValues(alpha:0.05),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpots) => Colors.black.withValues(alpha:0.8),
            tooltipBorderRadius: BorderRadius.circular(8),
            tooltipPadding: const EdgeInsets.all(12),
            fitInsideHorizontally: true,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final value = spot.y.toStringAsFixed(0);
                final monthIndex = spot.x.toInt();
                const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];

                return LineTooltipItem(
                  '$value\n${months[monthIndex]}',
                  const TextStyle(fontFamily: FontFamily.medium,
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold
                  ),
                );
              }).toList();
            },
          ),
          getTouchedSpotIndicator: (barData, spotIndexes) {
            return spotIndexes.map((index) {
              return TouchedSpotIndicatorData(
                FlLine(
                    color: Colors.grey.withValues(alpha:0.5),
                    strokeWidth: 1,
                    dashArray: [5, 5]
                ),
                FlDotData(
                  getDotPainter: (spot, percent, bar, index) =>
                      FlDotCirclePainter(
                        radius: 6,
                        color: Colors.white,
                        strokeColor: barData.color!,
                        strokeWidth: 3,
                      ),
                ),
              );
            }).toList();
          },
          handleBuiltInTouches: true,
        ),
      ),
    );
  }
}