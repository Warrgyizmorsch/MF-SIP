import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

class WishlistResponseModel {
  final bool success;
  final int? count;
  final List<WishListData>? data;

  WishlistResponseModel({
    required this.success,
    required this.count,
    this.data,
  });

  factory WishlistResponseModel.fromJson(Map<String, dynamic> json) {
    return WishlistResponseModel(
      success: json.parse<bool>('success') ?? false,
      count: json.parse<int>('count'),
      data: json.parseListOf('data', (e) => WishListData.fromJson(e)) ?? [],
    );
  }
}

class WishListData {
  final int? wishlistId;
  final String? schemeName;
  final String? schemeCode;
  final String? riskLevel;
  final WishlistReturns? returns;
  final String? amcLogo;

  WishListData({
    required this.wishlistId,
    required this.schemeName,
    required this.schemeCode,
    required this.riskLevel,
    required this.returns,
    required this.amcLogo,
  });

  factory WishListData.fromJson(Map<String, dynamic> json) {
    return WishListData(
      wishlistId: json.parse<int>('wishlist_id'),
      schemeName: json.parse<String>('scheme_name'),
      schemeCode: json.parse<String>('scheme_code'),
      riskLevel: json.parse<String>('risk_level'),
      returns: json.parseNested('returns', (e) => WishlistReturns.fromJson(e)),
      amcLogo: json.parse<String>('amc_logo'),
    );
  }
}

class WishlistReturns {
  final String? oneYear;
  final String? threeYear;
  final String? fiveYear;
  final String? tenYear;

  WishlistReturns({
    required this.oneYear,
    required this.threeYear,
    required this.fiveYear,
    required this.tenYear,
  });

  factory WishlistReturns.fromJson(Map<String, dynamic> json) {
    return WishlistReturns(
      oneYear: json.parse<String>('1y'),
      threeYear: json.parse<String>('3y'),
      fiveYear: json.parse<String>('5y'),
      tenYear: json.parse<String>('10y'),
    );
  }
}
