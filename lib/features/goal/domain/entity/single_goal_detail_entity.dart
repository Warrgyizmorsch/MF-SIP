class SingleGoalDetailResponseEntity {
  final bool success;
  final String message;
  final SingleGoalDetailEntity? data;

  SingleGoalDetailResponseEntity({
    required this.success,
    required this.message,
    this.data,
  });
}

class SingleGoalDetailEntity {
  final int id;
  final String goalName;
  final String goalCover;
  final String status;
  final String investmentType;
  final double investmentAmount;
  final String frequency;
  final double sipAmount;
  final double totalSipAmount;
  final double monthlySipAmount;
  final double lumpsumAmount;
  final double totalLumpsumAmount;
  final double progressPercent;
  final double savedAmount;
  final double remainingAmount;
  final double targetAmount;
  final int estYear;
  final String? startDate;
  final String? endDate;
  final String? duration;
  final double expectedReturnRate;
  final String deadlineLabel;
  final double dailySavings;
  final double weeklySavings;
  final double monthlySavings;
  final double requiredDailySip;
  final double requiredWeeklySip;
  final double requiredMonthlySip;
  final int goalTenure;
  final GoalSavingEntity? saving;
  final GoalDeadlineEntity? deadline;
  final List<GoalLinkedFundEntity> linkedFunds;

  SingleGoalDetailEntity({
    required this.id,
    required this.goalName,
    required this.goalCover,
    required this.status,
    this.investmentType = '',
    this.investmentAmount = 0.0,
    this.frequency = '',
    this.sipAmount = 0.0,
    this.totalSipAmount = 0.0,
    this.monthlySipAmount = 0.0,
    this.lumpsumAmount = 0.0,
    this.totalLumpsumAmount = 0.0,
    required this.progressPercent,
    required this.savedAmount,
    required this.remainingAmount,
    required this.targetAmount,
    required this.estYear,
    this.startDate,
    this.endDate,
    this.duration,
    this.expectedReturnRate = 0.0,
    required this.deadlineLabel,
    required this.dailySavings,
    required this.weeklySavings,
    required this.monthlySavings,
    this.requiredDailySip = 0.0,
    this.requiredWeeklySip = 0.0,
    this.requiredMonthlySip = 0.0,
    required this.goalTenure,
    this.saving,
    this.deadline,
    required this.linkedFunds,
  });

  SingleGoalDetailEntity copyWith({
    int? id,
    String? goalName,
    String? goalCover,
    String? status,
    String? investmentType,
    double? investmentAmount,
    String? frequency,
    double? sipAmount,
    double? totalSipAmount,
    double? monthlySipAmount,
    double? lumpsumAmount,
    double? totalLumpsumAmount,
    double? progressPercent,
    double? savedAmount,
    double? remainingAmount,
    double? targetAmount,
    int? estYear,
    String? startDate,
    String? endDate,
    String? duration,
    double? expectedReturnRate,
    String? deadlineLabel,
    double? dailySavings,
    double? weeklySavings,
    double? monthlySavings,
    double? requiredDailySip,
    double? requiredWeeklySip,
    double? requiredMonthlySip,
    int? goalTenure,
    GoalSavingEntity? saving,
    GoalDeadlineEntity? deadline,
    List<GoalLinkedFundEntity>? linkedFunds,
  }) {
    return SingleGoalDetailEntity(
      id: id ?? this.id,
      goalName: goalName ?? this.goalName,
      goalCover: goalCover ?? this.goalCover,
      status: status ?? this.status,
      investmentType: investmentType ?? this.investmentType,
      investmentAmount: investmentAmount ?? this.investmentAmount,
      frequency: frequency ?? this.frequency,
      sipAmount: sipAmount ?? this.sipAmount,
      totalSipAmount: totalSipAmount ?? this.totalSipAmount,
      monthlySipAmount: monthlySipAmount ?? this.monthlySipAmount,
      lumpsumAmount: lumpsumAmount ?? this.lumpsumAmount,
      totalLumpsumAmount: totalLumpsumAmount ?? this.totalLumpsumAmount,
      progressPercent: progressPercent ?? this.progressPercent,
      savedAmount: savedAmount ?? this.savedAmount,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      targetAmount: targetAmount ?? this.targetAmount,
      estYear: estYear ?? this.estYear,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      duration: duration ?? this.duration,
      expectedReturnRate: expectedReturnRate ?? this.expectedReturnRate,
      deadlineLabel: deadlineLabel ?? this.deadlineLabel,
      dailySavings: dailySavings ?? this.dailySavings,
      weeklySavings: weeklySavings ?? this.weeklySavings,
      monthlySavings: monthlySavings ?? this.monthlySavings,
      requiredDailySip: requiredDailySip ?? this.requiredDailySip,
      requiredWeeklySip: requiredWeeklySip ?? this.requiredWeeklySip,
      requiredMonthlySip: requiredMonthlySip ?? this.requiredMonthlySip,
      goalTenure: goalTenure ?? this.goalTenure,
      saving: saving ?? this.saving,
      deadline: deadline ?? this.deadline,
      linkedFunds: linkedFunds ?? this.linkedFunds,
    );
  }
}

class GoalSavingEntity {
  final double saved;
  final double remaining;
  final double goal;

  GoalSavingEntity({
    required this.saved,
    required this.remaining,
    required this.goal,
  });
}

class GoalDeadlineEntity {
  final int estYear;
  final String label;
  final double dailySavings;
  final double weeklySavings;
  final double monthlySavings;

  GoalDeadlineEntity({
    required this.estYear,
    required this.label,
    required this.dailySavings,
    required this.weeklySavings,
    required this.monthlySavings,
  });
}

class GoalRedemptionDetailEntity {
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

  GoalRedemptionDetailEntity({
    required this.orderRefNo,
    required this.gorn,
    required this.amount,
    required this.units,
    required this.transactionVolumeType,
    required this.requestedDate,
    required this.status,
    required this.statusLabel,
    required this.orderStatusLabel,
    required this.statusCode,
    required this.estimatedPayoutDays,
    required this.message,
  });
}

class GoalExitLoadDataEntity {
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
  final List<GoalExitLoadLotEntity> lotsBreakdown;
  final String disclaimer;

  GoalExitLoadDataEntity({
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
}

class GoalExitLoadLotEntity {
  final String allotmentDate;
  final double units;
  final double amount;
  final double ratePercent;
  final double exitLoadAmount;
  final int daysHeld;

  GoalExitLoadLotEntity({
    this.allotmentDate = '',
    this.units = 0.0,
    this.amount = 0.0,
    this.ratePercent = 0.0,
    this.exitLoadAmount = 0.0,
    this.daysHeld = 0,
  });
}

class GoalLinkedFundEntity {
  final int id;
  final String amcImageUrl;
  final String amcLogo;
  final String fundName;
  final String schemeCode;
  final String category;
  final String riskLabel;
  final String divOption;
  final double minimumTopup;
  final String allowedSipDates;
  final GoalExitLoadDataEntity? exitLoadData;
  final double exitLoadAmount;
  final double exitLoadRate;
  final String exitLoadRateFormatted;
  final int exitLoadDaysRemaining;
  final String exitLoadFreeDate;
  final String exitLoadFreeDateFormatted;
  final String exitLoadStatusBadge;
  final String exitLoadSmartTip;
  final String folioNo;
  final double totalUnits;
  final double units;
  final double purchaseNav;
  final double? latestPurchaseNav;
  final double currentNav;
  final double nav;
  final double averageNav;
  final String investedDate;
  final String? firstInvestedDate;
  final String? latestInvestedDate;
  final String navDate;
  final double navChange;
  final double dayChange;
  final double dayChangePercent;
  final double oneDayChangePercent;
  final double oneDayReturn;
  final double oneDayReturnPercent;
  final double fundInvested;
  final double investedAmount;
  final double investmentAmount;
  final double currentValue;
  final double gainLoss;
  final double gainLossPercent;
  final String allotmentStatus;
  final String unitStatus;
  final String allotmentStatusLabel;
  final String allotmentMessage;
  final bool isUnitAllotted;
  final bool isRedeemed;
  final String holdingStatus;
  final bool isInvested;
  final String investmentStatus;
  final String orderStatus;
  final bool hasPendingRedemption;
  final String? redemptionStatus;
  final String? redemptionMessage;
  final List<GoalRedemptionDetailEntity> redemptionDetails;
  final double redeemedAmount;
  final double redeemedUnits;
  final bool isSip;
  final String? sipStatus;
  final String? sipFrequency;
  final String? sipFrequencyType;
  final String? frequency;
  final String? sipDay;
  final String? nextSipDate;
  final String? nextInstallmentDate;
  final int totalInstallments;
  final bool isSipCancelled;
  final bool hasPendingSipCancellation;
  final GoalSipCancellationDetailEntity? sipCancellationDetails;
  final String latestOrderStatus;
  final String latestOrderStatusLabel;
  final int mfuOrderId;
  final int mfuOrderFundId;
  final int goalId;
  final String goalName;
  final String type;
  final String investmentType;
  final String exitLoad;
  final bool isLumpsumAllowed;
  final bool isSipAllowed;
  final double sipMinimumAmount;
  final double lumpsumMinimumAmount;
  final List<GoalFundTransactionEntity> transactions;

  GoalLinkedFundEntity({
    this.id = 0,
    required this.amcImageUrl,
    required this.amcLogo,
    required this.fundName,
    required this.schemeCode,
    this.category = '',
    this.riskLabel = '',
    this.divOption = '',
    this.minimumTopup = 0.0,
    this.allowedSipDates = '',
    this.exitLoadData,
    this.exitLoadAmount = 0.0,
    this.exitLoadRate = 0.0,
    this.exitLoadRateFormatted = '',
    this.exitLoadDaysRemaining = 0,
    this.exitLoadFreeDate = '',
    this.exitLoadFreeDateFormatted = '',
    this.exitLoadStatusBadge = '',
    this.exitLoadSmartTip = '',
    required this.folioNo,
    required this.totalUnits,
    required this.units,
    required this.purchaseNav,
    this.latestPurchaseNav,
    required this.currentNav,
    this.nav = 0.0,
    this.averageNav = 0.0,
    required this.investedDate,
    this.firstInvestedDate,
    this.latestInvestedDate,
    required this.navDate,
    required this.navChange,
    required this.dayChange,
    required this.dayChangePercent,
    this.oneDayChangePercent = 0.0,
    required this.oneDayReturn,
    required this.oneDayReturnPercent,
    required this.fundInvested,
    required this.investedAmount,
    this.investmentAmount = 0.0,
    required this.currentValue,
    required this.gainLoss,
    required this.gainLossPercent,
    required this.allotmentStatus,
    required this.unitStatus,
    required this.allotmentStatusLabel,
    required this.allotmentMessage,
    required this.isUnitAllotted,
    this.isRedeemed = false,
    this.holdingStatus = 'active',
    this.isInvested = false,
    this.investmentStatus = '',
    this.orderStatus = '',
    required this.hasPendingRedemption,
    this.redemptionStatus,
    this.redemptionMessage,
    this.redemptionDetails = const [],
    required this.redeemedAmount,
    required this.redeemedUnits,
    required this.isSip,
    this.sipStatus,
    this.sipFrequency,
    this.sipFrequencyType,
    this.frequency,
    this.sipDay,
    this.nextSipDate,
    this.nextInstallmentDate,
    this.totalInstallments = 0,
    required this.isSipCancelled,
    required this.hasPendingSipCancellation,
    this.sipCancellationDetails,
    required this.latestOrderStatus,
    required this.latestOrderStatusLabel,
    required this.mfuOrderId,
    required this.mfuOrderFundId,
    required this.goalId,
    this.goalName = '',
    required this.type,
    this.investmentType = '',
    this.exitLoad = '',
    this.isLumpsumAllowed = true,
    this.isSipAllowed = true,
    this.sipMinimumAmount = 500.0,
    this.lumpsumMinimumAmount = 500.0,
    this.transactions = const [],
  });
}

class GoalSipCancellationDetailEntity {
  final String status;
  final String statusCode;
  final String orderRefNo;
  final String message;
  final String cancelledDate;

  GoalSipCancellationDetailEntity({
    this.status = '',
    this.statusCode = '',
    this.orderRefNo = '',
    this.message = '',
    this.cancelledDate = '',
  });
}

class GoalFundTransactionDisplayEntity {
  final String amount;
  final String units;

  GoalFundTransactionDisplayEntity({this.amount = '', this.units = ''});
}

class GoalFundTransactionEntity {
  final int id;
  final int txnId;
  final String orderId;
  final String mfOrderId;
  final String date;
  final String txnDate;
  final String displayDate;
  final String type;
  final String txtType;
  final String investmentType;
  final String schemeCode;
  final String amfiSchemeCode;
  final String mfuSchemeCode;
  final String fundName;
  final String amcName;
  final String amcLogo;
  final String amcImageUrl;
  final String folioNo;
  final String folio;
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
  final GoalFundTransactionDisplayEntity? display;
  final int goalId;

  GoalFundTransactionEntity({
    this.id = 0,
    this.txnId = 0,
    this.orderId = '',
    this.mfOrderId = '',
    this.date = '',
    this.txnDate = '',
    this.displayDate = '',
    this.type = '',
    this.txtType = '',
    this.investmentType = '',
    this.schemeCode = '',
    this.amfiSchemeCode = '',
    this.mfuSchemeCode = '',
    this.fundName = '',
    this.amcName = '',
    this.amcLogo = '',
    this.amcImageUrl = '',
    this.folioNo = '',
    this.folio = '',
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
    this.display,
    this.goalId = 0,
  });
}
