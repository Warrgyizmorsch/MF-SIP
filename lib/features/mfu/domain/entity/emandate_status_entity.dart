// // features/mfu/domain/entity/mfu_mandate_status_entity.dart

// import 'package:equatable/equatable.dart';
// import 'package:my_sip/features/mfu/data/model/emandate_status.dart';

// class MfuMandateStatusEntity extends Equatable {
//   final bool success;
//   final String message;
//   final int mandateId;
//   final String mandateType;
//   final String status;

//   const MfuMandateStatusEntity({
//     required this.success,
//     required this.message,
//     required this.mandateId,
//     required this.mandateType,
//     required this.status,
//   });

//   bool get isActive => status.toLowerCase() == 'active';
//   bool get isPending => status.toLowerCase() == 'pending';
//   bool get isFailed => status.toLowerCase() == 'failed';

//   @override
//   List<Object?> get props => [success, message, mandateId, mandateType, status];
// }

// extension MfuMandateStatusMapper on MfuMandateStatusModel {
//   MfuMandateStatusEntity toEntity() {
//     return MfuMandateStatusEntity(
//       success: success ?? false,
//       message: message ?? '',
//       mandateId: mandateId ?? 0,
//       mandateType: mandateType ?? '',
//       status: status ?? '',
//     );
//   }
// }


// features/mfu/domain/entity/mfu_mandate_status_entity.dart

import 'package:equatable/equatable.dart';
import 'package:my_sip/features/mfu/data/model/emandate_status.dart';

class MfuMandateStatusEntity extends Equatable {
  final bool status;
  final String message;
  final int mandateId;
  final int userId;
  final String mandateMode;
  final String can;
  final String mumrn;
  final String mmrn;
  final String aumrn;
  final String mandateStatus;
  final MfuMandateStatusResponseEntity? response;

  const MfuMandateStatusEntity({
    required this.status,
    required this.message,
    required this.mandateId,
    required this.userId,
    required this.mandateMode,
    required this.can,
    required this.mumrn,
    required this.mmrn,
    required this.aumrn,
    required this.mandateStatus,
    this.response,
  });

  bool get isEnach => mandateMode == 'enach';
  bool get isUpi => mandateMode == 'upi';
  bool get isPending => mandateStatus.toLowerCase() == 'pending';
  bool get isActive => mandateStatus.toLowerCase() == 'active';
  bool get isInitiated => mandateStatus.toLowerCase() == 'initiated';
  bool get isFailed => mandateStatus.toLowerCase() == 'failed';
  bool get isResponseSuccess => response?.isSuccess ?? false;

  @override
  List<Object?> get props => [
        status, message, mandateId, userId, mandateMode, can,
        mumrn, mmrn, aumrn, mandateStatus, response,
      ];
}

class MfuMandateStatusResponseEntity extends Equatable {
  final String respFlag;
  final int respCode;
  final String respMsg;
  final String aumrn;
  final String prn;
  final String regStatus;
  final String aggrStatus;

  const MfuMandateStatusResponseEntity({
    required this.respFlag,
    required this.respCode,
    required this.respMsg,
    required this.aumrn,
    required this.prn,
    required this.regStatus,
    required this.aggrStatus,
  });

  bool get isSuccess => respFlag == 'S';

  @override
  List<Object?> get props => [
        respFlag, respCode, respMsg, aumrn, prn, regStatus, aggrStatus,
      ];
}

// ─── Mappers ──────────────────────────────────────────────────────────────────

extension MfuMandateStatusMapper on MfuMandateStatusModel {
  MfuMandateStatusEntity toEntity() {
    return MfuMandateStatusEntity(
      status: status ?? false,
      message: message ?? '',
      mandateId: mandateId ?? 0,
      userId: userId ?? 0,
      mandateMode: mandateMode ?? '',
      can: can ?? '',
      mumrn: mumrn ?? '',
      mmrn: mmrn ?? '',
      aumrn: aumrn ?? '',
      mandateStatus: mandateStatus ?? '',
      response: response?.toEntity(),
    );
  }
}

extension MfuMandateStatusResponseMapper on MfuMandateStatusResponseModel {
  MfuMandateStatusResponseEntity toEntity() {
    return MfuMandateStatusResponseEntity(
      respFlag: respFlag ?? '',
      respCode: respCode ?? 0,
      respMsg: respMsg ?? '',
      aumrn: aumrn ?? '',
      prn: prn ?? '',
      regStatus: regStatus ?? '',
      aggrStatus: aggrStatus ?? '',
    );
  }
}