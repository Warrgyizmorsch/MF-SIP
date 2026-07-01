// features/kyc/data/model/add_bank_model.dart

import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

class AddBankResponseModel {
  final bool? success;
  final String? message;
  final AddBankDataModel? data;

  AddBankResponseModel({this.success, this.message, this.data});

  factory AddBankResponseModel.fromJson(Map<String, dynamic> json) {
    return AddBankResponseModel(
      success: json.parse<bool>('success'),
      message: json.parse<String>('message'),
      data: json['data'] != null
          ? AddBankDataModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class AddBankDataModel {
  final AddedBankModel? bank;
  final int? count;
  final int? maxAllowed;

  AddBankDataModel({this.bank, this.count, this.maxAllowed});

  factory AddBankDataModel.fromJson(Map<String, dynamic> json) {
    return AddBankDataModel(
      bank: json['bank'] != null
          ? AddedBankModel.fromJson(json['bank'] as Map<String, dynamic>)
          : null,
      count: json.parse<int>('count'),
      maxAllowed: json.parse<int>('max_allowed'),
    );
  }
}

class AddedBankModel {
  final int? id;
  final int? uid;
  final String? accountHolderName;
  final String? accountNumber;
  final String? ifscCode;
  final String? micrCode;
  final String? accountType;
  final String? bankName;
  final bool? verified;
  final String? verifiedAt;
  final String? createdAt;
  final String? updatedAt;

  AddedBankModel({
    this.id,
    this.uid,
    this.accountHolderName,
    this.accountNumber,
    this.ifscCode,
    this.micrCode,
    this.accountType,
    this.bankName,
    this.verified,
    this.verifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory AddedBankModel.fromJson(Map<String, dynamic> json) {
    return AddedBankModel(
      id: json.parse<int>('id'),
      uid: json.parse<int>('uid'),
      accountHolderName: json.parse<String>('account_holder_name'),
      accountNumber: json.parse<String>('account_number'),
      ifscCode: json.parse<String>('ifsc_code'),
      micrCode: json.parse<String>('micr_code'),
      accountType: json.parse<String>('account_type'),
      bankName: json.parse<String>('bank_name'),
      verified: json.parse<bool>('verified'),
      verifiedAt: json.parse<String>('verified_at'),
      createdAt: json.parse<String>('created_at'),
      updatedAt: json.parse<String>('updated_at'),
    );
  }
}