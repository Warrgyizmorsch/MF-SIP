import 'package:equatable/equatable.dart';
import 'package:my_sip/features/dashboard/data/model/transactionlist_model.dart';

class MfuTransactionListEntity extends Equatable {
  final bool success;
  final List<MfuTransactionEntity> transactions;

  const MfuTransactionListEntity({
    required this.success,
    required this.transactions,
  });

  bool get isEmpty => transactions.isEmpty;
  int get totalCount => transactions.length;

  List<MfuTransactionEntity> get pending =>
      transactions.where((t) => t.isPending).toList();

  List<MfuTransactionEntity> get failed =>
      transactions.where((t) => t.isFailed).toList();

  List<MfuTransactionEntity> get successful =>
      transactions.where((t) => t.isSuccess).toList();

  List<MfuTransactionEntity> get sipTransactions =>
      transactions.where((t) => t.isSip).toList();

  List<MfuTransactionEntity> get normalTransactions =>
      transactions.where((t) => t.isNormal).toList();

  @override
  List<Object?> get props => [success, transactions];
}

class MfuTransactionEntity extends Equatable {
  final String txnDate;
  final String mfOrderId;
  final String investmentType;
  final String txtType;
  final double amount;
  final String status;
  final String fundName;
  final String invSince;

  const MfuTransactionEntity({
    required this.txnDate,
    required this.mfOrderId,
    required this.investmentType,
    required this.txtType,
    required this.amount,
    required this.status,
    required this.fundName,
    required this.invSince,
  });

  bool get isPending => status.toLowerCase() == 'pending';
  bool get isFailed => status.toLowerCase() == 'failed';
  bool get isSuccess => status.toLowerCase() == 'success';
  bool get isSip => investmentType.toLowerCase() == 'sip';
  bool get isNormal => investmentType.toLowerCase() == 'normal';
  bool get isRedeem => txtType.toLowerCase() == 'redeem';
  bool get isLumpsum => txtType.toLowerCase() == 'lumpsum';
  bool get isSystematic => txtType.toLowerCase() == 'systematic';

  @override
  List<Object?> get props => [
    txnDate,
    mfOrderId,
    investmentType,
    txtType,
    amount,
    status,
    fundName,
    invSince,
  ];
}

extension MfuTransactionListMapper on MfuTransactionListModel {
  MfuTransactionListEntity toEntity() {
    return MfuTransactionListEntity(
      success: success ?? false,
      transactions: transactions?.map((e) => e.toEntity()).toList() ?? [],
    );
  }
}

extension MfuTransactionMapper on MfuTransactionModel {
  MfuTransactionEntity toEntity() {
    return MfuTransactionEntity(
      txnDate: txnDate ?? '',
      mfOrderId: mfOrderId ?? '',
      investmentType: investmentType ?? '',
      txtType: txtType ?? '',
      amount: amount ?? 0.0,
      status: status ?? '',
      fundName: fundName ?? '',
      invSince: invSince ?? '',
    );
  }
}
