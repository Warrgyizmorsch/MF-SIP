import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

class LumpsumResModel {
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

  LumpsumResModel({
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

  factory LumpsumResModel.fromJson(Map<String, dynamic> json) {
    return LumpsumResModel(
      success: json.parse<bool>('success'),
      message: json.parse<String>('message'),
      txnType: json.parse<String>('txn_type'),
      investmentType: json.parse<String>('investment_type'),
      entGroupRef:
          json.parse<String>('ent_group_ref') ??
          json.parse<String>('ent_group_ref_no'),
      mfuOrderId: json.parse<int>('mfu_order_id'),
      mfuGorn: json.parse<String>('mfu_gorn'),
      corn: json.parse<String>('corn'),
      orderStatus: json.parse<String>('order_status'),
      paymentLink: json.parse<String>('payment_link'),
      approvalLink: json.parse<String>('approval_link'),
      mfuItrn: json.parse<String>('mfu_itrn'),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'txn_type': txnType,
    'investment_type': investmentType,
    'ent_group_ref': entGroupRef,
    'mfu_order_id': mfuOrderId,
    'mfu_gorn': mfuGorn,
    'corn': corn,
    'order_status': orderStatus,
    'payment_link': paymentLink,
    'approval_link': approvalLink,
    'mfu_itrn': mfuItrn,
  };
}
