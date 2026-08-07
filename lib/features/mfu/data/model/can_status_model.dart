// features/mfu/data/model/mfu_can_status_model.dart

import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

class MfuCanStatusModel {
  final bool? success;
  final MfuCanStatusRequestModel? request;
  final MfuCanStatusApiResponseModel? response;

  MfuCanStatusModel({this.success, this.request, this.response});

  factory MfuCanStatusModel.fromJson(Map<String, dynamic> json) {
    return MfuCanStatusModel(
      success: json.parse<bool>('success'),
      request: json['request'] != null
          ? MfuCanStatusRequestModel.fromJson(
              json['request'] as Map<String, dynamic>,
            )
          : null,
      response: json['response'] != null
          ? MfuCanStatusApiResponseModel.fromJson(
              json['response'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class MfuCanStatusRequestModel {
  final MfuCanStatusReqHeaderModel? reqHeader;
  final MfuCanStatusReqBodyModel? reqBody;

  MfuCanStatusRequestModel({this.reqHeader, this.reqBody});

  factory MfuCanStatusRequestModel.fromJson(Map<String, dynamic> json) {
    return MfuCanStatusRequestModel(
      reqHeader: json['reqHeader'] != null
          ? MfuCanStatusReqHeaderModel.fromJson(
              json['reqHeader'] as Map<String, dynamic>,
            )
          : null,
      reqBody: json['reqBody'] != null
          ? MfuCanStatusReqBodyModel.fromJson(
              json['reqBody'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class MfuCanStatusReqHeaderModel {
  final String? entityId;
  final String? version;
  final String? reqTs;
  final String? apiType;
  final String? uniqueId;

  MfuCanStatusReqHeaderModel({
    this.entityId,
    this.version,
    this.reqTs,
    this.apiType,
    this.uniqueId,
  });

  factory MfuCanStatusReqHeaderModel.fromJson(Map<String, dynamic> json) {
    return MfuCanStatusReqHeaderModel(
      entityId: json.parse<String>('entityId'),
      version: json.parse<String>('version'),
      reqTs: json.parse<String>('reqTS'),
      apiType: json.parse<String>('apiType'),
      uniqueId: json.parse<String>('uniqueId'),
    );
  }
}

class MfuCanStatusReqBodyModel {
  final String? data;

  MfuCanStatusReqBodyModel({this.data});

  factory MfuCanStatusReqBodyModel.fromJson(Map<String, dynamic> json) {
    return MfuCanStatusReqBodyModel(data: json.parse<String>('data'));
  }
}

class MfuCanStatusApiResponseModel {
  final MfuCanStatusRespHeaderModel? respHeader;
  final MfuCanStatusRespBodyModel? respBody;

  MfuCanStatusApiResponseModel({this.respHeader, this.respBody});

  factory MfuCanStatusApiResponseModel.fromJson(Map<String, dynamic> json) {
    return MfuCanStatusApiResponseModel(
      respHeader: json['respHeader'] != null
          ? MfuCanStatusRespHeaderModel.fromJson(
              json['respHeader'] as Map<String, dynamic>,
            )
          : null,
      respBody: json['respBody'] != null
          ? MfuCanStatusRespBodyModel.fromJson(
              json['respBody'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class MfuCanStatusRespHeaderModel {
  final String? respFlag;
  final String? respTs;
  final String? errorCode;
  final String? errorMsg;

  MfuCanStatusRespHeaderModel({
    this.respFlag,
    this.respTs,
    this.errorCode,
    this.errorMsg,
  });

  factory MfuCanStatusRespHeaderModel.fromJson(Map<String, dynamic> json) {
    return MfuCanStatusRespHeaderModel(
      respFlag: json.parse<String>('respFlag'),
      respTs: json.parse<String>('respTs'),
      errorCode: json.parse<String>('errorCode'),
      errorMsg: json.parse<String>('errorMsg'),
    );
  }
}

class MfuCanStatusRespBodyModel {
  final String? can;
  final String? proofUpdlnk;
  final String? msg;
  final String? canStatus;
  final List<MfuCanStatusBlockRespModel>? blockRespList;

  MfuCanStatusRespBodyModel({
    this.can,
    this.proofUpdlnk,
    this.msg,
    this.canStatus,
    this.blockRespList,
  });

  factory MfuCanStatusRespBodyModel.fromJson(Map<String, dynamic> json) {
    return MfuCanStatusRespBodyModel(
      can: json.parse<String>('can'),
      proofUpdlnk: json.parse<String>('proofUpdlnk'),
      msg: json.parse<String>('msg'),
      canStatus: json.parse<String>('canStatus'),
      blockRespList: json.parseListOf<MfuCanStatusBlockRespModel>(
        'blockRespList',
        (item) =>
            MfuCanStatusBlockRespModel.fromJson(item as Map<String, dynamic>),
      ),
    );
  }
}

class MfuCanStatusBlockRespModel {
  final String? blockName;
  final String? blockSubName;
  final String? seqNo;
  final String? rspType;
  final String? rspCode;

  MfuCanStatusBlockRespModel({
    this.blockName,
    this.blockSubName,
    this.seqNo,
    this.rspType,
    this.rspCode,
  });

  factory MfuCanStatusBlockRespModel.fromJson(Map<String, dynamic> json) {
    return MfuCanStatusBlockRespModel(
      blockName: json.parse<String>('blockName'),
      blockSubName: json.parse<String>('blockSubName'),
      seqNo: json.parse<String>('seqNo'),
      rspType: json.parse<String>('rspType'),
      rspCode: json.parse<String>('rspCode'),
    );
  }
}
