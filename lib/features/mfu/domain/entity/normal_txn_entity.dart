// features/mfu/domain/entity/mfu_normal_txn_entity.dart

import 'package:equatable/equatable.dart';
import 'package:my_sip/features/mfu/data/model/normal_txn_model.dart';

class MfuNormalTxnEntity extends Equatable {
  final bool success;
  final String message;
  final String txnType;
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

  const MfuNormalTxnEntity({
    required this.success,
    required this.message,
    required this.txnType,
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
  });

  bool get isOrderCreated => ordCreatedFlag == 'Y';
  bool get hasApprovalLink => approvalLink.isNotEmpty;
  bool get hasPaymentLink => paymentLink.isNotEmpty;

  @override
  List<Object?> get props => [
    success,
    message,
    txnType,
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
  ];
}

extension MfuNormalTxnMapper on MfuNormalTxnModel {
  MfuNormalTxnEntity toEntity() {
    return MfuNormalTxnEntity(
      success: success ?? false,
      message: message ?? '',
      txnType: txnType ?? '',
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
    );
  }
}
