import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

class MfuCanBankValidationModel {
  final bool? success;
  final String? message;
  final String? stage;
  final MfuCanBankValidationDataModel? data;
  final MfuCanBankValidationMfuResponseModel? mfuResponse;

  MfuCanBankValidationModel({
    this.success,
    this.message,
    this.stage,
    this.data,
    this.mfuResponse,
  });

  factory MfuCanBankValidationModel.fromJson(Map<String, dynamic> json) {
    return MfuCanBankValidationModel(
      success: json.parse<bool>('success'),
      message: json.parse<String>('message'),
      stage: json.parse<String>('stage'),
      data: json['data'] != null
          ? MfuCanBankValidationDataModel.fromJson(
              json['data'] as Map<String, dynamic>,
            )
          : null,
      mfuResponse: json['mfu_response'] != null
          ? MfuCanBankValidationMfuResponseModel.fromJson(
              json['mfu_response'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class MfuCanBankValidationDataModel {
  final int? uid;
  final String? can;
  final String? accountNo;
  final String? ifscCode;
  final String? micrNo;
  final String? bankExistFlag;

  MfuCanBankValidationDataModel({
    this.uid,
    this.can,
    this.accountNo,
    this.ifscCode,
    this.micrNo,
    this.bankExistFlag,
  });

  factory MfuCanBankValidationDataModel.fromJson(Map<String, dynamic> json) {
    return MfuCanBankValidationDataModel(
      uid: json.parse<int>('uid'),
      can: json.parse<String>('can'),
      accountNo: json.parse<String>('accountNo'),
      ifscCode: json.parse<String>('ifscCode'),
      micrNo: json.parse<String>('micrNo'),
      bankExistFlag: json.parse<String>('bankExistFlag'),
    );
  }
}

class MfuCanBankValidationMfuResponseModel {
  final MfuCanBankValidationRespHeaderModel? respHeader;
  final MfuCanBankValidationRespBodyModel? respBody;

  MfuCanBankValidationMfuResponseModel({this.respHeader, this.respBody});

  factory MfuCanBankValidationMfuResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MfuCanBankValidationMfuResponseModel(
      respHeader: json['respHeader'] != null
          ? MfuCanBankValidationRespHeaderModel.fromJson(
              json['respHeader'] as Map<String, dynamic>,
            )
          : null,
      respBody: json['respBody'] != null
          ? MfuCanBankValidationRespBodyModel.fromJson(
              json['respBody'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class MfuCanBankValidationRespHeaderModel {
  final String? respFlag;
  final String? respTs;
  final String? errorCode;
  final String? errorMsg;

  MfuCanBankValidationRespHeaderModel({
    this.respFlag,
    this.respTs,
    this.errorCode,
    this.errorMsg,
  });

  factory MfuCanBankValidationRespHeaderModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MfuCanBankValidationRespHeaderModel(
      respFlag: json.parse<String>('respFlag'),
      respTs: json.parse<String>('respTs'),
      errorCode: json.parse<String>('errorCode'),
      errorMsg: json.parse<String>('errorMsg'),
    );
  }
}

class MfuCanBankValidationRespBodyModel {
  final String? bankExistFlag;

  MfuCanBankValidationRespBodyModel({this.bankExistFlag});

  factory MfuCanBankValidationRespBodyModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MfuCanBankValidationRespBodyModel(
      bankExistFlag: json.parse<String>('bankExistFlag'),
    );
  }
}
