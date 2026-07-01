import 'package:equatable/equatable.dart';
import 'package:my_sip/features/personalization/data/model/delete_bank_model.dart';

class DeleteBankEntity extends Equatable {
  final bool success;
  final String message;
  final DeleteBankDataEntity? data;

  const DeleteBankEntity({
    required this.success,
    required this.message,
    this.data,
  });

  @override
  List<Object?> get props => [success, message, data];
}

class DeleteBankDataEntity extends Equatable {
  final int uid;
  final int bankId;
  final int count;
  final int maxAllowed;
  final bool canAddMore;

  const DeleteBankDataEntity({
    required this.uid,
    required this.bankId,
    required this.count,
    required this.maxAllowed,
    required this.canAddMore,
  });

  @override
  List<Object?> get props => [uid, bankId, count, maxAllowed, canAddMore];
}

// ─── Mappers ──────────────────────────────────────────────────────────────────

extension DeleteBankMapper on DeleteBankModel {
  DeleteBankEntity toEntity() {
    return DeleteBankEntity(
      success: success ?? false,
      message: message ?? '',
      data: data?.toEntity(),
    );
  }
}

extension DeleteBankDataMapper on DeleteBankDataModel {
  DeleteBankDataEntity toEntity() {
    return DeleteBankDataEntity(
      uid: uid ?? 0,
      bankId: bankId ?? 0,
      count: count ?? 0,
      maxAllowed: maxAllowed ?? 0,
      canAddMore: canAddMore ?? false,
    );
  }
}
