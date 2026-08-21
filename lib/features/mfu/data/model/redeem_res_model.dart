import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

class RedeemResModel {
  final bool? success;
  final String? message;
  final String? txnType;
  final String? investmentType;
  final String? entGroupRef;
  final int? mfuOrderId;
  final String? mfuGorn;
  final String? corn;
  final String? orderStatus;
  final String? paymentLink;
  final String? approvalLink;
  final String? mfuItrn;

  RedeemResModel({
    this.success,
    this.message,
    this.txnType,
    this.investmentType,
    this.entGroupRef,
    this.mfuOrderId,
    this.mfuGorn,
    this.corn,
    this.orderStatus,
    this.paymentLink,
    this.approvalLink,
    this.mfuItrn,
  });

  bool get hasApprovalLink => approvalLink != null && approvalLink!.isNotEmpty;

  factory RedeemResModel.fromJson(Map<String, dynamic> json) {
    return RedeemResModel(
      success: json.parse<bool>('success'),
      message: json.parse<String>('message'),
      txnType: json.parse<String>('txn_type'),
      investmentType: json.parse<String>('investment_type'),
      entGroupRef: json.parse<String>('ent_group_ref'),
      mfuOrderId: json.parse<int>('mfu_order_id'),
      mfuGorn: json.parse<String>('mfu_gorn'),
      corn: json.parse<String>('corn'),
      orderStatus: json.parse<String>('order_status'),
      paymentLink: json.parse<String>('payment_link'),
      approvalLink: json.parse<String>('approval_link'),
      mfuItrn: json.parse<String>('mfu_itrn'),
    );
  }
}
