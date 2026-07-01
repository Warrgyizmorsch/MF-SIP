// import 'dart:convert';

// import 'package:my_sip/core/utils/helper/custom_json_parser.dart';
// class OnboardingResponse {
//   final bool? success;
//   final String? message;
//   final UserDetails? userDetails;
//   final String? onboardingId;
//   final String? sessionToken;
//   final DbRecord? dbRecord;

//   OnboardingResponse({
//     this.success,
//     this.message,
//     this.userDetails,
//     this.onboardingId,
//     this.sessionToken,
//     this.dbRecord,
//   });

//   factory OnboardingResponse.fromJson(Map<String, dynamic> json) {
//     return OnboardingResponse(
//       success: json.parse<bool>('success'),
//       message: json.parse<String>('message'),
//       onboardingId: json.parse<String>('onboarding_id'),
//       sessionToken: json.parse<String>('session_token'),
//       userDetails: json.parseNested<UserDetails>(
//         'user_details',
//         (map) => UserDetails.fromJson(map),
//       ),
//       dbRecord: json.parseNested<DbRecord>(
//         'db_record',
//         (map) => DbRecord.fromJson(map),
//       ),
//     );
//   }
// }

// class UserDetails {
//   final String? name;
//   final String? username;

//   UserDetails({this.name, this.username});

//   factory UserDetails.fromJson(Map<String, dynamic> json) {
//     return UserDetails(
//       name: json.parse<String>('name'),
//       username: json.parse<String>('username'),
//     );
//   }
// }

// class DbRecord {
//   final int? id;
//   final int? userId;
//   final String? onboardingId;
//   final String? signzyUserId;
//   final String? username;
//   final String? password;
//   final String? channelId;
//   final String? sessionToken;
//   final String? createdAt;

//   DbRecord({
//     this.id,
//     this.userId,
//     this.onboardingId,
//     this.signzyUserId,
//     this.username,
//     this.password,
//     this.channelId,
//     this.sessionToken,
//     this.createdAt,
//   });

//   factory DbRecord.fromJson(Map<String, dynamic> json) {
//     return DbRecord(
//       id: json.parse<int>('id'),
//       userId: json.parse<int>('user_id'),
//       onboardingId: json.parse<String>('onboarding_id'),
//       signzyUserId: json.parse<String>('signzy_user_id'),
//       username: json.parse<String>('username'),
//       password: json.parse<String>('password'),
//       channelId: json.parse<String>('channel_id'),
//       sessionToken: json.parse<String>('session_token'),
//       createdAt: json.parse<String>('created_at'),
//     );
//   }
// }


import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

class OnboardingResponse {
  final bool? success;
  final String? message;
  final UserDetails? userDetails;
  final String? onboardingId;
  final String? sessionToken;
  final DbRecord? dbRecord;

  OnboardingResponse({
    this.success,
    this.message,
    this.userDetails,
    this.onboardingId,
    this.sessionToken,
    this.dbRecord,
  });

  factory OnboardingResponse.fromJson(Map<String, dynamic> json) {
    return OnboardingResponse(
      success: json.parse<bool>('success'),
      message: json.parse<String>('message'),
      onboardingId: json.parse<String>('onboarding_id'),
      sessionToken: json.parse<String>('session_token'),
      userDetails: json.parseNested<UserDetails>(
        'user_details',
        (map) => UserDetails.fromJson(map),
      ),
      dbRecord: json.parseNested<DbRecord>(
        'db_record',
        (map) => DbRecord.fromJson(map),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'user_details': userDetails?.toJson(),
      'onboarding_id': onboardingId,
      'session_token': sessionToken,
      'db_record': dbRecord?.toJson(),
    };
  }
}

class UserDetails {
  final String? name;
  final String? username;

  UserDetails({this.name, this.username});

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      name: json.parse<String>('name'),
      username: json.parse<String>('username'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
    };
  }
}

class DbRecord {
  final int? id;
  final int? userId;
  final String? onboardingId;
  final String? signzyUserId;
  final String? username;
  final String? password;
  final String? channelId;
  final String? sessionToken;
  final String? createdAt;

  DbRecord({
    this.id,
    this.userId,
    this.onboardingId,
    this.signzyUserId,
    this.username,
    this.password,
    this.channelId,
    this.sessionToken,
    this.createdAt,
  });

  factory DbRecord.fromJson(Map<String, dynamic> json) {
    return DbRecord(
      id: json.parse<int>('id'),
      userId: json.parse<int>('user_id'),
      onboardingId: json.parse<String>('onboarding_id'),
      signzyUserId: json.parse<String>('signzy_user_id'),
      username: json.parse<String>('username'),
      password: json.parse<String>('password'),
      channelId: json.parse<String>('channel_id'),
      sessionToken: json.parse<String>('session_token'),
      createdAt: json.parse<String>('created_at'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'onboarding_id': onboardingId,
      'signzy_user_id': signzyUserId,
      'username': username,
      'password': password,
      'channel_id': channelId,
      'session_token': sessionToken,
      'created_at': createdAt,
    };
  }
}