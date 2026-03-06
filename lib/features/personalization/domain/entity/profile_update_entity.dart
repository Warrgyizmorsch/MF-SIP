import 'package:equatable/equatable.dart';
import 'package:my_sip/features/personalization/data/model/profile_update_model.dart';

class ProfileUpdateResponseEntity {
  final bool? status;
  final String? message;
  final ProfileDataEntity? data;

  const ProfileUpdateResponseEntity({
    required this.status,
    required this.message,
    required this.data,
  });

  @override
  List<Object?> get props => [status, message, data];
}

extension ProfileUpdateResponseX on ProfileUpdateModel {
  ProfileUpdateResponseEntity toEntity() {
    return ProfileUpdateResponseEntity(
      status: status,
      message: message,
      data: data?.toEntity(),
    );
  }
}

class ProfileDataEntity extends Equatable {
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
  final CustomerDetailsEntity? customerDetails;

  const ProfileDataEntity({
    required this.id,
    required this.roleId,
    required this.name,
    required this.email,
    required this.mobile,
    required this.image,
    required this.panCard,
    required this.emailVerifiedAt,
    required this.phoneVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.kycStatus,
    required this.kycVerifiedAt,
    required this.status,
    required this.riskSlabId,
    required this.riskProfile,
    required this.customerDetails,
  });

  @override
  List<Object?> get props => [
    id,
    roleId,
    name,
    email,
    mobile,
    image,
    panCard,
    emailVerifiedAt,
    phoneVerifiedAt,
    createdAt,
    updatedAt,
    kycStatus,
    kycVerifiedAt,
    status,
    riskSlabId,
    riskProfile,
    customerDetails,
  ];
}

extension ProfileDataEntityX on ProfileDataModel {
  ProfileDataEntity toEntity() {
    return ProfileDataEntity(
      id: id,
      roleId: roleId,
      name: name,
      email: email,
      mobile: mobile,
      image: image,
      panCard: panCard,
      emailVerifiedAt: emailVerifiedAt,
      phoneVerifiedAt: phoneVerifiedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      kycStatus: kycStatus,
      kycVerifiedAt: kycVerifiedAt,
      status: status,
      riskSlabId: riskSlabId,
      riskProfile: riskProfile,
      customerDetails: customerDetails?.toEntity(),
    );
  }
}

class CustomerDetailsEntity extends Equatable {
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

  const CustomerDetailsEntity({
    required this.id,
    required this.userId,
    required this.dob,
    required this.wealthSource,
    required this.ageGroup,
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
  ];
}

extension CustomerDetailsEntityX on CustomerDetailsModel {
  CustomerDetailsEntity toEntity() {
    return CustomerDetailsEntity(
      id: id,
      userId: userId,
      dob: dob,
      wealthSource: wealthSource,
      ageGroup: ageGroup,
      riskAppetite: riskAppetite,
      yearlyIncome: yearlyIncome,
      adhar: adhar,
      address: address,
      updatedAt: updatedAt,
      createdAt: createdAt,
    );
  }
}
