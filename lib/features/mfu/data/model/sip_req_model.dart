import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

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
      'sip_day': int.tryParse(day) ?? day,
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
      day: json['sip_day']?.toString() ?? json['day']?.toString() ?? '25',
      devopt: json['devopt']?.toString(),
    );
  }
}

class SipReqModel {
  final List<SipFundItemModel>? funds;
  final dynamic goalId;
  final int? bankId;
  final String? paymentType;
  final String? frequency;
  final dynamic sipDay;
  final int? mandateId;
  final String? mandateRefNo;
  final String? schemeCode;
  final num? amount;
  final String? folio;

  SipReqModel({
    this.funds,
    this.goalId,
    this.bankId,
    this.paymentType,
    this.frequency,
    this.sipDay,
    this.mandateId,
    this.mandateRefNo,
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
    if (frequency != null && frequency!.isNotEmpty) {
      data['frequency'] = frequency;
    }
    if (sipDay != null) {
      data['sip_day'] = int.tryParse(sipDay.toString()) ?? sipDay;
    }
    if (mandateId != null) {
      data['mandate_id'] = mandateId;
    }
    if (mandateRefNo != null && mandateRefNo!.isNotEmpty) {
      data['mandate_ref_no'] = mandateRefNo;
    }
    if (goalId != null) {
      data['goal_id'] = goalId;
    }

    if (funds != null && funds!.isNotEmpty) {
      if (funds!.length == 1 && (schemeCode == null || schemeCode!.isEmpty)) {
        // Single fund support matching POST /api/v1/invest/sip
        final single = funds!.first;
        data['scheme_code'] = single.schemeCode;
        data['amount'] = single.amount;
        data['folio'] = single.folio;
        data['frequency'] = single.frequency;
        data['sip_day'] = int.tryParse(single.day) ?? single.day;
        if (single.devopt != null) data['devopt'] = single.devopt;
      } else {
        // Multiple funds support
        data['funds'] = funds!.map((e) => e.toJson()).toList();
      }
    } else if (schemeCode != null && schemeCode!.isNotEmpty) {
      data['scheme_code'] = schemeCode;
      data['amount'] = amount ?? 0;
      data['folio'] = folio ?? 'NEW';
      if (frequency != null) data['frequency'] = frequency;
      if (sipDay != null) {
        data['sip_day'] = int.tryParse(sipDay.toString()) ?? sipDay;
      }
    }

    return data;
  }

  factory SipReqModel.fromJson(Map<String, dynamic> json) {
    return SipReqModel(
      goalId: json['goal_id'],
      bankId: json.parse<int>('bank_id'),
      paymentType: json.parse<String>('payment_type'),
      frequency: json.parse<String>('frequency'),
      sipDay: json['sip_day'],
      mandateId: json.parse<int>('mandate_id'),
      mandateRefNo: json.parse<String>('mandate_ref_no'),
      schemeCode: json.parse<String>('scheme_code'),
      amount: json.parse<num>('amount'),
      folio: json.parse<String>('folio'),
      funds:
          (json['funds'] as List<dynamic>?)
              ?.map((e) => SipFundItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
