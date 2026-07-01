
import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

class MfuTransactionListModel {
  final bool? success;
  final List<MfuTransactionModel>? transactions;

  MfuTransactionListModel({this.success, this.transactions});

  factory MfuTransactionListModel.fromJson(Map<String, dynamic> json) {
    return MfuTransactionListModel(
      success: json.parse<bool>('success'),
      transactions: json.parseListOf<MfuTransactionModel>(
        'transactions',
        (item) => MfuTransactionModel.fromJson(item as Map<String, dynamic>),
      ),
    );
  }
}

class MfuTransactionModel {
  final String? txnDate;
  final String? mfOrderId;
  final String? investmentType;
  final String? txtType;
  final double? amount;
  final String? status;
  final String? fundName;
  final String? invSince;

  MfuTransactionModel({
    this.txnDate,
    this.mfOrderId,
    this.investmentType,
    this.txtType,
    this.amount,
    this.status,
    this.fundName,
    this.invSince,
  });

  factory MfuTransactionModel.fromJson(Map<String, dynamic> json) {
    return MfuTransactionModel(
      txnDate: json.parse<String>('txn_date'),
      mfOrderId: json.parse<String>('mf_order_id'),
      investmentType: json.parse<String>('investment_type'),
      txtType: json.parse<String>('txt_type'),
      amount: json.parse<double>('amount'),
      status: json.parse<String>('status'),
      fundName: json.parse<String>('fund_name'),
      invSince: json.parse<String>('launch_date'),
    );
  }
}