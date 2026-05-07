import 'package:equatable/equatable.dart';
import 'package:my_sip/features/mfu/data/model/can_status_model.dart';

class MfuCanStatusEntity extends Equatable {
  final bool success;
  final MfuCanStatusRequestEntity? request;
  final MfuCanStatusApiResponseEntity? response;

  const MfuCanStatusEntity({
    required this.success,
    this.request,
    this.response,
  });

  bool get isSuccess => response?.respHeader?.isSuccess ?? false;
  String get canStatus => response?.respBody?.canStatus ?? '';
  String get canNumber => response?.respBody?.can ?? '';
  List<MfuCanStatusBlockRespEntity> get blockRespList =>
      response?.respBody?.blockRespList ?? [];

  @override
  List<Object?> get props => [success, request, response];
}

class MfuCanStatusRequestEntity extends Equatable {
  final MfuCanStatusReqHeaderEntity? reqHeader;
  final String? reqBodyData;

  const MfuCanStatusRequestEntity({this.reqHeader, this.reqBodyData});

  @override
  List<Object?> get props => [reqHeader, reqBodyData];
}

class MfuCanStatusReqHeaderEntity extends Equatable {
  final String entityId;
  final String version;
  final String reqTs;
  final String apiType;
  final String uniqueId;

  const MfuCanStatusReqHeaderEntity({
    required this.entityId,
    required this.version,
    required this.reqTs,
    required this.apiType,
    required this.uniqueId,
  });

  @override
  List<Object?> get props => [entityId, version, reqTs, apiType, uniqueId];
}

class MfuCanStatusApiResponseEntity extends Equatable {
  final MfuCanStatusRespHeaderEntity? respHeader;
  final MfuCanStatusRespBodyEntity? respBody;

  const MfuCanStatusApiResponseEntity({this.respHeader, this.respBody});

  @override
  List<Object?> get props => [respHeader, respBody];
}

class MfuCanStatusRespHeaderEntity extends Equatable {
  final String respFlag;
  final String respTs;
  final String errorCode;
  final String errorMsg;

  const MfuCanStatusRespHeaderEntity({
    required this.respFlag,
    required this.respTs,
    required this.errorCode,
    required this.errorMsg,
  });

  bool get isSuccess => respFlag == 'S';

  @override
  List<Object?> get props => [respFlag, respTs, errorCode, errorMsg];
}

class MfuCanStatusRespBodyEntity extends Equatable {
  final String can;
  final String proofUpdlnk;
  final String msg;
  final String canStatus;
  final List<MfuCanStatusBlockRespEntity> blockRespList;

  const MfuCanStatusRespBodyEntity({
    required this.can,
    required this.proofUpdlnk,
    required this.msg,
    required this.canStatus,
    required this.blockRespList,
  });

  @override
  List<Object?> get props => [can, proofUpdlnk, msg, canStatus, blockRespList];
}

class MfuCanStatusBlockRespEntity extends Equatable {
  final String blockName;
  final String blockSubName;
  final String seqNo;
  final String rspType;
  final String rspCode;

  const MfuCanStatusBlockRespEntity({
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

extension MfuCanStatusMapper on MfuCanStatusModel {
  MfuCanStatusEntity toEntity() {
    return MfuCanStatusEntity(
      success: success ?? false,
      request: request?.toEntity(),
      response: response?.toEntity(),
    );
  }
}

extension MfuCanStatusRequestMapper on MfuCanStatusRequestModel {
  MfuCanStatusRequestEntity toEntity() {
    return MfuCanStatusRequestEntity(
      reqHeader: reqHeader?.toEntity(),
      reqBodyData: reqBody?.data,
    );
  }
}

extension MfuCanStatusReqHeaderMapper on MfuCanStatusReqHeaderModel {
  MfuCanStatusReqHeaderEntity toEntity() {
    return MfuCanStatusReqHeaderEntity(
      entityId: entityId ?? '',
      version: version ?? '',
      reqTs: reqTs ?? '',
      apiType: apiType ?? '',
      uniqueId: uniqueId ?? '',
    );
  }
}

extension MfuCanStatusApiResponseMapper on MfuCanStatusApiResponseModel {
  MfuCanStatusApiResponseEntity toEntity() {
    return MfuCanStatusApiResponseEntity(
      respHeader: respHeader?.toEntity(),
      respBody: respBody?.toEntity(),
    );
  }
}

extension MfuCanStatusRespHeaderMapper on MfuCanStatusRespHeaderModel {
  MfuCanStatusRespHeaderEntity toEntity() {
    return MfuCanStatusRespHeaderEntity(
      respFlag: respFlag ?? '',
      respTs: respTs ?? '',
      errorCode: errorCode ?? '',
      errorMsg: errorMsg ?? '',
    );
  }
}

extension MfuCanStatusRespBodyMapper on MfuCanStatusRespBodyModel {
  MfuCanStatusRespBodyEntity toEntity() {
    return MfuCanStatusRespBodyEntity(
      can: can ?? '',
      proofUpdlnk: proofUpdlnk ?? '',
      msg: msg ?? '',
      canStatus: canStatus ?? '',
      blockRespList: blockRespList?.map((e) => e.toEntity()).toList() ?? [],
    );
  }
}

extension MfuCanStatusBlockRespMapper on MfuCanStatusBlockRespModel {
  MfuCanStatusBlockRespEntity toEntity() {
    return MfuCanStatusBlockRespEntity(
      blockName: blockName ?? '',
      blockSubName: blockSubName ?? '',
      seqNo: seqNo ?? '',
      rspType: rspType ?? '',
      rspCode: rspCode ?? '',
    );
  }
}
