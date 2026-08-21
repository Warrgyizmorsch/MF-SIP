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

class MfuRedemptionDetailsModel {
  final String? orderRefNo;
  final String? gorn;
  final double? amount;
  final String? requestedDate;
  final String? status;
  final String? statusCode;
  final String? estimatedPayoutDays;
  final String? message;

  MfuRedemptionDetailsModel({
    this.orderRefNo,
    this.gorn,
    this.amount,
    this.requestedDate,
    this.status,
    this.statusCode,
    this.estimatedPayoutDays,
    this.message,
  });

  factory MfuRedemptionDetailsModel.fromJson(Map<String, dynamic> json) {
    return MfuRedemptionDetailsModel(
      orderRefNo: json.parse<String>('order_ref_no'),
      gorn: json.parse<String>('gorn'),
      amount: json.parse<double>('amount'),
      requestedDate: json.parse<String>('requested_date'),
      status: json.parse<String>('status'),
      statusCode: json.parse<String>('status_code'),
      estimatedPayoutDays: json.parse<String>('estimated_payout_days'),
      message: json.parse<String>('message'),
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
  final String? navDate;
  final double? navChange;
  final int? mfuOrderFundId;
  final bool? hasPendingRedemption;
  final String? redemptionStatus;
  final String? redemptionMessage;
  final MfuRedemptionDetailsModel? redemptionDetails;

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
    this.navDate,
    this.navChange,
    this.mfuOrderFundId,
    this.hasPendingRedemption,
    this.redemptionStatus,
    this.redemptionMessage,
    this.redemptionDetails,
  });

  factory MfuPortfolioItemModel.fromJson(Map<String, dynamic> json) {
    final String? parsedLogo =
        json.parse<String>('amc_logo') ?? json.parse<String>('amc_image_url');

    final String? parsedType =
        json.parse<String>('type') ?? json.parse<String>('investment_type');

    final double? parsedInvested =
        json.parse<double>('invested_amount') ??
        json.parse<double>('fund_invested');

    final String? parsedFolio =
        json.parse<String>('folio_no') ?? json.parse<String>('folio');

    final double? parsedUnits =
        json.parse<double>('total_units') ?? json.parse<double>('units');

    final double? parsedPurchaseNav =
        json.parse<double>('purchase_nav') ??
        json.parse<double>('invested_nav') ??
        json.parse<double>('average_nav') ??
        json.parse<double>('latest_purchase_nav');

    final double? parsedCurrentNav =
        json.parse<double>('current_nav') ?? json.parse<double>('nav');

    final double? parsed1DChange =
        json.parse<double>('one_day_change') ??
        json.parse<double>('day_change') ??
        json.parse<double>('one_day_return');

    final double? parsed1DChangePercent =
        json.parse<double>('one_day_change_percent') ??
        json.parse<double>('day_change_percent') ??
        json.parse<double>('one_day_return_percent');

    final String? parsedDate =
        json.parse<String>('purchase_date') ??
        json.parse<String>('invested_date') ??
        json.parse<String>('investment_date') ??
        json.parse<String>('latest_invested_date');

    return MfuPortfolioItemModel(
      schemeCode: json['scheme_code']?.toString(),
      fundName: json.parse<String>('fund_name'),
      amcName: json.parse<String>('amc_name'),
      amcCode: json.parse<String>('amc_code'),
      amcLogo: parsedLogo,
      investmentType: parsedType,
      investedAmount: parsedInvested,
      totalUnits: parsedUnits,
      purchaseNav: parsedPurchaseNav,
      averagePurchaseNav: parsedPurchaseNav,
      currentNav: parsedCurrentNav,
      currentValue: json.parse<double>('current_value'),
      gainLoss: json.parse<double>('gain_loss'),
      gainLossPercent: json.parse<double>('gain_loss_percent'),
      oneDayChange: parsed1DChange,
      oneDayChangePercent: parsed1DChangePercent,
      folioNo: parsedFolio,
      purchaseDate: parsedDate,
      lastTransactionDate: json.parse<String>('last_transaction_date'),
      navDate: json.parse<String>('nav_date'),
      navChange: json.parse<double>('nav_change'),
      mfuOrderFundId: json.parse<int>('mfu_order_fund_id'),
      hasPendingRedemption: json.parse<bool>('has_pending_redemption'),
      redemptionStatus: json.parse<String>('redemption_status'),
      redemptionMessage: json.parse<String>('redemption_message'),
      redemptionDetails: json['redemption_details'] != null
          ? MfuRedemptionDetailsModel.fromJson(
              json['redemption_details'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class MfuPortfolioSummaryModel {
  final double? totalInvested;
  final double? totalCurrentValue;
  final double? totalGainLoss;
  final double? totalGainLossPercent;
  final double? oneDayReturns;
  final double? oneDayReturnsPercent;
  final MfuPortfolioDisplayModel? display;

  MfuPortfolioSummaryModel({
    this.totalInvested,
    this.totalCurrentValue,
    this.totalGainLoss,
    this.totalGainLossPercent,
    this.oneDayReturns,
    this.oneDayReturnsPercent,
    this.display,
  });

  factory MfuPortfolioSummaryModel.fromJson(Map<String, dynamic> json) {
    final double? parsed1DReturns =
        json.parse<double>('one_day_returns') ??
        json.parse<double>('one_day_return') ??
        json.parse<double>('one_day_change');

    final double? parsed1DReturnsPercent =
        json.parse<double>('one_day_returns_percent') ??
        json.parse<double>('one_day_change_percent');

    return MfuPortfolioSummaryModel(
      totalCurrentValue: json.parse<double>('current_value'),
      totalInvested: json.parse<double>('total_invested'),
      totalGainLoss:
          json.parse<double>('total_returns') ??
          json.parse<double>('total_gain_loss'),
      totalGainLossPercent:
          json.parse<double>('total_returns_percent') ??
          json.parse<double>('total_gain_loss_percent'),
      oneDayReturns: parsed1DReturns,
      oneDayReturnsPercent: parsed1DReturnsPercent,
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
  final String? oneDayReturns;
  final String? oneDayReturnsPercent;

  MfuPortfolioDisplayModel({
    this.currentValue,
    this.totalInvested,
    this.totalReturns,
    this.totalReturnsPercent,
    this.oneDayReturns,
    this.oneDayReturnsPercent,
  });

  factory MfuPortfolioDisplayModel.fromJson(Map<String, dynamic> json) {
    return MfuPortfolioDisplayModel(
      currentValue: json.parse<String>('current_value'),
      totalInvested: json.parse<String>('total_invested'),
      totalReturns: json.parse<String>('total_returns'),
      totalReturnsPercent: json.parse<String>('total_returns_percent'),
      oneDayReturns: json.parse<String>('one_day_returns'),
      oneDayReturnsPercent: json.parse<String>('one_day_returns_percent'),
    );
  }
}
