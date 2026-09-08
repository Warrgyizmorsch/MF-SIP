class LumpsumFundItemModel {
  final String schemeCode;
  final num amount;
  final String folio;
  final String? devopt;

  LumpsumFundItemModel({
    required this.schemeCode,
    required this.amount,
    this.folio = 'NEW',
    this.devopt,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'scheme_code': schemeCode,
      'amount': amount,
      'folio': folio,
    };
    if (devopt != null) data['devopt'] = devopt;
    return data;
  }

  factory LumpsumFundItemModel.fromJson(Map<String, dynamic> json) {
    return LumpsumFundItemModel(
      schemeCode: json['scheme_code']?.toString() ?? '',
      amount: json['amount'] ?? 0,
      folio: json['folio']?.toString() ?? 'NEW',
      devopt: json['devopt']?.toString(),
    );
  }
}

class LumpsumReqModel {
  final List<LumpsumFundItemModel> funds;

  LumpsumReqModel({required this.funds});

  Map<String, dynamic> toJson() => {
    'funds': funds.map((e) => e.toJson()).toList(),
  };

  factory LumpsumReqModel.fromJson(Map<String, dynamic> json) {
    return LumpsumReqModel(
      funds:
          (json['funds'] as List<dynamic>?)
              ?.map(
                (e) => LumpsumFundItemModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }
}
