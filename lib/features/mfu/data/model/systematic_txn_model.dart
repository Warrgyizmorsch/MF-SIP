
import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

class MfuSystematicTxnModel {
  final bool? success;
  final String? message;
  final String? txnType;
  final String? txtType;
  final String? investmentType;
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
  final List<dynamic>? errors;

  MfuSystematicTxnModel({
    this.success,
    this.message,
    this.txnType,
    this.txtType,
    this.investmentType,
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
    this.errors,
  });

  factory MfuSystematicTxnModel.fromJson(Map<String, dynamic> json) {
    return MfuSystematicTxnModel(
      success: json.parse<bool>('success'),
      message: json.parse<String>('message'),
      txnType: json.parse<String>('txn_type'),
      txtType: json.parse<String>('txt_type'),
      investmentType: json.parse<String>('investment_type'),
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
      errors: json['errors'] as List<dynamic>?,
    );
  }
}