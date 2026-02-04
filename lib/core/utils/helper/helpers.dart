import 'dart:convert';

import 'package:flutter/foundation.dart';
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

// Map<String, String> parseFundManagers(String? raw) {
//   if (raw == null || raw.trim().isEmpty) {
//     return {'fm1': '', 'fm2': ''};
//   }

//   final fm1Match = RegExp(r'FM\s*1\s*(.*?)(?=FM\s*2|$)')
//       .firstMatch(raw);

//   final fm2Match = RegExp(r'FM\s*2\s*(.*)')
//       .firstMatch(raw);

//   return {
//     'fm1': fm1Match?.group(1)?.trim() ?? '',
//     'fm2': fm2Match?.group(1)?.trim() ?? '',
//   };
// }

Map<String, String> parseFundManagers(String? raw) {
  if (raw == null || raw.trim().isEmpty) {
    return {'fm1': '', 'fm2': ''};
  }

  // Case 1: No FM labels → treat whole string as FM1
  if (!raw.contains('FM')) {
    return {'fm1': raw.trim(), 'fm2': ''};
  }

  // Case 2: FM labels exist
  final fm1Match = RegExp(r'FM\s*1\s*(.*?)(?=FM\s*2|$)').firstMatch(raw);

  final fm2Match = RegExp(r'FM\s*2\s*(.*)').firstMatch(raw);

  return {
    'fm1': fm1Match?.group(1)?.trim() ?? '',
    'fm2': fm2Match?.group(1)?.trim() ?? '',
  };
}

int? _cacheSize(double size, double pixelRatio) {
  // Multiply by pixel ratio to maintain high quality on retina screens
  return (size * pixelRatio).toInt();
}
