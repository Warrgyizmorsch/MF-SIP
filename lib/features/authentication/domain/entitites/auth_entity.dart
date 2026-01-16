import 'package:equatable/equatable.dart';
import 'package:my_sip/features/authentication/data/models/auth_model.dart';


class LoginResponseEntity  extends Equatable{
  final String? token;
  final String? message;
  final UserModel userModel;

  const LoginResponseEntity({required this.token, required this.message, required this.userModel});

  @override
  // TODO: implement props
  List<Object?> get props => [
    token, message, userModel
  ];
}



class UserEntity extends Equatable {
  final int id;
  final int roleId;
  final String name;
  final String email;
  final String mobile;
  final String panCard;
  final String? emailVerifiedAt;
  final String? phoneVerifiedAt;
  final String createdAt;
  final String updatedAt;
  final String kycStatus;
  final String? kycVerifiedAt;
  final String status;

  const UserEntity({
    required this.id,
    required this.roleId,
    required this.name,
    required this.email,
    required this.mobile,
    required this.panCard,
    this.emailVerifiedAt,
    this.phoneVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.kycStatus,
    this.kycVerifiedAt,
    required this.status,
  });

  @override
  List<Object?> get props => [
    id, roleId, name, email, mobile, panCard,
    emailVerifiedAt, phoneVerifiedAt, createdAt,
    updatedAt, kycStatus, kycVerifiedAt, status
  ];
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




extension UserModelx on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      id: id ?? 0,
      roleId: roleId ?? 0,
      name: name ?? '',
      email: email ?? '',
      mobile: mobile ?? '',
      panCard: panCard ?? '',
      emailVerifiedAt: emailVerifiedAt,
      phoneVerifiedAt: phoneVerifiedAt,
      createdAt: createdAt ?? '',
      updatedAt: updatedAt ?? '',
      kycStatus: kycStatus ?? 'NOT_STARTED',
      kycVerifiedAt: kycVerifiedAt,
      status: status ?? 'inactive',
    );
  }
}


