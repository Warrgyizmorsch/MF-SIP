import 'package:equatable/equatable.dart';
import 'package:my_sip/features/explore/data/model/fund_house_model.dart';

class FundHouseResponseEntity extends Equatable {
  final bool? success;
  final List<FundHouseItemEntity> data;

  const FundHouseResponseEntity({required this.success, required this.data});

  @override
  List<Object?> get props => [success, data];
}

extension FundHouseResponseEntityX on FundHouseResponseModel {
  FundHouseResponseEntity toEntity() {
    return FundHouseResponseEntity(
      success: success ?? false,
      data: data?.map((e) => e.toEntity()).toList() ?? [ ],
    );
  }
}

class FundHouseItemEntity extends Equatable {
  final int? id;
  final String? amcCode;
  final String? amcName;
  final String? amcLogo;
  final int? status;
  final String? createdAt;
  final String? amcLogoURl;

  const FundHouseItemEntity({
    required this.id,
    required this.amcCode,
    required this.amcName,
    required this.amcLogo,
    required this.status,
    required this.createdAt,
    required this.amcLogoURl,
  });

  @override
  List<Object?> get props => [
    id,
    amcCode,
    amcName,
    amcLogo,
    status,
    createdAt,
    amcLogoURl,
  ];
}

extension FundHouseEntityx on FundHouseItemModel {
  FundHouseItemEntity toEntity() {
    return FundHouseItemEntity(
      id: id,
      amcCode: amcCode,
      amcName: amcName,
      amcLogo: amcLogo,
      status: status,
      createdAt: createdAt,
      amcLogoURl: amcLogoURl,
    );
  }
}
