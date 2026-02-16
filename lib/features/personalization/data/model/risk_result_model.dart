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

  // factory RiskResultModel.fromJson(Map<String, dynamic> json){
  //   // return RiskResultModel(status: json.parse(''), totalScore: totalScore, riskSlabId: riskSlabId, profileName: profileName)
  // }
}
