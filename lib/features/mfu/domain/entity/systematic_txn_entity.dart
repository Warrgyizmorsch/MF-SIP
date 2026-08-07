// features/mfu/domain/entity/mfu_systematic_txn_entity.dart

import 'package:equatable/equatable.dart';
import 'package:my_sip/features/mfu/data/model/systematic_txn_model.dart';

class MfuSystematicTxnEntity extends Equatable {
  final bool success;
  final String message;
  final String txnType;
  final String txtType;
  final String investmentType;
  final String mfuTxnType;
  final String entGroupRefNo;
  final String ordCreatedFlag;
  final String mfuGorn;
  final String corn;
  final String orderStatus;
  final String paymentLink;
  final String approvalLink;
  final String appLinkPri;
  final String mfuItrn;
  final List<dynamic> errors;

  const MfuSystematicTxnEntity({
    required this.success,
    required this.message,
    required this.txnType,
    required this.txtType,
    required this.investmentType,
    required this.mfuTxnType,
    required this.entGroupRefNo,
    required this.ordCreatedFlag,
    required this.mfuGorn,
    required this.corn,
    required this.orderStatus,
    required this.paymentLink,
    required this.approvalLink,
    required this.appLinkPri,
    required this.mfuItrn,
    required this.errors,
  });

  bool get isOrderCreated => ordCreatedFlag == 'Y';
  bool get hasApprovalLink => approvalLink.isNotEmpty;
  bool get hasPaymentLink => paymentLink.isNotEmpty;
  bool get hasErrors => errors.isNotEmpty;

  @override
  List<Object?> get props => [
    success,
    message,
    txnType,
    txtType,
    investmentType,
    mfuTxnType,
    entGroupRefNo,
    ordCreatedFlag,
    mfuGorn,
    corn,
    orderStatus,
    paymentLink,
    approvalLink,
    appLinkPri,
    mfuItrn,
    errors,
  ];
}

extension MfuSystematicTxnMapper on MfuSystematicTxnModel {
  MfuSystematicTxnEntity toEntity() {
    return MfuSystematicTxnEntity(
      success: success ?? false,
      message: message ?? '',
      txnType: txnType ?? '',
      txtType: txtType ?? '',
      investmentType: investmentType ?? '',
      mfuTxnType: mfuTxnType ?? '',
      entGroupRefNo: entGroupRefNo ?? '',
      ordCreatedFlag: ordCreatedFlag ?? '',
      mfuGorn: mfuGorn ?? '',
      corn: corn ?? '',
      orderStatus: orderStatus ?? '',
      paymentLink: paymentLink ?? '',
      approvalLink: approvalLink ?? '',
      appLinkPri: appLinkPri ?? '',
      mfuItrn: mfuItrn ?? '',
      errors: errors ?? [],
    );
  }
}
