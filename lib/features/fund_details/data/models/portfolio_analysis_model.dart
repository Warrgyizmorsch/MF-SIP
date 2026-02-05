import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

class SchemeDetailsModel {
  final int? status;
  final String? statusMsg;
  final String? msg;
  final String? isin;
  final String? schemeName;

  final List<String>? schemePortfolioHoldingsNamesString;
  final List<double>? schemePortfolioHoldingsValuesString;
  final Map<String, double>? schemePortfolioHoldings;

  final List<String>? sectorNamesString;
  final List<double>? sectorValuesString;
  final Map<String, double>? sectorAllocation;

  final List<String>? assetAllocationNamesString;
  final List<double>? assetAllocationValuesString;
  final Map<String, double>? assetAllocation;

  final McapAllocationModel? mcapAllocationResponse;

  SchemeDetailsModel({
    this.status,
    this.statusMsg,
    this.msg,
    this.isin,
    this.schemeName,
    this.schemePortfolioHoldingsNamesString,
    this.schemePortfolioHoldingsValuesString,
    this.schemePortfolioHoldings,
    this.sectorNamesString,
    this.sectorValuesString,
    this.sectorAllocation,
    this.assetAllocationNamesString,
    this.assetAllocationValuesString,
    this.assetAllocation,
    this.mcapAllocationResponse,
  });

  factory SchemeDetailsModel.fromJson(Map<String, dynamic> json) {
    return SchemeDetailsModel(
      status: json.parse<int>('status'),
      statusMsg: json.parse<String>('status_msg'),
      msg: json.parse<String>('msg'),
      isin: json.parse<String>('isin'),
      schemeName: json.parse<String>('scheme_name'),

      // Parsing Lists
      schemePortfolioHoldingsNamesString: json.parseListOf<String>(
        'schemePortfolioHoldingsNamesString',
        (e) => e.toString(),
      ),
      schemePortfolioHoldingsValuesString: json.parseListOf<double>(
        'schemePortfolioHoldingsValuesString',
        (e) => (e as num).toDouble(),
      ),
      sectorNamesString: json.parseListOf<String>(
        'sectorNamesString',
        (e) => e.toString(),
      ),
      sectorValuesString: json.parseListOf<double>(
        'sectorValuesString',
        (e) => (e as num).toDouble(),
      ),
      assetAllocationNamesString: json.parseListOf<String>(
        'assetAllocationNamesString',
        (e) => e.toString(),
      ),
      assetAllocationValuesString: json.parseListOf<double>(
        'assetAllocationValuesString',
        (e) => (e as num).toDouble(),
      ),

      // Parsing Maps
      schemePortfolioHoldings: json.parseNested(
        'schemePortfolioHoldings',
        (data) => data.map((k, v) => MapEntry(k, (v as num).toDouble())),
      ),
      sectorAllocation: json.parseNested(
        'sectorAllocation',
        (data) => data.map((k, v) => MapEntry(k, (v as num).toDouble())),
      ),
      assetAllocation: json.parseNested(
        'assetAllocation',
        (data) => data.map((k, v) => MapEntry(k, (v as num).toDouble())),
      ),

      // Parsing Nested Object
      mcapAllocationResponse: json.parseNested(
        'mcapAllocationResponse',
        (data) => McapAllocationModel.fromJson(data),
      ),
    );
  }
}

class McapAllocationModel {
  final double? marketCapLargecapPercent;
  final double? marketCapMidcapPercent;
  final double? marketCapSmallcapPercent;

  McapAllocationModel({
    this.marketCapLargecapPercent,
    this.marketCapMidcapPercent,
    this.marketCapSmallcapPercent,
  });

  factory McapAllocationModel.fromJson(Map<String, dynamic> json) {
    return McapAllocationModel(
      marketCapLargecapPercent: json.parse<double>(
        'market_cap_largecap_percent',
      ),
      marketCapMidcapPercent: json.parse<double>('market_cap_midcap_percent'),
      marketCapSmallcapPercent: json.parse<double>(
        'market_cap_smallcap_percent',
      ),
    );
  }
}
