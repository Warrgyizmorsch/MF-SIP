// features/mfu/data/model/response/mfu_can_status_response.dart

import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

class MfuCanStatusResponse {
  final MfuCanStatusRespHeader? respHeader;
  final MfuCanStatusRespBody? respBody;

  MfuCanStatusResponse({this.respHeader, this.respBody});

  factory MfuCanStatusResponse.fromJson(Map<String, dynamic> json) {
    return MfuCanStatusResponse(
      respHeader: json['respHeader'] != null
          ? MfuCanStatusRespHeader.fromJson(
              json['respHeader'] as Map<String, dynamic>,
            )
          : null,
      respBody: json['respBody'] != null
          ? MfuCanStatusRespBody.fromJson(
              json['respBody'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class MfuCanStatusRespHeader {
  final String? respFlag;
  final String? respTs;
  final String? errorCode;
  final String? errorMsg;

  MfuCanStatusRespHeader({
    this.respFlag,
    this.respTs,
    this.errorCode,
    this.errorMsg,
  });

  factory MfuCanStatusRespHeader.fromJson(Map<String, dynamic> json) {
    return MfuCanStatusRespHeader(
      respFlag: json.parse<String>('respFlag'),
      respTs: json.parse<String>('respTs'),
      errorCode: json.parse<String>('errorCode'),
      errorMsg: json.parse<String>('errorMsg'),
    );
  }
}

class MfuCanStatusRespBody {
  final String? can;
  final String? proofUpdlnk;
  final String? msg;
  final String? canStatus;
  final List<MfuCanStatusBlockResp>? blockRespList;

  MfuCanStatusRespBody({
    this.can,
    this.proofUpdlnk,
    this.msg,
    this.canStatus,
    this.blockRespList,
  });

  factory MfuCanStatusRespBody.fromJson(Map<String, dynamic> json) {
    return MfuCanStatusRespBody(
      can: json.parse<String>('can'),
      proofUpdlnk: json.parse<String>('proofUpdlnk'),
      msg: json.parse<String>('msg'),
      canStatus: json.parse<String>('canStatus'),
      blockRespList: json.parseListOf<MfuCanStatusBlockResp>(
        'blockRespList',
        (item) => MfuCanStatusBlockResp.fromJson(item as Map<String, dynamic>),
      ),
    );
  }
}

class MfuCanStatusBlockResp {
  final String? blockName;
  final String? blockSubName;
  final String? seqNo;
  final String? rspType;
  final String? rspCode;

  MfuCanStatusBlockResp({
    this.blockName,
    this.blockSubName,
    this.seqNo,
    this.rspType,
    this.rspCode,
  });

  factory MfuCanStatusBlockResp.fromJson(Map<String, dynamic> json) {
    return MfuCanStatusBlockResp(
      blockName: json.parse<String>('blockName'),
      blockSubName: json.parse<String>('blockSubName'),
      seqNo: json.parse<String>('seqNo'),
      rspType: json.parse<String>('rspType'),
      rspCode: json.parse<String>('rspCode'),
    );
  }
}
