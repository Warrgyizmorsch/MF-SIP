class RedeemResModel {
  final bool? success;
  final String? message;
  final int? mfuOrderId;
  final String? mfuGorn;
  final String? orderStatus;

  RedeemResModel({
    this.success,
    this.message,
    this.mfuOrderId,
    this.mfuGorn,
    this.orderStatus,
  });

  factory RedeemResModel.fromJson(Map<String, dynamic> json) {
    return RedeemResModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      mfuOrderId: json['mfu_order_id'] as int?,
      mfuGorn: json['mfu_gorn'] as String?,
      orderStatus: json['order_status'] as String?,
    );
  }
}
