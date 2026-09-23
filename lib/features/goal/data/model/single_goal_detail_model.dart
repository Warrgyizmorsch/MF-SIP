import '../../../../core/utils/helper/custom_json_parser.dart';
import '../../domain/entity/single_goal_detail_entity.dart';

class SingleGoalDetailResponseModel {
  final bool? success;
  final String? message;
  final SingleGoalDetailModel? data;

  SingleGoalDetailResponseModel({this.success, this.message, this.data});

  factory SingleGoalDetailResponseModel.fromJson(Map<String, dynamic> json) {
    return SingleGoalDetailResponseModel(
      success: json.parse<bool>('success') ?? (json['status'] == true),
      message: json.parse<String>('message') ?? '',
      data: json['data'] is Map<String, dynamic>
          ? SingleGoalDetailModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  SingleGoalDetailResponseEntity toEntity() {
    return SingleGoalDetailResponseEntity(
      success: success ?? false,
      message: message ?? '',
      data: data?.toEntity(),
    );
  }
}

class SingleGoalDetailModel {
  final int? id;
  final String? goalName;
  final String? goalCover;
  final String? status;
  final double? progressPercent;
  final double? savedAmount;
  final double? remainingAmount;
  final double? targetAmount;
  final int? estYear;
  final String? deadlineLabel;
  final double? dailySavings;
  final double? weeklySavings;
  final double? monthlySavings;
  final int? goalTenure;
  final GoalSavingModel? saving;
  final GoalDeadlineModel? deadline;
  final List<GoalLinkedFundModel>? linkedFunds;

  SingleGoalDetailModel({
    this.id,
    this.goalName,
    this.goalCover,
    this.status,
    this.progressPercent,
    this.savedAmount,
    this.remainingAmount,
    this.targetAmount,
    this.estYear,
    this.deadlineLabel,
    this.dailySavings,
    this.weeklySavings,
    this.monthlySavings,
    this.goalTenure,
    this.saving,
    this.deadline,
    this.linkedFunds,
  });

  factory SingleGoalDetailModel.fromJson(Map<String, dynamic> json) {
    return SingleGoalDetailModel(
      id: json.parse<int>('id'),
      goalName: json.parse<String>('goal_name'),
      goalCover: json.parse<String>('goal_cover'),
      status: json.parse<String>('status'),
      progressPercent: json.parse<double>('progress_percent'),
      savedAmount:
          json.parse<double>('saved_amount') ?? json.parse<double>('saved'),
      remainingAmount:
          json.parse<double>('remaining_amount') ??
          json.parse<double>('remaining'),
      targetAmount:
          json.parse<double>('target_amount') ?? json.parse<double>('goal'),
      estYear: json.parse<int>('est_year') ?? json.parse<int>('deadline_year'),
      deadlineLabel: json.parse<String>('deadline_label'),
      dailySavings: json.parse<double>('daily_savings'),
      weeklySavings: json.parse<double>('weekly_savings'),
      monthlySavings:
          json.parse<double>('monthly_savings') ??
          json.parse<double>('monthly_investment'),
      goalTenure: json.parse<int>('goal_tenure'),
      saving: json['saving'] is Map<String, dynamic>
          ? GoalSavingModel.fromJson(json['saving'] as Map<String, dynamic>)
          : null,
      deadline: json['deadline'] is Map<String, dynamic>
          ? GoalDeadlineModel.fromJson(json['deadline'] as Map<String, dynamic>)
          : null,
      linkedFunds: json.parseListOf<GoalLinkedFundModel>(
        'linked_funds',
        (item) => GoalLinkedFundModel.fromJson(item as Map<String, dynamic>),
      ),
    );
  }

  SingleGoalDetailEntity toEntity() {
    return SingleGoalDetailEntity(
      id: id ?? 0,
      goalName: goalName ?? '',
      goalCover: goalCover ?? '',
      status: status ?? '',
      progressPercent: progressPercent ?? 0.0,
      savedAmount: savedAmount ?? saving?.saved ?? 0.0,
      remainingAmount: remainingAmount ?? saving?.remaining ?? 0.0,
      targetAmount: targetAmount ?? saving?.goal ?? 0.0,
      estYear: estYear ?? deadline?.estYear ?? 0,
      deadlineLabel: deadlineLabel ?? deadline?.label ?? '',
      dailySavings: dailySavings ?? deadline?.dailySavings ?? 0.0,
      weeklySavings: weeklySavings ?? deadline?.weeklySavings ?? 0.0,
      monthlySavings: monthlySavings ?? deadline?.monthlySavings ?? 0.0,
      goalTenure: goalTenure ?? 0,
      saving: saving?.toEntity(),
      deadline: deadline?.toEntity(),
      linkedFunds: linkedFunds?.map((f) => f.toEntity()).toList() ?? [],
    );
  }
}

class GoalSavingModel {
  final double? saved;
  final double? remaining;
  final double? goal;

  GoalSavingModel({this.saved, this.remaining, this.goal});

  factory GoalSavingModel.fromJson(Map<String, dynamic> json) {
    return GoalSavingModel(
      saved: json.parse<double>('saved'),
      remaining: json.parse<double>('remaining'),
      goal: json.parse<double>('goal'),
    );
  }

  GoalSavingEntity toEntity() {
    return GoalSavingEntity(
      saved: saved ?? 0.0,
      remaining: remaining ?? 0.0,
      goal: goal ?? 0.0,
    );
  }
}

class GoalDeadlineModel {
  final int? estYear;
  final String? label;
  final double? dailySavings;
  final double? weeklySavings;
  final double? monthlySavings;

  GoalDeadlineModel({
    this.estYear,
    this.label,
    this.dailySavings,
    this.weeklySavings,
    this.monthlySavings,
  });

  factory GoalDeadlineModel.fromJson(Map<String, dynamic> json) {
    return GoalDeadlineModel(
      estYear: json.parse<int>('est_year'),
      label: json.parse<String>('label'),
      dailySavings: json.parse<double>('daily_savings'),
      weeklySavings: json.parse<double>('weekly_savings'),
      monthlySavings: json.parse<double>('monthly_savings'),
    );
  }

  GoalDeadlineEntity toEntity() {
    return GoalDeadlineEntity(
      estYear: estYear ?? 0,
      label: label ?? '',
      dailySavings: dailySavings ?? 0.0,
      weeklySavings: weeklySavings ?? 0.0,
      monthlySavings: monthlySavings ?? 0.0,
    );
  }
}

class GoalLinkedFundModel {
  final String? amcImageUrl;
  final String? amcLogo;
  final String? fundName;
  final String? schemeCode;
  final String? folioNo;
  final double? totalUnits;
  final double? units;
  final double? purchaseNav;
  final double? currentNav;
  final String? investedDate;
  final String? navDate;
  final double? navChange;
  final double? dayChange;
  final double? dayChangePercent;
  final double? oneDayReturn;
  final double? oneDayReturnPercent;
  final double? fundInvested;
  final double? investedAmount;
  final double? currentValue;
  final double? gainLoss;
  final double? gainLossPercent;
  final String? allotmentStatus;
  final String? unitStatus;
  final String? allotmentStatusLabel;
  final String? allotmentMessage;
  final bool? isUnitAllotted;
  final bool? hasPendingRedemption;
  final String? redemptionStatus;
  final double? redeemedAmount;
  final double? redeemedUnits;
  final bool? isSip;
  final String? sipStatus;
  final bool? isSipCancelled;
  final bool? hasPendingSipCancellation;
  final String? latestOrderStatus;
  final String? latestOrderStatusLabel;
  final int? mfuOrderId;
  final int? mfuOrderFundId;
  final int? goalId;
  final String? type;

  GoalLinkedFundModel({
    this.amcImageUrl,
    this.amcLogo,
    this.fundName,
    this.schemeCode,
    this.folioNo,
    this.totalUnits,
    this.units,
    this.purchaseNav,
    this.currentNav,
    this.investedDate,
    this.navDate,
    this.navChange,
    this.dayChange,
    this.dayChangePercent,
    this.oneDayReturn,
    this.oneDayReturnPercent,
    this.fundInvested,
    this.investedAmount,
    this.currentValue,
    this.gainLoss,
    this.gainLossPercent,
    this.allotmentStatus,
    this.unitStatus,
    this.allotmentStatusLabel,
    this.allotmentMessage,
    this.isUnitAllotted,
    this.hasPendingRedemption,
    this.redemptionStatus,
    this.redeemedAmount,
    this.redeemedUnits,
    this.isSip,
    this.sipStatus,
    this.isSipCancelled,
    this.hasPendingSipCancellation,
    this.latestOrderStatus,
    this.latestOrderStatusLabel,
    this.mfuOrderId,
    this.mfuOrderFundId,
    this.goalId,
    this.type,
  });

  factory GoalLinkedFundModel.fromJson(Map<String, dynamic> json) {
    return GoalLinkedFundModel(
      amcImageUrl:
          json.parse<String>('amc_image_url') ?? json.parse<String>('amc_logo'),
      amcLogo:
          json.parse<String>('amc_logo') ?? json.parse<String>('amc_image_url'),
      fundName: json.parse<String>('fund_name'),
      schemeCode: json.parse<String>('scheme_code'),
      folioNo: json.parse<String>('folio_no') ?? json.parse<String>('folio'),
      totalUnits:
          json.parse<double>('total_units') ?? json.parse<double>('units'),
      units: json.parse<double>('units') ?? json.parse<double>('total_units'),
      purchaseNav:
          json.parse<double>('purchase_nav') ??
          json.parse<double>('invested_nav') ??
          json.parse<double>('average_nav'),
      currentNav:
          json.parse<double>('current_nav') ?? json.parse<double>('nav'),
      investedDate:
          json.parse<String>('invested_date') ??
          json.parse<String>('investment_date'),
      navDate: json.parse<String>('nav_date'),
      navChange: json.parse<double>('nav_change'),
      dayChange:
          json.parse<double>('day_change') ??
          json.parse<double>('one_day_change'),
      dayChangePercent:
          json.parse<double>('day_change_percent') ??
          json.parse<double>('one_day_change_percent'),
      oneDayReturn:
          json.parse<double>('one_day_return') ??
          json.parse<double>('day_change'),
      oneDayReturnPercent:
          json.parse<double>('one_day_return_percent') ??
          json.parse<double>('day_change_percent'),
      fundInvested:
          json.parse<double>('fund_invested') ??
          json.parse<double>('invested_amount'),
      investedAmount:
          json.parse<double>('invested_amount') ??
          json.parse<double>('fund_invested'),
      currentValue: json.parse<double>('current_value'),
      gainLoss: json.parse<double>('gain_loss'),
      gainLossPercent: json.parse<double>('gain_loss_percent'),
      allotmentStatus: json.parse<String>('allotment_status'),
      unitStatus: json.parse<String>('unit_status'),
      allotmentStatusLabel:
          json.parse<String>('allotment_status_label') ??
          json.parse<String>('unit_status'),
      allotmentMessage: json.parse<String>('allotment_message'),
      isUnitAllotted: json.parse<bool>('is_unit_allotted'),
      hasPendingRedemption: json.parse<bool>('has_pending_redemption'),
      redemptionStatus: json.parse<String>('redemption_status'),
      redeemedAmount: json.parse<double>('redeemed_amount'),
      redeemedUnits: json.parse<double>('redeemed_units'),
      isSip: json.parse<bool>('is_sip'),
      sipStatus: json.parse<String>('sip_status'),
      isSipCancelled: json.parse<bool>('is_sip_cancelled'),
      hasPendingSipCancellation: json.parse<bool>(
        'has_pending_sip_cancellation',
      ),
      latestOrderStatus: json.parse<String>('latest_order_status'),
      latestOrderStatusLabel: json.parse<String>('latest_order_status_label'),
      mfuOrderId: json.parse<int>('mfu_order_id'),
      mfuOrderFundId: json.parse<int>('mfu_order_fund_id'),
      goalId: json.parse<int>('goal_id'),
      type: json.parse<String>('type'),
    );
  }

  GoalLinkedFundEntity toEntity() {
    return GoalLinkedFundEntity(
      amcImageUrl: amcImageUrl ?? '',
      amcLogo: amcLogo ?? '',
      fundName: fundName ?? '',
      schemeCode: schemeCode ?? '',
      folioNo: folioNo ?? '',
      totalUnits: totalUnits ?? 0.0,
      units: units ?? 0.0,
      purchaseNav: purchaseNav ?? 0.0,
      currentNav: currentNav ?? 0.0,
      investedDate: investedDate ?? '',
      navDate: navDate ?? '',
      navChange: navChange ?? 0.0,
      dayChange: dayChange ?? 0.0,
      dayChangePercent: dayChangePercent ?? 0.0,
      oneDayReturn: oneDayReturn ?? 0.0,
      oneDayReturnPercent: oneDayReturnPercent ?? 0.0,
      fundInvested: fundInvested ?? 0.0,
      investedAmount: investedAmount ?? 0.0,
      currentValue: currentValue ?? 0.0,
      gainLoss: gainLoss ?? 0.0,
      gainLossPercent: gainLossPercent ?? 0.0,
      allotmentStatus: allotmentStatus ?? '',
      unitStatus: unitStatus ?? '',
      allotmentStatusLabel: allotmentStatusLabel ?? '',
      allotmentMessage: allotmentMessage ?? '',
      isUnitAllotted: isUnitAllotted ?? false,
      hasPendingRedemption: hasPendingRedemption ?? false,
      redemptionStatus: redemptionStatus,
      redeemedAmount: redeemedAmount ?? 0.0,
      redeemedUnits: redeemedUnits ?? 0.0,
      isSip: isSip ?? false,
      sipStatus: sipStatus,
      isSipCancelled: isSipCancelled ?? false,
      hasPendingSipCancellation: hasPendingSipCancellation ?? false,
      latestOrderStatus: latestOrderStatus ?? '',
      latestOrderStatusLabel: latestOrderStatusLabel ?? '',
      mfuOrderId: mfuOrderId ?? 0,
      mfuOrderFundId: mfuOrderFundId ?? 0,
      goalId: goalId ?? 0,
      type: type ?? '',
    );
  }
}
