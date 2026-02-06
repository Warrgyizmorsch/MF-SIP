import 'package:flutter/material.dart';

class RiskMeterConfig {
  final int needleValue; // 0–100
  final Color color;
  final String label;

  RiskMeterConfig({
    required this.needleValue,
    required this.color,
    required this.label,
  });
}
