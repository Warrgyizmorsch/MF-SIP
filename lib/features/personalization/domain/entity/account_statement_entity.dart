// features/mfu/domain/entity/account_statement_entity.dart

import 'package:equatable/equatable.dart';
import 'package:my_sip/features/personalization/data/model/account_statement_model.dart';

class AccountStatementEntity extends Equatable {
  final bool success;
  final String message;
  final String type;
  final bool emailSent;
  final String emailTo;
  final String downloadUrl;
  final int expiresInMinutes;

  const AccountStatementEntity({
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

extension AccountStatementMapper on AccountStatementModel {
  AccountStatementEntity toEntity() {
    return AccountStatementEntity(
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