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
  final MfuPortfolioUserEntity? user;
  final MfuPortfolioPaginationEntity? pagination;

  const MfuPortfolioEntity({
    required this.success,
    required this.portfolio,
    required this.summary,
    this.user,
    this.pagination,
  });

  int get totalFunds => portfolio.length;

  MfuPortfolioEntity copyWith({
    List<MfuPortfolioItemEntity>? portfolio,
    MfuPortfolioSummaryEntity? summary,
    MfuPortfolioUserEntity? user,
    MfuPortfolioPaginationEntity? pagination,
  }) => MfuPortfolioEntity(
    success: success,
    portfolio: portfolio ?? this.portfolio,
    summary: summary ?? this.summary,
    user: user ?? this.user,
    pagination: pagination ?? this.pagination,
  );

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
  List<Object?> get props => [success, portfolio, summary, user, pagination];
}

class MfuRedemptionDetailsEntity extends Equatable {
  final String orderRefNo;
  final String gorn;
  final double amount;
  final double units;
  final String transactionVolumeType;
  final String requestedDate;
  final String status;
  final String statusLabel;
  final String orderStatusLabel;
  final String statusCode;
  final String estimatedPayoutDays;
  final String message;

  const MfuRedemptionDetailsEntity({
    required this.orderRefNo,
    required this.gorn,
    required this.amount,
    this.units = 0.0,
    this.transactionVolumeType = '',
    required this.requestedDate,
    required this.status,
    this.statusLabel = '',
    this.orderStatusLabel = '',
    required this.statusCode,
    required this.estimatedPayoutDays,
    required this.message,
  });

  @override
  List<Object?> get props => [
    orderRefNo,
    gorn,
    amount,
    units,
    transactionVolumeType,
    requestedDate,
    status,
    statusLabel,
    orderStatusLabel,
    statusCode,
    estimatedPayoutDays,
    message,
  ];
}

class SipCancellationDetailsEntity extends Equatable {
  final String status;
  final String statusCode;
  final String orderRefNo;
  final String message;
  final String cancelledDate;

  const SipCancellationDetailsEntity({
    this.status = '',
    this.statusCode = '',
    this.orderRefNo = '',
    this.message = '',
    this.cancelledDate = '',
  });

  @override
  List<Object?> get props => [
    status,
    statusCode,
    orderRefNo,
    message,
    cancelledDate,
  ];
}

class MfuPortfolioUserEntity extends Equatable {
  final int id;
  final String name;
  final String image;

  const MfuPortfolioUserEntity({this.id = 0, this.name = '', this.image = ''});

  @override
  List<Object?> get props => [id, name, image];
}

class MfuPortfolioPaginationEntity extends Equatable {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final bool hasMore;

  const MfuPortfolioPaginationEntity({
    this.currentPage = 1,
    this.perPage = 20,
    this.total = 0,
    this.lastPage = 1,
    this.hasMore = false,
  });

  @override
  List<Object?> get props => [currentPage, perPage, total, lastPage, hasMore];
}

class MfuExitLoadLotEntity extends Equatable {
  final String allotmentDate;
  final double units;
  final double amount;
  final double ratePercent;
  final double exitLoadAmount;
  final int daysHeld;

  const MfuExitLoadLotEntity({
    this.allotmentDate = '',
    this.units = 0.0,
    this.amount = 0.0,
    this.ratePercent = 0.0,
    this.exitLoadAmount = 0.0,
    this.daysHeld = 0,
  });

  @override
  List<Object?> get props => [
    allotmentDate,
    units,
    amount,
    ratePercent,
    exitLoadAmount,
    daysHeld,
  ];
}

class MfuExitLoadDataEntity extends Equatable {
  final bool success;
  final String schemeCode;
  final String fundName;
  final String folio;
  final double currentNav;
  final double grossAmount;
  final double units;
  final double exitLoadAmount;
  final double netEstimatedPayout;
  final double ratePercent;
  final String rateFormatted;
  final bool isApplicable;
  final int daysHeld;
  final int thresholdDays;
  final int daysRemainingForNil;
  final String freeDate;
  final String freeDateFormatted;
  final String statusBadge;
  final String summaryText;
  final String smartTip;
  final String rawRule;
  final int lotsCount;
  final List<MfuExitLoadLotEntity> lotsBreakdown;
  final String disclaimer;

  const MfuExitLoadDataEntity({
    this.success = false,
    this.schemeCode = '',
    this.fundName = '',
    this.folio = '',
    this.currentNav = 0.0,
    this.grossAmount = 0.0,
    this.units = 0.0,
    this.exitLoadAmount = 0.0,
    this.netEstimatedPayout = 0.0,
    this.ratePercent = 0.0,
    this.rateFormatted = '',
    this.isApplicable = false,
    this.daysHeld = 0,
    this.thresholdDays = 0,
    this.daysRemainingForNil = 0,
    this.freeDate = '',
    this.freeDateFormatted = '',
    this.statusBadge = '',
    this.summaryText = '',
    this.smartTip = '',
    this.rawRule = '',
    this.lotsCount = 0,
    this.lotsBreakdown = const [],
    this.disclaimer = '',
  });

  @override
  List<Object?> get props => [
    success,
    schemeCode,
    fundName,
    folio,
    currentNav,
    grossAmount,
    units,
    exitLoadAmount,
    netEstimatedPayout,
    ratePercent,
    rateFormatted,
    isApplicable,
    daysHeld,
    thresholdDays,
    daysRemainingForNil,
    freeDate,
    freeDateFormatted,
    statusBadge,
    summaryText,
    smartTip,
    rawRule,
    lotsCount,
    lotsBreakdown,
    disclaimer,
  ];
}

class MfuPortfolioDisplayEntity extends Equatable {
  final String currentValue;
  final String totalInvested;
  final String totalReturns;
  final String totalReturnsPercent;
  final String oneDayReturns;
  final String oneDayReturnsPercent;

  const MfuPortfolioDisplayEntity({
    this.currentValue = '',
    this.totalInvested = '',
    this.totalReturns = '',
    this.totalReturnsPercent = '',
    this.oneDayReturns = '',
    this.oneDayReturnsPercent = '',
  });

  @override
  List<Object?> get props => [
    currentValue,
    totalInvested,
    totalReturns,
    totalReturnsPercent,
    oneDayReturns,
    oneDayReturnsPercent,
  ];
}

class MfuFundTransactionEntity extends Equatable {
  final int id;
  final String date;
  final String displayDate;
  final String type;
  final String investmentType;
  final String schemeCode;
  final String fundName;
  final String amcName;
  final String folioNo;
  final double amount;
  final double units;
  final double nav;
  final String status;
  final String statusLabel;
  final String orderStatus;
  final String orderStatusLabel;
  final String mfuGorn;
  final String mfuItrn;
  final String direction;
  final String displayAmount;
  final String displayUnits;

  const MfuFundTransactionEntity({
    this.id = 0,
    this.date = '',
    this.displayDate = '',
    this.type = '',
    this.investmentType = '',
    this.schemeCode = '',
    this.fundName = '',
    this.amcName = '',
    this.folioNo = '',
    this.amount = 0.0,
    this.units = 0.0,
    this.nav = 0.0,
    this.status = '',
    this.statusLabel = '',
    this.orderStatus = '',
    this.orderStatusLabel = '',
    this.mfuGorn = '',
    this.mfuItrn = '',
    this.direction = '',
    this.displayAmount = '',
    this.displayUnits = '',
  });

  bool get isCredit => direction.toLowerCase() == 'credit';
  bool get isDebit => direction.toLowerCase() == 'debit';
  bool get isSuccess =>
      status.toLowerCase() == 'processed' ||
      status.toLowerCase() == 'settled' ||
      orderStatus.toLowerCase() == 'rp';

  @override
  List<Object?> get props => [
    id,
    date,
    displayDate,
    type,
    investmentType,
    schemeCode,
    fundName,
    amcName,
    folioNo,
    amount,
    units,
    nav,
    status,
    statusLabel,
    orderStatus,
    orderStatusLabel,
    mfuGorn,
    mfuItrn,
    direction,
    displayAmount,
    displayUnits,
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
  final double purchaseNav;
  final String purchaseDate;
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
  final int? mfuOrderId;
  final int? goalId;
  final String? goalName;
  final bool hasPendingRedemption;
  final String redemptionStatus;
  final String redemptionMessage;
  final MfuRedemptionDetailsEntity? redemptionDetails;
  final double redeemedAmount;
  final double redeemedUnits;
  final bool isSipFlag;
  final String sipStatus;
  final bool isSipCancelled;
  final bool hasPendingSipCancellation;
  final SipCancellationDetailsEntity? sipCancellationDetails;
  final String latestOrderStatus;
  final String latestOrderStatusLabel;
  final String exitLoad;
  final MfuExitLoadDataEntity? exitLoadData;
  final double exitLoadAmount;
  final double exitLoadRate;
  final String exitLoadRateFormatted;
  final int exitLoadDaysRemaining;
  final String exitLoadFreeDate;
  final String exitLoadFreeDateFormatted;
  final String exitLoadStatusBadge;
  final String exitLoadSmartTip;
  final bool isRedeemed;
  final String holdingStatus;
  final String firstInvestedDate;
  final String latestInvestedDate;
  final double latestPurchaseNav;
  final String sipFrequency;
  final String sipFrequencyType;
  final String sipDay;
  final String nextSipDate;
  final int totalInstallments;
  final List<MfuFundTransactionEntity> transactions;

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
    this.purchaseNav = 0.0,
    this.purchaseDate = '',
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
    this.mfuOrderId,
    this.goalId,
    this.goalName,
    this.hasPendingRedemption = false,
    this.redemptionStatus = '',
    this.redemptionMessage = '',
    this.redemptionDetails,
    this.redeemedAmount = 0.0,
    this.redeemedUnits = 0.0,
    this.isSipFlag = false,
    this.sipStatus = '',
    this.isSipCancelled = false,
    this.hasPendingSipCancellation = false,
    this.sipCancellationDetails,
    this.latestOrderStatus = '',
    this.latestOrderStatusLabel = '',
    this.exitLoad = '',
    this.exitLoadData,
    this.exitLoadAmount = 0.0,
    this.exitLoadRate = 0.0,
    this.exitLoadRateFormatted = '',
    this.exitLoadDaysRemaining = 0,
    this.exitLoadFreeDate = '',
    this.exitLoadFreeDateFormatted = '',
    this.exitLoadStatusBadge = '',
    this.exitLoadSmartTip = '',
    this.isRedeemed = false,
    this.holdingStatus = '',
    this.firstInvestedDate = '',
    this.latestInvestedDate = '',
    this.latestPurchaseNav = 0.0,
    this.sipFrequency = '',
    this.sipFrequencyType = '',
    this.sipDay = '',
    this.nextSipDate = '',
    this.totalInstallments = 0,
    this.transactions = const [],
  });

  /// Identifier used by the existing portfolio-to-goal link endpoint integration.
  /// Keep the fund-ID precedence used by Dashboard, including string API values.
  int get goalLinkId {
    final fundId = int.tryParse(mfuOrderFundId?.toString().trim() ?? '');
    if (fundId != null && fundId > 0) return fundId;
    return (mfuOrderId ?? 0) > 0 ? mfuOrderId! : 0;
  }

  String get normalizedSchemeCode => schemeCode.trim().toUpperCase();

  bool get hasGoalAssociation =>
      (goalId ?? 0) > 0 || (goalName?.trim().isNotEmpty ?? false);

  MfuPortfolioItemEntity copyWith({int? goalId, String? goalName}) {
    return MfuPortfolioItemEntity(
      schemeCode: schemeCode,
      fundName: fundName,
      amcName: amcName,
      amcLogo: amcLogo,
      investmentType: investmentType,
      investedAmount: investedAmount,
      totalUnits: totalUnits,
      currentNav: currentNav,
      currentValue: currentValue,
      gainLoss: gainLoss,
      gainLossPercent: gainLossPercent,
      oneDayChange: oneDayChange,
      oneDayChangePercent: oneDayChangePercent,
      purchaseNav: purchaseNav,
      purchaseDate: purchaseDate,
      folioNo: folioNo,
      lastTransactionDate: lastTransactionDate,
      navDate: navDate,
      navChange: navChange,
      allotmentStatus: allotmentStatus,
      unitStatus: unitStatus,
      allotmentStatusLabel: allotmentStatusLabel,
      allotmentMessage: allotmentMessage,
      isUnitAllotted: isUnitAllotted,
      mfuOrderFundId: mfuOrderFundId,
      mfuOrderId: mfuOrderId,
      goalId: goalId ?? this.goalId,
      goalName: goalName ?? this.goalName,
      hasPendingRedemption: hasPendingRedemption,
      redemptionStatus: redemptionStatus,
      redemptionMessage: redemptionMessage,
      redemptionDetails: redemptionDetails,
      redeemedAmount: redeemedAmount,
      redeemedUnits: redeemedUnits,
      isSipFlag: isSipFlag,
      sipStatus: sipStatus,
      isSipCancelled: isSipCancelled,
      hasPendingSipCancellation: hasPendingSipCancellation,
      sipCancellationDetails: sipCancellationDetails,
      latestOrderStatus: latestOrderStatus,
      latestOrderStatusLabel: latestOrderStatusLabel,
      exitLoad: exitLoad,
      exitLoadData: exitLoadData,
      exitLoadAmount: exitLoadAmount,
      exitLoadRate: exitLoadRate,
      exitLoadRateFormatted: exitLoadRateFormatted,
      exitLoadDaysRemaining: exitLoadDaysRemaining,
      exitLoadFreeDate: exitLoadFreeDate,
      exitLoadFreeDateFormatted: exitLoadFreeDateFormatted,
      exitLoadStatusBadge: exitLoadStatusBadge,
      exitLoadSmartTip: exitLoadSmartTip,
      isRedeemed: isRedeemed,
      holdingStatus: holdingStatus,
      firstInvestedDate: firstInvestedDate,
      latestInvestedDate: latestInvestedDate,
      latestPurchaseNav: latestPurchaseNav,
      sipFrequency: sipFrequency,
      sipFrequencyType: sipFrequencyType,
      sipDay: sipDay,
      nextSipDate: nextSipDate,
      totalInstallments: totalInstallments,
      transactions: transactions,
    );
  }

  // Computed properties for easy UI styling
  bool get isProfit => gainLoss >= 0;
  bool get isOneDayProfit => oneDayChange >= 0;
  bool get isSip => investmentType.toLowerCase() == 'sip' || isSipFlag;
  bool get isSipActive => isSip && !isSipCancelledFlag;
  bool get isLumpsum =>
      investmentType.toLowerCase() == 'lumpsum' ||
      investmentType.toLowerCase() == 'normal' ||
      investmentType.toLowerCase() == 'lump-sum';

  bool get isRedemptionSettled =>
      redemptionStatus.toLowerCase() == 'settled' ||
      (redemptionDetails?.statusCode.toLowerCase() == 'rp');

  bool get isSipCancelledFlag =>
      isSipCancelled || sipStatus.toLowerCase() == 'cancelled';

  bool get isFullyRedeemed =>
      isRedeemed ||
      holdingStatus.toLowerCase() == 'redeemed' ||
      allotmentStatus.toLowerCase() == 'redeemed' ||
      (isRedemptionSettled && totalUnits == 0);

  bool get isPartiallyRedeemed => redeemedAmount > 0 && totalUnits > 0;

  /// Redemption is pending if type is redeem or hasPendingRedemption is true, but NOT YET SETTLED
  bool get isRedemptionPending =>
      !isRedemptionSettled &&
      (hasPendingRedemption ||
          investmentType.toLowerCase() == 'redeem' ||
          investmentType.toLowerCase() == 'redemption' ||
          (redemptionStatus.isNotEmpty &&
              redemptionStatus.toLowerCase() != 'null' &&
              redemptionStatus.toLowerCase() != 'none' &&
              redemptionStatus.toLowerCase() != 'settled'));

  /// Allotment is pending ONLY if NOT redeeming and allotment is in progress
  bool get isAllotmentPending =>
      !isRedemptionPending &&
      !isRedemptionSettled &&
      (!isUnitAllotted ||
          allotmentStatus.toLowerCase() == 'allotment_in_progress' ||
          allotmentStatus.toLowerCase() == 'pending');

  bool get hasExitLoadData => exitLoadData != null;
  bool get isExitLoadFree =>
      (exitLoadData?.daysRemainingForNil ?? exitLoadDaysRemaining) <= 0 &&
      (exitLoadData?.exitLoadAmount ?? exitLoadAmount) <= 0;

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
    mfuOrderId,
    goalId,
    goalName,
    hasPendingRedemption,
    redemptionStatus,
    redemptionMessage,
    redemptionDetails,
    redeemedAmount,
    redeemedUnits,
    isSipFlag,
    sipStatus,
    isSipCancelled,
    hasPendingSipCancellation,
    sipCancellationDetails,
    latestOrderStatus,
    latestOrderStatusLabel,
    exitLoad,
    exitLoadData,
    exitLoadAmount,
    exitLoadRate,
    exitLoadRateFormatted,
    exitLoadDaysRemaining,
    exitLoadFreeDate,
    exitLoadFreeDateFormatted,
    exitLoadStatusBadge,
    exitLoadSmartTip,
    isRedeemed,
    holdingStatus,
    firstInvestedDate,
    latestInvestedDate,
    latestPurchaseNav,
    sipFrequency,
    sipFrequencyType,
    sipDay,
    nextSipDate,
    totalInstallments,
    transactions,
  ];
}

class MfuPortfolioSummaryEntity extends Equatable {
  final double totalInvested;
  final double totalCurrentValue;
  final double totalGainLoss;
  final double totalGainLossPercent;
  final double oneDayReturns;
  final double oneDayReturnsPercent;
  final MfuPortfolioDisplayEntity? display;

  const MfuPortfolioSummaryEntity({
    required this.totalInvested,
    required this.totalCurrentValue,
    required this.totalGainLoss,
    required this.totalGainLossPercent,
    this.oneDayReturns = 0.0,
    this.oneDayReturnsPercent = 0.0,
    this.display,
  });

  // Computed property for UI styling (green/red)
  bool get isOverallProfit => totalGainLoss >= 0;
  bool get isOneDayProfit => oneDayReturns >= 0;

  @override
  List<Object?> get props => [
    totalInvested,
    totalCurrentValue,
    totalGainLoss,
    totalGainLossPercent,
    oneDayReturns,
    oneDayReturnsPercent,
    display,
  ];
}

// Import your model and entity files here

extension MfuPortfolioModelMapper on MfuPortfolioModel {
  MfuPortfolioEntity toEntity() {
    return MfuPortfolioEntity(
      success: success ?? false,
      portfolio: portfolio?.map((e) => e.toEntity()).toList() ?? [],
      user: user?.toEntity(),
      pagination: pagination?.toEntity(),
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

extension SipCancellationDetailsMapper on SipCancellationDetailsModel {
  SipCancellationDetailsEntity toEntity() {
    return SipCancellationDetailsEntity(
      status: status ?? '',
      statusCode: statusCode ?? '',
      orderRefNo: orderRefNo ?? '',
      message: message ?? '',
      cancelledDate: cancelledDate ?? '',
    );
  }
}

extension MfuRedemptionDetailsMapper on MfuRedemptionDetailsModel {
  MfuRedemptionDetailsEntity toEntity() {
    return MfuRedemptionDetailsEntity(
      orderRefNo: orderRefNo ?? '',
      gorn: gorn ?? '',
      amount: amount ?? 0.0,
      units: units ?? 0.0,
      transactionVolumeType: transactionVolumeType ?? '',
      requestedDate: requestedDate ?? '',
      status: status ?? '',
      statusLabel: statusLabel ?? '',
      orderStatusLabel: orderStatusLabel ?? '',
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
      purchaseNav: purchaseNav ?? averagePurchaseNav ?? 0.0,
      purchaseDate: purchaseDate ?? lastTransactionDate ?? '',
      folioNo: folioNo ?? 'NEW',
      lastTransactionDate: lastTransactionDate ?? '',
      navDate: navDate ?? '',
      navChange: navChange ?? 0.0,
      allotmentStatus: allotmentStatus ?? '',
      unitStatus: unitStatus ?? '',
      allotmentStatusLabel: allotmentStatusLabel ?? '',
      allotmentMessage: allotmentMessage ?? '',
      isUnitAllotted:
          isUnitAllotted ??
          ((allotmentStatus ?? '').toLowerCase() != 'allotment_in_progress' &&
              (allotmentStatus ?? '').toLowerCase() != 'pending'),
      mfuOrderFundId: mfuOrderFundId,
      mfuOrderId: mfuOrderId,
      goalId: goalId,
      goalName: goalName,
      hasPendingRedemption: hasPendingRedemption ?? false,
      redemptionStatus: redemptionStatus ?? '',
      redemptionMessage: redemptionMessage ?? '',
      redemptionDetails: redemptionDetails?.toEntity(),
      redeemedAmount: redeemedAmount ?? 0.0,
      redeemedUnits: redeemedUnits ?? 0.0,
      isSipFlag: isSip ?? false,
      sipStatus: sipStatus ?? '',
      isSipCancelled: isSipCancelled ?? false,
      hasPendingSipCancellation: hasPendingSipCancellation ?? false,
      sipCancellationDetails: sipCancellationDetails?.toEntity(),
      latestOrderStatus: latestOrderStatus ?? '',
      latestOrderStatusLabel: latestOrderStatusLabel ?? '',
      exitLoad: exitLoad ?? '',
      exitLoadData: exitLoadData?.toEntity(),
      exitLoadAmount: exitLoadAmount ?? exitLoadData?.exitLoadAmount ?? 0.0,
      exitLoadRate: exitLoadRate ?? exitLoadData?.ratePercent ?? 0.0,
      exitLoadRateFormatted:
          exitLoadRateFormatted ?? exitLoadData?.rateFormatted ?? '',
      exitLoadDaysRemaining:
          exitLoadDaysRemaining ?? exitLoadData?.daysRemainingForNil ?? 0,
      exitLoadFreeDate: exitLoadFreeDate ?? exitLoadData?.freeDate ?? '',
      exitLoadFreeDateFormatted:
          exitLoadFreeDateFormatted ?? exitLoadData?.freeDateFormatted ?? '',
      exitLoadStatusBadge:
          exitLoadStatusBadge ?? exitLoadData?.statusBadge ?? '',
      exitLoadSmartTip: exitLoadSmartTip ?? exitLoadData?.smartTip ?? '',
      isRedeemed: isRedeemed ?? false,
      holdingStatus: holdingStatus ?? '',
      firstInvestedDate: firstInvestedDate ?? '',
      latestInvestedDate: latestInvestedDate ?? '',
      latestPurchaseNav: latestPurchaseNav ?? 0.0,
      sipFrequency: sipFrequency ?? '',
      sipFrequencyType: sipFrequencyType ?? '',
      sipDay: sipDay ?? '',
      nextSipDate: nextSipDate ?? '',
      totalInstallments: totalInstallments ?? 0,
      transactions: transactions?.map((e) => e.toEntity()).toList() ?? const [],
    );
  }
}

extension MfuFundTransactionMapper on MfuFundTransactionModel {
  MfuFundTransactionEntity toEntity() {
    return MfuFundTransactionEntity(
      id: id ?? 0,
      date: date ?? '',
      displayDate: displayDate ?? '',
      type: type ?? '',
      investmentType: investmentType ?? '',
      schemeCode: schemeCode ?? '',
      fundName: fundName ?? '',
      amcName: amcName ?? '',
      folioNo: folioNo ?? '',
      amount: amount ?? 0.0,
      units: units ?? 0.0,
      nav: nav ?? 0.0,
      status: status ?? '',
      statusLabel: statusLabel ?? '',
      orderStatus: orderStatus ?? '',
      orderStatusLabel: orderStatusLabel ?? '',
      mfuGorn: mfuGorn ?? '',
      mfuItrn: mfuItrn ?? '',
      direction: direction ?? '',
      displayAmount: displayAmount ?? '',
      displayUnits: displayUnits ?? '',
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
      oneDayReturns: oneDayReturns ?? 0.0,
      oneDayReturnsPercent: oneDayReturnsPercent ?? 0.0,
      display: display?.toEntity(),
    );
  }
}

extension MfuPortfolioDisplayMapper on MfuPortfolioDisplayModel {
  MfuPortfolioDisplayEntity toEntity() {
    return MfuPortfolioDisplayEntity(
      currentValue: currentValue ?? '',
      totalInvested: totalInvested ?? '',
      totalReturns: totalReturns ?? '',
      totalReturnsPercent: totalReturnsPercent ?? '',
      oneDayReturns: oneDayReturns ?? '',
      oneDayReturnsPercent: oneDayReturnsPercent ?? '',
    );
  }
}

extension MfuPortfolioUserMapper on MfuPortfolioUserModel {
  MfuPortfolioUserEntity toEntity() {
    return MfuPortfolioUserEntity(
      id: id ?? 0,
      name: name ?? '',
      image: image ?? '',
    );
  }
}

extension MfuPortfolioPaginationMapper on MfuPortfolioPaginationModel {
  MfuPortfolioPaginationEntity toEntity() {
    return MfuPortfolioPaginationEntity(
      currentPage: currentPage ?? 1,
      perPage: perPage ?? 20,
      total: total ?? 0,
      lastPage: lastPage ?? 1,
      hasMore: hasMore ?? false,
    );
  }
}

extension MfuExitLoadLotMapper on MfuExitLoadLotModel {
  MfuExitLoadLotEntity toEntity() {
    return MfuExitLoadLotEntity(
      allotmentDate: allotmentDate ?? '',
      units: units ?? 0.0,
      amount: amount ?? 0.0,
      ratePercent: ratePercent ?? 0.0,
      exitLoadAmount: exitLoadAmount ?? 0.0,
      daysHeld: daysHeld ?? 0,
    );
  }
}

extension MfuExitLoadDataMapper on MfuExitLoadDataModel {
  MfuExitLoadDataEntity toEntity() {
    return MfuExitLoadDataEntity(
      success: success ?? false,
      schemeCode: schemeCode ?? '',
      fundName: fundName ?? '',
      folio: folio ?? '',
      currentNav: currentNav ?? 0.0,
      grossAmount: grossAmount ?? 0.0,
      units: units ?? 0.0,
      exitLoadAmount: exitLoadAmount ?? 0.0,
      netEstimatedPayout: netEstimatedPayout ?? 0.0,
      ratePercent: ratePercent ?? 0.0,
      rateFormatted: rateFormatted ?? '',
      isApplicable: isApplicable ?? false,
      daysHeld: daysHeld ?? 0,
      thresholdDays: thresholdDays ?? 0,
      daysRemainingForNil: daysRemainingForNil ?? 0,
      freeDate: freeDate ?? '',
      freeDateFormatted: freeDateFormatted ?? '',
      statusBadge: statusBadge ?? '',
      summaryText: summaryText ?? '',
      smartTip: smartTip ?? '',
      rawRule: rawRule ?? '',
      lotsCount: lotsCount ?? 0,
      lotsBreakdown:
          lotsBreakdown?.map((l) => l.toEntity()).toList() ?? const [],
      disclaimer: disclaimer ?? '',
    );
  }
}
