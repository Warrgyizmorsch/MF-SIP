import 'package:flutter/material.dart';
import 'package:my_sip/features/fund_details/data/models/risk_analysis_model.dart';

RiskMeterConfig getRiskMeter(String? risk) {
  final value = risk?.toLowerCase().trim() ?? '';

  switch (value) {
    case 'low':
      return RiskMeterConfig(
        needleValue: 10,
        color: Colors.green,
        label: 'Low',
      );

    case 'low to moderate':
      return RiskMeterConfig(
        needleValue: 30,
        color: Colors.lightGreen,
        label: 'Low to Moderate',
      );

    case 'moderate':
      return RiskMeterConfig(
        needleValue: 50,
        color: Colors.yellow,
        label: 'Moderate',
      );

    case 'moderate high':
      return RiskMeterConfig(
        needleValue: 70,
        color: Colors.orange,
        label: 'Moderate High',
      );
    case 'moderately high':
      return RiskMeterConfig(
        needleValue: 70,
        color: Colors.orange,
        label: 'Moderate High',
      );

    case 'high':
      return RiskMeterConfig(needleValue: 90, color: Colors.red, label: 'High');
    case 'very high':
      return RiskMeterConfig(needleValue: 90, color: Colors.red, label: 'High');

    default:
      return RiskMeterConfig(
        needleValue: 0,
        color: Colors.grey,
        label: 'Unknown',
      );
  }
}