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
  final AmcEntity? amc;

  final int? minSipAmount;
  final int? minLumpsum;
  final List<VariantModelEntity> variants;

  const MutualFundListEntity({
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

  const AmcEntity({
    required this.id,
    required this.amcName,
    required this.amcLogoUrl,
  });

  @override
  List<Object?> get props => [id, amcName, amcLogoUrl];
}

extension AmcEntityX on AmcModel {
  AmcEntity toEntity() {
    return AmcEntity(id: id, amcName: amcName, amcLogoUrl: amcLogoUrl);
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
