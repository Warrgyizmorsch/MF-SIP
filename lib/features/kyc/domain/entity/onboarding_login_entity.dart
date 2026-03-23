import 'package:equatable/equatable.dart';
import 'package:my_sip/features/kyc/data/model/onboarding_login_model.dart';

class OnboardingEntity extends Equatable {
  final bool? success;
  final String? message;
  final UserDetailsEntity? userDetails;
  final String? onboardingId;
  final String? sessionToken;
  final DbRecordEntity? dbRecord;

  const OnboardingEntity({
    this.success,
    this.message,
    this.userDetails,
    this.onboardingId,
    this.sessionToken,
    this.dbRecord,
  });

  @override
  List<Object?> get props => [
        success,
        message,
        userDetails,
        onboardingId,
        sessionToken,
        dbRecord,
      ];
}

extension OnboardingEntityX on OnboardingResponse {
  OnboardingEntity toEntity() {
    return OnboardingEntity(
      success: success ?? false,
      message: message,
      onboardingId: onboardingId,
      sessionToken: sessionToken,
      userDetails: userDetails?.toEntity(),
      dbRecord: dbRecord?.toEntity(),
    );
  }
}

class UserDetailsEntity extends Equatable {
  final String? name;
  final String? username;

  const UserDetailsEntity({this.name, this.username});

  @override
  List<Object?> get props => [name, username];
}

extension UserDetailsEntityX on UserDetails {
  UserDetailsEntity toEntity() => UserDetailsEntity(
        name: name,
        username: username,
      );
}

class DbRecordEntity extends Equatable {
  final int? id;
  final String? username;
  final String? sessionToken;
  final String? createdAt;

  const DbRecordEntity({
    this.id,
    this.username,
    this.sessionToken,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, username, sessionToken, createdAt];
}

extension DbRecordEntityX on DbRecord {
  DbRecordEntity toEntity() {
    return DbRecordEntity(
      id: id,
      username: username,
      sessionToken: sessionToken,
      createdAt: createdAt,
    );
  }
}