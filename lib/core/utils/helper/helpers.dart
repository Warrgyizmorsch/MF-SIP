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