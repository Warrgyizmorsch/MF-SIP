// features/mfu/domain/entity/response/mfu_can_status_entity.dart

import 'package:equatable/equatable.dart';
import 'package:my_sip/features/mfu/data/model/mfu_can_status_response.dart';

class MfuCanStatusEntity extends Equatable {
  final String respFlag;
  final String respTs;
  final String errorCode;
  final String errorMsg;
  final String can;
  final String proofUpdlnk;
  final String msg;
  final String canStatus;
  final List<MfuCanStatusBlockEntity> blockRespList;

  const MfuCanStatusEntity({
    required this.respFlag,
    required this.respTs,
    required this.errorCode,
    required this.errorMsg,
    required this.can,
    required this.proofUpdlnk,
    required this.msg,
    required this.canStatus,
    required this.blockRespList,
  });

  bool get isSuccess => respFlag == 'S';
  bool get isPending => canStatus.toLowerCase() == 'pending';
  bool get isApproved => canStatus.toLowerCase() == 'approved';
  bool get hasBlocks => blockRespList.isNotEmpty;
  bool get hasProofLink => proofUpdlnk.isNotEmpty;

  @override
  List<Object?> get props => [
    respFlag,
    respTs,
    errorCode,
    errorMsg,
    can,
    proofUpdlnk,
    msg,
    canStatus,
    blockRespList,
  ];
}

class MfuCanStatusBlockEntity extends Equatable {
  final String blockName;
  final String blockSubName;
  final String seqNo;
  final String rspType;
  final String rspCode;

  const MfuCanStatusBlockEntity({
    required this.blockName,
    required this.blockSubName,
    required this.seqNo,
    required this.rspType,
    required this.rspCode,
  });

  @override
  List<Object?> get props => [blockName, blockSubName, seqNo, rspType, rspCode];
}

// ─── Mapper ───────────────────────────────────────────────────────────────────

extension MfuCanStatusResponseMapper on MfuCanStatusResponse {
  MfuCanStatusEntity toEntity() {
    return MfuCanStatusEntity(
      respFlag: respHeader?.respFlag ?? '',
      respTs: respHeader?.respTs ?? '',
      errorCode: respHeader?.errorCode ?? '',
      errorMsg: respHeader?.errorMsg ?? '',
      can: respBody?.can ?? '',
      proofUpdlnk: respBody?.proofUpdlnk ?? '',
      msg: respBody?.msg ?? '',
      canStatus: respBody?.canStatus ?? '',
      blockRespList:
          respBody?.blockRespList
              ?.map(
                (e) => MfuCanStatusBlockEntity(
                  blockName: e.blockName ?? '',
                  blockSubName: e.blockSubName ?? '',
                  seqNo: e.seqNo ?? '',
                  rspType: e.rspType ?? '',
                  rspCode: e.rspCode ?? '',
                ),
              )
              .toList() ??
          [],
    );
  }
}
