class RedeemReqModel {
  final dynamic mfuOrderFundId;
  final bool? redeemAll;
  final double? amount;
  final double? units;

  RedeemReqModel({
    required this.mfuOrderFundId,
    this.redeemAll,
    this.amount,
    this.units,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'mfu_order_fund_id': mfuOrderFundId};
    if (redeemAll == true) {
      data['redeem_all'] = true;
    } else if (amount != null && amount! > 0) {
      data['amount'] = amount;
    } else if (units != null && units! > 0) {
      data['units'] = units;
    }
    return data;
  }
}
