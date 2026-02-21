import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class GroupedPerformanceBarChart extends StatefulWidget {
  final List<dynamic> data;

  const GroupedPerformanceBarChart({super.key, required this.data});

  @override
  State<GroupedPerformanceBarChart> createState() =>
      _GroupedPerformanceBarChartState();
}

class _GroupedPerformanceBarChartState
    extends State<GroupedPerformanceBarChart> {
  late int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) return const SizedBox();

    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final width = isDesktop
        ? 16.0
        : 12.0; // Increased width slightly for desktop

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isDesktop ? 16 : 12),
        border: isDesktop ? Border.all(color: Colors.grey.shade200) : null,
        boxShadow: isDesktop
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      padding: isDesktop ? const EdgeInsets.all(24) : const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Important for Column
        children: [
          if (isDesktop) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Performance Comparison',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade900,
                  ),
                ),
                _buildLegend(isDesktop: true, width: width),
              ],
            ),
            const SizedBox(height: 24),
          ],

          // ---------------------------------------------------------
          // 👇 FIX: Use SizedBox with fixed height instead of AspectRatio
          // ---------------------------------------------------------
          SizedBox(
            height: isDesktop
                ? 300
                : 250, // Fixed height prevents overflow on wide screens
            child: BarChart(
              BarChartData(
                // alignment: BarChartAlignment.spaceAround,
                alignment: BarChartAlignment.spaceBetween,
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      interval: 1,
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < widget.data.length) {
                          return Padding(
                            padding: EdgeInsets.only(top: isDesktop ? 12 : 8),
                            child: FittedBox(
                              child: Text(
                                widget.data[index].period,
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w600,
                                  fontSize: isDesktop ? 12 : 10,
                                ),
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      // interval: 1,
                      showTitles: false,
                      reservedSize: isDesktop ? 40 : 30,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return const SizedBox();
                        return Text(
                          '${value.toInt()}%',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: isDesktop ? 12 : 10,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,

                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) =>
                      FlLine(color: Colors.grey.shade100, strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => Colors.grey.shade900,
                    tooltipPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      String label = '';
                      if (rodIndex == 0) label = 'Fund';
                      if (rodIndex == 1) label = 'Benchmark';
                      // if (rodIndex == 2) label = 'Category';
                      return BarTooltipItem(
                        '$label\n',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '${rod.toY.toStringAsFixed(2)}%',
                            style: const TextStyle(
                              color: Colors.yellowAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
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
                      touchedIndex =
                          barTouchResponse.spot!.touchedBarGroupIndex;
                    });
                  },
                ),
                barGroups: widget.data.asMap().entries.map((entry) {
                  final index = entry.key;
                  final row = entry.value;
                  return generateGroup(
                    index,
                    row.scheme,
                    row.benchmark,
                    // row.category,
                    width,
                    isDesktop,
                  );
                }).toList(),
                // maxY: _getMaxY(), // Added buffer for top labels
                maxY: (_getMaxY()).ceilToDouble(), // Adds 1% buffer to the top
              ),
            ),
          ),
          if (!isDesktop) ...[
            const SizedBox(height: 16),
            _buildLegend(isDesktop: false, width: width),
          ],
        ],
      ),
    );
  }

  Widget _buildLegend({required bool isDesktop, required double width}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      // spacing: isDesktop ? 24 : 16,

      // runSpacing: 8,
      children: [
        _legendItem('Fund', const Color(0xFF22C55E), width),
        _legendItem('Benchmark', Colors.grey.shade400, width),
        // _legendItem('Category', const Color(0xFF60A5FA), width),
      ],
    );
  }

  Widget _legendItem(String label, Color color, double width) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

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
    // double category,
    double width,
    bool isDesktop,
  ) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      groupVertically: false,
      barRods: [
        BarChartRodData(
          toY: fund,
          gradient: const LinearGradient(
            colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          width: width,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(isDesktop ? 4 : 2),
          ),
        ),
        BarChartRodData(
          toY: benchmark,
          color: Colors.grey.shade400,
          width: width,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(isDesktop ? 4 : 2),
          ),
        ),
        // BarChartRodData(
        //   toY: category,
        //   color: const Color(0xFF60A5FA),
        //   width: width,
        //   borderRadius: BorderRadius.vertical(
        //     top: Radius.circular(isDesktop ? 4 : 2),
        //   ),
        // ),
      ],
    );
  }
}
