import 'dart:math' as math;

import 'package:equatable/equatable.dart';

import '../../data/model/goal_model.dart';

class GoalResponseEntity extends Equatable {
  final bool success;
  final String message;
  final List<UserGoalEntity> goal;
  final List<UserGoalEntity> data;

  const GoalResponseEntity({
    required this.success,
    required this.message,
    List<UserGoalEntity>? goal,
    List<UserGoalEntity>? data,
  }) : goal = goal ?? data ?? const [],
       data = data ?? goal ?? const [];

  @override
  List<Object?> get props => [success, message, goal, data];
}

class SaveGoalResponseEntity extends Equatable {
  final bool? status;
  final bool success;
  final String message;
  final GoalDetailEntity data;

  const SaveGoalResponseEntity({
    this.status,
    required this.success,
    required this.message,
    required this.data,
  });

  @override
  List<Object?> get props => [status, success, message, data];
}

class GoalDetailEntity extends Equatable {
  final int id;
  final int userId;
  final int goalId;
  final String goalName;
  final String goalCover;
  final String txnType;
  final double lumpsumAmount;
  final String createdDate;
  final double targetAmount;
  final String frequency;
  final double monthlyInvestment;
  final double expectedReturnRate;
  final int goalTenure;
  final double investedAmount;
  final String status;
  final String? createdAt;
  final String? updatedAt;
  final GoalTypeEntity? goalType;
  final List<GoalFundEntity> goalFunds;

  const GoalDetailEntity({
    required this.id,
    required this.userId,
    required this.goalId,
    required this.goalName,
    required this.goalCover,
    required this.txnType,
    required this.lumpsumAmount,
    required this.createdDate,
    required this.targetAmount,
    required this.frequency,
    required this.monthlyInvestment,
    required this.expectedReturnRate,
    required this.goalTenure,
    required this.investedAmount,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.goalType,
    required this.goalFunds,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    goalId,
    goalName,
    goalCover,
    txnType,
    lumpsumAmount,
    createdDate,
    targetAmount,
    frequency,
    monthlyInvestment,
    expectedReturnRate,
    goalTenure,
    investedAmount,
    status,
    createdAt,
    updatedAt,
    goalType,
    goalFunds,
  ];
}

class UserGoalEntity extends Equatable {
  final int id;
  final int userId;
  final int goalId;
  final String goalName;
  final String goalCover;
  final String txnType;
  final double lumpsumAmount;
  final double targetAmount;
  final String frequency;
  final double monthlyInvestment;
  final double expectedReturnRate;
  final int goalTenure;
  final double savedAmount;
  final double investedAmount;
  final double remainingAmount;
  final double progressPercent;
  final String startDate;
  final String endDate;
  final String duration;
  final String status;
  final String mfuOrderStatus;
  final GoalTypeEntity? goalType;
  final List<GoalFundEntity> goalFunds;

  const UserGoalEntity({
    required this.id,
    required this.userId,
    required this.goalId,
    required this.goalName,
    required this.goalCover,
    required this.txnType,
    required this.lumpsumAmount,
    required this.targetAmount,
    required this.frequency,
    required this.monthlyInvestment,
    required this.expectedReturnRate,
    required this.goalTenure,
    double? savedAmount,
    double? investedAmount,
    this.remainingAmount = 0.0,
    this.progressPercent = 0.0,
    this.startDate = '',
    this.endDate = '',
    this.duration = '',
    this.status = '',
    this.mfuOrderStatus = 'not_ordered',
    this.goalType,
    this.goalFunds = const [],
  }) : savedAmount = savedAmount ?? investedAmount ?? 0.0,
       investedAmount = investedAmount ?? savedAmount ?? 0.0;

  double get effectiveTenureYears {
    if (duration.isNotEmpty) {
      final match = RegExp(r'(\d+)').firstMatch(duration);
      if (match != null) {
        final val = double.tryParse(match.group(1)!);
        if (val != null && val > 0) return val;
      }
    }
    if (startDate.isNotEmpty && endDate.isNotEmpty) {
      final start = DateTime.tryParse(startDate);
      final end = DateTime.tryParse(endDate);
      if (start != null && end != null && end.isAfter(start)) {
        final days = end.difference(start).inDays;
        if (days > 0) return days / 365.25;
      }
    }
    final rawTenure = goalTenure > 0 ? goalTenure : (goalType?.goalTenure ?? 0);
    if (rawTenure <= 0) return 0.0;
    return rawTenure > 50 ? rawTenure / 12.0 : rawTenure.toDouble();
  }

  double get effectiveRemainingAmount {
    if (remainingAmount > 0) return remainingAmount;
    final diff = targetAmount - investedAmount;
    return diff > 0 ? diff : 0.0;
  }

  double get effectiveProgressPercent {
    if (progressPercent > 0) return progressPercent;
    if (targetAmount > 0 && investedAmount > 0) {
      final calc = (investedAmount / targetAmount) * 100.0;
      return calc.clamp(0.0, 100.0);
    }
    return 0.0;
  }

  double get effectiveMonthlySip {
    final explicitMonthly = monthlyInvestment > 0
        ? monthlyInvestment
        : (goalType?.monthlyInvestment ?? 0.0);
    if (explicitMonthly > 0) return explicitMonthly;

    final deficit = effectiveRemainingAmount;
    if (deficit <= 0) return 0.0;

    final tenureYears = effectiveTenureYears;
    if (tenureYears <= 0) return 0.0;

    final totalMonths = (tenureYears * 12).round();
    if (totalMonths <= 0) return 0.0;

    final annualRate = expectedReturnRate > 0
        ? expectedReturnRate
        : (goalType?.expectedReturnRate ?? 12.0);
    final rate = annualRate > 0 ? annualRate : 12.0;
    final monthlyRate = math.pow(1 + rate / 100.0, 1.0 / 12.0) - 1.0;

    if (monthlyRate <= 0) {
      return (deficit / totalMonths).ceilToDouble();
    }

    final factor =
        ((math.pow(1 + monthlyRate, totalMonths) - 1.0) / monthlyRate) *
        (1 + monthlyRate);
    if (factor <= 0) {
      return (deficit / totalMonths).ceilToDouble();
    }

    return (deficit / factor).ceilToDouble();
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    goalId,
    goalName,
    goalCover,
    txnType,
    lumpsumAmount,
    targetAmount,
    frequency,
    monthlyInvestment,
    expectedReturnRate,
    goalTenure,
    savedAmount,
    investedAmount,
    remainingAmount,
    progressPercent,
    startDate,
    endDate,
    duration,
    status,
    mfuOrderStatus,
    goalType,
    goalFunds,
  ];
}

class GoalTypeEntity extends Equatable {
  final int id;
  final String typeName;
  final String goalIcon;
  final String logo;
  final String goalDescription;
  final double targetAmount;
  final double monthlyInvestment;
  final double expectedReturnRate;
  final int goalTenure;
  final double investedAmount;
  final String status;

  const GoalTypeEntity({
    required this.id,
    required this.typeName,
    required this.goalIcon,
    required this.logo,
    required this.goalDescription,
    required this.targetAmount,
    required this.monthlyInvestment,
    required this.expectedReturnRate,
    required this.goalTenure,
    required this.investedAmount,
    required this.status,
  });

  @override
  List<Object?> get props => [
    id,
    typeName,
    goalIcon,
    goalDescription,
    targetAmount,
    monthlyInvestment,
    expectedReturnRate,
    goalTenure,
    investedAmount,
    status,
    logo,
  ];
}

class GoalFundEntity extends Equatable {
  final int id;
  final int goalId;
  final int userId;
  final String schemeCode;
  final String orderDate;
  final String orderType;
  final double sipAmount;
  final int sipDay;
  final String sipStartDate;
  final String sipEndDate;
  final double lumpsumAmount;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String mfuOrderStatus;
  final MutualFundEntity? mutualFund;

  const GoalFundEntity({
    required this.id,
    required this.goalId,
    required this.userId,
    required this.schemeCode,
    required this.orderDate,
    required this.orderType,
    required this.sipAmount,
    required this.sipDay,
    required this.sipStartDate,
    required this.sipEndDate,
    required this.lumpsumAmount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.mfuOrderStatus,
    this.mutualFund,
  });

  @override
  List<Object?> get props => [
    id,
    goalId,
    userId,
    schemeCode,
    orderDate,
    orderType,
    sipAmount,
    sipDay,
    sipStartDate,
    sipEndDate,
    lumpsumAmount,
    status,
    createdAt,
    updatedAt,
    mfuOrderStatus,
    mutualFund,
  ];
}

class MutualFundEntity extends Equatable {
  final int id;
  final String schemeCode;
  final String schemeName;
  final String baseSchemeName;
  final String schemeType;
  final String schemeCategory;
  final String assetClass;
  final String riskLevel;
  final String isin;
  final int amcId;
  final double minSipAmount;
  final double minLumpsum;
  final double minimumTopup;
  final double nav;
  final String navDate;
  final AmcEntity? amc;
  final MfPerformanceSchemeEntity? mfPerformanceScheme;
  const MutualFundEntity({
    required this.id,
    required this.schemeCode,
    required this.schemeName,
    required this.baseSchemeName,
    required this.schemeType,
    required this.schemeCategory,
    required this.assetClass,
    required this.riskLevel,
    required this.isin,
    required this.amcId,
    required this.minSipAmount,
    required this.minLumpsum,
    required this.minimumTopup,
    required this.nav,
    required this.navDate,
    this.amc,
    this.mfPerformanceScheme,
  });

  @override
  List<Object?> get props => [
    id,
    schemeCode,
    schemeName,
    baseSchemeName,
    schemeType,
    schemeCategory,
    assetClass,
    riskLevel,
    isin,
    amcId,
    minSipAmount,
    minLumpsum,
    minimumTopup,
    nav,
    navDate,
    amc,
    mfPerformanceScheme,
  ];
}

class AmcEntity extends Equatable {
  final int id;
  final String amcName;
  final String amcCode;
  final String amcLogo;
  final String amcLogoUrl;

  const AmcEntity({
    required this.id,
    required this.amcName,
    required this.amcCode,
    required this.amcLogo,
    required this.amcLogoUrl,
  });

  @override
  List<Object?> get props => [id, amcName, amcCode, amcLogo, amcLogoUrl];
}

class MfPerformanceSchemeEntity extends Equatable {
  final int id;
  final int schemeCode;
  final String performanceType;
  final String label;
  final String oneWeek;
  final String oneMonth;
  final String threeMonth;
  final String sixMonth;
  final String oneYear;
  final String twoYear;
  final String threeYear;
  final String fiveYear;
  final String tenYear;
  final String inceptionReturn;
  final String ytdReturn;
  final String aum;

  const MfPerformanceSchemeEntity({
    required this.id,
    required this.schemeCode,
    required this.performanceType,
    required this.label,
    required this.oneWeek,
    required this.oneMonth,
    required this.threeMonth,
    required this.sixMonth,
    required this.oneYear,
    required this.twoYear,
    required this.threeYear,
    required this.fiveYear,
    required this.tenYear,
    required this.inceptionReturn,
    required this.ytdReturn,
    required this.aum,
  });

  @override
  List<Object?> get props => [
    id,
    schemeCode,
    performanceType,
    label,
    oneWeek,
    oneMonth,
    threeMonth,
    sixMonth,
    oneYear,
    twoYear,
    threeYear,
    fiveYear,
    tenYear,
    inceptionReturn,
    ytdReturn,
    aum,
  ];
}
// --- Mappers ---

extension GoalResponseMapper on GoalResponseModel {
  GoalResponseEntity toEntity() {
    final list = (goal ?? data)?.map((e) => e.toEntity()).toList() ?? [];
    return GoalResponseEntity(
      success: success ?? false,
      message: message ?? '',
      goal: list,
      data: list,
    );
  }
}

extension GoalDetailMapper on GoalDetailModel {
  GoalDetailEntity toEntity() {
    return GoalDetailEntity(
      id: id ?? 0,
      userId: userId ?? 0,
      goalId: goalId ?? 0,
      goalName: goalName ?? '',
      goalCover: goalCover ?? '',
      txnType: txnType ?? '',
      lumpsumAmount: lumpsumAmount ?? 0.0,
      createdDate: createdDate ?? '',
      targetAmount: targetAmount ?? 0.0,
      frequency: frequency ?? '',
      monthlyInvestment: monthlyInvestment ?? 0.0,
      expectedReturnRate: expectedReturnRate ?? 0.0,
      goalTenure: goalTenure ?? 0,
      investedAmount: investedAmount ?? 0.0,
      status: status ?? '',
      createdAt: createdAt,
      updatedAt: updatedAt,
      goalType: goal?.toEntity(),
      goalFunds: const [],
    );
  }
}

extension UserGoalMapper on UserGoalModel {
  UserGoalEntity toEntity() {
    return UserGoalEntity(
      id: id ?? 0,
      userId: userId ?? 0,
      goalId: goalId ?? 0,
      goalName: goalName ?? '',
      goalCover: goalCover ?? '',
      txnType: txnType ?? '',
      lumpsumAmount: lumpsumAmount ?? 0.0,
      targetAmount: targetAmount ?? 0.0,
      frequency: frequency ?? '',
      monthlyInvestment: monthlyInvestment ?? 0.0,
      expectedReturnRate: expectedReturnRate ?? 0.0,
      goalTenure: goalTenure ?? 0,
      savedAmount: savedAmount ?? investedAmount ?? 0.0,
      investedAmount: investedAmount ?? savedAmount ?? 0.0,
      remainingAmount: remainingAmount ?? 0.0,
      progressPercent: progressPercent ?? 0.0,
      startDate: startDate ?? '',
      endDate: endDate ?? '',
      duration: duration ?? '',
      status: status ?? '',
      mfuOrderStatus: mfuOrderStatus ?? 'not_ordered',
      goalType: goalType?.toEntity(),
      goalFunds: goalFunds?.map((e) => e.toEntity()).toList() ?? [],
    );
  }
}

extension GoalTypeMapper on GoalTypeModel {
  GoalTypeEntity toEntity() {
    return GoalTypeEntity(
      id: id ?? 0,
      typeName: goalType ?? '',
      goalIcon: goalIcon ?? '',
      logo: logo ?? '',
      goalDescription: goalDescription ?? '',
      targetAmount: targetAmount ?? 0.0,
      monthlyInvestment: monthlyInvestment ?? 0.0,
      expectedReturnRate: expectedReturnRate ?? 0.0,
      goalTenure: goalTenure ?? 0,
      investedAmount: investedAmount ?? 0.0,
      status: status ?? '',
    );
  }
}

extension GoalFundMapper on GoalFundModel {
  GoalFundEntity toEntity() {
    return GoalFundEntity(
      id: id ?? 0,
      goalId: goalId ?? 0,
      userId: userId ?? 0,
      schemeCode: schemeCode ?? '',
      orderDate: orderDate ?? '',
      orderType: orderType ?? '',
      sipAmount: sipAmount ?? 0.0,
      sipDay: sipDay ?? 0,
      sipStartDate: sipStartDate ?? '',
      sipEndDate: sipEndDate ?? '',
      lumpsumAmount: lumpsumAmount ?? 0.0,
      status: status ?? '',
      createdAt: createdAt ?? '',
      updatedAt: updatedAt ?? '',
      mfuOrderStatus: mfuOrderStatus ?? 'not_ordered',
      mutualFund: mutualFund?.toEntity(),
    );
  }
}

extension MutualFundMapper on MutualFundModel {
  MutualFundEntity toEntity() {
    return MutualFundEntity(
      id: id ?? 0,
      schemeCode: schemeCode ?? '',
      schemeName: schemeName ?? '',
      baseSchemeName: baseSchemeName ?? '',
      schemeType: schemeType ?? '',
      schemeCategory: schemeCategory ?? '',
      assetClass: assetClass ?? '',
      riskLevel: riskLevel ?? '',
      isin: isin ?? '',
      amcId: amcId ?? 0,
      minSipAmount: minSipAmount ?? 0.0,
      minLumpsum: minLumpsum ?? 0.0,
      minimumTopup: minimumTopup ?? 0.0,
      nav: nav ?? 0.0,
      navDate: navDate ?? '',
      amc: amc?.toEntity(),
      mfPerformanceScheme: mfPerformanceScheme?.toEntity(),
    );
  }
}

extension AmcMapper on AmcModel {
  AmcEntity toEntity() {
    return AmcEntity(
      id: id ?? 0,
      amcName: amcName ?? '',
      amcCode: amcCode ?? '',
      amcLogo: amcLogo ?? '',
      amcLogoUrl: amcLogoUrl ?? '',
    );
  }
}

extension MfPerformanceSchemeMapper on MfPerformanceSchemeModel {
  MfPerformanceSchemeEntity toEntity() {
    return MfPerformanceSchemeEntity(
      id: id ?? 0,
      schemeCode: schemeCode ?? 0,
      performanceType: performanceType ?? '',
      label: label ?? '',
      oneWeek: oneWeek ?? '',
      oneMonth: oneMonth ?? '',
      threeMonth: threeMonth ?? '',
      sixMonth: sixMonth ?? '',
      oneYear: oneYear ?? '',
      twoYear: twoYear ?? '',
      threeYear: threeYear ?? '',
      fiveYear: fiveYear ?? '',
      tenYear: tenYear ?? '',
      inceptionReturn: inceptionReturn ?? '',
      ytdReturn: ytdReturn ?? '',
      aum: aum ?? '',
    );
  }
}

extension SaveGoalResponseMapper on SaveGoalResponseModel {
  SaveGoalResponseEntity toEntity() {
    return SaveGoalResponseEntity(
      status: status,
      success: success ?? false,
      message: message ?? '',
      data: data != null
          ? data!.toEntity()
          : const GoalDetailEntity(
              id: 0,
              userId: 0,
              goalId: 0,
              goalName: '',
              goalCover: '',
              txnType: '',
              lumpsumAmount: 0.0,
              createdDate: '',
              targetAmount: 0.0,
              frequency: '',
              monthlyInvestment: 0.0,
              expectedReturnRate: 0.0,
              goalTenure: 0,
              investedAmount: 0.0,
              status: '',
              goalFunds: [],
            ),
    );
  }
}
