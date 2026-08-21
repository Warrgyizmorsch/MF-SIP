class RedeemReqModel {
  final dynamic mfuOrderFundId;
  final String? folio;
  final bool? redeemAll;
  final double? amount;
  final double? units;

  RedeemReqModel({
    required this.mfuOrderFundId,
    this.folio,
    this.redeemAll,
    this.amount,
    this.units,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'mfu_order_fund_id': mfuOrderFundId};
    if (folio != null && folio!.isNotEmpty) {
      final cleanFolio = folio!.contains('/')
          ? folio!.split('/').first
          : folio!;
      data['folio'] = cleanFolio;
    }
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
