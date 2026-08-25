// // features/mfu/domain/entity/mfu_portfolio_entity.dart

// import 'package:equatable/equatable.dart';
// import 'package:my_sip/features/dashboard/data/model/portfolio_model.dart';

// class MfuPortfolioEntity extends Equatable {
//   final bool success;
//   final List<MfuPortfolioItemEntity> portfolio;
//   final MfuPortfolioSummaryEntity? summary;

//   const MfuPortfolioEntity({
//     required this.success,
//     required this.portfolio,
//     this.summary,
//   });

//   bool get isEmpty => portfolio.isEmpty;
//   int get totalFunds => portfolio.length;

//   List<MfuPortfolioItemEntity> get sipFunds =>
//       portfolio.where((p) => p.isSip).toList();

//   List<MfuPortfolioItemEntity> get lumpsumFunds =>
//       portfolio.where((p) => p.isLumpsum).toList();

//   List<MfuPortfolioItemEntity> get profitFunds =>
//       portfolio.where((p) => p.isProfit).toList();

//   List<MfuPortfolioItemEntity> get lossFunds =>
//       portfolio.where((p) => p.isLoss).toList();

//   @override
//   List<Object?> get props => [success, portfolio, summary];
// }

// class MfuPortfolioItemEntity extends Equatable {
//   final String schemeCode;
//   final String fundName;
//   final String investmentType;
//   final double investedAmount;
//   final double totalUnits;
//   final double currentNav;
//   final double currentValue;
//   final double gainLoss;
//   final double gainLossPercent;

//   const MfuPortfolioItemEntity({
//     required this.schemeCode,
//     required this.fundName,
//     required this.investmentType,
//     required this.investedAmount,
//     required this.totalUnits,
//     required this.currentNav,
//     required this.currentValue,
//     required this.gainLoss,
//     required this.gainLossPercent,
//   });

//   bool get isSip => investmentType.toLowerCase() == 'sip';
//   bool get isLumpsum => investmentType.toLowerCase() == 'lumpsum';
//   bool get isProfit => gainLoss > 0;
//   bool get isLoss => gainLoss < 0;

//   @override
//   List<Object?> get props => [
//         schemeCode, fundName, investmentType, investedAmount,
//         totalUnits, currentNav, currentValue, gainLoss, gainLossPercent,
//       ];
// }

// class MfuPortfolioSummaryEntity extends Equatable {
//   final double totalInvested;
//   final double totalCurrentValue;
//   final double totalGainLoss;

//   const MfuPortfolioSummaryEntity({
//     required this.totalInvested,
//     required this.totalCurrentValue,
//     required this.totalGainLoss,
//   });

//   bool get isOverallProfit => totalGainLoss > 0;
//   bool get isOverallLoss => totalGainLoss < 0;

//   double get totalGainLossPercent => totalInvested > 0
//       ? (totalGainLoss / totalInvested) * 100
//       : 0.0;

//   @override
//   List<Object?> get props => [totalInvested, totalCurrentValue, totalGainLoss];
// }

// // ─── Mappers ──────────────────────────────────────────────────────────────────

// extension MfuPortfolioMapper on MfuPortfolioModel {
//   MfuPortfolioEntity toEntity() {
//     return MfuPortfolioEntity(
//       success: success ?? false,
//       portfolio: portfolio?.map((e) => e.toEntity()).toList() ?? [],
//       summary: summary?.toEntity(),
//     );
//   }
// }

// extension MfuPortfolioItemMapper on MfuPortfolioItemModel {
//   MfuPortfolioItemEntity toEntity() {
//     return MfuPortfolioItemEntity(
//       schemeCode: schemeCode ?? '',
//       fundName: fundName ?? '',
//       investmentType: investmentType ?? '',
//       investedAmount: investedAmount ?? 0.0,
//       totalUnits: totalUnits ?? 0.0,
//       currentNav: currentNav ?? 0.0,
//       currentValue: currentValue ?? 0.0,
//       gainLoss: gainLoss ?? 0.0,
//       gainLossPercent: gainLossPercent ?? 0.0,
//     );
//   }
// }

// extension MfuPortfolioSummaryMapper on MfuPortfolioSummaryModel {
//   MfuPortfolioSummaryEntity toEntity() {
//     return MfuPortfolioSummaryEntity(
//       totalInvested: totalInvested ?? 0.0,
//       totalCurrentValue: totalCurrentValue ?? 0.0,
//       totalGainLoss: totalGainLoss ?? 0.0,
//     );
//   }
// }
import 'package:equatable/equatable.dart';
import 'package:my_sip/features/dashboard/data/model/portfolio_model.dart';

class MfuPortfolioEntity extends Equatable {
  final bool success;
  final List<MfuPortfolioItemEntity> portfolio;
  final MfuPortfolioSummaryEntity summary;

  const MfuPortfolioEntity({
    required this.success,
    required this.portfolio,
    required this.summary,
  });

  int get totalFunds => portfolio.length;

  List<MfuPortfolioItemEntity> get sipFunds =>
      portfolio.where((f) => f.investmentType.toLowerCase() == 'sip').toList();

  List<MfuPortfolioItemEntity> get lumpsumFunds => portfolio
      .where(
        (f) =>
            f.investmentType.toLowerCase() == 'lumpsum' ||
            f.investmentType.toLowerCase() == 'normal',
      )
      .toList();

  @override
  List<Object?> get props => [success, portfolio, summary];
}

class MfuRedemptionDetailsEntity extends Equatable {
  final String orderRefNo;
  final String gorn;
  final double amount;
  final String requestedDate;
  final String status;
  final String statusCode;
  final String estimatedPayoutDays;
  final String message;

  const MfuRedemptionDetailsEntity({
    required this.orderRefNo,
    required this.gorn,
    required this.amount,
    required this.requestedDate,
    required this.status,
    required this.statusCode,
    required this.estimatedPayoutDays,
    required this.message,
  });

  @override
  List<Object?> get props => [
    orderRefNo,
    gorn,
    amount,
    requestedDate,
    status,
    statusCode,
    estimatedPayoutDays,
    message,
  ];
}

class MfuPortfolioItemEntity extends Equatable {
  final String schemeCode;
  final String fundName;
  final String amcName;
  final String amcLogo;
  final String investmentType;
  final double investedAmount;
  final double totalUnits;
  final double currentNav;
  final double currentValue;
  final double gainLoss;
  final double gainLossPercent;
  final double oneDayChange;
  final double oneDayChangePercent;
  final String folioNo;
  final String lastTransactionDate;
  final String navDate;
  final double navChange;
  final String allotmentStatus;
  final String unitStatus;
  final String allotmentStatusLabel;
  final String allotmentMessage;
  final bool isUnitAllotted;
  final dynamic mfuOrderFundId;
  final bool hasPendingRedemption;
  final String redemptionStatus;
  final String redemptionMessage;
  final MfuRedemptionDetailsEntity? redemptionDetails;

  const MfuPortfolioItemEntity({
    required this.schemeCode,
    required this.fundName,
    required this.amcName,
    required this.amcLogo,
    required this.investmentType,
    required this.investedAmount,
    this.totalUnits = 0.0,
    required this.currentNav,
    required this.currentValue,
    required this.gainLoss,
    required this.gainLossPercent,
    required this.oneDayChange,
    required this.oneDayChangePercent,
    required this.folioNo,
    required this.lastTransactionDate,
    this.navDate = '',
    this.navChange = 0.0,
    this.allotmentStatus = '',
    this.unitStatus = '',
    this.allotmentStatusLabel = '',
    this.allotmentMessage = '',
    this.isUnitAllotted = true,
    this.mfuOrderFundId,
    this.hasPendingRedemption = false,
    this.redemptionStatus = '',
    this.redemptionMessage = '',
    this.redemptionDetails,
  });

  // Computed properties for easy UI styling
  bool get isProfit => gainLoss >= 0;
  bool get isOneDayProfit => oneDayChange >= 0;
  bool get isSip => investmentType.toLowerCase() == 'sip';
  bool get isLumpsum =>
      investmentType.toLowerCase() == 'lumpsum' ||
      investmentType.toLowerCase() == 'normal' ||
      investmentType.toLowerCase() == 'lump-sum';

  @override
  List<Object?> get props => [
    schemeCode,
    fundName,
    amcName,
    amcLogo,
    investmentType,
    investedAmount,
    totalUnits,
    currentNav,
    currentValue,
    gainLoss,
    gainLossPercent,
    oneDayChange,
    oneDayChangePercent,
    folioNo,
    lastTransactionDate,
    navDate,
    navChange,
    allotmentStatus,
    unitStatus,
    allotmentStatusLabel,
    allotmentMessage,
    isUnitAllotted,
    mfuOrderFundId,
    hasPendingRedemption,
    redemptionStatus,
    redemptionMessage,
    redemptionDetails,
  ];
}

class MfuPortfolioSummaryEntity extends Equatable {
  final double totalInvested;
  final double totalCurrentValue;
  final double totalGainLoss;
  final double totalGainLossPercent;

  const MfuPortfolioSummaryEntity({
    required this.totalInvested,
    required this.totalCurrentValue,
    required this.totalGainLoss,
    required this.totalGainLossPercent,
  });

  // Computed property for UI styling (green/red)
  bool get isOverallProfit => totalGainLoss >= 0;

  @override
  List<Object?> get props => [
    totalInvested,
    totalCurrentValue,
    totalGainLoss,
    totalGainLossPercent,
  ];
}

// Import your model and entity files here

extension MfuPortfolioModelMapper on MfuPortfolioModel {
  MfuPortfolioEntity toEntity() {
    return MfuPortfolioEntity(
      success: success ?? false,
      portfolio: portfolio?.map((e) => e.toEntity()).toList() ?? [],
      // Provide a safe default empty summary if the API returns null
      summary:
          summary?.toEntity() ??
          const MfuPortfolioSummaryEntity(
            totalInvested: 0.0,
            totalCurrentValue: 0.0,
            totalGainLoss: 0.0,
            totalGainLossPercent: 0.0,
          ),
    );
  }
}

extension MfuRedemptionDetailsMapper on MfuRedemptionDetailsModel {
  MfuRedemptionDetailsEntity toEntity() {
    return MfuRedemptionDetailsEntity(
      orderRefNo: orderRefNo ?? '',
      gorn: gorn ?? '',
      amount: amount ?? 0.0,
      requestedDate: requestedDate ?? '',
      status: status ?? '',
      statusCode: statusCode ?? '',
      estimatedPayoutDays: estimatedPayoutDays ?? '',
      message: message ?? '',
    );
  }
}

extension MfuPortfolioItemMapper on MfuPortfolioItemModel {
  MfuPortfolioItemEntity toEntity() {
    return MfuPortfolioItemEntity(
      schemeCode: schemeCode ?? '',
      fundName: fundName ?? 'Unknown Fund',
      amcName: amcName ?? 'Unknown AMC',
      amcLogo: amcLogo ?? '',
      investmentType: investmentType ?? 'normal',
      investedAmount: investedAmount ?? 0.0,
      totalUnits: totalUnits ?? 0.0,
      currentNav: currentNav ?? 0.0,
      currentValue: currentValue ?? 0.0,
      gainLoss: gainLoss ?? 0.0,
      gainLossPercent: gainLossPercent ?? 0.0,
      oneDayChange: oneDayChange ?? 0.0,
      oneDayChangePercent: oneDayChangePercent ?? 0.0,
      folioNo: folioNo ?? 'NEW',
      lastTransactionDate: lastTransactionDate ?? '',
      navDate: navDate ?? '',
      navChange: navChange ?? 0.0,
      allotmentStatus: allotmentStatus ?? '',
      unitStatus: unitStatus ?? '',
      allotmentStatusLabel: allotmentStatusLabel ?? '',
      allotmentMessage: allotmentMessage ?? '',
      isUnitAllotted: isUnitAllotted ?? true,
      mfuOrderFundId: mfuOrderFundId,
      hasPendingRedemption: hasPendingRedemption ?? false,
      redemptionStatus: redemptionStatus ?? '',
      redemptionMessage: redemptionMessage ?? '',
      redemptionDetails: redemptionDetails?.toEntity(),
    );
  }
}

extension MfuPortfolioSummaryMapper on MfuPortfolioSummaryModel {
  MfuPortfolioSummaryEntity toEntity() {
    return MfuPortfolioSummaryEntity(
      totalInvested: totalInvested ?? 0.0,
      totalCurrentValue: totalCurrentValue ?? 0.0,
      totalGainLoss: totalGainLoss ?? 0.0,
      totalGainLossPercent: totalGainLossPercent ?? 0.0,
    );
  }
}
