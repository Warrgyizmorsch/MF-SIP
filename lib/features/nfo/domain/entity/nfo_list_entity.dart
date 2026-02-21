import 'package:equatable/equatable.dart';
import 'package:my_sip/features/nfo/data/model/nfo_model.dart';

class NfoListEntity extends Equatable {
  final bool? success;
  final String? type;
  final int? count;
  final List<LaunchDataEntity>? data;

  const NfoListEntity({this.success, this.type, this.count, this.data});
  @override
  List<Object?> get props => [success, type, count, data];
}

extension NfoListEntityX on UpcomingLaunchResponse {
  NfoListEntity toEntity() {
    return NfoListEntity(
      success: success,
      type: type,
      count: count,
      data: data?.map((e) => e.toEntity()).toList() ?? [],
    );
  }
}

class LaunchDataEntity extends Equatable {
  final int? id;
  final String? schemeName;
  final int? amcId;
  final String? schemeCode;
  final String? isin;
  final String? baseSchemeName;
  final String? schemeObjective;
  final String? nfoOpenDate;
  final String? nfoCloseDate;
  final String? allotmentDate;
  final String? launchDate;
  final double? nfoPrice;
  final double? minSubscriptionAmount;
  final double? expenseRatio;
  final String? expenseRatioDate;
  final double? aum;
  final String? benchmark;
  final String? fundManager;
  final String? exitLoad;
  final double? nav;
  final String? schemeType;
  final String? planType;
  final String? optionType;
  final String? assetClass;
  final String? schemeCategory;
  final String? riskLevel;
  final String? status;
  final bool? isNfo;
  final bool? isSipAllowed;
  final double? minSipAmount;
  final bool? isLumpsumAllowed;
  final double? minLumpsum;
  final double? minimumTopup;
  final String? createdAt;
  final String? updatedAt;

  const LaunchDataEntity({
    this.id,
    this.schemeName,
    this.amcId,
    this.schemeCode,
    this.isin,
    this.baseSchemeName,
    this.schemeObjective,
    this.nfoOpenDate,
    this.nfoCloseDate,
    this.allotmentDate,
    this.launchDate,
    this.nfoPrice,
    this.minSubscriptionAmount,
    this.expenseRatio,
    this.expenseRatioDate,
    this.aum,
    this.benchmark,
    this.fundManager,
    this.exitLoad,
    this.nav,
    this.schemeType,
    this.planType,
    this.optionType,
    this.assetClass,
    this.schemeCategory,
    this.riskLevel,
    this.status,
    this.isNfo,
    this.isSipAllowed,
    this.minSipAmount,
    this.isLumpsumAllowed,
    this.minLumpsum,
    this.minimumTopup,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    schemeName,
    amcId,
    schemeCode,
    isin,
    baseSchemeName,
    schemeObjective,
    nfoOpenDate,
    nfoCloseDate,
    allotmentDate,
    launchDate,
    nfoPrice,
    minSubscriptionAmount,
    expenseRatio,
    expenseRatioDate,
    aum,
    benchmark,
    fundManager,
    exitLoad,
    nav,
    schemeType,
    planType,
    optionType,
    assetClass,
    schemeCategory,
    riskLevel,
    status,
    isNfo,
    isSipAllowed,
    minSipAmount,
    isLumpsumAllowed,
    minLumpsum,
    minimumTopup,
    createdAt,
    updatedAt,
  ];
}

extension LaunchDataEntityX on LaunchData {
  LaunchDataEntity toEntity() {
    return LaunchDataEntity(
      schemeName: schemeName,
      schemeCode: schemeCode,
      isin: isin,
      baseSchemeName: baseSchemeName,
      schemeObjective: schemeObjective,
      nfoOpenDate: nfoOpenDate,
      nfoCloseDate: nfoCloseDate,
      allotmentDate: allotmentDate,
      launchDate: launchDate,
      nfoPrice: nfoPrice,
      minSubscriptionAmount: minSubscriptionAmount,
      expenseRatio: expenseRatio,
      expenseRatioDate: expenseRatioDate,
      aum: aum,
      benchmark: benchmark,
      fundManager: fundManager,
      exitLoad: exitLoad,
      nav: nav,
      schemeType: schemeType,
      planType: planType,
      optionType: optionType,
      assetClass: assetClass,
      schemeCategory: schemeCategory,
      riskLevel: riskLevel,
      status: status,
      isNfo: isNfo,
      isSipAllowed: isSipAllowed,
      minSipAmount: minSipAmount,
      isLumpsumAllowed: isLumpsumAllowed,
      minLumpsum: minLumpsum,
      minimumTopup: minimumTopup,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
