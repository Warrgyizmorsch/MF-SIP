import 'package:equatable/equatable.dart';
import 'package:my_sip/features/kyc/data/model/verify_bank_account_model.dart';

class VerifyAmountEntity extends Equatable {
  final String amountMatch;
  final String ownerName;

  const VerifyAmountEntity({
    required this.amountMatch,
    required this.ownerName,
  });

  @override
  List<Object?> get props => [amountMatch, ownerName];
}

extension VerifyAmountModelMapper on VerifyAmountModel {
  VerifyAmountEntity toEntity() {
    return VerifyAmountEntity(amountMatch: amountMatch, ownerName: ownerName);
  }
}
