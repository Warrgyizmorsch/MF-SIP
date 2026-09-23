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
  final double progressPercent;
  final double savedAmount;
  final double remainingAmount;
  final double targetAmount;
  final int estYear;
  final String deadlineLabel;
  final double dailySavings;
  final double weeklySavings;
  final double monthlySavings;
  final int goalTenure;
  final GoalSavingEntity? saving;
  final GoalDeadlineEntity? deadline;
  final List<GoalLinkedFundEntity> linkedFunds;

  SingleGoalDetailEntity({
    required this.id,
    required this.goalName,
    required this.goalCover,
    required this.status,
    required this.progressPercent,
    required this.savedAmount,
    required this.remainingAmount,
    required this.targetAmount,
    required this.estYear,
    required this.deadlineLabel,
    required this.dailySavings,
    required this.weeklySavings,
    required this.monthlySavings,
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
    double? progressPercent,
    double? savedAmount,
    double? remainingAmount,
    double? targetAmount,
    int? estYear,
    String? deadlineLabel,
    double? dailySavings,
    double? weeklySavings,
    double? monthlySavings,
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
      progressPercent: progressPercent ?? this.progressPercent,
      savedAmount: savedAmount ?? this.savedAmount,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      targetAmount: targetAmount ?? this.targetAmount,
      estYear: estYear ?? this.estYear,
      deadlineLabel: deadlineLabel ?? this.deadlineLabel,
      dailySavings: dailySavings ?? this.dailySavings,
      weeklySavings: weeklySavings ?? this.weeklySavings,
      monthlySavings: monthlySavings ?? this.monthlySavings,
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

class GoalLinkedFundEntity {
  final int id;
  final String amcImageUrl;
  final String amcLogo;
  final String fundName;
  final String schemeCode;
  final String folioNo;
  final double totalUnits;
  final double units;
  final double purchaseNav;
  final double currentNav;
  final String investedDate;
  final String navDate;
  final double navChange;
  final double dayChange;
  final double dayChangePercent;
  final double oneDayReturn;
  final double oneDayReturnPercent;
  final double fundInvested;
  final double investedAmount;
  final double currentValue;
  final double gainLoss;
  final double gainLossPercent;
  final String allotmentStatus;
  final String unitStatus;
  final String allotmentStatusLabel;
  final String allotmentMessage;
  final bool isUnitAllotted;
  final bool hasPendingRedemption;
  final String? redemptionStatus;
  final double redeemedAmount;
  final double redeemedUnits;
  final bool isSip;
  final String? sipStatus;
  final bool isSipCancelled;
  final bool hasPendingSipCancellation;
  final String latestOrderStatus;
  final String latestOrderStatusLabel;
  final int mfuOrderId;
  final int mfuOrderFundId;
  final int goalId;
  final String type;

  GoalLinkedFundEntity({
    this.id = 0,
    required this.amcImageUrl,
    required this.amcLogo,
    required this.fundName,
    required this.schemeCode,
    required this.folioNo,
    required this.totalUnits,
    required this.units,
    required this.purchaseNav,
    required this.currentNav,
    required this.investedDate,
    required this.navDate,
    required this.navChange,
    required this.dayChange,
    required this.dayChangePercent,
    required this.oneDayReturn,
    required this.oneDayReturnPercent,
    required this.fundInvested,
    required this.investedAmount,
    required this.currentValue,
    required this.gainLoss,
    required this.gainLossPercent,
    required this.allotmentStatus,
    required this.unitStatus,
    required this.allotmentStatusLabel,
    required this.allotmentMessage,
    required this.isUnitAllotted,
    required this.hasPendingRedemption,
    this.redemptionStatus,
    required this.redeemedAmount,
    required this.redeemedUnits,
    required this.isSip,
    this.sipStatus,
    required this.isSipCancelled,
    required this.hasPendingSipCancellation,
    required this.latestOrderStatus,
    required this.latestOrderStatusLabel,
    required this.mfuOrderId,
    required this.mfuOrderFundId,
    required this.goalId,
    required this.type,
  });
}
