class ReturnRow {
  final String period;
  final double scheme;
  final double category;
  final double benchmark;
  final double? extra;

  ReturnRow({
    required this.period,
    required this.scheme,
    required this.category,
    required this.benchmark,
    this.extra,
  });
}
