
import 'package:equatable/equatable.dart';
import 'package:my_sip/features/personalization/data/model/capital_gain_statement_model.dart';

class CapitalGainStatementEntity extends Equatable {
  final bool success;
  final String message;
  final String type;
  final bool emailSent;
  final String emailTo;
  final String downloadUrl;
  final int expiresInMinutes;

  const CapitalGainStatementEntity({
    required this.success,
    required this.message,
    required this.type,
    required this.emailSent,
    required this.emailTo,
    required this.downloadUrl,
    required this.expiresInMinutes,
  });

  // Helper getters
  bool get isEmail => type.toLowerCase() == 'email';
  bool get isDownload => type.toLowerCase() == 'download';

  @override
  List<Object?> get props => [
        success, 
        message, 
        type, 
        emailSent, 
        emailTo, 
        downloadUrl, 
        expiresInMinutes,
      ];
}

// ─── Mappers ──────────────────────────────────────────────────────────────────

extension CapitalGainStatementMapper on CapitalGainStatementModel {
  CapitalGainStatementEntity toEntity() {
    return CapitalGainStatementEntity(
      success: success ?? false,
      message: message ?? '',
      type: type ?? '',
      emailSent: emailSent ?? false,
      emailTo: emailTo ?? '',
      downloadUrl: downloadUrl ?? '',
      expiresInMinutes: expiresInMinutes ?? 0,
    );
  }
}