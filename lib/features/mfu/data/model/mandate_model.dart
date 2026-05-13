// features/mfu/data/model/mfu_mandate_create_model.dart

import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

class MfuMandateCreateModel {
  final bool? success;
  final String? message;
  final int? mandateId;
  final String? mandateType;
  final MfuMandatePlainBodyModel? plainBody;
  final MfuMandateResponseModel? response;

  MfuMandateCreateModel({
    this.success,
    this.message,
    this.mandateId,
    this.mandateType,
    this.plainBody,
    this.response,
  });

  factory MfuMandateCreateModel.fromJson(Map<String, dynamic> json) {
    return MfuMandateCreateModel(
      success: json.parse<bool>('success'),
      message: json.parse<String>('message'),
      mandateId: json.parse<int>('mandate_id'),
      mandateType: json.parse<String>('mandate_type'),
      plainBody: json['plain_body'] != null
          ? MfuMandatePlainBodyModel.fromJson(
              json['plain_body'] as Map<String, dynamic>)
          : null,
      response: json['response'] != null
          ? MfuMandateResponseModel.fromJson(
              json['response'] as Map<String, dynamic>)
          : null,
    );
  }
}

class MfuMandatePlainBodyModel {
  final String? mandateType;
  final String? regMode;
  final String? can;
  final String? arnCode;
  final String? riaCode;
  final String? euin;
  final String? accNo;
  final String? accType;
  final String? ifscCode;
  final String? micrCode;
  final String? maxAmt;
  final String? perpetualFlag;
  final String? startDate;
  final String? endDate;

  MfuMandatePlainBodyModel({
    this.mandateType,
    this.regMode,
    this.can,
    this.arnCode,
    this.riaCode,
    this.euin,
    this.accNo,
    this.accType,
    this.ifscCode,
    this.micrCode,
    this.maxAmt,
    this.perpetualFlag,
    this.startDate,
    this.endDate,
  });

  factory MfuMandatePlainBodyModel.fromJson(Map<String, dynamic> json) {
    return MfuMandatePlainBodyModel(
      mandateType: json.parse<String>('mandateType'),
      regMode: json.parse<String>('regMode'),
      can: json.parse<String>('can'),
      arnCode: json.parse<String>('arnCode'),
      riaCode: json.parse<String>('riaCode'),
      euin: json.parse<String>('euin'),
      accNo: json.parse<String>('accNo'),
      accType: json.parse<String>('accType'),
      ifscCode: json.parse<String>('ifscCode'),
      micrCode: json.parse<String>('micrCode'),
      maxAmt: json.parse<String>('maxAmt'),
      perpetualFlag: json.parse<String>('perpetualFlag'),
      startDate: json.parse<String>('startDate'),
      endDate: json.parse<String>('endDate'),
    );
  }
}

class MfuMandateResponseModel {
  final String? respFlag;
  final int? respCode;
  final String? respMsg;
  final String? mmrn;
  final String? approveLink;

  MfuMandateResponseModel({
    this.respFlag,
    this.respCode,
    this.respMsg,
    this.mmrn,
    this.approveLink,
  });

  factory MfuMandateResponseModel.fromJson(Map<String, dynamic> json) {
    return MfuMandateResponseModel(
      respFlag: json.parse<String>('respFlag'),
      respCode: json.parse<int>('respCode'),
      respMsg: json.parse<String>('respMsg'),
      mmrn: json.parse<String>('mmrn'),
      approveLink: json.parse<String>('approveLink'),
    );
  }
}