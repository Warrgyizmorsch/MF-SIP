import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SchemeLineChart extends StatelessWidget {
  const SchemeLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    final List<FlSpot> schemeSpots = [
      FlSpot(0, 10),
      FlSpot(1, 9.5),
      FlSpot(2, 10.2),
      FlSpot(3, 9.8),
      FlSpot(4, 10.6),
      FlSpot(5, 10.4),
      FlSpot(6, 11.0),
      FlSpot(7, 10.8),
      FlSpot(8, 11.3),
      FlSpot(9, 11.7),
    ];
    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: schemeSpots.length - 1,
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
          ),
          lineBarsData: [
            LineChartBarData(
              spots: schemeSpots,
              isCurved: true,
              color: const Color(0xFF1E5DB9), // BLUE LINE
              barWidth: 2.5,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
