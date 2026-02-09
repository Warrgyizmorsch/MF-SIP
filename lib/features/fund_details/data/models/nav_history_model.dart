import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

class NavHistoryResponseModel {
  final bool? success;
  final int? schemeCode;
  final String? from;
  final String? to;
  final int? count;
  final List<NavEntry>? data;

  NavHistoryResponseModel({
    this.success,
    this.schemeCode,
    this.from,
    this.to,
    this.count,
    this.data,
  });

  factory NavHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    return NavHistoryResponseModel(
      success: json.parse<bool>('success'),
      schemeCode: json.parse<int>('scheme_code'),
      from: json.parse<String>('from'),
      to: json.parse<String>('to'),
      count: json.parse<int>('count'),
      data: json.parseListOf('data', (e) => NavEntry.fromJson(e)) ?? [],
    );
  }
}

class NavEntry {
  final String? navDate;
  final double? nav;

  NavEntry({this.navDate, this.nav});

  factory NavEntry.fromJson(Map<String, dynamic> json) {
    return NavEntry(
      navDate: json.parse<String>('nav_date'),
      nav: double.tryParse(json['nav']?.toString() ?? ''),
    );
  }
}
