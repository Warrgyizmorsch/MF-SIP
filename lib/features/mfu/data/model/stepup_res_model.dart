class StepUpResModel {
  final bool? success;
  final String? message;
  final int? mfuOrderId;
  final String? orderStatus;

  StepUpResModel({
    this.success,
    this.message,
    this.mfuOrderId,
    this.orderStatus,
  });

  factory StepUpResModel.fromJson(Map<String, dynamic> json) {
    return StepUpResModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      mfuOrderId: json['mfu_order_id'] as int?,
      orderStatus: json['order_status'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'mfu_order_id': mfuOrderId,
    'order_status': orderStatus,
  };
}
