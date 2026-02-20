import 'package:equatable/equatable.dart';
import 'package:my_sip/features/cart/data/model/cart_list_model.dart';

class CartResponseEntity extends Equatable {
  final bool? status;
  final String? message;
  final CartDataEntity? cart;
  final List<CartItemEntity> items;

  const CartResponseEntity({
    this.status,
    this.message,
    this.cart,
    required this.items,
  });

  CartResponseEntity copyWith({
    bool? status,
    String? message,
    CartDataEntity? cart,
    List<CartItemEntity>? items,
  }) {
    return CartResponseEntity(
      status: status ?? this.status,
      message: message ?? this.message,
      cart: cart ?? this.cart,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [status, message, cart, items];
}

class CartDataEntity extends Equatable {
  final int? cartId;
  final int? userId;
  final String? status;
  final int? totalItems;
  final int? totalAmount;
  final int? topUPTotal;
  final TransactionSummaryEntity? sip;
  final TransactionSummaryEntity? lumpsum;

  const CartDataEntity({
    this.cartId,
    this.userId,
    this.status,
    this.totalItems,
    this.totalAmount,
    this.topUPTotal,
    this.sip,
    this.lumpsum,
  });

  @override
  List<Object?> get props => [
    cartId,
    userId,
    status,
    totalItems,
    totalAmount,
    topUPTotal,
    sip,
    lumpsum,
  ];
}

class TransactionSummaryEntity extends Equatable {
  final int? count;
  final int? amount;

  const TransactionSummaryEntity({this.count, this.amount});

  @override
  List<Object?> get props => [count, amount];
}

class CartItemEntity extends Equatable {
  final int? id;
  final int? cartId;
  final String? transType;
  final int? schemeCode;
  final int? amount;
  final String? frequency;
  final String? topUpAmount;
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
  final int? goalId;
  final String? goalName;
  final String? goalTargetAmount;
  final String? goalMonthlyInvestment;
  final String? goalTenure;
  final String? expectedReturnRate;
  final String? goalStatus;
  final String? goalCover;

  const CartItemEntity({
    this.minTopupAmount,
    this.amcLogo,
    this.id,
    this.cartId,
    this.transType,
    this.schemeCode,
    this.amount,
    this.frequency,
    this.topUpAmount,
    this.sipDay,
    this.tenureMonths,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
    this.schemeName,
    this.minSipAmount,
    this.minLumpsum,
    //
    this.goalId,
    this.goalTargetAmount,
    this.goalMonthlyInvestment,
    this.goalTenure,
    this.expectedReturnRate,
    this.goalStatus,
    this.goalCover,
    this.goalName,
  });

  // Add this copyWith method
  CartItemEntity copyWith({
    int? id,
    int? cartId,
    String? transType,
    int? schemeCode,
    int? amount,
    String? frequency,
    String? topUpAmount,
    int? sipDay,
    int? tenureMonths,
    String? startDate,
    String? endDate,
    String? createdAt,
    String? updatedAt,
    String? schemeName,
    String? minSipAmount,
    String? minLumpsum,
    String? minTopupAmount,
  }) {
    return CartItemEntity(
      id: id ?? this.id,
      cartId: cartId ?? this.cartId,
      transType: transType ?? this.transType,
      schemeCode: schemeCode ?? this.schemeCode,
      amount: amount ?? this.amount,
      frequency: frequency ?? this.frequency,
      topUpAmount: topUpAmount ?? this.topUpAmount,
      sipDay: sipDay ?? this.sipDay,
      tenureMonths: tenureMonths ?? this.tenureMonths,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      schemeName: schemeName ?? this.schemeName,
      minSipAmount: minSipAmount ?? this.minSipAmount,
      minLumpsum: minLumpsum ?? this.minLumpsum,
      amcLogo: amcLogo ?? this.amcLogo,
      minTopupAmount: minTopupAmount ?? this.minTopupAmount,
    );
  }

  @override
  List<Object?> get props => [
    goalId,
    goalTargetAmount,
    goalMonthlyInvestment,
    goalTenure,
    expectedReturnRate,
    goalStatus,
    goalCover,
    goalName,

    minTopupAmount,
    id,
    cartId,
    transType,
    schemeCode,
    amount,
    frequency,
    topUpAmount,
    sipDay,
    tenureMonths,
    startDate,
    endDate,
    createdAt,
    updatedAt,
    schemeName,
    minSipAmount,
    minLumpsum,
    amcLogo,
  ];
}

extension CartResponseModelX on CartResponseModel {
  CartResponseEntity toEntity() {
    return CartResponseEntity(
      status: status,
      message: message,
      cart: cart?.toEntity(),
      items: items.map((e) => e.toEntity()).toList(),
    );
  }
}

extension CartDataModelX on CartDataModel {
  CartDataEntity toEntity() {
    return CartDataEntity(
      cartId: cartId,
      userId: userId,
      status: status,
      totalItems: totalItems,
      totalAmount: totalAmount,
      topUPTotal: topUPTotal,
      sip: sip?.toEntity(),
      lumpsum: lumpsum?.toEntity(),
    );
  }
}

extension TransactionSummaryModelX on TransactionSummaryModel {
  TransactionSummaryEntity toEntity() {
    return TransactionSummaryEntity(count: count, amount: amount);
  }
}

extension CartItemModelX on CartItemModel {
  CartItemEntity toEntity() {
    return CartItemEntity(
      goalId: goalId,
      expectedReturnRate: expectedReturnRate,
      goalCover: goalCover,
      goalMonthlyInvestment: goalMonthlyInvestment,
      goalName: goalName,
      goalStatus: goalStatus,
      goalTargetAmount: goalTargetAmount,
      goalTenure: goalTenure,
      id: id,
      cartId: cartId,
      transType: transType,
      schemeCode: schemeCode,
      amount: amount,
      frequency: frequency,
      topUpAmount: topUpAmount,
      sipDay: sipDay,
      tenureMonths: tenureMonths,
      startDate: startDate,
      endDate: endDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
      schemeName: schemeName,
      minSipAmount: minSipAmount,
      minLumpsum: minLumpsum,
      amcLogo: amcLogo,
      minTopupAmount: minTopupAmount,
    );
  }
}
