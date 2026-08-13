class LumpsumFundItemModel {
  final String schemeCode;
  final num amount;
  final String folio;

  LumpsumFundItemModel({
    required this.schemeCode,
    required this.amount,
    this.folio = 'NEW',
  });

  Map<String, dynamic> toJson() => {
    'scheme_code': schemeCode,
    'amount': amount,
    'folio': folio,
  };

  factory LumpsumFundItemModel.fromJson(Map<String, dynamic> json) {
    return LumpsumFundItemModel(
      schemeCode: json['scheme_code']?.toString() ?? '',
      amount: json['amount'] ?? 0,
      folio: json['folio']?.toString() ?? 'NEW',
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
