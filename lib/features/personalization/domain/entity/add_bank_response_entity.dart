// features/kyc/domain/entity/add_bank_entity.dart

import 'package:equatable/equatable.dart';
import 'package:my_sip/features/personalization/data/model/add_bank_response_model.dart';

class AddBankResponseEntity extends Equatable {
  final bool success;
  final String message;
  final AddBankDataEntity? data;

  const AddBankResponseEntity({
    required this.success,
    required this.message,
    this.data,
  });

  @override
  List<Object?> get props => [success, message, data];
}

class AddBankDataEntity extends Equatable {
  final AddedBankEntity? bank;
  final int count;
  final int maxAllowed;

  const AddBankDataEntity({
    required this.bank,
    required this.count,
    required this.maxAllowed,
  });

  bool get canAddMoreBanks => count < maxAllowed;

  @override
  List<Object?> get props => [bank, count, maxAllowed];
}

class AddedBankEntity extends Equatable {
  final int id;
  final int uid;
  final String accountHolderName;
  final String accountNumber;
  final String ifscCode;
  final String micrCode;
  final String accountType;
  final String bankName;
  final bool verified;
  final String verifiedAt;
  final String createdAt;

  const AddedBankEntity({
    required this.id,
    required this.uid,
    required this.accountHolderName,
    required this.accountNumber,
    required this.ifscCode,
    required this.micrCode,
    required this.accountType,
    required this.bankName,
    required this.verified,
    required this.verifiedAt,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        uid,
        accountHolderName,
        accountNumber,
        ifscCode,
        micrCode,
        accountType,
        bankName,
        verified,
        verifiedAt,
        createdAt,
      ];
}

// ─── Mappers ──────────────────────────────────────────────────────────────────

extension AddBankResponseMapper on AddBankResponseModel {
  AddBankResponseEntity toEntity() {
    return AddBankResponseEntity(
      success: success ?? false,
      message: message ?? '',
      data: data?.toEntity(),
    );
  }
}

extension AddBankDataMapper on AddBankDataModel {
  AddBankDataEntity toEntity() {
    return AddBankDataEntity(
      bank: bank?.toEntity(),
      count: count ?? 0,
      maxAllowed: maxAllowed ?? 3,
    );
  }
}

extension AddedBankMapper on AddedBankModel {
  AddedBankEntity toEntity() {
    return AddedBankEntity(
      id: id ?? 0,
      uid: uid ?? 0,
      accountHolderName: accountHolderName ?? '',
      accountNumber: accountNumber ?? '',
      ifscCode: ifscCode ?? '',
      micrCode: micrCode ?? '',
      accountType: accountType ?? '',
      bankName: bankName ?? '',
      verified: verified ?? false,
      verifiedAt: verifiedAt ?? '',
      createdAt: createdAt ?? '',
    );
  }
}