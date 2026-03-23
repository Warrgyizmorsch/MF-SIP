import 'package:equatable/equatable.dart';
import 'package:my_sip/features/kyc/data/model/kyc_check_model.dart';

class KycCheckEntity extends Equatable {
  final bool? status;
  final String? message;
  final String? currentStatus;
  final KycCheckDataEntity? data;

  const KycCheckEntity({
    this.status,
    this.message,
    this.currentStatus,
    this.data,
  });

  @override
  List<Object?> get props => [status, message, currentStatus, data];
}

class KycCheckDataEntity extends Equatable {
  final RespHeaderEntity? respHeader;
  final RespBodyEntity? respBody;

  const KycCheckDataEntity({
    this.respHeader,
    this.respBody,
  });

  @override
  List<Object?> get props => [respHeader, respBody];
}

class RespHeaderEntity extends Equatable {
  final String? respFlag;
  final String? respTs;
  final String? errorCode;
  final String? errorMsg;

  const RespHeaderEntity({
    this.respFlag,
    this.respTs,
    this.errorCode,
    this.errorMsg,
  });

  @override
  List<Object?> get props => [respFlag, respTs, errorCode, errorMsg];
}

class RespBodyEntity extends Equatable {
  final String? panVerifyRefNo;
  final String? canAvailFlg;
  final String? can;
  final String? errorCode;
  final String? errorMsg;
  final String? txnEligFlg;
  final List<PanItemEntity>? panList;

  const RespBodyEntity({
    this.panVerifyRefNo,
    this.canAvailFlg,
    this.can,
    this.errorCode,
    this.errorMsg,
    this.txnEligFlg,
    this.panList,
  });

  @override
  List<Object?> get props => [
        panVerifyRefNo,
        canAvailFlg,
        can,
        errorCode,
        errorMsg,
        txnEligFlg,
        panList,
      ];
}

class PanItemEntity extends Equatable {
  final String? pan;
  final String? panValFlg;
  final String? panName;
  final String? panKycSt;
  final String? mfuKycStatus;
  final String? panAppStatus;
  final String? panAppUpdtStatus;

  const PanItemEntity({
    this.pan,
    this.panValFlg,
    this.panName,
    this.panKycSt,
    this.mfuKycStatus,
    this.panAppStatus,
    this.panAppUpdtStatus,
  });

  @override
  List<Object?> get props => [
        pan,
        panValFlg,
        panName,
        panKycSt,
        mfuKycStatus,
        panAppStatus,
        panAppUpdtStatus,
      ];
}


// ==========================================
// MAPPERS (Model -> Entity)
// ==========================================

extension KycCheckModelMapper on KycCheckModel {
  KycCheckEntity toEntity() {
    return KycCheckEntity(
      status: status,
      message: message,
      currentStatus: currentStatus,
      data: data?.toEntity(),
    );
  }
}

extension KycCheckDataModelMapper on KycCheckDataModel {
  KycCheckDataEntity toEntity() {
    return KycCheckDataEntity(
      respHeader: respHeader?.toEntity(),
      respBody: respBody?.toEntity(),
    );
  }
}

extension RespHeaderModelMapper on RespHeaderModel {
  RespHeaderEntity toEntity() {
    return RespHeaderEntity(
      respFlag: respFlag,
      respTs: respTs,
      errorCode: errorCode,
      errorMsg: errorMsg,
    );
  }
}

extension RespBodyModelMapper on RespBodyModel {
  RespBodyEntity toEntity() {
    return RespBodyEntity(
      panVerifyRefNo: panVerifyRefNo,
      canAvailFlg: canAvailFlg,
      can: can,
      errorCode: errorCode,
      errorMsg: errorMsg,
      txnEligFlg: txnEligFlg,
      panList: panList?.map((e) => e.toEntity()).toList(),
    );
  }
}

extension PanItemModelMapper on PanItemModel {
  PanItemEntity toEntity() {
    return PanItemEntity(
      pan: pan,
      panValFlg: panValFlg,
      panName: panName,
      panKycSt: panKycSt,
      mfuKycStatus: mfuKycStatus,
      panAppStatus: panAppStatus,
      panAppUpdtStatus: panAppUpdtStatus,
    );
  }
}