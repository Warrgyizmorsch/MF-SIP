// features/mfu/data/model/mfu_normal_txn_model.dart

import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

class MfuNormalTxnModel {
  final bool? success;
  final String? message;
  final String? txnType;
  final String? mfuTxnType;
  final String? entGroupRefNo;
  final String? ordCreatedFlag;
  final String? mfuGorn;
  final String? corn;
  final String? orderStatus;
  final String? paymentLink;
  final String? approvalLink;
  final String? appLinkPri;
  final String? mfuItrn;

  MfuNormalTxnModel({
    this.success,
    this.message,
    this.txnType,
    this.mfuTxnType,
    this.entGroupRefNo,
    this.ordCreatedFlag,
    this.mfuGorn,
    this.corn,
    this.orderStatus,
    this.paymentLink,
    this.approvalLink,
    this.appLinkPri,
    this.mfuItrn,
  });

  factory MfuNormalTxnModel.fromJson(Map<String, dynamic> json) {
    return MfuNormalTxnModel(
      success: json.parse<bool>('success'),
      message: json.parse<String>('message'),
      txnType: json.parse<String>('txn_type'),
      mfuTxnType: json.parse<String>('mfu_txn_type'),
      entGroupRefNo: json.parse<String>('ent_group_ref_no'),
      ordCreatedFlag: json.parse<String>('ord_created_flag'),
      mfuGorn: json.parse<String>('mfu_gorn'),
      corn: json.parse<String>('corn'),
      orderStatus: json.parse<String>('order_status'),
      paymentLink: json.parse<String>('payment_link'),
      approvalLink: json.parse<String>('approval_link'),
      appLinkPri: json.parse<String>('app_link_pri'),
      mfuItrn: json.parse<String>('mfu_itrn'),
    );
  }
}