import 'package:equatable/equatable.dart';
import 'package:my_sip/features/authentication/data/models/auth_model.dart';

class LoginResponseEntity extends Equatable {
  final String? token;
  final String? message;
  final UserModel userModel;

  const LoginResponseEntity({
    required this.token,
    required this.message,
    required this.userModel,
  });

  @override
  List<Object?> get props => [token, message, userModel];
}

class RegisterResponseEntity extends Equatable {
  final String? token;
  final String? message;
  final UserModel userModel;

  const RegisterResponseEntity({
    required this.token,
    required this.message,
    required this.userModel,
  });

  @override
  List<Object?> get props => [token, message, userModel];
}

class UserEntity extends Equatable {
  final int id;
  final int roleId;
  final String name;
  final String email;
  final String mobile;
  final String? img;
  final String panCard;
  final String? emailVerifiedAt;
  final String? phoneVerifiedAt;
  final String createdAt;
  final String updatedAt;
  final String kycStatus;
  final String? kycVerifiedAt;
  final String status;
  final String? riskSlabId;
  final String? riskScore;
  final String? canNumber;
  final String? canStatus;
  final RiskProfileEntity? riskProfileEntity;
  final CustomerDetailsEntity1? customerDetailsEntity;

  const UserEntity({
    required this.id,
    required this.roleId,
    required this.name,
    required this.email,
    required this.mobile,
    this.img,
    required this.panCard,
    this.emailVerifiedAt,
    this.phoneVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.kycStatus,
    this.kycVerifiedAt,
    required this.status,
    this.riskSlabId,
    this.riskScore,
    this.canNumber,
    this.canStatus,
    this.riskProfileEntity,
    this.customerDetailsEntity,
  });

  @override
  List<Object?> get props => [
    id,
    roleId,
    name,
    email,
    mobile,
    img,
    panCard,
    emailVerifiedAt,
    phoneVerifiedAt,
    createdAt,
    updatedAt,
    kycStatus,
    kycVerifiedAt,
    status,
    riskSlabId,
    canNumber,
    canStatus,
    riskScore,
    riskProfileEntity,
    customerDetailsEntity,
  ];
}

class RiskProfileEntity extends Equatable {
  final int? id;
  final int? minScore;
  final int? maxScore;
  final String? profileName;
  final int? fixesIncomePercent;
  final int? equityPercent;

  const RiskProfileEntity({
    required this.id,
    required this.minScore,
    required this.maxScore,
    required this.profileName,
    required this.fixesIncomePercent,
    required this.equityPercent,
  });

  @override
  List<Object?> get props => [
    id,
    minScore,
    maxScore,
    profileName,
    fixesIncomePercent,
    equityPercent,
  ];
}

extension RiskProfileEntityX on RiskProfileModel {
  RiskProfileEntity toEntity() {
    return RiskProfileEntity(
      id: id,
      minScore: minScore,
      maxScore: maxScore,
      profileName: profileName,
      fixesIncomePercent: fixesIncomePercent,
      equityPercent: equityPercent,
    );
  }
}

extension LoginResponseEntityx on LoginResponseModel {
  LoginResponseEntity toEntity() {
    return LoginResponseEntity(
      token: token,
      message: message,
      userModel: userModel,
    );
  }
}

extension RegisterResponseModelx on RegisterResponseModel {
  RegisterResponseEntity toEntity() {
    return RegisterResponseEntity(
      token: token,
      message: message,
      userModel: userModel,
    );
  }
}

extension UserModelx on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      id: id ?? 0,
      roleId: roleId ?? 0,
      name: name ?? '',
      email: email ?? '',
      mobile: mobile ?? '',
      img: img,
      panCard: panCard ?? '',
      emailVerifiedAt: emailVerifiedAt,
      phoneVerifiedAt: phoneVerifiedAt,
      createdAt: createdAt ?? '',
      updatedAt: updatedAt ?? '',
      kycStatus: kycStatus ?? 'NOT_STARTED',
      kycVerifiedAt: kycVerifiedAt,
      status: status ?? 'inactive',
      riskSlabId: riskSlabId ?? '',
      canNumber: canNumber,
      canStatus: canStatus,

      riskProfileEntity: riskProfileModel?.toEntity(),
      customerDetailsEntity: customerDetailsModel?.toEntity(),
    );
  }
}

class CustomerDetailsEntity1 extends Equatable {
  final int? id;
  final int? userId;
  final String? dob;
  final String? wealthSource;
  final String? ageGroup;
  final String? riskAppetite;
  final String? yearlyIncome;
  final String? occupation;
  final String? adhar;
  final String? address;
  final String? updatedAt;
  final String? createdAt;

  const CustomerDetailsEntity1({
    required this.id,
    required this.userId,
    required this.dob,
    required this.wealthSource,
    required this.ageGroup,
    required this.occupation,
    required this.riskAppetite,
    required this.yearlyIncome,
    required this.adhar,
    required this.address,
    required this.updatedAt,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    dob,
    wealthSource,
    ageGroup,
    riskAppetite,
    yearlyIncome,
    adhar,
    address,
    updatedAt,
    createdAt,
    occupation,
  ];
}

extension CustomerDetailsEntityX on CustomerDetailsModel1 {
  CustomerDetailsEntity1 toEntity() {
    return CustomerDetailsEntity1(
      id: id,
      userId: userId,
      dob: dob,
      wealthSource: wealthSource,
      ageGroup: ageGroup,
      riskAppetite: riskAppetite,
      yearlyIncome: yearlyIncome,
      occupation: occupation,
      adhar: adhar,
      address: address,
      updatedAt: updatedAt,
      createdAt: createdAt,
    );
  }
}
