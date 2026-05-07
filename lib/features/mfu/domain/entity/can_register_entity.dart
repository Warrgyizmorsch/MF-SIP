import 'package:equatable/equatable.dart';
import 'package:my_sip/features/mfu/data/model/can_register_model.dart';


class MfuCanResponseEntity extends Equatable {
  final bool status;
  final String message;
  final String can;
  final String canStatus;
  final String canStatusMessage;
  final String canValidFlag;
  final String canValidPan;
  final String canValidDob;
  final String canValidEmail;
  final String canAllowForTrans;
  final String proofUploadLink;
  final String nomVerifyLinkH1;
  final String nomVerifyLinkH2;
  final String nomVerifyLinkH3;
  final CanRegistrationResponseEntity? canRegistrationResponse;
  final CanValidationResponseEntity? canValidationResponse;
  final CanStatusResponseEntity? canStatusResponse;

  const MfuCanResponseEntity({
    required this.status,
    required this.message,
    required this.can,
    required this.canStatus,
    required this.canStatusMessage,
    required this.canValidFlag,
    required this.canValidPan,
    required this.canValidDob,
    required this.canValidEmail,
    required this.canAllowForTrans,
    required this.proofUploadLink,
    required this.nomVerifyLinkH1,
    required this.nomVerifyLinkH2,
    required this.nomVerifyLinkH3,
    this.canRegistrationResponse,
    this.canValidationResponse,
    this.canStatusResponse,
  });

  @override
  List<Object?> get props => [
        status, message, can, canStatus, canStatusMessage,
        canValidFlag, canValidPan, canValidDob, canValidEmail,
        canAllowForTrans, proofUploadLink,
        nomVerifyLinkH1, nomVerifyLinkH2, nomVerifyLinkH3,
        canRegistrationResponse, canValidationResponse, canStatusResponse,
      ];
}

// ─── Shared: RespHeader Entity ────────────────────────────────────────────────

class RespHeaderEntity extends Equatable {
  final String respFlag;
  final String respTs;
  final String errorCode;
  final String errorMsg;

  const RespHeaderEntity({
    required this.respFlag,
    required this.respTs,
    required this.errorCode,
    required this.errorMsg,
  });

  bool get isSuccess => respFlag == 'S';

  @override
  List<Object?> get props => [respFlag, respTs, errorCode, errorMsg];
}

// ─── CAN Registration Entities ────────────────────────────────────────────────

class CanRegistrationResponseEntity extends Equatable {
  final RespHeaderEntity? respHeader;
  final CanRegistrationRespBodyEntity? respBody;

  const CanRegistrationResponseEntity({this.respHeader, this.respBody});

  @override
  List<Object?> get props => [respHeader, respBody];
}

class CanRegistrationRespBodyEntity extends Equatable {
  final String can;
  final String proofUploadLink;
  final String nomVerifyLinkH1;
  final String nomVerifyLinkH2;
  final String nomVerifyLinkH3;

  const CanRegistrationRespBodyEntity({
    required this.can,
    required this.proofUploadLink,
    required this.nomVerifyLinkH1,
    required this.nomVerifyLinkH2,
    required this.nomVerifyLinkH3,
  });

  @override
  List<Object?> get props => [can, proofUploadLink, nomVerifyLinkH1, nomVerifyLinkH2, nomVerifyLinkH3];
}

// ─── CAN Validation Entities ──────────────────────────────────────────────────

class CanValidationResponseEntity extends Equatable {
  final RespHeaderEntity? respHeader;
  final CanValidationRespBodyEntity? respBody;

  const CanValidationResponseEntity({this.respHeader, this.respBody});

  @override
  List<Object?> get props => [respHeader, respBody];
}

class CanValidationRespBodyEntity extends Equatable {
  final String isValidCan;
  final String isValidPan;
  final String isValidDob;
  final String isValidEmail;
  final String canStatus;
  final String allowForTrans;
  final String accountCategory;
  final String canModeOfHolding;

  const CanValidationRespBodyEntity({
    required this.isValidCan,
    required this.isValidPan,
    required this.isValidDob,
    required this.isValidEmail,
    required this.canStatus,
    required this.allowForTrans,
    required this.accountCategory,
    required this.canModeOfHolding,
  });

  @override
  List<Object?> get props => [
        isValidCan, isValidPan, isValidDob, isValidEmail,
        canStatus, allowForTrans, accountCategory, canModeOfHolding,
      ];
}

// ─── CAN Status Entities ──────────────────────────────────────────────────────

class CanStatusResponseEntity extends Equatable {
  final RespHeaderEntity? respHeader;
  final CanStatusRespBodyEntity? respBody;

  const CanStatusResponseEntity({this.respHeader, this.respBody});

  @override
  List<Object?> get props => [respHeader, respBody];
}

class CanStatusRespBodyEntity extends Equatable {
  final String can;
  final String proofUpdlnk;
  final String msg;
  final String canStatus;
  final List<BlockRespEntity> blockRespList;

  const CanStatusRespBodyEntity({
    required this.can,
    required this.proofUpdlnk,
    required this.msg,
    required this.canStatus,
    required this.blockRespList,
  });

  @override
  List<Object?> get props => [can, proofUpdlnk, msg, canStatus, blockRespList];
}

class BlockRespEntity extends Equatable {
  final String blockName;
  final String blockSubName;
  final String seqNo;
  final String rspType;
  final String rspCode;

  const BlockRespEntity({
    required this.blockName,
    required this.blockSubName,
    required this.seqNo,
    required this.rspType,
    required this.rspCode,
  });

  @override
  List<Object?> get props => [blockName, blockSubName, seqNo, rspType, rspCode];
}

// ─── Mappers ──────────────────────────────────────────────────────────────────

extension MfuCanResponseMapper on MfuCanResponseModel {
  MfuCanResponseEntity toEntity() {
    return MfuCanResponseEntity(
      status: status ?? false,
      message: message ?? '',
      can: can ?? '',
      canStatus: canStatus ?? '',
      canStatusMessage: canStatusMessage ?? '',
      canValidFlag: canValidFlag ?? '',
      canValidPan: canValidPan ?? '',
      canValidDob: canValidDob ?? '',
      canValidEmail: canValidEmail ?? '',
      canAllowForTrans: canAllowForTrans ?? '',
      proofUploadLink: proofUploadLink ?? '',
      nomVerifyLinkH1: nomVerifyLinkH1 ?? '',
      nomVerifyLinkH2: nomVerifyLinkH2 ?? '',
      nomVerifyLinkH3: nomVerifyLinkH3 ?? '',
      canRegistrationResponse: canRegistrationResponse?.toEntity(),
      canValidationResponse: canValidationResponse?.toEntity(),
      canStatusResponse: canStatusResponse?.toEntity(),
    );
  }
}

extension RespHeaderMapper on RespHeaderModel {
  RespHeaderEntity toEntity() {
    return RespHeaderEntity(
      respFlag: respFlag ?? '',
      respTs: respTs ?? '',
      errorCode: errorCode ?? '',
      errorMsg: errorMsg ?? '',
    );
  }
}

extension CanRegistrationResponseMapper on CanRegistrationResponseModel {
  CanRegistrationResponseEntity toEntity() {
    return CanRegistrationResponseEntity(
      respHeader: respHeader?.toEntity(),
      respBody: respBody?.toEntity(),
    );
  }
}

extension CanRegistrationRespBodyMapper on CanRegistrationRespBodyModel {
  CanRegistrationRespBodyEntity toEntity() {
    return CanRegistrationRespBodyEntity(
      can: can ?? '',
      proofUploadLink: proofUploadLink ?? '',
      nomVerifyLinkH1: nomVerifyLinkH1 ?? '',
      nomVerifyLinkH2: nomVerifyLinkH2 ?? '',
      nomVerifyLinkH3: nomVerifyLinkH3 ?? '',
    );
  }
}

extension CanValidationResponseMapper on CanValidationResponseModel {
  CanValidationResponseEntity toEntity() {
    return CanValidationResponseEntity(
      respHeader: respHeader?.toEntity(),
      respBody: respBody?.toEntity(),
    );
  }
}

extension CanValidationRespBodyMapper on CanValidationRespBodyModel {
  CanValidationRespBodyEntity toEntity() {
    return CanValidationRespBodyEntity(
      isValidCan: isValidCan ?? '',
      isValidPan: isValidPan ?? '',
      isValidDob: isValidDob ?? '',
      isValidEmail: isValidEmail ?? '',
      canStatus: canStatus ?? '',
      allowForTrans: allowForTrans ?? '',
      accountCategory: accountCategory ?? '',
      canModeOfHolding: canModeOfHolding ?? '',
    );
  }
}

extension CanStatusResponseMapper on CanStatusResponseModel {
  CanStatusResponseEntity toEntity() {
    return CanStatusResponseEntity(
      respHeader: respHeader?.toEntity(),
      respBody: respBody?.toEntity(),
    );
  }
}

extension CanStatusRespBodyMapper on CanStatusRespBodyModel {
  CanStatusRespBodyEntity toEntity() {
    return CanStatusRespBodyEntity(
      can: can ?? '',
      proofUpdlnk: proofUpdlnk ?? '',
      msg: msg ?? '',
      canStatus: canStatus ?? '',
      blockRespList: blockRespList?.map((e) => e.toEntity()).toList() ?? [],
    );
  }
}

extension BlockRespMapper on BlockRespModel {
  BlockRespEntity toEntity() {
    return BlockRespEntity(
      blockName: blockName ?? '',
      blockSubName: blockSubName ?? '',
      seqNo: seqNo ?? '',
      rspType: rspType ?? '',
      rspCode: rspCode ?? '',
    );
  }
}