import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

class FundModel {
  final String icon;
  final String name;
  final String riskType;
  final String sipReturns;
  final double rating;

  FundModel({
    required this.icon,
    required this.name,
    required this.riskType,
    required this.sipReturns,
    required this.rating,
  });

  factory FundModel.fromJson(Map<String, dynamic> json) {
    return FundModel(
      icon: json.parse<String>('icon') ?? '',
      name: json.parse<String>('name') ?? '',
      riskType: json.parse<String>('riskType') ?? '',
      sipReturns: json.parse<String>('sipReturns') ?? '',
      rating: json.parse<double>('rating') ?? 0.0,
    );
  }
}
