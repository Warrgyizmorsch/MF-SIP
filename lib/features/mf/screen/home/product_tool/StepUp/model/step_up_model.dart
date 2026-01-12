import 'dart:math';

enum StepUpType { percentage, amount }

class ChartRow {
  final int year;
  final double invested;
  final double value;

  ChartRow({
    required this.year,
    required this.invested,
    required this.value,
  });
}

class DetailRow {
  final int year;
  final double stepInvested;
  final double stepValue;
  final double stepProfit;
  final double normalValue;
  final double extraGain;

  DetailRow({
    required this.year,
    required this.stepInvested,
    required this.stepValue,
    required this.stepProfit,
    required this.normalValue,
    required this.extraGain,
  });
}

class Compare {
  final double invested;
  final double value;
  final double profit;

  Compare({
    required this.invested,
    required this.value,
    required this.profit,
  });
}

class StepUpSipResult {
  final Compare normal;
  final Compare stepUp;
  final List<ChartRow> chartData;
  final List<DetailRow> detailRows;

  StepUpSipResult({
    required this.normal,
    required this.stepUp,
    required this.chartData,
    required this.detailRows,
  });
}
