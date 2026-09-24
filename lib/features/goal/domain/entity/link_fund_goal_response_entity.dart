class LinkFundGoalResponseEntity {
  final bool status;
  final bool success;
  final String message;
  final int goalId;
  final int mfuOrderId;
  final int mfuOrderFundId;
  final String orderRefNo;
  final String schemeCode;
  final int linkedTxnCount;

  const LinkFundGoalResponseEntity({
    required this.status,
    required this.success,
    required this.message,
    required this.goalId,
    required this.mfuOrderId,
    required this.mfuOrderFundId,
    required this.orderRefNo,
    required this.schemeCode,
    required this.linkedTxnCount,
  });
}
