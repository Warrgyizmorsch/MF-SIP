import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

class ProfileUpdateModel {
  final bool? status;
  final String? message;
  final ProfileDataModel? data;

  ProfileUpdateModel({
    this.status,
    this.message,
    this.data,
  });

  factory ProfileUpdateModel.fromJson(Map<String, dynamic> json) {
    return ProfileUpdateModel(
      status: json.parse<bool>('status'),
      message: json.parse<String>('message'),
      data: json.parseNested<ProfileDataModel>(
        'data',
        (m) => ProfileDataModel.fromJson(m),
      ),
    );
  }
}

class ProfileDataModel {
  final int? id;
  final int? roleId;
  final String? name;
  final String? email;
  final String? mobile;
  final String? image;
  final String? panCard;
  final String? emailVerifiedAt;
  final String? phoneVerifiedAt;
  final String? createdAt;
  final String? updatedAt;
  final String? kycStatus;
  final String? kycVerifiedAt;
  final String? status;
  final int? riskSlabId;
  final String? riskProfile;
  final CustomerDetailsModel? customerDetails;

  ProfileDataModel({
    this.id,
    this.roleId,
    this.name,
    this.email,
    this.mobile,
    this.image,
    this.panCard,
    this.emailVerifiedAt,
    this.phoneVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.kycStatus,
    this.kycVerifiedAt,
    this.status,
    this.riskSlabId,
    this.riskProfile,
    this.customerDetails,
  });

  factory ProfileDataModel.fromJson(Map<String, dynamic> json) {
    return ProfileDataModel(
      id: json.parse<int>('id'),
      roleId: json.parse<int>('role_id'),
      name: json.parse<String>('name'),
      email: json.parse<String>('email'),
      mobile: json.parse<String>('mobile'),
      image: json.parse<String>('image'),
      panCard: json.parse<String>('pan_card'),
      emailVerifiedAt: json.parse<String>('email_verified_at'),
      phoneVerifiedAt: json.parse<String>('phone_verified_at'),
      createdAt: json.parse<String>('created_at'),
      updatedAt: json.parse<String>('updated_at'),
      kycStatus: json.parse<String>('kyc_status'),
      kycVerifiedAt: json.parse<String>('kyc_verified_at'),
      status: json.parse<String>('status'),
      riskSlabId: json.parse<int>('risk_slab_id'),
      riskProfile: json.parse<String>('risk_profile'),
      customerDetails: json.parseNested<CustomerDetailsModel>(
        'customer_details',
        (m) => CustomerDetailsModel.fromJson(m),
      ),
    );
  }
}

class CustomerDetailsModel {
  final int? id;
  final int? userId;
  final String? dob;
  final String? wealthSource;
  final String? ageGroup;
  final String? riskAppetite;
  final String? yearlyIncome;
  final String? adhar;
  final String? address;
  final String? updatedAt;
  final String? createdAt;

  CustomerDetailsModel({
    this.id,
    this.userId,
    this.dob,
    this.wealthSource,
    this.ageGroup,
    this.riskAppetite,
    this.yearlyIncome,
    this.adhar,
    this.address,
    this.updatedAt,
    this.createdAt,
  });

  factory CustomerDetailsModel.fromJson(Map<String, dynamic> json) {
    return CustomerDetailsModel(
      id: json.parse<int>('id'),
      userId: json.parse<int>('user_id'),
      dob: json.parse<String>('dob'),
      wealthSource: json.parse<String>('wealth_source'),
      ageGroup: json.parse<String>('age_group'),
      riskAppetite: json.parse<String>('risk_appetite'),
      yearlyIncome: json.parse<String>('yearly_income'),
      adhar: json.parse<String>('adhar'),
      address: json.parse<String>('address'),
      updatedAt: json.parse<String>('updated_at'),
      createdAt: json.parse<String>('created_at'),
    );
  }
}