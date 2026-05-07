import '../../../../core/utils/helper/custom_json_parser.dart';

// ─── Top-level Response ───────────────────────────────────────────────────────

class MfuCanResponseModel {
  final bool? status;
  final String? message;
  final String? can;
  final String? canStatus;
  final String? canStatusMessage;
  final String? canValidFlag;
  final String? canValidPan;
  final String? canValidDob;
  final String? canValidEmail;
  final String? canAllowForTrans;
  final String? proofUploadLink;
  final String? nomVerifyLinkH1;
  final String? nomVerifyLinkH2;
  final String? nomVerifyLinkH3;
  final CanRegistrationResponseModel? canRegistrationResponse;
  final CanValidationResponseModel? canValidationResponse;
  final CanStatusResponseModel? canStatusResponse;

  MfuCanResponseModel({
    this.status,
    this.message,
    this.can,
    this.canStatus,
    this.canStatusMessage,
    this.canValidFlag,
    this.canValidPan,
    this.canValidDob,
    this.canValidEmail,
    this.canAllowForTrans,
    this.proofUploadLink,
    this.nomVerifyLinkH1,
    this.nomVerifyLinkH2,
    this.nomVerifyLinkH3,
    this.canRegistrationResponse,
    this.canValidationResponse,
    this.canStatusResponse,
  });

  factory MfuCanResponseModel.fromJson(Map<String, dynamic> json) {
    return MfuCanResponseModel(
      status: json.parse<bool>('status'),
      message: json.parse<String>('message'),
      can: json.parse<String>('can'),
      canStatus: json.parse<String>('can_status'),
      canStatusMessage: json.parse<String>('can_status_message'),
      canValidFlag: json.parse<String>('can_valid_flag'),
      canValidPan: json.parse<String>('can_valid_pan'),
      canValidDob: json.parse<String>('can_valid_dob'),
      canValidEmail: json.parse<String>('can_valid_email'),
      canAllowForTrans: json.parse<String>('can_allow_for_trans'),
      proofUploadLink: json.parse<String>('proof_upload_link'),
      nomVerifyLinkH1: json.parse<String>('nom_verify_link_h1'),
      nomVerifyLinkH2: json.parse<String>('nom_verify_link_h2'),
      nomVerifyLinkH3: json.parse<String>('nom_verify_link_h3'),
      canRegistrationResponse: json['can_registration_response'] != null
          ? CanRegistrationResponseModel.fromJson(
              json['can_registration_response'] as Map<String, dynamic>)
          : null,
      canValidationResponse: json['can_validation_response'] != null
          ? CanValidationResponseModel.fromJson(
              json['can_validation_response'] as Map<String, dynamic>)
          : null,
      canStatusResponse: json['can_status_response'] != null
          ? CanStatusResponseModel.fromJson(
              json['can_status_response'] as Map<String, dynamic>)
          : null,
    );
  }
}

// ─── Shared: RespHeader ───────────────────────────────────────────────────────

class RespHeaderModel {
  final String? respFlag;
  final String? respTs;
  final String? errorCode;
  final String? errorMsg;

  RespHeaderModel({
    this.respFlag,
    this.respTs,
    this.errorCode,
    this.errorMsg,
  });

  factory RespHeaderModel.fromJson(Map<String, dynamic> json) {
    return RespHeaderModel(
      respFlag: json.parse<String>('respFlag'),
      respTs: json.parse<String>('respTs'),
      errorCode: json.parse<String>('errorCode'),
      errorMsg: json.parse<String>('errorMsg'),
    );
  }
}

// ─── CAN Registration Response ───────────────────────────────────────────────

class CanRegistrationResponseModel {
  final RespHeaderModel? respHeader;
  final CanRegistrationRespBodyModel? respBody;

  CanRegistrationResponseModel({this.respHeader, this.respBody});

  factory CanRegistrationResponseModel.fromJson(Map<String, dynamic> json) {
    return CanRegistrationResponseModel(
      respHeader: json['respHeader'] != null
          ? RespHeaderModel.fromJson(json['respHeader'] as Map<String, dynamic>)
          : null,
      respBody: json['respBody'] != null
          ? CanRegistrationRespBodyModel.fromJson(
              json['respBody'] as Map<String, dynamic>)
          : null,
    );
  }
}

class CanRegistrationRespBodyModel {
  final String? can;
  final String? proofUploadLink;
  final String? nomVerifyLinkH1;
  final String? nomVerifyLinkH2;
  final String? nomVerifyLinkH3;

  CanRegistrationRespBodyModel({
    this.can,
    this.proofUploadLink,
    this.nomVerifyLinkH1,
    this.nomVerifyLinkH2,
    this.nomVerifyLinkH3,
  });

  factory CanRegistrationRespBodyModel.fromJson(Map<String, dynamic> json) {
    return CanRegistrationRespBodyModel(
      can: json.parse<String>('can'),
      proofUploadLink: json.parse<String>('proofUploadLink'),
      nomVerifyLinkH1: json.parse<String>('nomVerifyLinkH1'),
      nomVerifyLinkH2: json.parse<String>('nomVerifyLinkH2'),
      nomVerifyLinkH3: json.parse<String>('nomVerifyLinkH3'),
    );
  }
}

// ─── CAN Validation Response ──────────────────────────────────────────────────

class CanValidationResponseModel {
  final RespHeaderModel? respHeader;
  final CanValidationRespBodyModel? respBody;

  CanValidationResponseModel({this.respHeader, this.respBody});

  factory CanValidationResponseModel.fromJson(Map<String, dynamic> json) {
    return CanValidationResponseModel(
      respHeader: json['respHeader'] != null
          ? RespHeaderModel.fromJson(json['respHeader'] as Map<String, dynamic>)
          : null,
      respBody: json['respBody'] != null
          ? CanValidationRespBodyModel.fromJson(
              json['respBody'] as Map<String, dynamic>)
          : null,
    );
  }
}

class CanValidationRespBodyModel {
  final String? isValidCan;
  final String? isValidPan;
  final String? isValidDob;
  final String? isValidEmail;
  final String? canStatus;
  final String? allowForTrans;
  final String? accountCategory;
  final String? canModeOfHolding;

  CanValidationRespBodyModel({
    this.isValidCan,
    this.isValidPan,
    this.isValidDob,
    this.isValidEmail,
    this.canStatus,
    this.allowForTrans,
    this.accountCategory,
    this.canModeOfHolding,
  });

  factory CanValidationRespBodyModel.fromJson(Map<String, dynamic> json) {
    return CanValidationRespBodyModel(
      isValidCan: json.parse<String>('isValidCan'),
      isValidPan: json.parse<String>('isValidPan'),
      isValidDob: json.parse<String>('isValidDob'),
      isValidEmail: json.parse<String>('isValidEmail'),
      canStatus: json.parse<String>('canStatus'),
      allowForTrans: json.parse<String>('allowForTrans'),
      accountCategory: json.parse<String>('accountCategory'),
      canModeOfHolding: json.parse<String>('canModeOfHolding'),
    );
  }
}

// ─── CAN Status Response ──────────────────────────────────────────────────────

class CanStatusResponseModel {
  final RespHeaderModel? respHeader;
  final CanStatusRespBodyModel? respBody;

  CanStatusResponseModel({this.respHeader, this.respBody});

  factory CanStatusResponseModel.fromJson(Map<String, dynamic> json) {
    return CanStatusResponseModel(
      respHeader: json['respHeader'] != null
          ? RespHeaderModel.fromJson(json['respHeader'] as Map<String, dynamic>)
          : null,
      respBody: json['respBody'] != null
          ? CanStatusRespBodyModel.fromJson(
              json['respBody'] as Map<String, dynamic>)
          : null,
    );
  }
}

class CanStatusRespBodyModel {
  final String? can;
  final String? proofUpdlnk;
  final String? msg;
  final String? canStatus;
  final List<BlockRespModel>? blockRespList;

  CanStatusRespBodyModel({
    this.can,
    this.proofUpdlnk,
    this.msg,
    this.canStatus,
    this.blockRespList,
  });

  factory CanStatusRespBodyModel.fromJson(Map<String, dynamic> json) {
    return CanStatusRespBodyModel(
      can: json.parse<String>('can'),
      proofUpdlnk: json.parse<String>('proofUpdlnk'),
      msg: json.parse<String>('msg'),
      canStatus: json.parse<String>('canStatus'),
      blockRespList: json.parseListOf<BlockRespModel>(
        'blockRespList',
        (item) => BlockRespModel.fromJson(item as Map<String, dynamic>),
      ),
    );
  }
}

class BlockRespModel {
  final String? blockName;
  final String? blockSubName;
  final String? seqNo;
  final String? rspType;
  final String? rspCode;

  BlockRespModel({
    this.blockName,
    this.blockSubName,
    this.seqNo,
    this.rspType,
    this.rspCode,
  });

  factory BlockRespModel.fromJson(Map<String, dynamic> json) {
    return BlockRespModel(
      blockName: json.parse<String>('blockName'),
      blockSubName: json.parse<String>('blockSubName'),
      seqNo: json.parse<String>('seqNo'),
      rspType: json.parse<String>('rspType'),
      rspCode: json.parse<String>('rspCode'),
    );
  }
}