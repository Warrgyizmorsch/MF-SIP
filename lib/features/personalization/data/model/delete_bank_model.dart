
import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

class DeleteBankModel {
  final bool? success;
  final String? message;
  final DeleteBankDataModel? data;

  DeleteBankModel({this.success, this.message, this.data});

  factory DeleteBankModel.fromJson(Map<String, dynamic> json) {
    return DeleteBankModel(
      success: json.parse<bool>('success'),
      message: json.parse<String>('message'),
      data: json['data'] != null
          ? DeleteBankDataModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class DeleteBankDataModel {
  final int? uid;
  final int? bankId;
  final int? count;
  final int? maxAllowed;
  final bool? canAddMore;

  DeleteBankDataModel({
    this.uid,
    this.bankId,
    this.count,
    this.maxAllowed,
    this.canAddMore,
  });

  factory DeleteBankDataModel.fromJson(Map<String, dynamic> json) {
    return DeleteBankDataModel(
      uid: json.parse<int>('uid'),
      bankId: json.parse<int>('bank_id'),
      count: json.parse<int>('count'),
      maxAllowed: json.parse<int>('max_allowed'),
      canAddMore: json.parse<bool>('can_add_more'),
    );
  }
}