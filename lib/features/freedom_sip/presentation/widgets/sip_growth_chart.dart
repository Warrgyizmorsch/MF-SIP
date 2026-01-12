import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SipGrowthChart extends StatefulWidget {
  const SipGrowthChart({super.key});

  @override
  State<SipGrowthChart> createState() => _SipGrowthChartState();
}

class _SipGrowthChartState extends State<SipGrowthChart> {
  // Mock Data: [Year, Amount]
  // X = Year, Y = Amount in Lakhs (for example)
  // final List<FlSpot> investedData = [
  //   const FlSpot(0, 0),
  //   const FlSpot(1, 1.2),
  //   const FlSpot(2, 2.4),
  //   const FlSpot(3, 3.6),
  //   const FlSpot(4, 4.8),
  //   const FlSpot(5, 6.0),
  // ];

  final List<FlSpot> valueData = [
    const FlSpot(0, 0),
    const FlSpot(1, 1.3),
    const FlSpot(2, 2.8),
    const FlSpot(3, 4.5),
    const FlSpot(4, 6.5),
    const FlSpot(5, 9.2),
  ];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.70,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 18,
          left: 12,
          top: 24,
          bottom: 12,
        ),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              horizontalInterval: 2,
              getDrawingVerticalLine: (value){
                return const FlLine(
                  color: Color(0xffe7e8ec),
                  strokeWidth: 1,
                );
              },
              getDrawingHorizontalLine: (value) {
                return const FlLine(
                  color: Color(0xffe7e8ec),
                  strokeWidth: 1,
                );
              },
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
                  interval: 1,
                  getTitlesWidget: bottomTitleWidgets,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                  interval: 2,
                  getTitlesWidget: leftTitleWidgets,
                  reservedSize: 42,
                ),
              ),
            ),
            borderData: FlBorderData(
              show: false,
            ),
            minX: 0,
            maxX: 5,
            minY: 0,
            maxY: 10,
            lineBarsData: [
              // Invested Amount Line (Grey)
              // LineChartBarData(
              //   spots: investedData,
              //   isCurved: false,
              //   color: Colors.grey.withOpacity(0.5),
              //   barWidth: 3,
              //   isStrokeCapRound: true,
              //   dotData: const FlDotData(show: false),
              //   belowBarData: BarAreaData(show: false),
              // ),
              // Current Value Line (Green/Primary)
              LineChartBarData(
                spots: valueData,
                isCurved: true,
                color: Colors.green,
                barWidth: 4,
                isStrokeCapRound: true,
                dotData: const FlDotData(
                  show: false,
                ),
                // belowBarData: BarAreaData(
                //   show: true,
                //   color: Colors.green.withOpacity(0.1),
                // ),
              ),
            ],
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (touchedSpot) => Colors.black87,
                getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                  return touchedBarSpots.map((barSpot) {
                    final isInvested = barSpot.barIndex == 0;
                    return LineTooltipItem(
                      '${isInvested ? "Invested" : "Value"}: ${barSpot.y}L\n',
                      TextStyle(
                        color: isInvested ? Colors.grey[300] : Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }).toList();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
      color: Colors.grey,
    );
    return SideTitleWidget(
      meta: meta,
      child: Text('Yr ${value.toInt()}', style: style),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
      color: Colors.grey,
    );
    return Text('${value.toInt()}L', style: style, textAlign: TextAlign.left);
  }
}