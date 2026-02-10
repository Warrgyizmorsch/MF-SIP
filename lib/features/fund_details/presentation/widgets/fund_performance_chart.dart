import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GroupedPerformanceBarChart extends StatefulWidget {
  final List<dynamic> data; // Accepts List<ReturnRow>

  const GroupedPerformanceBarChart({super.key, required this.data});

  @override
  State<GroupedPerformanceBarChart> createState() =>
      _GroupedPerformanceBarChartState();
}

class _GroupedPerformanceBarChartState
    extends State<GroupedPerformanceBarChart> {
  // Config for bar width and spacing
  final double width = 7;
  late int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) return const SizedBox();

    return AspectRatio(
      aspectRatio: 1.5,
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            titlesData: FlTitlesData(
              show: true,
              // Bottom Titles (Time Periods: 1M, 3M, etc.)
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < widget.data.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          widget.data[index].period,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
              // Left Titles (Y-Axis Percentages)
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    if (value == 0) return const SizedBox(); // Hide 0
                    return Text(
                      '${value.toInt()}%',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 10,
                      ),
                    );
                  },
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 5, // Grid line every 5%
              getDrawingHorizontalLine: (value) =>
                  FlLine(color: Colors.grey.shade100, strokeWidth: 1),
            ),
            borderData: FlBorderData(show: false),
            // Tooltip Configuration
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (_) => Colors.blueGrey.shade900,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  String label = '';
                  if (rodIndex == 0) label = 'Fund';
                  if (rodIndex == 1) label = 'B\'mark';
                  if (rodIndex == 2) label = 'Cat';
                  return BarTooltipItem(
                    '$label\n',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '${rod.toY}%',
                        style: const TextStyle(
                          color: Colors.yellowAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  );
                },
              ),
              touchCallback: (FlTouchEvent event, barTouchResponse) {
                setState(() {
                  if (!event.isInterestedForInteractions ||
                      barTouchResponse == null ||
                      barTouchResponse.spot == null) {
                    touchedIndex = -1;
                    return;
                  }
                  touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
                });
              },
            ),
            barGroups: widget.data.asMap().entries.map((entry) {
              final index = entry.key;
              final row = entry.value;
              return generateGroup(
                index,
                row.scheme, // Fund
                row.benchmark, // Benchmark
                row.category, // Category
              );
            }).toList(),
            // Maximum Y value (add a buffer so top bars aren't cut off)
            maxY: _getMaxY() + 1,
          ),
        ),
      ),
    );
  }

  // Helper to calculate max Y value for scaling
  double _getMaxY() {
    double maxVal = 0;
    for (var item in widget.data) {
      if (item.scheme > maxVal) maxVal = item.scheme;
      if (item.benchmark > maxVal) maxVal = item.benchmark;
      if (item.category > maxVal) maxVal = item.category;
    }
    return maxVal;
  }

  BarChartGroupData generateGroup(
    int x,
    double fund,
    double benchmark,
    double category,
  ) {
    return BarChartGroupData(
      x: x,
      groupVertically: false,
      barRods: [
        // 1. Fund Bar (Green - Main)
        BarChartRodData(
          toY: fund,
          color: Colors.green, // Your Brand Green
          width: width,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
        // 2. Benchmark Bar (Grey)
        BarChartRodData(
          toY: benchmark,
          color: Colors.grey.shade400,
          width: width,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
        // 3. Category Bar (Light Blue)
        BarChartRodData(
          toY: category,
          color: Colors.lightBlue.shade200,
          width: width,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
    );
  }
}
