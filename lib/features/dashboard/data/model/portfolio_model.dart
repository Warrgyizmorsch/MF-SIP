// features/mfu/data/model/mfu_portfolio_model.dart

import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

class MfuPortfolioModel {
  final bool? success;
  final List<MfuPortfolioItemModel>? portfolio;
  final MfuPortfolioSummaryModel? summary;

  MfuPortfolioModel({this.success, this.portfolio, this.summary});

  factory MfuPortfolioModel.fromJson(Map<String, dynamic> json) {
    return MfuPortfolioModel(
      success: json.parse<bool>('success'),
      portfolio: json.parseListOf<MfuPortfolioItemModel>(
        'portfolio',
        (item) => MfuPortfolioItemModel.fromJson(item as Map<String, dynamic>),
      ),
      summary: json['summary'] != null
          ? MfuPortfolioSummaryModel.fromJson(
              json['summary'] as Map<String, dynamic>)
          : null,
    );
  }
}

class MfuPortfolioItemModel {
  final String? schemeCode;
  final String? fundName;
  final String? investmentType;
  final double? investedAmount;
  final double? totalUnits;
  final double? currentNav;
  final double? currentValue;
  final double? gainLoss;
  final double? gainLossPercent;

  MfuPortfolioItemModel({
    this.schemeCode,
    this.fundName,
    this.investmentType,
    this.investedAmount,
    this.totalUnits,
    this.currentNav,
    this.currentValue,
    this.gainLoss,
    this.gainLossPercent,
  });

  factory MfuPortfolioItemModel.fromJson(Map<String, dynamic> json) {
    return MfuPortfolioItemModel(
      schemeCode: json.parse<String>('scheme_code'),
      fundName: json.parse<String>('fund_name'),
      investmentType: json.parse<String>('investment_type'),
      investedAmount: json.parse<double>('invested_amount'),
      totalUnits: json.parse<double>('total_units'),
      currentNav: json.parse<double>('current_nav'),
      currentValue: json.parse<double>('current_value'),
      gainLoss: json.parse<double>('gain_loss'),
      gainLossPercent: json.parse<double>('gain_loss_percent'),
    );
  }
}

class MfuPortfolioSummaryModel {
  final double? totalInvested;
  final double? totalCurrentValue;
  final double? totalGainLoss;

  MfuPortfolioSummaryModel({
    this.totalInvested,
    this.totalCurrentValue,
    this.totalGainLoss,
  });

  factory MfuPortfolioSummaryModel.fromJson(Map<String, dynamic> json) {
    return MfuPortfolioSummaryModel(
      totalInvested: json.parse<double>('total_invested'),
      totalCurrentValue: json.parse<double>('total_current_value'),
      totalGainLoss: json.parse<double>('total_gain_loss'),
    );
  }
}