// // features/mfu/data/model/mfu_mandate_create_model.dart

// import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

// class MfuMandateCreateModel {
//   final bool? success;
//   final String? message;
//   final int? mandateId;
//   final String? mandateType;
//   final String? status;
//   final String? approveLink;
//   final String? deepLink;
//   final MfuMandatePlainBodyModel? plainBody;
//   final MfuMandateResponseModel? response;

//   MfuMandateCreateModel({
//     this.success,
//     this.message,
//     this.mandateId,
//     this.mandateType,
//     this.status,
//     this.approveLink,
//     this.deepLink,
//     this.plainBody,
//     this.response,
//   });

//   factory MfuMandateCreateModel.fromJson(Map<String, dynamic> json) {
//     return MfuMandateCreateModel(
//       success: json.parse<bool>('status'),
//       message: json.parse<String>('message'),
//       mandateId: json.parse<int>('mandate_id'),
//       mandateType: json.parse<String>('mandate_type'),
//       status: json.parse<String>('status'),
//       approveLink: json.parse<String>('approve_link'),
//       deepLink: json.parse<String>('deep_link'),
//       plainBody: json['plain_body'] != null
//           ? MfuMandatePlainBodyModel.fromJson(
//               json['plain_body'] as Map<String, dynamic>,
//             )
//           : null,
//       response: json['response'] != null
//           ? MfuMandateResponseModel.fromJson(
//               json['response'] as Map<String, dynamic>,
//             )
//           : null,
//     );
//   }
// }

// class MfuMandatePlainBodyModel {
//   final String? mandateType;
//   final String? regMode;
//   final String? can;
//   final String? arnCode;
//   final String? riaCode;
//   final String? euin;
//   final String? accNo;
//   final String? accType;
//   final String? ifscCode;
//   final String? micrCode;
//   final String? maxAmt;
//   final String? perpetualFlag;
//   final String? startDate;
//   final String? endDate;

//   MfuMandatePlainBodyModel({
//     this.mandateType,
//     this.regMode,
//     this.can,
//     this.arnCode,
//     this.riaCode,
//     this.euin,
//     this.accNo,
//     this.accType,
//     this.ifscCode,
//     this.micrCode,
//     this.maxAmt,
//     this.perpetualFlag,
//     this.startDate,
//     this.endDate,
//   });

//   factory MfuMandatePlainBodyModel.fromJson(Map<String, dynamic> json) {
//     return MfuMandatePlainBodyModel(
//       mandateType: json.parse<String>('mandateType'),
//       regMode: json.parse<String>('regMode'),
//       can: json.parse<String>('can'),
//       arnCode: json.parse<String>('arnCode'),
//       riaCode: json.parse<String>('riaCode'),
//       euin: json.parse<String>('euin'),
//       accNo: json.parse<String>('accNo'),
//       accType: json.parse<String>('accType'),
//       ifscCode: json.parse<String>('ifscCode'),
//       micrCode: json.parse<String>('micrCode'),
//       maxAmt: json.parse<String>('maxAmt'),
//       perpetualFlag: json.parse<String>('perpetualFlag'),
//       startDate: json.parse<String>('startDate'),
//       endDate: json.parse<String>('endDate'),
//     );
//   }
// }

// class MfuMandateResponseModel {
//   final String? respFlag;
//   final int? respCode;
//   final String? respMsg;
//   final String? mmrn;
//   final String? approveLink;

//   MfuMandateResponseModel({
//     this.respFlag,
//     this.respCode,
//     this.respMsg,
//     this.mmrn,
//     this.approveLink,
//   });

//   factory MfuMandateResponseModel.fromJson(Map<String, dynamic> json) {
//     return MfuMandateResponseModel(
//       respFlag: json.parse<String>('respFlag'),
//       respCode: json.parse<int>('respCode'),
//       respMsg: json.parse<String>('respMsg'),
//       mmrn: json.parse<String>('mmrn'),
//       approveLink: json.parse<String>('approveLink'),
//     );
//   }
// }

// features/mfu/data/model/mfu_mandate_create_model.dart

import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

class MfuMandateCreateModel {
  final bool? status;
  final String? message;
  final String? mandateType;
  final String? can;
  final MfuMandateDetailModel? mandate;

  // eNACH response
  final MfuMandateEnachResponseModel? enachResponse;

  // UPI response
  final MfuMandateUpiResponseModel? upiResponse;

  MfuMandateCreateModel({
    this.status,
    this.message,
    this.mandateType,
    this.can,
    this.mandate,
    this.enachResponse,
    this.upiResponse,
  });

  factory MfuMandateCreateModel.fromJson(Map<String, dynamic> json) {
    final type = json['mandate_type']?.toString() ?? '';
    final responseJson = json['response'] as Map<String, dynamic>?;

    // eNACH response has respHeader + respBody
    // UPI response has respFlag directly
    MfuMandateEnachResponseModel? enachResp;
    MfuMandateUpiResponseModel? upiResp;

    if (responseJson != null) {
      if (type == 'enach') {
        enachResp = MfuMandateEnachResponseModel.fromJson(responseJson);
      } else if (type == 'upi') {
        upiResp = MfuMandateUpiResponseModel.fromJson(responseJson);
      }
    }

    return MfuMandateCreateModel(
      status: json.parse<bool>('status'),
      message: json.parse<String>('message'),
      mandateType: json.parse<String>('mandate_type'),
      can: json.parse<String>('can'),
      mandate: json['mandate'] != null
          ? MfuMandateDetailModel.fromJson(
              json['mandate'] as Map<String, dynamic>)
          : null,
      enachResponse: enachResp,
      upiResponse: upiResp,
    );
  }
}

// ─── Mandate Detail (shared) ──────────────────────────────────────────────────

class MfuMandateDetailModel {
  final int? id;
  final int? userId;
  final int? bankAccountId;
  final String? startDate;
  final String? endDate;
  final String? vpaId;
  final String? mandateMode;
  final String? mandateType;
  final String? mumrn;
  final String? mmrn;
  final String? aumrn;
  final double? maxAmount;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  MfuMandateDetailModel({
    this.id,
    this.userId,
    this.bankAccountId,
    this.startDate,
    this.endDate,
    this.vpaId,
    this.mandateMode,
    this.mandateType,
    this.mumrn,
    this.mmrn,
    this.aumrn,
    this.maxAmount,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory MfuMandateDetailModel.fromJson(Map<String, dynamic> json) {
    return MfuMandateDetailModel(
      id: json.parse<int>('id'),
      userId: json.parse<int>('user_id'),
      bankAccountId: json.parse<int>('bank_account_id'),
      startDate: json.parse<String>('start_date'),
      endDate: json.parse<String>('end_date'),
      vpaId: json.parse<String>('vpa_id'),
      mandateMode: json.parse<String>('mandate_mode'),
      mandateType: json.parse<String>('mandate_type'),
      mumrn: json.parse<String>('mumrn'),
      mmrn: json.parse<String>('mmrn'),
      aumrn: json.parse<String>('aumrn'),
      maxAmount: json.parse<double>('max_amount'),
      status: json.parse<String>('status'),
      createdAt: json.parse<String>('created_at'),
      updatedAt: json.parse<String>('updated_at'),
    );
  }
}

// ─── eNACH Response ───────────────────────────────────────────────────────────

class MfuMandateEnachResponseModel {
  final MfuMandateEnachRespHeaderModel? respHeader;
  final MfuMandateEnachRespBodyModel? respBody;

  MfuMandateEnachResponseModel({this.respHeader, this.respBody});

  factory MfuMandateEnachResponseModel.fromJson(Map<String, dynamic> json) {
    return MfuMandateEnachResponseModel(
      respHeader: json['respHeader'] != null
          ? MfuMandateEnachRespHeaderModel.fromJson(
              json['respHeader'] as Map<String, dynamic>)
          : null,
      respBody: json['respBody'] != null
          ? MfuMandateEnachRespBodyModel.fromJson(
              json['respBody'] as Map<String, dynamic>)
          : null,
    );
  }
}

class MfuMandateEnachRespHeaderModel {
  final String? respFlag;
  final String? respTs;
  final String? errorCode;
  final String? errorMsg;

  MfuMandateEnachRespHeaderModel({
    this.respFlag,
    this.respTs,
    this.errorCode,
    this.errorMsg,
  });

  factory MfuMandateEnachRespHeaderModel.fromJson(Map<String, dynamic> json) {
    return MfuMandateEnachRespHeaderModel(
      respFlag: json.parse<String>('respFlag'),
      respTs: json.parse<String>('respTs'),
      errorCode: json.parse<String>('errorCode'),
      errorMsg: json.parse<String>('errorMsg'),
    );
  }
}

class MfuMandateEnachRespBodyModel {
  final String? mmrn;
  final String? approveLink;

  MfuMandateEnachRespBodyModel({this.mmrn, this.approveLink});

  factory MfuMandateEnachRespBodyModel.fromJson(Map<String, dynamic> json) {
    return MfuMandateEnachRespBodyModel(
      mmrn: json.parse<String>('mmrn'),
      approveLink: json.parse<String>('approveLink'),
    );
  }
}

// ─── UPI Response ─────────────────────────────────────────────────────────────

class MfuMandateUpiResponseModel {
  final String? respFlag;
  final int? respCode;
  final String? respMsg;
  final String? mumrn;
  final String? approveLink;
  final String? deepLink;

  MfuMandateUpiResponseModel({
    this.respFlag,
    this.respCode,
    this.respMsg,
    this.mumrn,
    this.approveLink,
    this.deepLink,
  });

  factory MfuMandateUpiResponseModel.fromJson(Map<String, dynamic> json) {
    return MfuMandateUpiResponseModel(
      respFlag: json.parse<String>('respFlag'),
      respCode: json.parse<int>('respCode'),
      respMsg: json.parse<String>('respMsg'),
      mumrn: json.parse<String>('mumrn'),
      approveLink: json.parse<String>('approveLink'),
      deepLink: json.parse<String>('deepLink'),
    );
  }
}