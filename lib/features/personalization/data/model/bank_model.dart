import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

class BankListResponseModel {
  final bool?  success;
  final List<BankItemModel> data;

  BankListResponseModel({required this.success, required this.data});

  factory BankListResponseModel.fromJson(Map<String, dynamic> json) {
    return BankListResponseModel(
        success: json.parse<bool>('success'),
        data: json.parseListOf('data', ((e) => BankItemModel.fromJson(e))) ?? [],
    );
  }

}


class BankItemModel {
  final int? id;
  final String? bankName;
  final String? bankLogo;
  final String? shortCode;
  final int? status;

  BankItemModel({required this.id, required this.bankName, required this.bankLogo, required this.shortCode, required this.status});

  factory BankItemModel.fromJson(Map<String, dynamic> json) {
    return BankItemModel(
      id: json.parse<int>('id'),
      bankName: json.parse<String>('bank_name'),
      bankLogo: json.parse<String>('bank_logo'),
      shortCode: json.parse<String>('short_code'),
      status: json.parse<int>('status'),
    );
  }

}