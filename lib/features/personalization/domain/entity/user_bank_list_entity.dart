import 'package:equatable/equatable.dart';
import 'package:my_sip/features/personalization/domain/entity/profile_update_entity.dart';

class UserBankListEntity extends Equatable {
  final bool success;
  final String message;
  final bool isNct;
  final String nctStatus;
  final String nctRefNo;
  final String nctUniqId;
  final bool canCheckStatus;
  final int uid;
  final List<BankAccountEntity> banks;
  final int count;
  final int maxAllowed;
  final bool canAddMore;

  const UserBankListEntity({
    required this.success,
    required this.message,
    required this.isNct,
    required this.nctStatus,
    required this.nctRefNo,
    required this.nctUniqId,
    required this.canCheckStatus,
    required this.uid,
    required this.banks,
    required this.count,
    required this.maxAllowed,
    required this.canAddMore,
  });

  bool get hasPendingNct =>
      (nctStatus.toLowerCase() == 'pending') ||
      banks.any((b) => b.isPendingValidation);

  @override
  List<Object?> get props => [
        success,
        message,
        isNct,
        nctStatus,
        nctRefNo,
        nctUniqId,
        canCheckStatus,
        uid,
        banks,
        count,
        maxAllowed,
        canAddMore,
      ];
}
