

import '../../../../core/utils/helper/custom_json_parser.dart';

class LoginResponseModel {
  final bool success;
  final String? token;
  final String? message;
  final UserModel userModel;

  LoginResponseModel({required this.success,required this.token, required this.message, required this.userModel});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json.parse<bool>('success') ?? false,
      token: json.parse('token'),
      message: json.parse<String>('message'),
      userModel: UserModel.fromJson(json['user']),
    );
  }
}

class UserModel {
  final int? id;
  final int? roleId;
  final String? name;
  final String? email;
  final String? mobile;
  final String? panCard;
  final String? emailVerifiedAt;
  final String? phoneVerifiedAt;
  final String? createdAt;
  final String? updatedAt;
  final String? kycStatus;
  final String? kycVerifiedAt;
  final String? status;

  const UserModel({
    this.id,
    this.roleId,
    this.name,
    this.email,
    this.mobile,
    this.panCard,
    this.emailVerifiedAt,
    this.phoneVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.kycStatus,
    this.kycVerifiedAt,
    this.status,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {

    final Map<String, dynamic> userData =
        json.parseNested<Map<String, dynamic>>('user', (data) => data) ?? json;


    return UserModel(
      id: userData.parse<int>('id'),
      roleId: userData.parse<int>('role_id'),
      name: userData.parse<String>('name'),
      email: userData.parse<String>('email'),
      mobile: userData.parse<String>('mobile'),
      panCard: userData.parse<String>('pan_card'),
      emailVerifiedAt: userData.parse<String>('email_verified_at'),
      phoneVerifiedAt: userData.parse<String>('phone_verified_at'),
      createdAt: userData.parse<String>('created_at'),
      updatedAt: userData.parse<String>('updated_at'),
      kycStatus: userData.parse<String>('kyc_status'),
      kycVerifiedAt: userData.parse<String>('kyc_verified_at'),
      status: userData.parse<String>('status'),
    );
  }


}


class RegisterResponseModel {
  final String? token;
  final String? message;
  final UserModel userModel;

  RegisterResponseModel({required this.token, required this.message, required this.userModel});

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      token: json['token'],
      message: json['message'],
      userModel: UserModel.fromJson(json),
    );
  }
}