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
  final String? address;
  final String? contactNo;
  final String? email;
  final String? websiteUrl;
  final String? status;
  final String? createdAt;
  final String? mfuAmcCode;
  final String? amcLogoUrl;

  String? get amcLogoURl => amcLogoUrl;

  FundHouseItemModel({
    required this.id,
    required this.amcCode,
    required this.amcName,
    required this.amcLogo,
    this.address,
    this.contactNo,
    this.email,
    this.websiteUrl,
    required this.status,
    required this.createdAt,
    this.mfuAmcCode,
    this.amcLogoUrl,
  });

  factory FundHouseItemModel.fromJson(Map<String, dynamic> json) {
    return FundHouseItemModel(
      id: json.parse<int>('id'),
      amcCode: json.parse<String>('amc_code'),
      amcName: json.parse<String>('amc_name'),
      amcLogo: json.parse<String>('amc_logo'),
      address: json.parse<String>('address'),
      contactNo: json.parse<String>('contact_no'),
      email: json.parse<String>('email'),
      websiteUrl: json.parse<String>('website_url'),
      status: json.parse<dynamic>('status')?.toString(),
      createdAt: json.parse<String>('created_at'),
      mfuAmcCode: json.parse<String>('mfu_amc_code'),
      amcLogoUrl: json.parse<String>('amc_logo_url'),
    );
  }
}
