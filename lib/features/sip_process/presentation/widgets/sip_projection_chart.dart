import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';


class SipProjectionChart extends StatelessWidget {
  final List<FlSpot> investedSpots;
  final List<FlSpot> projectedSpots;

  const SipProjectionChart({
    super.key,
    required this.investedSpots,
    required this.projectedSpots,
  });

  @override
  Widget build(BuildContext context) {


    if (investedSpots.isEmpty || projectedSpots.isEmpty) {
      return const SizedBox.shrink();
    }



    final double minX = investedSpots.first.x;
    final double maxX = investedSpots.last.x;



    final double maxInvested = investedSpots.map((e) => e.y).reduce(math.max);
    final double maxProjected = projectedSpots.map((e) => e.y).reduce(math.max);
    final double maxY = math.max(maxInvested, maxProjected);


    final double maxYBuffer = maxY * 1.2;

    return AspectRatio(
      aspectRatio: 1.70,
      child: Container(
        color: Colors.transparent,
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),


            clipData: const FlClipData.none(),

            titlesData: FlTitlesData(
              show: true,
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),

              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    final year = value.toInt();


                    return SideTitleWidget(
                      meta: meta,
                      child: Text(
                        year.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),


            minX: minX,
            maxX: maxX,
            minY: 0,
            maxY: maxYBuffer,

            lineBarsData: [

              LineChartBarData(
                spots: investedSpots,
                isCurved: true,
                color: Colors.blueAccent,
                barWidth: 4,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(show: false),
              ),


              LineChartBarData(
                spots: projectedSpots,
                isCurved: true,
                color: Colors.greenAccent,
                barWidth: 4,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}