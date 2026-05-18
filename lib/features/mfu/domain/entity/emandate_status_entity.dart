// features/mfu/domain/entity/mfu_mandate_status_entity.dart

import 'package:equatable/equatable.dart';
import 'package:my_sip/features/mfu/data/model/emandate_status.dart';

class MfuMandateStatusEntity extends Equatable {
  final bool success;
  final String message;
  final int mandateId;
  final String mandateType;
  final String status;

  const MfuMandateStatusEntity({
    required this.success,
    required this.message,
    required this.mandateId,
    required this.mandateType,
    required this.status,
  });

  bool get isActive => status.toLowerCase() == 'active';
  bool get isPending => status.toLowerCase() == 'pending';
  bool get isFailed => status.toLowerCase() == 'failed';

  @override
  List<Object?> get props => [success, message, mandateId, mandateType, status];
}

extension MfuMandateStatusMapper on MfuMandateStatusModel {
  MfuMandateStatusEntity toEntity() {
    return MfuMandateStatusEntity(
      success: success ?? false,
      message: message ?? '',
      mandateId: mandateId ?? 0,
      mandateType: mandateType ?? '',
      status: status ?? '',
    );
  }
}