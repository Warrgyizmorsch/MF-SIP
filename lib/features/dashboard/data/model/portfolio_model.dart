// // features/mfu/data/model/mfu_portfolio_model.dart

// import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

// class MfuPortfolioModel {
//   final bool? success;
//   final List<MfuPortfolioItemModel>? portfolio;
//   final MfuPortfolioSummaryModel? summary;

//   MfuPortfolioModel({this.success, this.portfolio, this.summary});

//   factory MfuPortfolioModel.fromJson(Map<String, dynamic> json) {
//     return MfuPortfolioModel(
//       success: json.parse<bool>('success'),
//       portfolio: json.parseListOf<MfuPortfolioItemModel>(
//         'portfolio',
//         (item) => MfuPortfolioItemModel.fromJson(item as Map<String, dynamic>),
//       ),
//       summary: json['summary'] != null
//           ? MfuPortfolioSummaryModel.fromJson(
//               json['summary'] as Map<String, dynamic>,
//             )
//           : null,
//     );
//   }
// }

// class MfuPortfolioItemModel {
//   final String? schemeCode;
//   final String? fundName;
//   final String? investmentType;
//   final double? investedAmount;
//   final double? totalUnits;
//   final double? currentNav;
//   final double? currentValue;
//   final double? gainLoss;
//   final double? gainLossPercent;

//   MfuPortfolioItemModel({
//     this.schemeCode,
//     this.fundName,
//     this.investmentType,
//     this.investedAmount,
//     this.totalUnits,
//     this.currentNav,
//     this.currentValue,
//     this.gainLoss,
//     this.gainLossPercent,
//   });

//   factory MfuPortfolioItemModel.fromJson(Map<String, dynamic> json) {
//     return MfuPortfolioItemModel(
//       schemeCode: json.parse<String>('scheme_code'),
//       fundName: json.parse<String>('fund_name'),
//       investmentType: json.parse<String>('investment_type'),
//       investedAmount: json.parse<double>('invested_amount'),
//       totalUnits: json.parse<double>('total_units'),
//       currentNav: json.parse<double>('current_nav'),
//       currentValue: json.parse<double>('current_value'),
//       gainLoss: json.parse<double>('gain_loss'),
//       gainLossPercent: json.parse<double>('gain_loss_percent'),
//     );
//   }
// }

// class MfuPortfolioSummaryModel {
//   final double? totalInvested;
//   final double? totalCurrentValue;
//   final double? totalGainLoss;

//   MfuPortfolioSummaryModel({
//     this.totalInvested,
//     this.totalCurrentValue,
//     this.totalGainLoss,
//   });

//   factory MfuPortfolioSummaryModel.fromJson(Map<String, dynamic> json) {
//     return MfuPortfolioSummaryModel(
//       totalInvested: json.parse<double>('total_invested'),
//       // totalCurrentValue: json.parse<double>('total_current_value'),
//       totalCurrentValue: json.parse<double>('current_value'),
//       // totalGainLoss: json.parse<double>('total_gain_loss'),
//       totalGainLoss: json.parse<double>('total_returns'),
//     );
//   }
// }
import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

class MfuPortfolioModel {
  final bool? success;
  final List<MfuPortfolioItemModel>? portfolio;
  final MfuPortfolioSummaryModel? summary;
  final MfuPortfolioUserModel? user;
  final MfuPortfolioPaginationModel? pagination;

  MfuPortfolioModel({
    this.success,
    this.portfolio,
    this.summary,
    this.user,
    this.pagination,
  });

  factory MfuPortfolioModel.fromJson(Map<String, dynamic> json) {
    return MfuPortfolioModel(
      success: json.parse<bool>('success'),
      portfolio: json.parseListOf<MfuPortfolioItemModel>(
        'portfolio',
        (item) => MfuPortfolioItemModel.fromJson(item as Map<String, dynamic>),
      ),
      summary: json['summary'] != null
          ? MfuPortfolioSummaryModel.fromJson(
              json['summary'] as Map<String, dynamic>,
            )
          : null,
      user: json['user'] != null
          ? MfuPortfolioUserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      pagination: json['pagination'] != null
          ? MfuPortfolioPaginationModel.fromJson(
              json['pagination'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class MfuPortfolioUserModel {
  final int? id;
  final String? name;
  final String? image;

  MfuPortfolioUserModel({this.id, this.name, this.image});

  factory MfuPortfolioUserModel.fromJson(Map<String, dynamic> json) {
    return MfuPortfolioUserModel(
      id: json.parse<int>('id'),
      name: json.parse<String>('name'),
      image: json.parse<String>('image'),
    );
  }
}

class MfuPortfolioPaginationModel {
  final int? currentPage;
  final int? perPage;
  final int? total;
  final int? lastPage;
  final bool? hasMore;

  MfuPortfolioPaginationModel({
    this.currentPage,
    this.perPage,
    this.total,
    this.lastPage,
    this.hasMore,
  });

  factory MfuPortfolioPaginationModel.fromJson(Map<String, dynamic> json) {
    return MfuPortfolioPaginationModel(
      currentPage: json.parse<int>('current_page'),
      perPage: json.parse<int>('per_page'),
      total: json.parse<int>('total'),
      lastPage: json.parse<int>('last_page'),
      hasMore: json.parse<bool>('has_more'),
    );
  }
}

class MfuPortfolioItemModel {
  final String? schemeCode;
  final String? fundName;
  final String? amcName;
  final String? amcCode;
  final String? amcLogo;
  final String? investmentType;
  final double? investedAmount;
  final double? totalUnits;
  final double? purchaseNav;
  final double? averagePurchaseNav;
  final double? currentNav;
  final double? currentValue;
  final double? gainLoss;
  final double? gainLossPercent;
  final double? oneDayChange;
  final double? oneDayChangePercent;
  final String? folioNo;
  final String? purchaseDate;
  final String? lastTransactionDate;
  final int? mfuOrderFundId;

  MfuPortfolioItemModel({
    this.schemeCode,
    this.fundName,
    this.amcName,
    this.amcCode,
    this.amcLogo,
    this.investmentType,
    this.investedAmount,
    this.totalUnits,
    this.purchaseNav,
    this.averagePurchaseNav,
    this.currentNav,
    this.currentValue,
    this.gainLoss,
    this.gainLossPercent,
    this.oneDayChange,
    this.oneDayChangePercent,
    this.folioNo,
    this.purchaseDate,
    this.lastTransactionDate,
    this.mfuOrderFundId,
  });

  factory MfuPortfolioItemModel.fromJson(Map<String, dynamic> json) {
    final String? parsedLogo =
        json.parse<String>('amc_logo') ?? json.parse<String>('amc_image_url');

    final String? parsedType =
        json.parse<String>('type') ?? json.parse<String>('investment_type');

    final double? parsedInvested =
        json.parse<double>('invested_amount') ??
        json.parse<double>('fund_invested');

    return MfuPortfolioItemModel(
      schemeCode: json['scheme_code']?.toString(),
      fundName: json.parse<String>('fund_name'),
      amcName: json.parse<String>('amc_name'),
      amcCode: json.parse<String>('amc_code'),
      amcLogo: parsedLogo,
      investmentType: parsedType,
      investedAmount: parsedInvested,
      totalUnits: json.parse<double>('total_units'),
      purchaseNav: json.parse<double>('purchase_nav'),
      averagePurchaseNav: json.parse<double>('average_purchase_nav'),
      currentNav: json.parse<double>('current_nav'),
      currentValue: json.parse<double>('current_value'),
      gainLoss: json.parse<double>('gain_loss'),
      gainLossPercent: json.parse<double>('gain_loss_percent'),
      oneDayChange: json.parse<double>('one_day_change'),
      oneDayChangePercent: json.parse<double>('one_day_change_percent'),
      folioNo: json.parse<String>('folio_no'),
      purchaseDate: json.parse<String>('purchase_date'),
      lastTransactionDate: json.parse<String>('last_transaction_date'),
      mfuOrderFundId: json.parse<int>('mfu_order_fund_id'),
    );
  }
}

class MfuPortfolioSummaryModel {
  final double? totalInvested;
  final double? totalCurrentValue;
  final double? totalGainLoss;
  final double? totalGainLossPercent;
  final MfuPortfolioDisplayModel? display;

  MfuPortfolioSummaryModel({
    this.totalInvested,
    this.totalCurrentValue,
    this.totalGainLoss,
    this.totalGainLossPercent,
    this.display,
  });

  factory MfuPortfolioSummaryModel.fromJson(Map<String, dynamic> json) {
    return MfuPortfolioSummaryModel(
      totalCurrentValue: json.parse<double>('current_value'),
      totalInvested: json.parse<double>('total_invested'),
      totalGainLoss:
          json.parse<double>('total_returns') ??
          json.parse<double>('total_gain_loss'),
      totalGainLossPercent:
          json.parse<double>('total_returns_percent') ??
          json.parse<double>('total_gain_loss_percent'),
      display: json['display'] != null
          ? MfuPortfolioDisplayModel.fromJson(
              json['display'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class MfuPortfolioDisplayModel {
  final String? currentValue;
  final String? totalInvested;
  final String? totalReturns;
  final String? totalReturnsPercent;

  MfuPortfolioDisplayModel({
    this.currentValue,
    this.totalInvested,
    this.totalReturns,
    this.totalReturnsPercent,
  });

  factory MfuPortfolioDisplayModel.fromJson(Map<String, dynamic> json) {
    return MfuPortfolioDisplayModel(
      currentValue: json.parse<String>('current_value'),
      totalInvested: json.parse<String>('total_invested'),
      totalReturns: json.parse<String>('total_returns'),
      totalReturnsPercent: json.parse<String>('total_returns_percent'),
    );
  }
}
