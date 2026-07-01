import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

class MutualFundListResponseModel {
  final bool? success;
  final List<MutualFundListModel> data;
  final PaginationModel? pagination;
  MutualFundListResponseModel({
    required this.success,
    required this.data,
    this.pagination,
  });

  factory MutualFundListResponseModel.fromJson(Map<String, dynamic> json) {
    return MutualFundListResponseModel(
      success: json.parse<bool>('success'),
      data:
          json.parseListOf('data', (e) => MutualFundListModel.fromJson(e)) ??
          [],
      pagination: json.parseNested(
        'pagination',
        (e) => PaginationModel.fromJson(e),
      ),
    );
  }
}

class MutualFundListModel {
  final String? baseSchemeName;
  final String? schemeType;
  final String? riskLevel;
  final String? schemeCode;
  final String? schemecategory;
  final String? isin;
  final AmcModel? amc;
  final ReturnsModel? returns;

  final double? nav;

  final int? minSipAmount;
  final int? minLumpsum;
  final int? minTopUp;
  final List<VariantModel> variants;

  MutualFundListModel({
    this.returns,
    required this.schemeCode,
    required this.baseSchemeName,
    required this.schemeType,
    required this.isin,
    required this.riskLevel,
    required this.amc,
    required this.variants,
    required this.minSipAmount,
    required this.minLumpsum,
    required this.minTopUp,
    required this.schemecategory,
    required this.nav,
  });

  factory MutualFundListModel.fromJson(Map<String, dynamic> json) {
    return MutualFundListModel(
      schemeCode: json.parse<String>('scheme_code'),
      baseSchemeName: json.parse<String>('fund_name'),
      schemeType: json.parse<String>('scheme_type'),
      isin: json.parse<String>('isin'),
      minSipAmount: json.parse<int>('min_sip_amount'),
      minLumpsum: json.parse<int>('min_lumpsum'),
      minTopUp: json.parse<int>('minimum_topup'),
      nav: json.parse<double>('nav'),
      schemecategory: json.parse<String>('scheme_category'),
      riskLevel: json.parse<String>('risk_level'),
      amc: json.parseNested('amc', (e) => AmcModel.fromJson(e)),
      returns: json.parseNested('returns', (e) => ReturnsModel.fromJson(e)),

      variants:
          json.parseListOf('variants', (e) => VariantModel.fromJson(e)) ?? [],
    );
  }
}

class ReturnsModel {
  final String? oneWeek;
  final String? oneMonth;
  final String? oneYear;
  final String? threeYear;
  final String? fiveYear;
  final String? tenYear;
  ReturnsModel({
    this.oneWeek,
    this.oneMonth,
    this.oneYear,
    this.threeYear,
    this.fiveYear,
    this.tenYear,
  });

  factory ReturnsModel.fromJson(Map<String, dynamic> json) {
    return ReturnsModel(
      oneWeek: json.parse<String>('1w'),
      oneMonth: json.parse<String>('1m'),
      oneYear: json.parse<String>('1y'),
      threeYear: json.parse<String>('3y'),
      fiveYear: json.parse<String>('5y'),
      tenYear: json.parse<String>('10y'),
    );
  }
}

class AmcModel {
  final int? id;
  final String? amcName;
  final String? amcLogoUrl;
  final String? email;
  final String? contact;
  final String? address;

  AmcModel({
    required this.id,
    required this.amcName,
    required this.amcLogoUrl,
    this.email,
    this.contact,
    this.address,
  });

  factory AmcModel.fromJson(Map<String, dynamic> json) {
    return AmcModel(
      id: json.parse<int>('id'),
      amcName: json.parse<String>('name'),
      amcLogoUrl: json.parse<String>('logo_url'),
      email: json.parse<String>('email'),
      contact: json.parse<String>('contact'),
      address: json.parse<String>('address'),
    );
  }
}

class VariantModel {
  final int? id;
  final String? schemeCode;
  final String? planType;
  final double? nav;
  final String? navDate;

  VariantModel({
    required this.id,
    required this.schemeCode,
    required this.planType,
    required this.nav,
    required this.navDate,
  });

  factory VariantModel.fromJson(Map<String, dynamic> json) {
    return VariantModel(
      id: json.parse<int>('id'),
      schemeCode: json.parse<String>('scheme_code'),
      planType: json.parse<String>('plan_type'),
      nav: json.parse<double>('nav'),
      navDate: json.parse<String>('nav_date'),
    );
  }
}

class PaginationModel {
  final int? currentPage;
  final int? perPage;
  final int? total;
  final int? lastPage;
  final bool? hasMore;

  PaginationModel({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    required this.hasMore,
  });
  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      currentPage: json.parse<int>('current_page'),
      perPage: json.parse<int>('per_page'),
      total: json.parse<int>('total'),
      lastPage: json.parse<int>('last_page'),
      hasMore: json.parse<bool>('has_more'),
    );
  }
}
