import 'package:equatable/equatable.dart';
import 'package:my_sip/features/explore/data/model/mutual_fund_list_model.dart';

class MutualFundListResponseEntity extends Equatable {
  final bool? success;
  final int? count;
  final List<MutualFundListEntity> data;
  final PaginationModelEntity? pagination;

  const MutualFundListResponseEntity({
    required this.success,
    this.count,
    required this.data,
    this.pagination,
  });
  @override
  List<Object?> get props => [success, count, data, pagination];
}

extension MutualFundListResponseEntityX on MutualFundListResponseModel {
  MutualFundListResponseEntity toEntity() {
    return MutualFundListResponseEntity(
      success: success ?? false,
      count: count,
      data: data.map((e) => e.toEntity()).toList(),
      pagination: pagination?.toEntity(),
    );
  }
}

class MutualFundListEntity extends Equatable {
  final int? fundId;
  final int? amcId;
  final String? baseSchemeName;
  final String? schemeType;
  final String? riskLevel;
  final String? isin;
  final String? schemeCode;
  final String? mfuSchemeCode;
  final String? rtaAmcCode;
  final AmcEntity? amc;
  final ReturnsEntity? returnsEntity;

  final double? nav;
  final String? navDate;
  final double? navChange;

  final int? minSipAmount;
  final int? minLumpsum;
  final int? minTopUp;
  final String? allowedSipDates;
  final bool? isSipAllowed;
  final bool? isLumpsumAllowed;
  final bool? isPurchaseAllowed;
  final bool? isRedeemAllowed;

  final String? schemecategory;
  final String? divoption;
  final bool? isNfo;
  final NfoDetailsEntity? nfoDetails;

  final List<VariantModelEntity> variants;

  const MutualFundListEntity({
    this.fundId,
    this.amcId,
    required this.returnsEntity,
    required this.schemeCode,
    required this.nav,
    this.navDate,
    this.navChange,
    required this.baseSchemeName,
    required this.schemeType,
    required this.riskLevel,
    required this.isin,
    this.mfuSchemeCode,
    this.rtaAmcCode,
    required this.amc,
    required this.minSipAmount,
    required this.minLumpsum,
    required this.minTopUp,
    this.allowedSipDates,
    this.isSipAllowed,
    this.isLumpsumAllowed,
    this.isPurchaseAllowed,
    this.isRedeemAllowed,
    this.variants = const [],
    required this.schemecategory,
    this.divoption,
    this.isNfo,
    this.nfoDetails,
  });

  /// Convenient alias for fund name
  String? get fundName => baseSchemeName;

  @override
  List<Object?> get props => [
    fundId,
    amcId,
    returnsEntity,
    baseSchemeName,
    schemeType,
    riskLevel,
    isin,
    schemeCode,
    mfuSchemeCode,
    rtaAmcCode,
    amc,
    minSipAmount,
    schemecategory,
    minLumpsum,
    minTopUp,
    allowedSipDates,
    isSipAllowed,
    isLumpsumAllowed,
    isPurchaseAllowed,
    isRedeemAllowed,
    variants,
    nav,
    navDate,
    navChange,
    divoption,
    isNfo,
    nfoDetails,
  ];
}

extension MutualFundListEntityX on MutualFundListModel {
  MutualFundListEntity toEntity() {
    return MutualFundListEntity(
      fundId: fundId,
      amcId: amcId,
      returnsEntity: returns?.toEntity(),
      schemeCode: schemeCode,
      nav: nav,
      navDate: navDate,
      navChange: navChange,
      baseSchemeName: baseSchemeName,
      schemeType: schemeType,
      schemecategory: schemecategory,
      riskLevel: riskLevel,
      isin: isin,
      mfuSchemeCode: mfuSchemeCode,
      rtaAmcCode: rtaAmcCode,
      amc: amc?.toEntity(),
      minSipAmount: minSipAmount,
      minLumpsum: minLumpsum,
      minTopUp: minTopUp,
      allowedSipDates: allowedSipDates,
      isSipAllowed: isSipAllowed,
      isLumpsumAllowed: isLumpsumAllowed,
      isPurchaseAllowed: isPurchaseAllowed,
      isRedeemAllowed: isRedeemAllowed,
      divoption: divoption,
      isNfo: isNfo,
      nfoDetails: nfoDetails?.toEntity(),
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
  final String? websiteUrl;

  const AmcEntity({
    required this.id,
    required this.amcName,
    required this.amcLogoUrl,
    this.email,
    this.contact,
    this.address,
    this.websiteUrl,
  });

  @override
  List<Object?> get props => [id, amcName, amcLogoUrl, email, contact, address, websiteUrl];
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
      websiteUrl: websiteUrl,
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

class NfoDetailsEntity extends Equatable {
  final int? id;
  final String? schemeName;
  final String? nfoOpenDate;
  final String? nfoCloseDate;
  final String? allotmentDate;
  final String? launchDate;
  final double? nfoPrice;
  final int? minSubscriptionAmount;
  final String? fundManager;
  final String? benchmark;
  final String? schemeObjective;
  final String? exitLoad;
  final String? expenseRatio;
  final String? status;
  final bool? isOpen;
  final int? daysRemaining;

  const NfoDetailsEntity({
    this.id,
    this.schemeName,
    this.nfoOpenDate,
    this.nfoCloseDate,
    this.allotmentDate,
    this.launchDate,
    this.nfoPrice,
    this.minSubscriptionAmount,
    this.fundManager,
    this.benchmark,
    this.schemeObjective,
    this.exitLoad,
    this.expenseRatio,
    this.status,
    this.isOpen,
    this.daysRemaining,
  });

  @override
  List<Object?> get props => [
    id,
    schemeName,
    nfoOpenDate,
    nfoCloseDate,
    allotmentDate,
    launchDate,
    nfoPrice,
    minSubscriptionAmount,
    fundManager,
    benchmark,
    schemeObjective,
    exitLoad,
    expenseRatio,
    status,
    isOpen,
    daysRemaining,
  ];
}

extension NfoDetailsEntityX on NfoDetailsModel {
  NfoDetailsEntity toEntity() {
    return NfoDetailsEntity(
      id: id,
      schemeName: schemeName,
      nfoOpenDate: nfoOpenDate,
      nfoCloseDate: nfoCloseDate,
      allotmentDate: allotmentDate,
      launchDate: launchDate,
      nfoPrice: nfoPrice,
      minSubscriptionAmount: minSubscriptionAmount,
      fundManager: fundManager,
      benchmark: benchmark,
      schemeObjective: schemeObjective,
      exitLoad: exitLoad,
      expenseRatio: expenseRatio,
      status: status,
      isOpen: isOpen,
      daysRemaining: daysRemaining,
    );
  }
}
