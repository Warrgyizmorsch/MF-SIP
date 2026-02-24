import 'package:equatable/equatable.dart';
import 'package:my_sip/features/explore/data/model/mutual_fund_list_model.dart';

class MutualFundListResponseEntity extends Equatable {
  final bool? success;
  final List<MutualFundListEntity> data;
  final PaginationModelEntity? pagination;

  const MutualFundListResponseEntity({
    required this.success,
    required this.data,
    this.pagination,
  });
  @override
  List<Object?> get props => [success, data, pagination];
}

extension MutualFundListResponseEntityX on MutualFundListResponseModel {
  MutualFundListResponseEntity toEntity() {
    return MutualFundListResponseEntity(
      success: success ?? false,
      data: data.map((e) => e.toEntity()).toList(),
      pagination: pagination?.toEntity(),
    );
  }
}

class MutualFundListEntity extends Equatable {
  final String? baseSchemeName;
  final String? schemeType;
  final String? riskLevel;
  final String? isin;
  final String? schemeCode;
  final AmcEntity? amc;
  final ReturnsEntity? returnsEntity;

  final int? minSipAmount;
  final int? minLumpsum;
  final List<VariantModelEntity> variants;

  const MutualFundListEntity({
    required this.returnsEntity,
    required this.schemeCode,

    required this.baseSchemeName,
    required this.schemeType,
    required this.riskLevel,
    required this.isin,
    required this.amc,
    required this.minSipAmount,
    required this.minLumpsum,
    required this.variants,
  });

  @override
  List<Object?> get props => [
    returnsEntity,
    baseSchemeName,
    schemeType,
    riskLevel,
    isin,
    amc,
    minSipAmount,
    minLumpsum,
    variants,
  ];
}

extension MutualFundListEntityX on MutualFundListModel {
  MutualFundListEntity toEntity() {
    return MutualFundListEntity(
      returnsEntity: returns?.toEntity(),
      schemeCode: schemeCode,
      baseSchemeName: baseSchemeName,
      schemeType: schemeType,
      riskLevel: riskLevel,
      isin: isin,
      amc: amc?.toEntity(),
      minSipAmount: minSipAmount,
      minLumpsum: minLumpsum,
      variants: variants.map((e) => e.toEntity()).toList(),
    );
  }
}

class AmcEntity extends Equatable {
  final int? id;
  final String? amcName;
  final String? amcLogoUrl;
  final String? email;
  final String? contact;
  final String? address;

  const AmcEntity({
    required this.id,
    required this.amcName,
    required this.amcLogoUrl,
    this.email,
    this.contact,
    this.address,
  });

  @override
  List<Object?> get props => [id, amcName, amcLogoUrl, email, contact, address];
}

extension AmcEntityX on AmcModel {
  AmcEntity toEntity() {
    return AmcEntity(
      id: id,
      amcName: amcName,
      amcLogoUrl: amcLogoUrl,
      email: email,
      contact: contact,
      address: address,
    );
  }
}

class VariantModelEntity extends Equatable {
  final int? id;
  final String? schemeCode;
  final String? planType;
  final double? nav;
  final String? navDate;

  const VariantModelEntity({
    required this.id,
    required this.schemeCode,
    required this.planType,
    required this.nav,
    required this.navDate,
  });

  @override
  List<Object?> get props => [id, schemeCode, planType, nav, navDate];
}

extension VariantModelEntityX on VariantModel {
  VariantModelEntity toEntity() {
    return VariantModelEntity(
      id: id,
      schemeCode: schemeCode,
      planType: planType,
      nav: nav,
      navDate: navDate,
    );
  }
}

class ReturnsEntity extends Equatable {
  final String? oneWeek;
  final String? oneMonth;
  final String? oneYear;
  final String? threeYear;
  final String? fiveYear;
  final String? tenYear;
  const ReturnsEntity({
    this.oneWeek,
    this.oneMonth,
    this.oneYear,
    this.threeYear,
    this.fiveYear,
    this.tenYear,
  });
  @override
  List<Object?> get props => [
    oneWeek,
    oneMonth,
    oneYear,
    threeYear,
    fiveYear,
    tenYear,
  ];
}

extension RetunrsModelEntityx on ReturnsModel {
  ReturnsEntity toEntity() {
    return ReturnsEntity(
      oneWeek: oneWeek,
      oneMonth: oneMonth,
      oneYear: oneYear,
      threeYear: threeYear,
      fiveYear: fiveYear,
      tenYear: tenYear,
    );
  }
}

class PaginationModelEntity extends Equatable {
  final int? currentPage;
  final int? perPage;
  final int? total;
  final int? lastPage;
  final bool? hasMore;

  const PaginationModelEntity({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    required this.hasMore,
  });

  @override
  List<Object?> get props => [currentPage, perPage, total, lastPage, hasMore];
}

extension PaginationModelEntityX on PaginationModel {
  PaginationModelEntity toEntity() {
    return PaginationModelEntity(
      currentPage: currentPage,
      perPage: perPage,
      total: total,
      lastPage: lastPage,
      hasMore: hasMore,
    );
  }
}
