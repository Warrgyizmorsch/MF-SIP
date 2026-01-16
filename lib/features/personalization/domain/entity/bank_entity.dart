import 'package:equatable/equatable.dart';
import 'package:my_sip/features/personalization/data/model/bank_model.dart';

class BankResponseListEntity extends Equatable {
  final bool? success;
  final List<BankItemEntity> data;

  const BankResponseListEntity({required this.success, required this.data});

  @override
  // TODO: implement props
  List<Object?> get props =>[
    success,
    data,
  ];

}

extension BankResponseListEntityX on BankListResponseModel {
    BankResponseListEntity toEntity() {
      return BankResponseListEntity(
        success: success,
        data: data.map((e) => e.toEntity()).toList(),
      );
    }
}

class BankItemEntity extends Equatable{
  final int? id;
  final String? bankName;
  final String? bankLogo;
  final String? shortCode;
  final int? status;

  const BankItemEntity({required this.id, required this.bankName, required this.bankLogo, required this.shortCode, required this.status});

  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    bankName,
    bankLogo,
    shortCode,
    status,
  ];
}

extension BankItemEntityX on BankItemModel {
  BankItemEntity toEntity() {
    return BankItemEntity(
      id: id,
      bankName: bankName,
      bankLogo: bankLogo,
      shortCode: shortCode,
      status: status,
    );
  }
}