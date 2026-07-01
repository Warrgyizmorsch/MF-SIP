
// import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

// class MfuMandateStatusModel {
//   final bool? success;
//   final String? message;
//   final int? mandateId;
//   final String? mandateType;
//   final String? status;

//   MfuMandateStatusModel({
//     this.success,
//     this.message,
//     this.mandateId,
//     this.mandateType,
//     this.status,
//   });

//   factory MfuMandateStatusModel.fromJson(Map<String, dynamic> json) {
//     return MfuMandateStatusModel(
//       success: json.parse<bool>('status'),
//       message: json.parse<String>('message'),
//       mandateId: json.parse<int>('mandate_id'),
//       mandateType: json.parse<String>('mandate_type'),
//       status: json.parse<String>('status'),
//     );
//   }
// }


// features/mfu/data/model/mfu_mandate_status_model.dart

import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

class MfuMandateStatusModel {
  final bool? status;
  final String? message;
  final int? mandateId;
  final int? userId;
  final String? mandateMode;
  final String? can;
  final String? mumrn;
  final String? mmrn;
  final String? aumrn;
  final String? mandateStatus;
  final MfuMandateStatusResponseModel? response;

  MfuMandateStatusModel({
    this.status,
    this.message,
    this.mandateId,
    this.userId,
    this.mandateMode,
    this.can,
    this.mumrn,
    this.mmrn,
    this.aumrn,
    this.mandateStatus,
    this.response,
  });

  factory MfuMandateStatusModel.fromJson(Map<String, dynamic> json) {
    return MfuMandateStatusModel(
      status: json.parse<bool>('status'),
      message: json.parse<String>('message'),
      mandateId: json.parse<int>('mandate_id'),
      userId: json.parse<int>('user_id'),
      mandateMode: json.parse<String>('mandate_mode'),
      can: json.parse<String>('can'),
      mumrn: json.parse<String>('mumrn'),
      mmrn: json.parse<String>('mmrn'),
      aumrn: json.parse<String>('aumrn'),
      mandateStatus: json.parse<String>('mandate_status'),
      response: json['response'] != null
          ? MfuMandateStatusResponseModel.fromJson(
              json['response'] as Map<String, dynamic>)
          : null,
    );
  }
}

class MfuMandateStatusResponseModel {
  final String? respFlag;
  final int? respCode;
  final String? respMsg;
  final String? aumrn;
  final String? prn;
  final String? regStatus;
  final String? aggrStatus;

  MfuMandateStatusResponseModel({
    this.respFlag,
    this.respCode,
    this.respMsg,
    this.aumrn,
    this.prn,
    this.regStatus,
    this.aggrStatus,
  });

  factory MfuMandateStatusResponseModel.fromJson(Map<String, dynamic> json) {
    return MfuMandateStatusResponseModel(
      respFlag: json.parse<String>('respFlag'),
      respCode: json.parse<int>('respCode'),
      respMsg: json.parse<String>('respMsg'),
      aumrn: json.parse<String>('aumrn'),
      prn: json.parse<String>('prn'),
      regStatus: json.parse<String>('regStatus'),
      aggrStatus: json.parse<String>('aggrStatus'),
    );
  }
}