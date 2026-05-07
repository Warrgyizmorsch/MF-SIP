import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

class TokenDataModel {
  final bool success;
  final String message;
  final String id;
  final String userId;
  final TokenCredentialModel credentials;

  TokenDataModel({required this.success, required this.message, required this.id, required this.userId, required this.credentials});

  factory TokenDataModel.fromJson(Map<String, dynamic> json) {
    return TokenDataModel(
        success: json.parse<bool>('success') ?? false,
        message: json.parse<String>('message') ?? '',
        id: json.parse<String>('id') ?? '',
        userId: json.parse<String>('userId') ?? '',
        credentials: TokenCredentialModel.fromJson(json['credentials'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'id': id,
      'userId': userId,
      'credentials': credentials.toJson(),
    };
  }

}

class TokenCredentialModel {
  final String username;
  final String password;

  TokenCredentialModel({
    required this.username,
    required this.password,
  });

  factory TokenCredentialModel.fromJson(Map<String, dynamic> json) {
    return TokenCredentialModel(
      username: json.parse<String>('username') ?? '',
      password: json.parse<String>('password') ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}
