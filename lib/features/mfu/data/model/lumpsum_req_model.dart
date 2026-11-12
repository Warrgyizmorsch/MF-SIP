import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

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
  final List<LumpsumFundItemModel>? funds;
  final dynamic goalId;
  final int? bankId;
  final String? paymentType;
  final String? schemeCode;
  final num? amount;
  final String? folio;

  LumpsumReqModel({
    this.funds,
    this.goalId,
    this.bankId,
    this.paymentType,
    this.schemeCode,
    this.amount,
    this.folio,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (bankId != null) {
      data['bank_id'] = bankId;
    }
    if (paymentType != null && paymentType!.isNotEmpty) {
      data['payment_type'] = paymentType;
    }
    if (goalId != null) {
      data['goal_id'] = goalId;
    }

    if (funds != null && funds!.isNotEmpty) {
      if (funds!.length == 1 && (schemeCode == null || schemeCode!.isEmpty)) {
        // Single fund support matching POST /api/v1/invest/lumpsum
        final single = funds!.first;
        data['scheme_code'] = single.schemeCode;
        data['amount'] = single.amount;
        data['folio'] = single.folio;
        if (single.devopt != null) data['devopt'] = single.devopt;
      } else {
        // Multiple funds support
        data['funds'] = funds!.map((e) => e.toJson()).toList();
      }
    } else if (schemeCode != null && schemeCode!.isNotEmpty) {
      data['scheme_code'] = schemeCode;
      data['amount'] = amount ?? 0;
      data['folio'] = folio ?? 'NEW';
    }

    return data;
  }

  factory LumpsumReqModel.fromJson(Map<String, dynamic> json) {
    return LumpsumReqModel(
      goalId: json['goal_id'],
      bankId: json.parse<int>('bank_id'),
      paymentType: json.parse<String>('payment_type'),
      schemeCode: json.parse<String>('scheme_code'),
      amount: json.parse<num>('amount'),
      folio: json.parse<String>('folio'),
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
