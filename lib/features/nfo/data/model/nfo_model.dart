import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

class UpcomingLaunchResponse {
  final bool? success;
  final String? type;
  final int? count;
  final List<LaunchData>? data;

  UpcomingLaunchResponse({this.success, this.type, this.count, this.data});

  factory UpcomingLaunchResponse.fromJson(Map<String, dynamic> json) {
    return UpcomingLaunchResponse(
      success: json.parse<bool>('success'),
      type: json.parse<String>('type'),
      count: json.parse<int>('count'),
      data: json.parseListOf<LaunchData>(
        'data',
        (e) => LaunchData.fromJson(e as Map<String, dynamic>),
      ),
    );
  }
}

class LaunchData {
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

  LaunchData({
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

  factory LaunchData.fromJson(Map<String, dynamic> json) {
    return LaunchData(
      id: json.parse<int>('id'),
      schemeName: json.parse<String>('scheme_name'),
      amcId: json.parse<int>('amc_id'),
      schemeCode: json.parse<String>('scheme_code'),
      isin: json.parse<String>('isin'),
      baseSchemeName: json.parse<String>('base_scheme_name'),
      schemeObjective: json.parse<String>('scheme_objective'),
      nfoOpenDate: json.parse<String>('nfo_open_date'),
      nfoCloseDate: json.parse<String>('nfo_close_date'),
      allotmentDate: json.parse<String>('allotment_date'),
      launchDate: json.parse<String>('launch_date'),
      nfoPrice: json.parse<double>('nfo_price'),
      minSubscriptionAmount: json.parse<double>('min_subscription_amount'),
      expenseRatio: json.parse<double>('expense_ratio'),
      expenseRatioDate: json.parse<String>('expense_ratio_date'),
      aum: json.parse<double>('aum'),
      benchmark: json.parse<String>('benchmark'),
      fundManager: json.parse<String>('fund_manager'),
      exitLoad: json.parse<String>('exit_load'),
      nav: json.parse<double>('nav'),
      schemeType: json.parse<String>('scheme_type'),
      planType: json.parse<String>('plan_type'),
      optionType: json.parse<String>('option_type'),
      assetClass: json.parse<String>('asset_class'),
      schemeCategory: json.parse<String>('scheme_category'),
      riskLevel: json.parse<String>('risk_level'),
      status: json.parse<String>('status'),
      isNfo: json.parse<bool>('is_nfo'),
      isSipAllowed: json.parse<bool>('is_sip_allowed'),
      minSipAmount: json.parse<double>('min_sip_amount'),
      isLumpsumAllowed: json.parse<bool>('is_lumpsum_allowed'),
      minLumpsum: json.parse<double>('min_lumpsum'),
      minimumTopup: json.parse<double>('minimum_topup'),
      createdAt: json.parse<String>('created_at'),
      updatedAt: json.parse<String>('updated_at'),
    );
  }
}
