import 'package:my_sip/core/utils/helper/custom_json_parser.dart';
import '../../domain/entity/link_fund_goal_response_entity.dart';

class LinkFundGoalResponseModel {
  final bool? status;
  final bool? success;
  final String? message;
  final int? goalId;
  final int? mfuOrderId;
  final int? mfuOrderFundId;
  final String? orderRefNo;
  final String? schemeCode;
  final int? linkedTxnCount;

  LinkFundGoalResponseModel({
    this.status,
    this.success,
    this.message,
    this.goalId,
    this.mfuOrderId,
    this.mfuOrderFundId,
    this.orderRefNo,
    this.schemeCode,
    this.linkedTxnCount,
  });

  factory LinkFundGoalResponseModel.fromJson(Map<String, dynamic> json) {
    return LinkFundGoalResponseModel(
      status: json.parse<bool>('status'),
      success: json.parse<bool>('success'),
      message: json.parse<String>('message'),
      goalId: json.parse<int>('goal_id'),
      mfuOrderId: json.parse<int>('mfu_order_id'),
      mfuOrderFundId: json.parse<int>('mfu_order_fund_id'),
      orderRefNo: json.parse<String>('order_ref_no'),
      schemeCode: json.parse<String>('scheme_code'),
      linkedTxnCount: json.parse<int>('linked_txn_count'),
    );
  }

  LinkFundGoalResponseEntity toEntity() {
    return LinkFundGoalResponseEntity(
      status: status ?? success ?? false,
      success: success ?? status ?? false,
      message: message ?? '',
      goalId: goalId ?? 0,
      mfuOrderId: mfuOrderId ?? 0,
      mfuOrderFundId: mfuOrderFundId ?? 0,
      orderRefNo: orderRefNo ?? '',
      schemeCode: schemeCode ?? '',
      linkedTxnCount: linkedTxnCount ?? 0,
    );
  }
}
