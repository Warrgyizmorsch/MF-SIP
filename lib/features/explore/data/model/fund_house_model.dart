import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

class FundHouseResponseModel {
  final bool? success;
  final List<FundHouseItemModel> data;

  FundHouseResponseModel({required this.success, required this.data});

  factory FundHouseResponseModel.fromJson(Map<String, dynamic> json) {
    return FundHouseResponseModel(
      success: json.parse<bool>('success'),
      data:
          json.parseListOf('data', ((e) => FundHouseItemModel.fromJson(e))) ??
          [],
    );
  }
}

class FundHouseItemModel {
  final int? id;
  final String? amcCode;
  final String? amcName;
  final String? amcLogo;
  final int? status;
  final String? createdAt;
  final String? amcLogoURl;

  FundHouseItemModel({
    required this.id,
    required this.amcCode,
    required this.amcName,
    required this.amcLogo,
    required this.status,
    required this.createdAt,
    required this.amcLogoURl,
  });

  factory FundHouseItemModel.fromJson(Map<String, dynamic> json) {
    return FundHouseItemModel(
      id: json.parse<int>('id'),
      amcCode: json.parse<String>('amc_code'),
      amcName: json.parse<String>('amc_name'),
      amcLogo: json.parse<String>('amc_logo'),
      // status: json.parse<int>('status'),
      status: int.tryParse(json.parse<String>('status') ?? ''),
      createdAt: json.parse<String>('created_at'),
      amcLogoURl: json.parse<String>('amc_logo_url'),
    );
  }
}
