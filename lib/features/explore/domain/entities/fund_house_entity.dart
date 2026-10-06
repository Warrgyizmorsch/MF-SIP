// ignore_for_file: invalid_null_aware_operator

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
  final String? address;
  final String? contactNo;
  final String? email;
  final String? websiteUrl;
  final String? status;
  final String? createdAt;
  final String? mfuAmcCode;
  final String? amcLogoUrl;

  String? get amcLogoURl => amcLogoUrl;

  const FundHouseItemEntity({
    required this.id,
    required this.amcCode,
    required this.amcName,
    required this.amcLogo,
    this.address,
    this.contactNo,
    this.email,
    this.websiteUrl,
    required this.status,
    required this.createdAt,
    this.mfuAmcCode,
    this.amcLogoUrl,
  });

  @override
  List<Object?> get props => [
    id,
    amcCode,
    amcName,
    amcLogo,
    address,
    contactNo,
    email,
    websiteUrl,
    status,
    createdAt,
    mfuAmcCode,
    amcLogoUrl,
  ];
}

extension FundHouseEntityx on FundHouseItemModel {
  FundHouseItemEntity toEntity() {
    return FundHouseItemEntity(
      id: id,
      amcCode: amcCode,
      amcName: amcName,
      amcLogo: amcLogo,
      address: address,
      contactNo: contactNo,
      email: email,
      websiteUrl: websiteUrl,
      status: status,
      createdAt: createdAt,
      mfuAmcCode: mfuAmcCode,
      amcLogoUrl: amcLogoUrl,
    );
  }
}
