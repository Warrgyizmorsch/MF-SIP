import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

final priceFormatter = NumberFormat.currency(
  locale: 'hi_IN',
  symbol: '₹',
  decimalDigits: 0,
);
void createLog(dynamic message) {
  if (!kDebugMode) return; // Only show in debug mode

  String output;
  if (message is Map || message is List) {
    // Pretty-print JSON
    output = const JsonEncoder.withIndent('  ').convert(message);
  } else {
    // Convert anything else to a string
    output = message.toString();
  }

  // --- Define a title and line prefix ---
  const String logTitle = "[MF App Log]";
  const String linePrefix = "│ "; // Box-drawing character

  // --- Define borders (you can change the length) ---
  final String topBorder = "┌${"─" * 80}";
  final String bottomBorder = "└${"─" * 80}";

  // --- Print the formatted log ---
  if (kDebugMode) {
    // Start with a newline for space
    print("\n$topBorder");
    print("$linePrefix $logTitle"); // Print the title
    print(linePrefix); // Print a blank line inside the box

    // Print each line of the actual message
    output.split('\n').forEach((line) {
      if (kDebugMode) {
        print("$linePrefix $line");
      }
    });

    print("$bottomBorder\n"); // End with a newline
  }
}

class UHelperFunction {
  static String getGreetingMsg() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      // 5am -  12pm
      return 'Good Morning';
    } else if (hour >= 12 && hour < 16) {
      // 12pm - 4pm
      return 'Good Afternoon';
    }
    if (hour >= 16 && hour < 19) {
      // 4pm - 7pm
      return 'Good Evening';
    } else {
      return 'Good night';
    }
  }
}

///////////////// -------------- Extract Fund Manager ----------- //////////////////
List<String> parseFundManagers(String? raw) {
  if (raw == null || raw.trim().isEmpty) {
    return [];
  }

  String text = raw;

  // 1. Remove text inside parentheses (e.g., "(dedicated for...)")
  text = text.replaceAll(RegExp(r'\(.*?\)', dotAll: true), '');

  // 2. Replace "FM" labels (FM 1, FM-2, FM) with a comma to separate them
  //    This handles cases like "Name FM 1" -> "Name ,"
  text = text.replaceAll(RegExp(r'FM\s*[-]?\s*\d*', caseSensitive: false), ',');

  // 3. Normalize other separators (&, " and ", newline) to comma
  text = text.replaceAll(RegExp(r'[&\n]| and ', caseSensitive: false), ',');

  // 4. Split by comma and clean up each item
  List<String> managers = [];

  for (String part in text.split(',')) {
    // Remove leading hyphens, dots, or whitespace
    String clean = part.replaceAll(RegExp(r'^[\s\-\.]+'), '').trim();

    // 5. FILTER: Ignore empty strings and "Not Applicable" placeholders
    if (clean.isNotEmpty &&
        !clean.toLowerCase().contains('not applicable') &&
        clean.toLowerCase() != 'na') {
      managers.add(clean);
    }
  }

  return managers;
}

int? _cacheSize(double size, double pixelRatio) {
  // Multiply by pixel ratio to maintain high quality on retina screens
  return (size * pixelRatio).toInt();
}

class PanCardFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // 1. Force Uppercase
    String newText = newValue.text.toUpperCase();

    // 2. Prevent length > 10
    if (newText.length > 10) return oldValue;

    StringBuffer buffer = StringBuffer();

    for (int i = 0; i < newText.length; i++) {
      String char = newText[i];

      // 3. Apply PAN Validation Logic based on index
      if (i < 5) {
        // Indices 0-4: Must be Letters [A-Z]
        if (RegExp(r'[A-Z]').hasMatch(char)) buffer.write(char);
      } else if (i >= 5 && i < 9) {
        // Indices 5-8: Must be Numbers [0-9]
        if (RegExp(r'[0-9]').hasMatch(char)) buffer.write(char);
      } else if (i == 9) {
        // Index 9: Must be Letter [A-Z]
        if (RegExp(r'[A-Z]').hasMatch(char)) buffer.write(char);
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

List<String> getCleanedTopHoldings({
  required List<String>? names,
  required List<dynamic>? values,
  int limit = 5,
}) {
  if (names == null || values == null || names.isEmpty || values.isEmpty) {
    return [];
  }

  int count = names.length < values.length ? names.length : values.length;
  List<MapEntry<String, double>> holdings = [];

  for (int i = 0; i < count; i++) {
    // 1. Get raw name
    String name = names[i];

    // --- AGGRESSIVE CLEANING START ---

    // A. Remove Percentages (e.g., "7.44%" or "8.65 %")
    name = name.replaceAll(RegExp(r'\d+(\.\d+)?\s*%'), '');

    // B. Remove Dates (Text Format like "03 Nov 2034" or "30 Jan 2027")
    //    Matches: 1-2 digits, space/dash, 3+ letters, space/dash, 4 digits
    name = name.replaceAll(
      RegExp(r'\b\d{1,2}[\s-][a-zA-Z]{3,}[\s-]\d{4}\b', caseSensitive: false),
      '',
    );

    // C. Remove Dates (Numeric Format like "25/11/2027")
    name = name.replaceAll(RegExp(r'\d{1,2}[/-]\d{1,2}[/-]\d{2,4}'), '');

    // D. Remove EVERYTHING inside parentheses (handles "()", "(India)", "(Formerly..)")
    name = name.replaceAll(RegExp(r'\(.*?\)'), '');

    // E. Remove Face Value Junk (starts with EQ, FV, RS, etc.)
    name = name.replaceAll(
      RegExp(
        r'\s+(EQ|NEW|FV|RS\.?|RE\.?|Rs\.?|Re\.?)\b.*$',
        caseSensitive: false,
      ),
      '',
    );

    // F. Remove Standalone Years at the end (e.g., "Government of India 2033" -> removes 2033)
    //    Matches 19xx or 20xx at the end of the string
    name = name.replaceAll(RegExp(r'\b(19|20)\d{2}\s*$'), '');

    // G. Remove Punctuation & Extra Spaces
    name = name.replaceAll(RegExp(r'[-–]'), ' '); // Replace hyphens with space
    name = name.replaceAll(RegExp(r'\s+'), ' '); // Collapse multiple spaces
    name = name.trim(); // Final Trim

    // --- AGGRESSIVE CLEANING END ---

    // 2. Process Value
    double val = 0.0;
    if (values[i] is num) {
      val = (values[i] as num).toDouble();
    } else if (values[i] is String) {
      val = double.tryParse(values[i]) ?? 0.0;
    }

    if (name.isNotEmpty) {
      holdings.add(MapEntry(name, val));
    }
  }

  // 3. Sort & Return
  holdings.sort((a, b) => b.value.compareTo(a.value));
  return holdings.take(limit).map((e) => e.key).toList();
}

///// Parse String to Int
double parseIntSafe(String? value, {double defaultValue = 0}) {
  if (value == null || value.trim().isEmpty) {
    return defaultValue;
  }

  final cleanValue = value.replaceAll(',', '').trim();

  return double.tryParse(cleanValue) ?? defaultValue;
}

String getRemainingDays(String? closeDateStr) {
  if (closeDateStr == null || closeDateStr.isEmpty) return "N/A";

  try {
    // Parse the date (Format: YYYY-MM-DD)
    final DateTime closeDate = DateTime.parse(closeDateStr);
    final DateTime now = DateTime.now();

    // Normalize dates to midnight to compare full days accurately
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime expiry = DateTime(
      closeDate.year,
      closeDate.month,
      closeDate.day,
    );

    final int difference = expiry.difference(today).inDays;

    if (difference < 0) {
      return "CLOSED";
    } else if (difference == 0) {
      return "ENDS TODAY";
    } else if (difference == 1) {
      return "ENDS TOMORROW";
    } else {
      return "ENDS IN $difference DAYS";
    }
  } catch (e) {
    createLog("Error parsing NFO date: $e");
    return "N/A";
  }
}
