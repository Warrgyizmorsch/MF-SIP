// features/mfu/domain/entity/response/mfu_can_val_entity.dart

import 'package:equatable/equatable.dart';
import 'package:my_sip/features/mfu/data/model/mfu_can_val_response.dart';

class MfuCanValEntity extends Equatable {
  final String respFlag;
  final String respTs;
  final String errorCode;
  final String errorMsg;
  final String isValidCan;
  final String isValidPan;
  final String isValidDob;
  final String isValidEmail;
  final String canStatus;
  final String allowForTrans;
  final String accountCategory;
  final String canModeOfHolding;

  const MfuCanValEntity({
    required this.respFlag,
    required this.respTs,
    required this.errorCode,
    required this.errorMsg,
    required this.isValidCan,
    required this.isValidPan,
    required this.isValidDob,
    required this.isValidEmail,
    required this.canStatus,
    required this.allowForTrans,
    required this.accountCategory,
    required this.canModeOfHolding,
  });

  // ─── Convenience getters ──────────────────────────────────────────────────
  bool get isSuccess => respFlag == 'S';
  bool get canValid => isValidCan.toUpperCase() == 'TRUE';
  bool get panValid => isValidPan.toUpperCase() == 'TRUE';
  bool get dobValid => isValidDob.toUpperCase() == 'TRUE';
  bool get emailValid => isValidEmail.toUpperCase() == 'TRUE';
  bool get canAllowTrans => allowForTrans.toUpperCase() == 'TRUE';
  bool get isApproved => canStatus.toUpperCase() == 'AP';
  bool get isSingleHolding => canModeOfHolding.toUpperCase() == 'SI';

  @override
  List<Object?> get props => [
    respFlag,
    respTs,
    errorCode,
    errorMsg,
    isValidCan,
    isValidPan,
    isValidDob,
    isValidEmail,
    canStatus,
    allowForTrans,
    accountCategory,
    canModeOfHolding,
  ];
}

extension MfuCanValResponseMapper on MfuCanValResponse {
  MfuCanValEntity toEntity() {
    return MfuCanValEntity(
      respFlag: respHeader?.respFlag ?? '',
      respTs: respHeader?.respTs ?? '',
      errorCode: respHeader?.errorCode ?? '',
      errorMsg: respHeader?.errorMsg ?? '',
      isValidCan: respBody?.isValidCan ?? '',
      isValidPan: respBody?.isValidPan ?? '',
      isValidDob: respBody?.isValidDob ?? '',
      isValidEmail: respBody?.isValidEmail ?? '',
      canStatus: respBody?.canStatus ?? '',
      allowForTrans: respBody?.allowForTrans ?? '',
      accountCategory: respBody?.accountCategory ?? '',
      canModeOfHolding: respBody?.canModeOfHolding ?? '',
    );
  }
}
