import 'package:equatable/equatable.dart';
import 'package:my_sip/features/fund_details/data/models/fund_detail_model.dart';

class FundDetailEntity extends Equatable {
  final int status;
  final String statusMsg;
  final String msg;

  final String schemeName;
  final String schemeAmfiCode;
  final double nav;
  final String navDate;
  final double navChange;
  final double navChangePercentage;

  final double schemeInceptionReturn;
  final double benchmarkInceptionReturn;

  final String schemeObjective;
  final String schemeManager;
  final String riskometerValue;

  final String isinNo;
  final String isinDivReinvstNo;

  final String schemeCategory;
  final String schemeCompany;
  final String schemeInceptionDate;
  final String assetClass;

  final String schemeBenchmark;
  final String schemeBenchmarkCode;

  final double expenseRatioPercentage;
  final String expenseRatioDate;

  final String schemeStatus;
  final double minimumInvestment;
  final int sipMinimumAmount;
  final double minimumTopup;

  final double schemeAssets;
  final String schemeAssetDate;

  final bool isDividendScheme;
  final String exitLoad;

  final String rating;
  final int ratingValue;

  final double upmarketCaptureRatio;
  final double downmarketCaptureRatio;
  final double marketCapLargecapPercent;
  final double marketCapMidcapPercent;
  final double marketCapSmallcapPercent;

  final List<SchemePerformanceEntity> schemePerformanceList;
  final List<RiskStatisticsEntity> riskStatisticsList;
  final List<SchemePeerComparisonEntity> schemePeerComparisonList;

  const FundDetailEntity({
    required this.status,
    required this.statusMsg,
    required this.msg,
    required this.schemeName,
    required this.schemeAmfiCode,
    required this.nav,
    required this.navDate,
    required this.navChange,
    required this.navChangePercentage,
    required this.schemeInceptionReturn,
    required this.benchmarkInceptionReturn,
    required this.schemeObjective,
    required this.schemeManager,
    required this.riskometerValue,
    required this.isinNo,
    required this.isinDivReinvstNo,
    required this.schemeCategory,
    required this.schemeCompany,
    required this.schemeInceptionDate,
    required this.assetClass,
    required this.schemeBenchmark,
    required this.schemeBenchmarkCode,
    required this.expenseRatioPercentage,
    required this.expenseRatioDate,
    required this.schemeStatus,
    required this.minimumInvestment,
    required this.sipMinimumAmount,
    required this.minimumTopup,
    required this.schemeAssets,
    required this.schemeAssetDate,
    required this.isDividendScheme,
    required this.exitLoad,
    required this.rating,
    required this.ratingValue,
    required this.upmarketCaptureRatio,
    required this.downmarketCaptureRatio,
    required this.marketCapLargecapPercent,
    required this.marketCapMidcapPercent,
    required this.marketCapSmallcapPercent,
    required this.schemePerformanceList,
    required this.riskStatisticsList,
    required this.schemePeerComparisonList,
  });

  @override
  List<Object?> get props => [
    schemeAmfiCode,
    nav,
    ratingValue,
    schemeAssets,
    schemePerformanceList,
    riskStatisticsList,
    schemePeerComparisonList,
  ];
}

class SchemePerformanceEntity extends Equatable {
  final String schemeName;
  final double oneMonthReturn;
  final double threeMonthReturn;
  final double oneYearReturn;
  final double threeYearReturn;
  final double fiveYearReturn;
  final double tenYearReturn;
  final double twoYearReturn;
  final double sixMonthReturn;

  const SchemePerformanceEntity({
    required this.schemeName,
    required this.oneYearReturn,
    required this.threeYearReturn,
    required this.fiveYearReturn,
    required this.tenYearReturn,
    required this.twoYearReturn,
    required this.sixMonthReturn,
    required this.oneMonthReturn,
    required this.threeMonthReturn,
  });

  @override
  List<Object?> get props => [
    schemeName,
    oneYearReturn,
    threeYearReturn,
    fiveYearReturn,
    tenYearReturn,
  ];
}

class RiskStatisticsEntity extends Equatable {
  final String schemeCategory;
  final double volatilityCm3Year;
  final double sharpeRatioCm3Year;
  final double yieldToMaturity;
  final double averageMaturity;
  final double beteCm1Y;

  const RiskStatisticsEntity({
    required this.schemeCategory,
    required this.volatilityCm3Year,
    required this.sharpeRatioCm3Year,
    required this.yieldToMaturity,
    required this.averageMaturity,
    required this.beteCm1Y,
  });

  @override
  List<Object?> get props => [
    schemeCategory,
    volatilityCm3Year,
    yieldToMaturity,
    averageMaturity,
  ];
}

class SchemePeerComparisonEntity extends Equatable {
  final String schemeName;
  final String schemeInceptionDateString;
  final double oneYearReturn;
  final double threeYearReturn;
  final double fiveYearReturn;
  final int ratingValue;

  const SchemePeerComparisonEntity({
    required this.schemeName,
    required this.schemeInceptionDateString,
    required this.oneYearReturn,
    required this.threeYearReturn,
    required this.ratingValue,
    required this.fiveYearReturn,
  });

  @override
  List<Object?> get props => [
    schemeName,
    oneYearReturn,
    threeYearReturn,
    ratingValue,
  ];
}

extension FundDetailModelX on FundDetailModel {
  FundDetailEntity toEntity() {
    return FundDetailEntity(
      status: status ?? 0,
      statusMsg: statusMsg ?? '',
      msg: msg ?? '',
      schemeName: schemeName ?? '',
      schemeAmfiCode: schemeAmfiCode ?? '',
      nav: nav ?? 0.0,
      navDate: navDate ?? '',
      navChange: navChange ?? 0.0,
      navChangePercentage: navChangePercentage ?? 0.0,
      schemeInceptionReturn: schemeInceptionReturn ?? 0.0,
      benchmarkInceptionReturn: benchmarkInceptionReturn ?? 0.0,
      schemeObjective: schemeObjective ?? '',
      schemeManager: schemeManager ?? '',
      riskometerValue: riskometerValue ?? '',
      isinNo: isinNo ?? '',
      isinDivReinvstNo: isinDivReinvstNo ?? '',
      schemeCategory: schemeCategory ?? '',
      schemeCompany: schemeCompany ?? '',
      schemeInceptionDate: schemeInceptionDate ?? '',
      assetClass: assetClass ?? '',
      schemeBenchmark: schemeBenchmark ?? '',
      schemeBenchmarkCode: schemeBenchmarkCode ?? '',
      expenseRatioPercentage: expenseRatioPercentage ?? 0.0,
      expenseRatioDate: expenseRatioDate ?? '',
      schemeStatus: schemeStatus ?? '',
      minimumInvestment: minimumInvestment ?? 0.0,
      sipMinimumAmount: sipMinimumAmount ?? 0,
      minimumTopup: minimumTopup ?? 0.0,
      schemeAssets: schemeAssets ?? 0.0,
      schemeAssetDate: schemeAssetDate ?? '',
      isDividendScheme: isDividendScheme ?? false,
      exitLoad: exitLoad ?? '',
      rating: rating ?? '',
      ratingValue: ratingValue ?? 0,
      upmarketCaptureRatio: upmarketCaptureRatio ?? 0.0,
      downmarketCaptureRatio: downmarketCaptureRatio ?? 0.0,
      marketCapLargecapPercent: marketCapLargecapPercent ?? 0.0,
      marketCapMidcapPercent: marketCapMidcapPercent ?? 0.0,
      marketCapSmallcapPercent: marketCapSmallcapPercent ?? 0.0,
      schemePerformanceList: schemePerformanceList
          .map((e) => e.toEntity())
          .toList(),
      riskStatisticsList: riskStatisticsList.map((e) => e.toEntity()).toList(),
      schemePeerComparisonList: schemePeerComparisonList
          .map((e) => e.toEntity())
          .toList(),
    );
  }
}

extension SchemePerformanceModelX on SchemePerformanceModel {
  SchemePerformanceEntity toEntity() {
    return SchemePerformanceEntity(
      schemeName: schemeName ?? '',

      oneYearReturn: oneYearReturn ?? 0.0,
      threeYearReturn: threeYearReturn ?? 0.0,
      fiveYearReturn: fiveYearReturn ?? 0.0,
      tenYearReturn: tenYearReturn ?? 0.0,
      twoYearReturn: twoYearReturn ?? 0.0,
      sixMonthReturn: sixMonthReturn ?? 0.0,
      oneMonthReturn: oneMonthReturn ?? 0.0,
      threeMonthReturn: threeMonthReturn ?? 0.0,
    );
  }
}

extension RiskStatisticsModelX on RiskStatisticsModel {
  RiskStatisticsEntity toEntity() {
    return RiskStatisticsEntity(
      beteCm1Y: betaCm1Year ?? 0,
      schemeCategory: schemeCategory ?? '',
      volatilityCm3Year: volatilityCm3Year ?? 0.0,
      sharpeRatioCm3Year: sharpeRatioCm3Year ?? 0.0,
      yieldToMaturity: yieldToMaturity ?? 0.0,
      averageMaturity: averageMaturity ?? 0.0,
    );
  }
}

extension SchemePeerComparisonModelX on SchemePeerComparisonModel {
  SchemePeerComparisonEntity toEntity() {
    return SchemePeerComparisonEntity(
      schemeName: schemeName ?? '',
      schemeInceptionDateString: schemeInceptionDateString ?? '',
      oneYearReturn: oneYearReturn ?? 0.0,
      threeYearReturn: threeYearReturn ?? 0.0,
      ratingValue: ratingValue ?? 0,
      fiveYearReturn: fiveYearReturn ?? 0.0,
    );
  }
}
