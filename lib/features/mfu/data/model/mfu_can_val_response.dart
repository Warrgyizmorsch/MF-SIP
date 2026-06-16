// features/mfu/data/model/response/mfu_can_val_response.dart

import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

class MfuCanValResponse {
  final MfuCanValRespHeader? respHeader;
  final MfuCanValRespBody? respBody;

  MfuCanValResponse({this.respHeader, this.respBody});

  factory MfuCanValResponse.fromJson(Map<String, dynamic> json) {
    return MfuCanValResponse(
      respHeader: json['respHeader'] != null
          ? MfuCanValRespHeader.fromJson(
              json['respHeader'] as Map<String, dynamic>)
          : null,
      respBody: json['respBody'] != null
          ? MfuCanValRespBody.fromJson(
              json['respBody'] as Map<String, dynamic>)
          : null,
    );
  }
}

class MfuCanValRespHeader {
  final String? respFlag;
  final String? respTs;
  final String? errorCode;
  final String? errorMsg;

  MfuCanValRespHeader({
    this.respFlag, this.respTs, this.errorCode, this.errorMsg,
  });

  factory MfuCanValRespHeader.fromJson(Map<String, dynamic> json) {
    return MfuCanValRespHeader(
      respFlag: json.parse<String>('respFlag'),
      respTs: json.parse<String>('respTs'),
      errorCode: json.parse<String>('errorCode'),
      errorMsg: json.parse<String>('errorMsg'),
    );
  }
}

class MfuCanValRespBody {
  final String? isValidCan;
  final String? isValidPan;
  final String? isValidDob;
  final String? isValidEmail;
  final String? canStatus;
  final String? allowForTrans;
  final String? accountCategory;
  final String? canModeOfHolding;

  MfuCanValRespBody({
    this.isValidCan, this.isValidPan,
    this.isValidDob, this.isValidEmail,
    this.canStatus, this.allowForTrans,
    this.accountCategory, this.canModeOfHolding,
  });

  factory MfuCanValRespBody.fromJson(Map<String, dynamic> json) {
    return MfuCanValRespBody(
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