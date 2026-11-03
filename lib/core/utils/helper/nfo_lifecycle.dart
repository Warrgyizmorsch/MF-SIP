enum NfoLifecycle { regular, upcoming, open, closed }

/// NFO dates are India calendar dates, independent of the device's timezone.
DateTime indiaCalendarDate(DateTime instant) {
  final indiaTime = instant.toUtc().add(const Duration(hours: 5, minutes: 30));
  return DateTime.utc(indiaTime.year, indiaTime.month, indiaTime.day);
}

DateTime? nfoCalendarDate(String? value) {
  if (value == null) return null;
  final match = RegExp(
    r'^(\d{4})-(\d{2})-(\d{2})(?:$|T| )',
  ).firstMatch(value.trim());
  if (match == null) return null;
  final year = int.parse(match[1]!);
  final month = int.parse(match[2]!);
  final day = int.parse(match[3]!);
  final date = DateTime.utc(year, month, day);
  return date.year == year && date.month == month && date.day == day
      ? date
      : null;
}

NfoLifecycle resolveNfoLifecycle({
  required bool isNfo,
  String? openDate,
  String? closeDate,
  String? launchDate,
  String? status,
  bool? isOpen,
  int? daysRemaining,
  DateTime? now,
}) {
  if (!isNfo) return NfoLifecycle.regular;
  final today = indiaCalendarDate(now ?? DateTime.now());
  final launch = nfoCalendarDate(launchDate);
  // A historical NFO flag or CLOSED status must not override the launch.
  if (launch != null && !today.isBefore(launch)) {
    return NfoLifecycle.regular;
  }
  final open = nfoCalendarDate(openDate);
  if (open != null && today.isBefore(open)) return NfoLifecycle.upcoming;
  final close = nfoCalendarDate(closeDate);
  if (close != null && today.isAfter(close)) return NfoLifecycle.closed;
  if (isOpen == false || status?.trim().toUpperCase() == 'CLOSED') {
    return NfoLifecycle.closed;
  }
  // Zero days left still includes the closing date when that date is known.
  if (close == null && daysRemaining != null && daysRemaining <= 0) {
    return NfoLifecycle.closed;
  }
  return NfoLifecycle.open;
}
