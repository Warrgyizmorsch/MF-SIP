import 'package:equatable/equatable.dart';

import '../../data/model/bank_verification_model.dart';

class BankVerificationEntity extends Equatable {
  final String? active;
  final String? nameMatch;
  final String? mobileMatch;
  final String? signzyReferenceId;
  final AuditTrailEntity? auditTrail;

  const BankVerificationEntity({
    this.active,
    this.nameMatch,
    this.mobileMatch,
    this.signzyReferenceId,
    this.auditTrail,
  });

  @override
  List<Object?> get props => [
    active,
    nameMatch,
    mobileMatch,
    signzyReferenceId,
    auditTrail,
  ];
}


class AuditTrailEntity extends Equatable {
  final String? nature;
  final String? value;
  final String? timestamp;

  const AuditTrailEntity({
    this.nature,
    this.value,
    this.timestamp,
  });

  @override
  List<Object?> get props => [
    nature,
    value,
    timestamp,
  ];
}
extension BankVerificationModelMapper on BankVerificationModel {
  BankVerificationEntity toEntity() {
    return BankVerificationEntity(
      active: result?.active,
      nameMatch: result?.nameMatch,
      mobileMatch: result?.mobileMatch,
      signzyReferenceId: result?.signzyReferenceId,
      auditTrail: result?.auditTrail?.toEntity(),
    );
  }
}
extension AuditTrailModelMapper on AuditTrailModel {
  AuditTrailEntity toEntity() {
    return AuditTrailEntity(
      nature: nature,
      value: value,
      timestamp: timestamp,
    );
  }
}
