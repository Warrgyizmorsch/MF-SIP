// class SwpReportRow {
//   final int year;
//   final double withdrawn;
//   final double profit;
//   final double remaining;

//   SwpReportRow({
//     required this.year,
//     required this.withdrawn,
//     required this.profit,
//     required this.remaining,
//   });
// }


// class SwpYearReport {
//   final int year;
//   final double totalWithdrawn;
//   final double profit;
//   final double remaining;

//   SwpYearReport({
//     required this.year,
//     required this.totalWithdrawn,
//     required this.profit,
//     required this.remaining,
//   });
// }

class SwpYearReport {
  final int year;
  final double withdrawn; // cumulative
  final double remaining;
  final double profit;

  SwpYearReport({
    required this.year,
    required this.withdrawn,
    required this.remaining,
    required this.profit,
  });
}

