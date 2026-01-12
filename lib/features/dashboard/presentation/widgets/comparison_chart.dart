import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/core/utils/constant/colors.dart';

class FundComparisonChartWidget extends StatelessWidget {
  const FundComparisonChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Ucolors.darkgrey),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Fund Comparison",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(child: _buildChart()),
        ],
      ),
    );
  }

  Widget _buildChart() {
    // Sample data - replace with your real data
    // X-axis: months (Jan to Jun)
    // Two lines: your portfolio vs suggested/benchmark
    final List<FlSpot> yourSpots = [
      FlSpot(0, 50000), // Jan
      FlSpot(1, 62000), // Feb
      FlSpot(2, 45000), // Mar (dip)
      FlSpot(3, 77768), // Apr - current value
      FlSpot(4, 95000), // May
      FlSpot(5, 82000), // Jun
    ];

    final List<FlSpot> suggestedSpots = [
      FlSpot(0, 82000),
      FlSpot(1, 75000),
      FlSpot(2, 68000),
      FlSpot(3, 82300),
      FlSpot(4, 88000),
      FlSpot(5, 90000),
    ];

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 20000,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: Colors.grey.shade200, strokeWidth: 1),
          getDrawingVerticalLine: (value) =>
              FlLine(color: Colors.grey.shade200, strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                if (value.toInt() >= 0 && value.toInt() < months.length) {
                  return Text(
                    months[value.toInt()],
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 20000,
              getTitlesWidget: (value, meta) {
                if (value.toInt() % 20000 == 0) {
                  return Text(
                    '₹${(value / 1000).toStringAsFixed(0)}k',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  );
                }
                return const Text('');
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: 6,
        minY: 30000,
        maxY: 100000,
        lineBarsData: [
          // Your portfolio (green)
          LineChartBarData(
            spots: yourSpots,
            isCurved: true,
            curveSmoothness: 0.35,
            color: Colors.green.shade50,
            barWidth: 2.8,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, bar, index) {
                if (index == 3) {
                  // Highlight current point
                  return FlDotCirclePainter(
                    radius: 6,
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
              color: Colors.green,
              // color: Ucolors.light,
            ),
          ),
          // Suggested / benchmark (blue/teal)
          LineChartBarData(
            spots: suggestedSpots,
            isCurved: true,
            curveSmoothness: 0.35,
            color: Colors.blue.shade400,
            barWidth: 2.2,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: true, color: Colors.blue),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpots) => Colors.black,
            tooltipBorderRadius: BorderRadius.circular(8),
            tooltipPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            fitInsideHorizontally: true,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final value = spot.y.toStringAsFixed(0);
                final monthIndex = spot.x.toInt();
                const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];

                return LineTooltipItem(
                  '$value\n${months[monthIndex]}',
                  const TextStyle(color: Colors.white, fontSize: 13),
                );
              }).toList();
            },
          ),
          getTouchedSpotIndicator: (barData, spotIndexes) {
            return spotIndexes.map((index) {
              return TouchedSpotIndicatorData(
                FlLine(color: Colors.grey, strokeWidth: 1),
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

class FundComparisonChartWidget1 extends StatelessWidget {
  const FundComparisonChartWidget1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 260,
      height: Get.height * 0.3,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Ucolors.darkgrey),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Fund Comparison",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(child: _buildChart()),
        ],
      ),
    );
  }

  Widget _buildChart() {
    // Sample data - replace with your real data
    // X-axis: months (Jan to Jun)
    // Two lines: your portfolio vs suggested/benchmark
    final List<FlSpot> yourSpots = [
      FlSpot(0, 50000), // Jan
      FlSpot(1, 62000), // Feb
      FlSpot(2, 45000), // Mar (dip)
      FlSpot(3, 77768), // Apr - current value
      FlSpot(4, 95000), // May
      FlSpot(5, 82000), // Jun
    ];

    final List<FlSpot> suggestedSpots = [
      FlSpot(0, 82000),
      FlSpot(1, 75000),
      FlSpot(2, 68000),
      FlSpot(3, 82300),
      FlSpot(4, 88000),
      FlSpot(5, 90000),
    ];

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 20000,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: Colors.grey.shade200, strokeWidth: 1),
          getDrawingVerticalLine: (value) =>
              FlLine(color: Colors.grey.shade200, strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                if (value.toInt() >= 0 && value.toInt() < months.length) {
                  return Text(
                    months[value.toInt()],
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 20000,
              getTitlesWidget: (value, meta) {
                if (value.toInt() % 20000 == 0) {
                  return Text(
                    '₹${(value / 1000).toStringAsFixed(0)}k',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
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
          // Your portfolio (green)
          LineChartBarData(
            spots: yourSpots,
            isCurved: true,
            curveSmoothness: 0.35,
            color: Colors.green.shade600,
            barWidth: 2.8,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, bar, index) {
                if (index == 3) {
                  // Highlight current point
                  return FlDotCirclePainter(
                    radius: 6,
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
              color: Colors.green.withOpacity(0.12),
            ),
          ),
          // Suggested / benchmark (blue/teal)
          LineChartBarData(
            spots: suggestedSpots,
            isCurved: true,
            curveSmoothness: 0.35,
            color: Colors.blue.shade400,
            barWidth: 2.2,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blue.withOpacity(0.08),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpots) => Colors.black.withOpacity(0.75),
            tooltipBorderRadius: BorderRadius.circular(8),
            tooltipPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            fitInsideHorizontally: true,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final value = spot.y.toStringAsFixed(0);
                final monthIndex = spot.x.toInt();
                const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];

                return LineTooltipItem(
                  '$value\n${months[monthIndex]}',
                  const TextStyle(color: Colors.white, fontSize: 13),
                );
              }).toList();
            },
          ),
          getTouchedSpotIndicator: (barData, spotIndexes) {
            return spotIndexes.map((index) {
              return TouchedSpotIndicatorData(
                FlLine(color: Colors.grey.withOpacity(0.5), strokeWidth: 1),
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
