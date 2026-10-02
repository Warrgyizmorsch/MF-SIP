class SipFundItemModel {
  final String schemeCode;
  final num amount;
  final String folio;
  final String frequency;
  final String day;
  final String? devopt;

  SipFundItemModel({
    required this.schemeCode,
    required this.amount,
    this.folio = 'NEW',
    this.frequency = 'M',
    required this.day,
    this.devopt,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'scheme_code': schemeCode,
      'amount': amount,
      'folio': folio,
      'frequency': frequency,
      'day': day,
    };
    if (devopt != null) data['devopt'] = devopt;
    return data;
  }

  factory SipFundItemModel.fromJson(Map<String, dynamic> json) {
    return SipFundItemModel(
      schemeCode: json['scheme_code']?.toString() ?? '',
      amount: json['amount'] ?? 0,
      folio: json['folio']?.toString() ?? 'NEW',
      frequency: json['frequency']?.toString() ?? 'M',
      day: json['day']?.toString() ?? '25',
      devopt: json['devopt']?.toString(),
    );
  }
}

class SipReqModel {
  final List<SipFundItemModel> funds;
  final dynamic goalId;

  SipReqModel({
    required this.funds,
    this.goalId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'funds': funds.map((e) => e.toJson()).toList(),
    };
    if (goalId != null) {
      data['goal_id'] = goalId;
    }
    return data;
  }

  factory SipReqModel.fromJson(Map<String, dynamic> json) {
    return SipReqModel(
      goalId: json['goal_id'],
      funds:
          (json['funds'] as List<dynamic>?)
              ?.map((e) => SipFundItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
