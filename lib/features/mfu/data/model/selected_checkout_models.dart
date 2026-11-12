import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

class SelectedBankModel {
  final int? id;
  final String? bankName;
  final String? accountNumberMasked;
  final String? ifscCode;
  final String? accountType;
  final String? payMode;

  SelectedBankModel({
    this.id,
    this.bankName,
    this.accountNumberMasked,
    this.ifscCode,
    this.accountType,
    this.payMode,
  });

  factory SelectedBankModel.fromJson(Map<String, dynamic> json) {
    return SelectedBankModel(
      id: json.parse<int>('id'),
      bankName: json.parse<String>('bank_name'),
      accountNumberMasked: json.parse<String>('account_number_masked'),
      ifscCode: json.parse<String>('ifsc_code'),
      accountType: json.parse<String>('account_type'),
      payMode: json.parse<String>('pay_mode'),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'bank_name': bankName,
    'account_number_masked': accountNumberMasked,
    'ifsc_code': ifscCode,
    'account_type': accountType,
    'pay_mode': payMode,
  };
}

class SelectedMandateModel {
  final int? id;
  final String? mandateRef;
  final String? mandateMode;
  final String? status;
  final String? aggrStatus;

  SelectedMandateModel({
    this.id,
    this.mandateRef,
    this.mandateMode,
    this.status,
    this.aggrStatus,
  });

  factory SelectedMandateModel.fromJson(Map<String, dynamic> json) {
    return SelectedMandateModel(
      id: json.parse<int>('id'),
      mandateRef:
          json.parse<String>('mandate_ref') ??
          json.parse<String>('aumrn') ??
          json.parse<String>('mumrn') ??
          json.parse<String>('mmrn'),
      mandateMode: json.parse<String>('mandate_mode'),
      status: json.parse<String>('status'),
      aggrStatus: json.parse<String>('aggr_status'),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'mandate_ref': mandateRef,
    'mandate_mode': mandateMode,
    'status': status,
    'aggr_status': aggrStatus,
  };
}
