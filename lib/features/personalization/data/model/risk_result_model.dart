import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

class RiskResultModel {
  final bool status;
  final int totalScore;
  final int riskSlabId;
  final String profileName;

  RiskResultModel({
    required this.status,
    required this.totalScore,
    required this.riskSlabId,
    required this.profileName,
  });


Map<String, dynamic> toJson() {
    return {
      'status': status,
      'total_score': totalScore,
      'risk_slab_id': riskSlabId,
      'profile_name': profileName,
    };
  }
  factory RiskResultModel.fromJson(Map<String, dynamic> json) {
    return RiskResultModel(
      status: json.parse<bool>('status') ?? false,
      totalScore: json.parse<int>('total_score') ?? 0,
      riskSlabId: json.parse<int>('risk_slab_id') ?? 0,
      profileName: json.parse<String>('profile_name') ?? '',
    );
  }


}
