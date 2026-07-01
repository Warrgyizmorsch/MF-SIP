import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

class CartResponseModel {
  final bool? status;
  final String? message;
  final CartDataModel? cart;
  final List<CartItemModel> items;

  CartResponseModel({
    this.status,
    this.message,
    this.cart,
    required this.items,
  });

  factory CartResponseModel.fromJson(Map<String, dynamic> json) {
    return CartResponseModel(
      status: json.parse<bool>('status'),
      message: json.parse<String>('message'),
      cart: json.parseNested('cart', (e) => CartDataModel.fromJson(e)),
      items: json.parseListOf('items', (e) => CartItemModel.fromJson(e)) ?? [],
    );
  }
}

class CartDataModel {
  final int? cartId;
  final int? userId;
  final String? status;
  final int? totalItems;
  final int? totalAmount;
  final int? topUPTotal;
  final TransactionSummaryModel? sip;
  final TransactionSummaryModel? lumpsum;
  final GoalSummaryModel? withoutGoal;
  final GoalSummaryModel? withGoal;

  CartDataModel({
    this.cartId,
    this.userId,
    this.status,
    this.totalItems,
    this.totalAmount,
    this.topUPTotal,
    this.sip,
    this.lumpsum,
    this.withoutGoal,
    this.withGoal,
  });

  factory CartDataModel.fromJson(Map<String, dynamic> json) {
    return CartDataModel(
      cartId: json.parse<int>('cart_id'),
      userId: json.parse<int>('user_id'),
      status: json.parse<String>('status'),
      totalItems: json.parse<int>('total_items'),
      totalAmount: json.parse<int>('total_amount'),
      topUPTotal: json.parse<int>('top_up_total'),
      // sip: TransactionSummaryModel.fromJson(json['sip']),
      sip: json.parseNested('sip', (e) => TransactionSummaryModel.fromJson(e)),
      lumpsum: json.parseNested(
        'lumpsum',
        (e) => TransactionSummaryModel.fromJson(e),
      ),
      // lumpsum: TransactionSummaryModel.fromJson(json['lumpsum']),
      withoutGoal: json.parseNested('without_goal', (e) => GoalSummaryModel.fromJson(e)),
      withGoal: json.parseNested('with_goal', (e) => GoalSummaryModel.fromJson(e)),
    );
  }
}

class GoalSummaryModel {
  final int? totalItems;
  final int? totalAmount;
  final int? topUpTotal;
  final TransactionSummaryModel? sip;
  final TransactionSummaryModel? lumpsum;

  GoalSummaryModel({
    this.totalItems,
    this.totalAmount,
    this.topUpTotal,
    this.sip,
    this.lumpsum,
  });

  factory GoalSummaryModel.fromJson(Map<String, dynamic> json) {
    return GoalSummaryModel(
      totalItems: json.parse<int>('total_items'),
      totalAmount: json.parse<int>('total_amount'),
      topUpTotal: json.parse<int>('top_up_total'),
      sip: json.parseNested('sip', (e) => TransactionSummaryModel.fromJson(e)),
      lumpsum: json.parseNested('lumpsum', (e) => TransactionSummaryModel.fromJson(e)),
    );
  }
}

class TransactionSummaryModel {
  final int? count;
  final int? amount;

  TransactionSummaryModel({this.count, this.amount});

  factory TransactionSummaryModel.fromJson(Map<String, dynamic> json) {
    return TransactionSummaryModel(
      count: json.parse<int>('count'),
      amount: json.parse<int>('amount'),
    );
  }
}

class CartItemModel {
  final int? id;
  final int? cartId;
  final String? transType;
  final int? schemeCode;
  final int? amount;
  final String? frequency;
  final String? topUpAmount;
  final int?  stepUpPercentage;
  final String? capingDate;
  final String? capingAmount;
  final int? sipDay;
  final int? tenureMonths;
  final String? startDate;
  final String? endDate;
  final String? createdAt;
  final String? updatedAt;
  final String? schemeName;
  final String? minSipAmount;
  final String? minLumpsum;
  final String? amcLogo;
  final String? minTopupAmount;

  //
  // Added Goal Specific Fields
  final int? goalId;
  final String? goalName;
  final String? goalTargetAmount;
  final String? goalMonthlyInvestment;
  final String? goalTenure;
  final String? expectedReturnRate;
  final String? goalStatus;
  final String? goalCover;

  CartItemModel({
    this.minTopupAmount,
    this.id,
    this.cartId,
    this.transType,
    this.schemeCode,
    this.amount,
    this.frequency,
    this.topUpAmount,
    this.capingDate,
    this.capingAmount,
    this.sipDay,
    this.tenureMonths,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
    this.schemeName,
    this.minSipAmount,
    this.minLumpsum,
    this.amcLogo,
    this.stepUpPercentage,

    //this.goalName,
    this.goalId,
    this.goalTargetAmount,
    this.goalMonthlyInvestment,
    this.goalTenure,
    this.expectedReturnRate,
    this.goalStatus,
    this.goalCover,
    this.goalName,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json.parse<int>('id'),
      cartId: json.parse<int>('cart_id'),
      transType: json.parse<String>('trans_type'),
      schemeCode: json.parse<int>('scheme_code'),
      amount: json.parse<int>('amount'),
      frequency: json.parse<String>('frequency'),
      topUpAmount: json.parse<String>('top_up_amount'),
      stepUpPercentage: json.parse<int>('step_up_percentage'),
      capingDate: json.parse<String>('caping_date'),
      capingAmount: json.parse<String>('caping_amount'),
      sipDay: json.parse<int>('sip_day'),
      tenureMonths: json.parse<int>('tenure_months'),
      startDate: json.parse<String>('start_date'),
      endDate: json.parse<String>('end_date'),
      createdAt: json.parse<String>('created_at'),
      updatedAt: json.parse<String>('updated_at'),
      schemeName: json.parse<String>('scheme_name'),
      minSipAmount: json.parse<String>('min_sip_amount'),
      minLumpsum: json.parse<String>('min_lumpsum'),
      amcLogo: json.parse<String>('amc_logo'),
      minTopupAmount: json.parse<String>('minimum_topup'),
      //
      // Added Goal Mappings
      // goalId: json.parse<int>('goal_id'), // Added mapping
      // Inside CartItemModel.fromJson
      goalId: json['goal_id'] != null
          ? int.tryParse(json['goal_id'].toString())
          : null,
      goalName: json.parse<String>('goal_name'),
      goalTargetAmount: json.parse<String>('goal_target_amount'),
      goalMonthlyInvestment: json.parse<String>('goal_monthly_investment'),
      goalTenure: json.parse<String>('goal_tenure'),
      expectedReturnRate: json.parse<String>('expected_return_rate'),
      goalStatus: json.parse<String>('goal_status'),
      goalCover: json.parse<String>('goal_cover'),
    );
  }
}
