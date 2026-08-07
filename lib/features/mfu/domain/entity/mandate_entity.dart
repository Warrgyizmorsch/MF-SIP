// // features/mfu/domain/entity/mfu_mandate_create_entity.dart

// import 'package:equatable/equatable.dart';
// import 'package:my_sip/features/mfu/data/model/mandate_model.dart';

// class MfuMandateCreateEntity extends Equatable {
//   final bool success;
//   final String message;
//   final int mandateId;
//   final String mandateType;
//   final String? status;
//   final String? approveLink;
//   final String? deepLink;
//   final MfuMandatePlainBodyEntity? plainBody;
//   final MfuMandateResponseEntity? response;

//   const MfuMandateCreateEntity({
//     required this.success,
//     required this.message,
//     required this.mandateId,
//     required this.mandateType,
//     this.status,
//     this.approveLink,
//     this.deepLink,

//     this.plainBody,
//     this.response,
//   });

//   // bool get isSuccess => response?.isSuccess ?? false;
//   // String get approveLink => response?.approveLink ?? '';
//   // String get mmrn => response?.mmrn ?? '';

//   @override
//   List<Object?> get props => [
//         success, message, mandateId, mandateType,
//         plainBody, response,
//       ];
// }

// class MfuMandatePlainBodyEntity extends Equatable {
//   final String mandateType;
//   final String regMode;
//   final String can;
//   final String arnCode;
//   final String riaCode;
//   final String euin;
//   final String accNo;
//   final String accType;
//   final String ifscCode;
//   final String micrCode;
//   final String maxAmt;
//   final String perpetualFlag;
//   final String startDate;
//   final String endDate;

//   const MfuMandatePlainBodyEntity({
//     required this.mandateType,
//     required this.regMode,
//     required this.can,
//     required this.arnCode,
//     required this.riaCode,
//     required this.euin,
//     required this.accNo,
//     required this.accType,
//     required this.ifscCode,
//     required this.micrCode,
//     required this.maxAmt,
//     required this.perpetualFlag,
//     required this.startDate,
//     required this.endDate,
//   });

//   @override
//   List<Object?> get props => [
//         mandateType, regMode, can, arnCode, riaCode, euin,
//         accNo, accType, ifscCode, micrCode, maxAmt,
//         perpetualFlag, startDate, endDate,
//       ];
// }

// class MfuMandateResponseEntity extends Equatable {
//   final String respFlag;
//   final int respCode;
//   final String respMsg;
//   final String mmrn;
//   final String approveLink;

//   const MfuMandateResponseEntity({
//     required this.respFlag,
//     required this.respCode,
//     required this.respMsg,
//     required this.mmrn,
//     required this.approveLink,
//   });

//   bool get isSuccess => respFlag == 'S';

//   @override
//   List<Object?> get props => [respFlag, respCode, respMsg, mmrn, approveLink];
// }

// // ─── Mappers ──────────────────────────────────────────────────────────────────

// extension MfuMandateCreateMapper on MfuMandateCreateModel {
//   MfuMandateCreateEntity toEntity() {
//     return MfuMandateCreateEntity(
//       success: success ?? false,
//       message: message ?? '',
//       mandateId: mandateId ?? 0,
//       mandateType: mandateType ?? '',
//       status: status ?? '',
//       approveLink: approveLink ?? "",
//       deepLink: deepLink ?? '',
//       plainBody: plainBody?.toEntity(),
//       response: response?.toEntity(),
//     );
//   }
// }

// extension MfuMandatePlainBodyMapper on MfuMandatePlainBodyModel {
//   MfuMandatePlainBodyEntity toEntity() {
//     return MfuMandatePlainBodyEntity(
//       mandateType: mandateType ?? '',
//       regMode: regMode ?? '',
//       can: can ?? '',
//       arnCode: arnCode ?? '',
//       riaCode: riaCode ?? '',
//       euin: euin ?? '',
//       accNo: accNo ?? '',
//       accType: accType ?? '',
//       ifscCode: ifscCode ?? '',
//       micrCode: micrCode ?? '',
//       maxAmt: maxAmt ?? '',
//       perpetualFlag: perpetualFlag ?? '',
//       startDate: startDate ?? '',
//       endDate: endDate ?? '',
//     );
//   }
// }

// extension MfuMandateResponseMapper on MfuMandateResponseModel {
//   MfuMandateResponseEntity toEntity() {
//     return MfuMandateResponseEntity(
//       respFlag: respFlag ?? '',
//       respCode: respCode ?? 0,
//       respMsg: respMsg ?? '',
//       mmrn: mmrn ?? '',
//       approveLink: approveLink ?? '',
//     );
//   }
// }

// features/mfu/domain/entity/mfu_mandate_create_entity.dart

import 'package:equatable/equatable.dart';
import 'package:my_sip/features/mfu/data/model/mandate_model.dart';

class MfuMandateCreateEntity extends Equatable {
  final bool status;
  final String message;
  final String mandateType;
  final String can;
  final String topApproveLink;
  final String deepLink;
  final String topMumrn;
  final String topMmrn;
  final MfuMandateDetailEntity? mandate;
  final MfuMandateEnachResponseEntity? enachResponse;
  final MfuMandateUpiResponseEntity? upiResponse;

  const MfuMandateCreateEntity({
    required this.status,
    required this.message,
    required this.mandateType,
    required this.can,
    this.topApproveLink = '',
    this.deepLink = '',
    this.topMumrn = '',
    this.topMmrn = '',
    this.mandate,
    this.enachResponse,
    this.upiResponse,
  });

  bool get isEnach => mandateType == 'enach';
  bool get isUpi => mandateType == 'upi';

  // Unified approve link regardless of type
  String get approveLink {
    if (topApproveLink.isNotEmpty) return topApproveLink;
    if (isEnach) return enachResponse?.approveLink ?? '';
    if (isUpi) return upiResponse?.approveLink ?? '';
    return '';
  }

  String get mumrn {
    if (topMumrn.isNotEmpty) return topMumrn;
    if (mandate?.mumrn.isNotEmpty == true) return mandate!.mumrn;
    if (upiResponse?.mumrn.isNotEmpty == true) return upiResponse!.mumrn;
    return '';
  }

  String get mmrn {
    if (topMmrn.isNotEmpty) return topMmrn;
    if (mandate?.mmrn.isNotEmpty == true) return mandate!.mmrn;
    if (enachResponse?.mmrn.isNotEmpty == true) {
      return enachResponse!.mmrn;
    }
    return '';
  }

  // Unified success check
  bool get isSuccess {
    if (status) return true;
    if (isEnach) return enachResponse?.isSuccess ?? false;
    if (isUpi) return upiResponse?.isSuccess ?? false;
    return false;
  }

  @override
  List<Object?> get props => [
    status,
    message,
    mandateType,
    can,
    topApproveLink,
    deepLink,
    topMumrn,
    topMmrn,
    mandate,
    enachResponse,
    upiResponse,
  ];
}

// ─── Mandate Detail Entity ────────────────────────────────────────────────────

class MfuMandateDetailEntity extends Equatable {
  final int id;
  final int userId;
  final int bankAccountId;
  final String startDate;
  final String endDate;
  final String vpaId;
  final String mandateMode;
  final String mandateType;
  final String mumrn;
  final String mmrn;
  final String aumrn;
  final double maxAmount;
  final String status;
  final String createdAt;
  final String updatedAt;

  const MfuMandateDetailEntity({
    required this.id,
    required this.userId,
    required this.bankAccountId,
    required this.startDate,
    required this.endDate,
    required this.vpaId,
    required this.mandateMode,
    required this.mandateType,
    required this.mumrn,
    required this.mmrn,
    required this.aumrn,
    required this.maxAmount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isInitiated => status.toLowerCase() == 'initiated';
  bool get isActive => status.toLowerCase() == 'active';

  @override
  List<Object?> get props => [
    id,
    userId,
    bankAccountId,
    startDate,
    endDate,
    vpaId,
    mandateMode,
    mandateType,
    mumrn,
    mmrn,
    aumrn,
    maxAmount,
    status,
    createdAt,
    updatedAt,
  ];
}

// ─── eNACH Response Entity ────────────────────────────────────────────────────

class MfuMandateEnachResponseEntity extends Equatable {
  final String respFlag;
  final String respTs;
  final String errorCode;
  final String errorMsg;
  final String mmrn;
  final String approveLink;

  const MfuMandateEnachResponseEntity({
    required this.respFlag,
    required this.respTs,
    required this.errorCode,
    required this.errorMsg,
    required this.mmrn,
    required this.approveLink,
  });

  bool get isSuccess => respFlag == 'S';

  @override
  List<Object?> get props => [
    respFlag,
    respTs,
    errorCode,
    errorMsg,
    mmrn,
    approveLink,
  ];
}

// ─── UPI Response Entity ──────────────────────────────────────────────────────

class MfuMandateUpiResponseEntity extends Equatable {
  final String respFlag;
  final int respCode;
  final String respMsg;
  final String mumrn;
  final String approveLink;
  final String deepLink;

  const MfuMandateUpiResponseEntity({
    required this.respFlag,
    required this.respCode,
    required this.respMsg,
    required this.mumrn,
    required this.approveLink,
    required this.deepLink,
  });

  bool get isSuccess => respFlag == 'S';

  @override
  List<Object?> get props => [
    respFlag,
    respCode,
    respMsg,
    mumrn,
    approveLink,
    deepLink,
  ];
}

// ─── Mappers ──────────────────────────────────────────────────────────────────

extension MfuMandateCreateMapper on MfuMandateCreateModel {
  MfuMandateCreateEntity toEntity() {
    return MfuMandateCreateEntity(
      status: status ?? success ?? false,
      message: message ?? '',
      mandateType: mandateType ?? '',
      can: can ?? '',
      topApproveLink: approveLink ?? '',
      deepLink: deepLink ?? '',
      topMumrn: mumrn ?? '',
      topMmrn: mmrn ?? '',
      mandate: mandate?.toEntity(),
      enachResponse: enachResponse?.toEntity(),
      upiResponse: upiResponse?.toEntity(),
    );
  }
}

extension MfuMandateDetailMapper on MfuMandateDetailModel {
  MfuMandateDetailEntity toEntity() {
    return MfuMandateDetailEntity(
      id: id ?? 0,
      userId: userId ?? 0,
      bankAccountId: bankAccountId ?? 0,
      startDate: startDate ?? '',
      endDate: endDate ?? '',
      vpaId: vpaId ?? '',
      mandateMode: mandateMode ?? '',
      mandateType: mandateType ?? '',
      mumrn: mumrn ?? '',
      mmrn: mmrn ?? '',
      aumrn: aumrn ?? '',
      maxAmount: maxAmount ?? 0.0,
      status: status ?? '',
      createdAt: createdAt ?? '',
      updatedAt: updatedAt ?? '',
    );
  }
}

extension MfuMandateEnachResponseMapper on MfuMandateEnachResponseModel {
  MfuMandateEnachResponseEntity toEntity() {
    return MfuMandateEnachResponseEntity(
      respFlag: respHeader?.respFlag ?? '',
      respTs: respHeader?.respTs ?? '',
      errorCode: respHeader?.errorCode ?? '',
      errorMsg: respHeader?.errorMsg ?? '',
      mmrn: respBody?.mmrn ?? '',
      approveLink: respBody?.approveLink ?? '',
    );
  }
}

extension MfuMandateUpiResponseMapper on MfuMandateUpiResponseModel {
  MfuMandateUpiResponseEntity toEntity() {
    return MfuMandateUpiResponseEntity(
      respFlag: respFlag ?? '',
      respCode: respCode ?? 0,
      respMsg: respMsg ?? '',
      mumrn: mumrn ?? '',
      approveLink: approveLink ?? '',
      deepLink: deepLink ?? '',
    );
  }
}
