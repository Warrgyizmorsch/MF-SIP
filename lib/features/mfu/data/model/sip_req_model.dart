class SipFundItemModel {
  final String schemeCode;
  final num amount;
  final String folio;

  SipFundItemModel({
    required this.schemeCode,
    required this.amount,
    this.folio = 'NEW',
  });

  Map<String, dynamic> toJson() => {
    'scheme_code': schemeCode,
    'amount': amount,
    'folio': folio,
  };

  factory SipFundItemModel.fromJson(Map<String, dynamic> json) {
    return SipFundItemModel(
      schemeCode: json['scheme_code']?.toString() ?? '',
      amount: json['amount'] ?? 0,
      folio: json['folio']?.toString() ?? 'NEW',
    );
  }
}

class SipReqModel {
  final String frequency;
  final String day;
  final List<SipFundItemModel> funds;

  SipReqModel({this.frequency = 'M', required this.day, required this.funds});

  Map<String, dynamic> toJson() => {
    'frequency': frequency,
    'day': day,
    'funds': funds.map((e) => e.toJson()).toList(),
  };

  factory SipReqModel.fromJson(Map<String, dynamic> json) {
    return SipReqModel(
      frequency: json['frequency']?.toString() ?? 'M',
      day: json['day']?.toString() ?? '',
      funds:
          (json['funds'] as List<dynamic>?)
              ?.map((e) => SipFundItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
