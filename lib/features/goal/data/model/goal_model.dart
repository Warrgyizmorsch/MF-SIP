
import '../../../../core/utils/helper/custom_json_parser.dart';

class GoalResponseModel {
  final bool? success;
  final String? message;
  final List<UserGoalModel>? data;

  GoalResponseModel({this.success, this.message, this.data});

  factory GoalResponseModel.fromJson(Map<String, dynamic> json) {
    return GoalResponseModel(
      success: json.parse<bool>('success'),
      message: json.parse<String>('message'),
      data: json.parseListOf<UserGoalModel>(
        'goal',
            (item) => UserGoalModel.fromJson(item as Map<String, dynamic>),
      ),
    );
  }
}

class SaveGoalResponseModel {
  final bool? success;
  final String? message;
  final GoalDetailModel? data;

  SaveGoalResponseModel({this.success, this.message, this.data});

  factory SaveGoalResponseModel.fromJson(Map<String, dynamic> json) {
    return SaveGoalResponseModel(
      success: json.parse<bool>('success'),
      message: json.parse<String>('message'),
      data: json['data'] != null
          ? GoalDetailModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class GoalDetailModel {
  final int? id;
  final int? userId;
  final int? goalId;
  final String? goalName;
  final String? goalCover;
  final String? txnType;
  final double? lumpsumAmount;
  final String? createdDate;
  final double? targetAmount;
  final String? frequency;
  final double? monthlyInvestment;
  final double? expectedReturnRate;
  final int? goalTenure;
  final double? investedAmount;
  final String? status;

  GoalDetailModel({
    this.id,
    this.userId,
    this.goalId,
    this.goalName,
    this.goalCover,
    this.txnType,
    this.lumpsumAmount,
    this.createdDate,
    this.targetAmount,
    this.frequency,
    this.monthlyInvestment,
    this.expectedReturnRate,
    this.goalTenure,
    this.investedAmount,
    this.status,
  });

  factory GoalDetailModel.fromJson(Map<String, dynamic> json) {
    return GoalDetailModel(
      id: json.parse<int>('id'),
      userId: json.parse<int>('user_id'),
      goalId: json.parse<int>('goal_id'),
      goalName: json.parse<String>('goal_name'),
      goalCover: json.parse<String>('goal_cover'),
      txnType: json.parse<String>('txn_type'),
      lumpsumAmount: json.parse<double>('lumpsum_amount'),
      createdDate: json.parse<String>('created_date'),
      targetAmount: json.parse<double>('target_amount'), // String to double conversion via parse<double>
      frequency: json.parse<String>('frequency'),
      monthlyInvestment: json.parse<double>('monthly_investment'),
      expectedReturnRate: json.parse<double>('expected_return_rate'),
      goalTenure: json.parse<int>('goal_tenure'),
      investedAmount: json.parse<double>('Invested_amount') ?? json.parse<double>('invested_amount'),
      status: json.parse<String>('status'),
    );
  }
}

class UserGoalModel {
  final int? id;
  final int? userId;
  final int? goalId;
  final String? goalName;
  final String? goalCover;
  final String? txnType;
  final double? lumpsumAmount;
  final double? targetAmount; // Added missing property from API top level
  final String? frequency;
  final double? monthlyInvestment;
  final double? expectedReturnRate;
  final int? goalTenure;
  final double? investedAmount;
  final String? status;
  final String? mfuOrderStatus;
  final GoalTypeModel? goalType;
  final List<GoalFundModel>? goalFunds;

  UserGoalModel({
    this.id,
    this.userId,
    this.goalId,
    this.goalName,
    this.goalCover,
    this.txnType,
    this.lumpsumAmount,
    this.targetAmount,
    this.frequency,
    this.monthlyInvestment,
    this.expectedReturnRate,
    this.goalTenure,
    this.investedAmount,
    this.status,
    this.mfuOrderStatus,
    this.goalType,
    this.goalFunds,
  });

  factory UserGoalModel.fromJson(Map<String, dynamic> json) {
    return UserGoalModel(
      id: json.parse<int>('id'),
      userId: json.parse<int>('user_id'),
      goalId: json.parse<int>('goal_id'),
      goalName: json.parse<String>('goal_name'),
      goalCover: json.parse<String>('goal_cover'),
      txnType: json.parse<String>('txn_type'),
      lumpsumAmount: json.parse<double>('lumpsum_amount'),
      targetAmount: json.parse<double>('target_amount'), // Handles String "1000000.00" safely
      frequency: json.parse<String>('frequency'),
      monthlyInvestment: json.parse<double>('monthly_investment'),
      expectedReturnRate: json.parse<double>('expected_return_rate'),
      goalTenure: json.parse<int>('goal_tenure'),
      investedAmount: json.parse<double>('Invested_amount'),
      status: json.parse<String>('status'),
      mfuOrderStatus: json.parse<String>('mfu_order_status'),
      goalType: json.parseNested<GoalTypeModel>(
        'goal',
            (data) => GoalTypeModel.fromJson(data),
      ),
      goalFunds: json.parseListOf<GoalFundModel>(
        'goal_funds',
            (item) => GoalFundModel.fromJson(item as Map<String, dynamic>),
      ),
    );
  }
}

class GoalTypeModel {
  final int? id;
  final String? goalType;
  final String? goalIcon;
  final String? logo;
  final String? goalDescription;
  final double? targetAmount;
  final double? monthlyInvestment;
  final double? expectedReturnRate;
  final int? goalTenure;
  final double? investedAmount;
  final String? status;

  GoalTypeModel({
    this.id,
    this.goalType,
    this.goalIcon,
    this.logo,
    this.goalDescription,
    this.targetAmount,
    this.monthlyInvestment,
    this.expectedReturnRate,
    this.goalTenure,
    this.investedAmount,
    this.status,
  });

  factory GoalTypeModel.fromJson(Map<String, dynamic> json) {
    return GoalTypeModel(
      id: json.parse<int>('id'),
      goalType: json.parse<String>('goal_type'),
      logo: json.parse<String>('logo'),
      goalIcon: json.parse<String>('goal_icon'),
      goalDescription: json.parse<String>('goal_description'),
      targetAmount: json.parse<double>('target_amount'),
      monthlyInvestment: json.parse<double>('monthly_investment'),
      expectedReturnRate: json.parse<double>('expected_return_rate'),
      goalTenure: json.parse<int>('goal_tenure'),
      investedAmount: json.parse<double>('Invested_amount'),
      status: json.parse<String>('status'),
    );
  }
}

class GoalFundModel {
  final int? id;
  final int? goalId;
  final int? userId;
  final String? schemeCode;
  final String? orderDate;
  final String? orderType;
  final double? sipAmount;
  final int? sipDay;
  final String? sipStartDate;
  final String? sipEndDate;
  final double? lumpsumAmount;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final String? mfuOrderStatus;
  final MutualFundModel? mutualFund;

  GoalFundModel({
    this.id,
    this.goalId,
    this.userId,
    this.schemeCode,
    this.orderDate,
    this.orderType,
    this.sipAmount,
    this.sipDay,
    this.sipStartDate,
    this.sipEndDate,
    this.lumpsumAmount,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.mfuOrderStatus,
    this.mutualFund,
  });

  factory GoalFundModel.fromJson(Map<String, dynamic> json) {
    return GoalFundModel(
      id: json.parse<int>('id'),
      goalId: json.parse<int>('goal_id'),
      userId: json.parse<int>('user_id'),
      schemeCode: json.parse<String>('scheme_code'),
      orderDate: json.parse<String>('order_date'),
      orderType: json.parse<String>('order_type'),
      sipAmount: json.parse<double>('sip_amount'),
      sipDay: json.parse<int>('sip_day'),
      sipStartDate: json.parse<String>('sip_start_date'),
      sipEndDate: json.parse<String>('sip_end_date'),
      lumpsumAmount: json.parse<double>('lumpsum_amount'),
      status: json.parse<String>('status'),
      createdAt: json.parse<String>('cretated_at'), // Handles backend typo
      updatedAt: json.parse<String>('updated_at'),
      mfuOrderStatus: json.parse<String>('mfu_order_status'),
      mutualFund: json.parseNested<MutualFundModel>(
        'mutual_fund',
            (data) => MutualFundModel.fromJson(data),
      ),
    );
  }
}

class MutualFundModel {
  final int? id;
  final String? schemeCode;
  final String? schemeName;
  final String? baseSchemeName;
  final String? schemeType;
  final String? schemeCategory;
  final String? assetClass;
  final String? riskLevel;
  final String? isin;
  final int? amcId;
  final double? minSipAmount;
  final double? minLumpsum;
  final double? minimumTopup;
  final double? nav;
  final String? navDate;
  final AmcModel? amc;

  MutualFundModel({
    this.id,
    this.schemeCode,
    this.schemeName,
    this.baseSchemeName,
    this.schemeType,
    this.schemeCategory,
    this.assetClass,
    this.riskLevel,
    this.isin,
    this.amcId,
    this.minSipAmount,
    this.minLumpsum,
    this.minimumTopup,
    this.nav,
    this.navDate,
    this.amc,
  });

  factory MutualFundModel.fromJson(Map<String, dynamic> json) {
    return MutualFundModel(
      id: json.parse<int>('id'),
      schemeCode: json.parse<String>('scheme_code'),
      schemeName: json.parse<String>('scheme_name'),
      baseSchemeName: json.parse<String>('base_scheme_name'),
      schemeType: json.parse<String>('scheme_type'),
      schemeCategory: json.parse<String>('scheme_category'),
      assetClass: json.parse<String>('asset_class'),
      riskLevel: json.parse<String>('risk_level'),
      isin: json.parse<String>('isin'),
      amcId: json.parse<int>('amc_id'),
      minSipAmount: json.parse<double>('min_sip_amount'),
      minLumpsum: json.parse<double>('min_lumpsum'),
      minimumTopup: json.parse<double>('minimum_topup'),
      nav: json.parse<double>('nav'),
      navDate: json.parse<String>('nav_date'),
      amc: json.parseNested<AmcModel>(
        'amc',
            (data) => AmcModel.fromJson(data),
      ),
    );
  }
}

class AmcModel {
  final int? id;
  final String? amcName;
  final String? amcCode;
  final String? amcLogo;
  final String? amcLogoUrl;

  AmcModel({
    this.id,
    this.amcName,
    this.amcCode,
    this.amcLogo,
    this.amcLogoUrl,
  });

  factory AmcModel.fromJson(Map<String, dynamic> json) {
    return AmcModel(
      id: json.parse<int>('id'),
      amcName: json.parse<String>('amc_name'),
      amcCode: json.parse<String>('amc_code'),
      amcLogo: json.parse<String>('amc_logo'),
      amcLogoUrl: json.parse<String>('amc_logo_url'),
    );
  }
}