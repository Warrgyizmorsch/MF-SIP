// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:my_sip/features/mf/screen/fund_details/widget/model/fund_performance.dart';

// class ReturnsBarChart extends StatelessWidget {
//   final List<YearlyReturn> data;

//   const ReturnsBarChart({super.key, required this.data});

//   @override
//   Widget build(BuildContext context) {
//     return BarChart(
//       BarChartData(
//         maxY: 35,
//         minY: 0,
//         gridData: FlGridData(show: false),
//         borderData: FlBorderData(show: false),
//         titlesData: FlTitlesData(
//           leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//           topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//           rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//           bottomTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               getTitlesWidget: (value, _) {
//                 return Padding(
//                   padding: const EdgeInsets.only(top: 8),
//                   child: Text(
//                     data[value.toInt()].year,
//                     style: const TextStyle(fontSize: 11),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//         barGroups: List.generate(data.length, (index) {
//           final item = data[index];
//           return BarChartGroupData(
//             // barsSpace: 12,
//             x: index,
//             barRods: [
//               BarChartRodData(
//                 toY: item.value,
//                 width: 25,
//                 borderRadius: BorderRadius.circular(6),
//                 color: Colors.green.shade800,
//               ),
//             ],
//             // showingTooltipIndicators: [0],
//           );
//         }),
//         barTouchData: BarTouchData(
//           enabled: true,
//           touchTooltipData: BarTouchTooltipData(
//             // tooltipBgColor: Colors.transparent,
//             getTooltipItem: (group, _, rod, __) {
//               return BarTooltipItem(
//                 '${rod.toY.toStringAsFixed(2)}%',
//                 const TextStyle(
//                   color: Colors.green,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 12,
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:my_sip/features/fund_details/data/models/fund_performance.dart';

class YearlyReturnsChart extends StatelessWidget {
  const YearlyReturnsChart({super.key, this.height, required this.yearlyData});

  final double? height;
  final List<YearlyReturn> yearlyData;

  @override
  Widget build(BuildContext context) {
    final maxValue =
        yearlyData.map((e) => e.value).reduce((a, b) => a > b ? a : b) + 5;

    return SizedBox(
      height: height,
      child: Stack(
        children: [
          /// BAR CHART
          BarChart(
            BarChartData(
              maxY: maxValue,
              minY: 0,
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
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
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          yearlyData[value.toInt()].year,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black54,
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
                      width: 20,
                      color: const Color(0xFF1B7A3A),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),

          /// TEXT LABELS ABOVE BARS
          Positioned.fill(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(yearlyData.length, (index) {
                final value = yearlyData[index].value;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      // right: 5,
                      // left: 5,
                      // bottom: (value / 40 * 140) + 25, // auto placement
                      bottom: (value / maxValue * 140) + 25,
                    ),
                    child: Text(
                      '${value.toStringAsFixed(2)}%',
                      textAlign: TextAlign.center,
                      maxLines: 1,

                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,

                        fontSize: 10,
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
