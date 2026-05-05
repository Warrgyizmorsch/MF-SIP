import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/features/fund_details/data/models/fund_performance.dart';
import 'package:responsive_framework/responsive_framework.dart';

class YearlyReturnsChart extends StatelessWidget {
  const YearlyReturnsChart({super.key, this.height, required this.yearlyData});

  final double? height;
  final List<YearlyReturn> yearlyData;

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final maxValue =
        yearlyData.map((e) => e.value).reduce((a, b) => a > b ? a : b) + 5;

    return Container(
      height: height ?? (isDesktop ? 290 : 180),
      padding: isDesktop ? const EdgeInsets.all(20) : const EdgeInsets.all(8),
      decoration: isDesktop
          ? BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      )
          : null,
      child: Stack(
        children: [
          /// BAR CHART
          BarChart(
            BarChartData(
              maxY: maxValue,
              minY: 0,
              gridData: FlGridData(
                show: isDesktop,
                drawVerticalLine: false,
                horizontalInterval: 10,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.grey.shade100,
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(show: false),
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => Colors.black87,
                  tooltipPadding: const EdgeInsets.all(8),
                  tooltipMargin: 8,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      '${yearlyData[group.x.toInt()].year}\n${rod.toY.toStringAsFixed(2)}%',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: isDesktop,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '${value.toInt()}%',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
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
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      return Padding(
                        padding: EdgeInsets.only(top: isDesktop ? 12 : 6),
                        child: FittedBox(
                          child: Text(
                            yearlyData[value.toInt()].year,
                            style: TextStyle(
                              fontSize: isDesktop ? 11 : 11,
                              fontWeight: isDesktop ? FontWeight.w500 : FontWeight.normal,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              barGroups: List.generate(yearlyData.length, (index) {
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: yearlyData[index].value,
                      width: isDesktop ? 32 : Get.width * 0.07,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF1B7A3A),
                          const Color(0xFFFFF176),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(isDesktop ? 8 : 6),
                        topRight: Radius.circular(isDesktop ? 8 : 6),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),

          /// TEXT LABELS ABOVE BARS
          if (!isDesktop)
            Positioned.fill(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(yearlyData.length, (index) {
                  final value = yearlyData[index].value;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: (value / maxValue * 140) + 25,
                      ),
                      child: Text(
                        '${value.toStringAsFixed(2)}%',
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1B7A3A),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}