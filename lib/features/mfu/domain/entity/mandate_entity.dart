// features/mfu/domain/entity/mfu_mandate_create_entity.dart

import 'package:equatable/equatable.dart';
import 'package:my_sip/features/mfu/data/model/mandate_model.dart';

class MfuMandateCreateEntity extends Equatable {
  final bool success;
  final String message;
  final int mandateId;
  final String mandateType;
  final MfuMandatePlainBodyEntity? plainBody;
  final MfuMandateResponseEntity? response;

  const MfuMandateCreateEntity({
    required this.success,
    required this.message,
    required this.mandateId,
    required this.mandateType,
    this.plainBody,
    this.response,
  });

  bool get isSuccess => response?.isSuccess ?? false;
  String get approveLink => response?.approveLink ?? '';
  String get mmrn => response?.mmrn ?? '';

  @override
  List<Object?> get props => [
        success, message, mandateId, mandateType, plainBody, response,
      ];
}

class MfuMandatePlainBodyEntity extends Equatable {
  final String mandateType;
  final String regMode;
  final String can;
  final String arnCode;
  final String riaCode;
  final String euin;
  final String accNo;
  final String accType;
  final String ifscCode;
  final String micrCode;
  final String maxAmt;
  final String perpetualFlag;
  final String startDate;
  final String endDate;

  const MfuMandatePlainBodyEntity({
    required this.mandateType,
    required this.regMode,
    required this.can,
    required this.arnCode,
    required this.riaCode,
    required this.euin,
    required this.accNo,
    required this.accType,
    required this.ifscCode,
    required this.micrCode,
    required this.maxAmt,
    required this.perpetualFlag,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [
        mandateType, regMode, can, arnCode, riaCode, euin,
        accNo, accType, ifscCode, micrCode, maxAmt,
        perpetualFlag, startDate, endDate,
      ];
}

class MfuMandateResponseEntity extends Equatable {
  final String respFlag;
  final int respCode;
  final String respMsg;
  final String mmrn;
  final String approveLink;

  const MfuMandateResponseEntity({
    required this.respFlag,
    required this.respCode,
    required this.respMsg,
    required this.mmrn,
    required this.approveLink,
  });

  bool get isSuccess => respFlag == 'S';

  @override
  List<Object?> get props => [respFlag, respCode, respMsg, mmrn, approveLink];
}

// ─── Mappers ──────────────────────────────────────────────────────────────────

extension MfuMandateCreateMapper on MfuMandateCreateModel {
  MfuMandateCreateEntity toEntity() {
    return MfuMandateCreateEntity(
      success: success ?? false,
      message: message ?? '',
      mandateId: mandateId ?? 0,
      mandateType: mandateType ?? '',
      plainBody: plainBody?.toEntity(),
      response: response?.toEntity(),
    );
  }
}

extension MfuMandatePlainBodyMapper on MfuMandatePlainBodyModel {
  MfuMandatePlainBodyEntity toEntity() {
    return MfuMandatePlainBodyEntity(
      mandateType: mandateType ?? '',
      regMode: regMode ?? '',
      can: can ?? '',
      arnCode: arnCode ?? '',
      riaCode: riaCode ?? '',
      euin: euin ?? '',
      accNo: accNo ?? '',
      accType: accType ?? '',
      ifscCode: ifscCode ?? '',
      micrCode: micrCode ?? '',
      maxAmt: maxAmt ?? '',
      perpetualFlag: perpetualFlag ?? '',
      startDate: startDate ?? '',
      endDate: endDate ?? '',
    );
  }
}

extension MfuMandateResponseMapper on MfuMandateResponseModel {
  MfuMandateResponseEntity toEntity() {
    return MfuMandateResponseEntity(
      respFlag: respFlag ?? '',
      respCode: respCode ?? 0,
      respMsg: respMsg ?? '',
      mmrn: mmrn ?? '',
      approveLink: approveLink ?? '',
    );
  }
}