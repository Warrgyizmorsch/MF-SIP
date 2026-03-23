import 'package:equatable/equatable.dart';
import 'package:my_sip/features/personalization/data/model/risk_result_model.dart';

class RiskResultEntity extends Equatable {
  final bool status;
  final int totalScore;
  final int riskSlabId;
  final String profileName;

  const RiskResultEntity({
    required this.status,
    required this.totalScore,
    required this.riskSlabId,
    required this.profileName,
  });

  @override
  List<Object?> get props => [status, totalScore, riskSlabId, profileName];
}

extension RiskResultModelX on RiskResultModel {
  RiskResultEntity toRiskResultEntity() {
    return RiskResultEntity(
      status: status,
      totalScore: totalScore,
      riskSlabId: riskSlabId,
      profileName: profileName,
    );
  }
}
