
import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

class CapitalGainStatementModel {
  final bool? success;
  final String? message;
  final String? type;
  
  // Email specific fields
  final bool? emailSent;
  final String? emailTo;
  
  // Download specific fields
  final String? downloadUrl;
  final int? expiresInMinutes;

  CapitalGainStatementModel({
    this.success,
    this.message,
    this.type,
    this.emailSent,
    this.emailTo,
    this.downloadUrl,
    this.expiresInMinutes,
  });

  factory CapitalGainStatementModel.fromJson(Map<String, dynamic> json) {
    return CapitalGainStatementModel(
      success: json.parse<bool>('success'),
      message: json.parse<String>('message'),
      type: json.parse<String>('type'),
      emailSent: json.parse<bool>('email_sent'),
      emailTo: json.parse<String>('email_to'),
      downloadUrl: json.parse<String>('download_url'),
      expiresInMinutes: json.parse<int>('expires_in_minutes'),
    );
  }
}