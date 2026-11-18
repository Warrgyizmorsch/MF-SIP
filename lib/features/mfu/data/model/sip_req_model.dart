import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

class SipFundItemModel {
  final String schemeCode;
  final num amount;
  final String folio;
  final String frequency;
  final String day;
  final String? devopt;
  final String? endMonth;
  final String? endYear;

  SipFundItemModel({
    required this.schemeCode,
    required this.amount,
    this.folio = 'NEW',
    this.frequency = 'M',
    required this.day,
    this.devopt,
    this.endMonth,
    this.endYear,
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
    if (endMonth != null && endMonth!.isNotEmpty) data['end_month'] = endMonth;
    if (endYear != null && endYear!.isNotEmpty) data['end_year'] = endYear;
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
      endMonth: json['end_month']?.toString(),
      endYear: json['end_year']?.toString(),
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
  final String? endMonth;
  final String? endYear;

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
    this.endMonth,
    this.endYear,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (bankId != null) {
      data['bank_id'] = bankId;
    }
    if (paymentType != null && paymentType!.isNotEmpty) {
      data['payment_type'] = paymentType;
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
    if (endMonth != null && endMonth!.isNotEmpty) {
      data['end_month'] = endMonth;
    }
    if (endYear != null && endYear!.isNotEmpty) {
      data['end_year'] = endYear;
    }

    if (funds != null && funds!.isNotEmpty) {
      // Multiple or single funds array support:
      // When funds array is provided, each fund item carries its own scheme_code,
      // amount, folio, frequency, and sip_day. Root frequency and sip_day are omitted
      // to avoid contradicting individual fund dates and frequencies.
      data['funds'] = funds!.map((e) => e.toJson()).toList();
    } else if (schemeCode != null && schemeCode!.isNotEmpty) {
      // Direct flat single fund support
      data['scheme_code'] = schemeCode;
      data['amount'] = amount ?? 0;
      data['folio'] = folio ?? 'NEW';
      if (frequency != null && frequency!.isNotEmpty) {
        data['frequency'] = frequency;
      }
      if (sipDay != null) {
        data['sip_day'] = int.tryParse(sipDay.toString()) ?? sipDay;
      }
    } else {
      // Fallback for root metadata if neither funds nor schemeCode was passed
      if (frequency != null && frequency!.isNotEmpty) {
        data['frequency'] = frequency;
      }
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
      endMonth: json.parse<String>('end_month'),
      endYear: json.parse<String>('end_year'),
      funds:
          (json['funds'] as List<dynamic>?)
              ?.map((e) => SipFundItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
