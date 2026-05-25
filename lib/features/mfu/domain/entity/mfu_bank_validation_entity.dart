// features/mfu/domain/entity/mfu_can_bank_validation_entity.dart

import 'package:equatable/equatable.dart';
import 'package:my_sip/features/mfu/data/model/bank_validation_res.dart';

class MfuCanBankValidationEntity extends Equatable {
  final bool success;
  final String message;
  final String stage;
  final MfuCanBankValidationDataEntity? data;
  final MfuCanBankValidationMfuResponseEntity? mfuResponse;

  const MfuCanBankValidationEntity({
    required this.success,
    required this.message,
    required this.stage,
    this.data,
    this.mfuResponse,
  });

  bool get isBankLinked => data?.bankExistFlag == 'Y';
  bool get isMfuSuccess => mfuResponse?.isSuccess ?? false;

  @override
  List<Object?> get props => [success, message, stage, data, mfuResponse];
}

class MfuCanBankValidationDataEntity extends Equatable {
  final int uid;
  final String can;
  final String accountNo;
  final String ifscCode;
  final String micrNo;
  final String bankExistFlag;

  const MfuCanBankValidationDataEntity({
    required this.uid,
    required this.can,
    required this.accountNo,
    required this.ifscCode,
    required this.micrNo,
    required this.bankExistFlag,
  });

  bool get isBankExist => bankExistFlag == 'Y';

  @override
  List<Object?> get props => [uid, can, accountNo, ifscCode, micrNo, bankExistFlag];
}

class MfuCanBankValidationMfuResponseEntity extends Equatable {
  final String respFlag;
  final String respTs;
  final String errorCode;
  final String errorMsg;
  final String bankExistFlag;

  const MfuCanBankValidationMfuResponseEntity({
    required this.respFlag,
    required this.respTs,
    required this.errorCode,
    required this.errorMsg,
    required this.bankExistFlag,
  });

  bool get isSuccess => respFlag == 'S';

  @override
  List<Object?> get props => [
        respFlag, respTs, errorCode, errorMsg, bankExistFlag,
      ];
}

// ─── Mappers ──────────────────────────────────────────────────────────────────

extension MfuCanBankValidationMapper on MfuCanBankValidationModel {
  MfuCanBankValidationEntity toEntity() {
    return MfuCanBankValidationEntity(
      success: success ?? false,
      message: message ?? '',
      stage: stage ?? '',
      data: data?.toEntity(),
      mfuResponse: mfuResponse?.toEntity(),
    );
  }
}

extension MfuCanBankValidationDataMapper on MfuCanBankValidationDataModel {
  MfuCanBankValidationDataEntity toEntity() {
    return MfuCanBankValidationDataEntity(
      uid: uid ?? 0,
      can: can ?? '',
      accountNo: accountNo ?? '',
      ifscCode: ifscCode ?? '',
      micrNo: micrNo ?? '',
      bankExistFlag: bankExistFlag ?? '',
    );
  }
}

extension MfuCanBankValidationMfuResponseMapper
    on MfuCanBankValidationMfuResponseModel {
  MfuCanBankValidationMfuResponseEntity toEntity() {
    return MfuCanBankValidationMfuResponseEntity(
      respFlag: respHeader?.respFlag ?? '',
      respTs: respHeader?.respTs ?? '',
      errorCode: respHeader?.errorCode ?? '',
      errorMsg: respHeader?.errorMsg ?? '',
      bankExistFlag: respBody?.bankExistFlag ?? '',
    );
  }
}