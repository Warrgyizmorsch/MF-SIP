import 'package:my_sip/core/utils/helper/custom_json_parser.dart';


class FundDetailModel {
  final int? status;
  final String? statusMsg;
  final String? msg;

  final String? schemeName;
  final String? schemeAmfiCode;
  final double? nav;
  final String? navDate;
  final double? navChange;
  final double? navChangePercentage;

  final double? schemeInceptionReturn;
  final double? benchmarkInceptionReturn;

  final String? schemeObjective;
  final String? schemeManager;
  final String? riskometerValue;

  final String? isinNo;
  final String? isinDivReinvstNo;

  final String? schemeCategory;
  final String? schemeCompany;
  final String? schemeInceptionDate;
  final String? assetClass;

  final String? schemeBenchmark;
  final String? schemeBenchmarkCode;

  final double? expenseRatioPercentage;
  final String? expenseRatioDate;

  final String? schemeStatus;
  final double? minimumInvestment;
  final int? sipMinimumAmount;
  final double? minimumTopup;

  final double? schemeAssets;
  final String? schemeAssetDate;

  final bool? isDividendScheme;
  final String? exitLoad;

  final String? rating;
  final int? ratingValue;

  final double? upmarketCaptureRatio;
  final double? downmarketCaptureRatio;
  final double? marketCapLargecapPercent;
  final double? marketCapMidcapPercent;
  final double? marketCapSmallcapPercent;

  final List<SchemePerformanceModel> schemePerformanceList;
  final List<RiskStatisticsModel> riskStatisticsList;
  final List<SchemePeerComparisonModel> schemePeerComparisonList;

  FundDetailModel({
    this.status,
    this.statusMsg,
    this.msg,
    this.schemeName,
    this.schemeAmfiCode,
    this.nav,
    this.navDate,
    this.navChange,
    this.navChangePercentage,
    this.schemeInceptionReturn,
    this.benchmarkInceptionReturn,
    this.schemeObjective,
    this.schemeManager,
    this.riskometerValue,
    this.isinNo,
    this.isinDivReinvstNo,
    this.schemeCategory,
    this.schemeCompany,
    this.schemeInceptionDate,
    this.assetClass,
    this.schemeBenchmark,
    this.schemeBenchmarkCode,
    this.expenseRatioPercentage,
    this.expenseRatioDate,
    this.schemeStatus,
    this.minimumInvestment,
    this.sipMinimumAmount,
    this.minimumTopup,
    this.schemeAssets,
    this.schemeAssetDate,
    this.isDividendScheme,
    this.exitLoad,
    this.rating,
    this.ratingValue,
    this.upmarketCaptureRatio,
    this.downmarketCaptureRatio,
    this.marketCapLargecapPercent,
    this.marketCapMidcapPercent,
    this.marketCapSmallcapPercent,
    this.schemePerformanceList = const [],
    this.riskStatisticsList = const [],
    this.schemePeerComparisonList = const [],
  });

  factory FundDetailModel.fromJson(Map<String, dynamic> json) {
    return FundDetailModel(
      status: json.parse<int>('status'),
      statusMsg: json.parse<String>('status_msg'),
      msg: json.parse<String>('msg'),

      schemeName: json.parse<String>('scheme_name'),
      schemeAmfiCode: json.parse<String>('scheme_amfi_code'),
      nav: json.parse<double>('nav'),
      navDate: json.parse<String>('nav_date'),
      navChange: json.parse<double>('nav_change'),
      navChangePercentage: json.parse<double>('nav_change_percentage'),

      schemeInceptionReturn: json.parse<double>('scheme_inception_return'),
      benchmarkInceptionReturn:
      json.parse<double>('benchmark_inception_return'),

      schemeObjective: json.parse<String>('scheme_objective'),
      schemeManager: json.parse<String>('scheme_manager'),
      riskometerValue: json.parse<String>('riskometer_value'),

      isinNo: json.parse<String>('isin_no'),
      isinDivReinvstNo: json.parse<String>('isin_divreinvst_no'),

      schemeCategory: json.parse<String>('scheme_category'),
      schemeCompany: json.parse<String>('scheme_company'),
      schemeInceptionDate: json.parse<String>('scheme_inception_date'),
      assetClass: json.parse<String>('asset_class'),

      schemeBenchmark: json.parse<String>('scheme_benchmark'),
      schemeBenchmarkCode: json.parse<String>('scheme_benchmark_code'),

      expenseRatioPercentage:
      json.parse<double>('expense_ratio_percentage'),
      expenseRatioDate: json.parse<String>('expense_ratio_date'),

      schemeStatus: json.parse<String>('scheme_status'),
      minimumInvestment: json.parse<double>('minimum_investment'),
      sipMinimumAmount: json.parse<int>('sip_minimum_amount'),
      minimumTopup: json.parse<double>('minimum_topup'),

      schemeAssets: json.parse<double>('scheme_assets'),
      schemeAssetDate: json.parse<String>('scheme_asset_date'),

      isDividendScheme: json.parse<bool>('is_dividend_scheme'),
      exitLoad: json.parse<String>('exit_load'),

      rating: json.parse<String>('rating'),
      ratingValue: json.parse<int>('rating_value'),

      upmarketCaptureRatio:
      json.parse<double>('upmarket_capture_ratio'),
      downmarketCaptureRatio:
      json.parse<double>('downmarket_capture_ratio'),
      marketCapLargecapPercent:
      json.parse<double>('market_cap_largecap_percent'),
      marketCapMidcapPercent:
      json.parse<double>('market_cap_midcap_percent'),
      marketCapSmallcapPercent:
      json.parse<double>('market_cap_smallcap_percent'),

      schemePerformanceList:
      json.parseListOf('scheme_performance_list',
              (e) => SchemePerformanceModel.fromJson(e)) ??
          const [],

      riskStatisticsList:
      json.parseListOf('risk_statistics_list',
              (e) => RiskStatisticsModel.fromJson(e)) ??
          const [],

      schemePeerComparisonList:
      json.parseListOf('scheme_peer_comparision_list',
              (e) => SchemePeerComparisonModel.fromJson(e)) ??
          const [],
    );
  }
}

class SchemePerformanceModel {
  final String? schemeName;
  final double? oneWeekReturn;
  final double? oneMonthReturn;
  final double? threeMonthReturn;
  final double? sixMonthReturn;
  final double? oneYearReturn;
  final double? twoYearReturn;
  final double? threeYearReturn;
  final double? fiveYearReturn;
  final double? tenYearReturn;
  final double? inceptionYearReturn;
  final double? ytdReturn;
  final double? schemeAssets;

  SchemePerformanceModel({
    this.schemeName,
    this.oneWeekReturn,
    this.oneMonthReturn,
    this.threeMonthReturn,
    this.sixMonthReturn,
    this.oneYearReturn,
    this.twoYearReturn,
    this.threeYearReturn,
    this.fiveYearReturn,
    this.tenYearReturn,
    this.inceptionYearReturn,
    this.ytdReturn,
    this.schemeAssets,
  });

  factory SchemePerformanceModel.fromJson(Map<String, dynamic> json) {
    return SchemePerformanceModel(
      schemeName: json.parse<String>('scheme_name'),
      oneWeekReturn: json.parse<double>('one_week_return'),
      oneMonthReturn: json.parse<double>('one_month_return'),
      threeMonthReturn: json.parse<double>('three_month_return'),
      sixMonthReturn: json.parse<double>('six_month_return'),
      oneYearReturn: json.parse<double>('one_year_return'),
      twoYearReturn: json.parse<double>('two_year_return'),
      threeYearReturn: json.parse<double>('three_year_return'),
      fiveYearReturn: json.parse<double>('five_year_return'),
      tenYearReturn: json.parse<double>('ten_year_return'),
      inceptionYearReturn:
      json.parse<double>('inception_year_return'),
      ytdReturn: json.parse<double>('ytd_return'),
      schemeAssets: json.parse<double>('scheme_assets'),
    );
  }
}


class RiskStatisticsModel {
  final String? schemeCategory;
  final double? volatilityCm3Year;
  final double? sharpeRatioCm3Year;
  final double? alphaCm1Year;
  final double? betaCm1Year;
  final double? yieldToMaturity;
  final double? averageMaturity;
  final double? shortinoRatio;

  RiskStatisticsModel({
    this.schemeCategory,
    this.volatilityCm3Year,
    this.sharpeRatioCm3Year,
    this.alphaCm1Year,
    this.betaCm1Year,
    this.yieldToMaturity,
    this.averageMaturity,
    this.shortinoRatio,
  });

  factory RiskStatisticsModel.fromJson(Map<String, dynamic> json) {
    return RiskStatisticsModel(
      schemeCategory: json.parse<String>('scheme_category'),
      volatilityCm3Year:
      json.parse<double>('volatility_cm_3year'),
      sharpeRatioCm3Year:
      json.parse<double>('sharpratio_cm_3year'),
      alphaCm1Year: json.parse<double>('alpha_cm_1year'),
      betaCm1Year: json.parse<double>('beta_cm_1year'),
      yieldToMaturity:
      json.parse<double>('yield_to_maturity'),
      averageMaturity:
      json.parse<double>('average_maturity'),
      shortinoRatio: json.parse<double>('shortino_ratio'),
    );
  }
}


class SchemePeerComparisonModel {
  final String? schemeName;
  final String? schemeInceptionDateString;
  final double? oneWeekReturn;
  final double? oneMonthReturn;
  final double? threeMonthReturn;
  final double? sixMonthReturn;
  final double? oneYearReturn;
  final double? twoYearReturn;
  final double? threeYearReturn;
  final double? fiveYearReturn;
  final double? tenYearReturn;
  final double? inceptionYearReturn;
  final double? ytdReturn;
  final double? schemeAssets;
  final double? expenseRatioPercentage;
  final String? expenseRatioDate;
  final String? rating;
  final int? ratingValue;

  SchemePeerComparisonModel({
    this.schemeName,
    this.schemeInceptionDateString,
    this.oneWeekReturn,
    this.oneMonthReturn,
    this.threeMonthReturn,
    this.sixMonthReturn,
    this.oneYearReturn,
    this.twoYearReturn,
    this.threeYearReturn,
    this.fiveYearReturn,
    this.tenYearReturn,
    this.inceptionYearReturn,
    this.ytdReturn,
    this.schemeAssets,
    this.expenseRatioPercentage,
    this.expenseRatioDate,
    this.rating,
    this.ratingValue,
  });

  factory SchemePeerComparisonModel.fromJson(Map<String, dynamic> json) {
    return SchemePeerComparisonModel(
      schemeName: json.parse<String>('scheme_name'),
      schemeInceptionDateString:
      json.parse<String>('scheme_inception_date_string'),
      oneWeekReturn: json.parse<double>('one_week_return'),
      oneMonthReturn: json.parse<double>('one_month_return'),
      threeMonthReturn:
      json.parse<double>('three_month_return'),
      sixMonthReturn:
      json.parse<double>('six_month_return'),
      oneYearReturn: json.parse<double>('one_year_return'),
      twoYearReturn: json.parse<double>('two_year_return'),
      threeYearReturn:
      json.parse<double>('three_year_return'),
      fiveYearReturn:
      json.parse<double>('five_year_return'),
      tenYearReturn:
      json.parse<double>('ten_year_return'),
      inceptionYearReturn:
      json.parse<double>('inception_year_return'),
      ytdReturn: json.parse<double>('ytd_return'),
      schemeAssets: json.parse<double>('scheme_assets'),
      expenseRatioPercentage:
      json.parse<double>('expense_ratio_percentage'),
      expenseRatioDate:
      json.parse<String>('expense_ratio_date'),
      rating: json.parse<String>('rating'),
      ratingValue: json.parse<int>('rating_value'),
    );
  }
}
