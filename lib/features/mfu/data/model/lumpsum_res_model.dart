class LumpsumResModel {
  final bool? success;
  final String? message;
  final int? mfuOrderId;
  final String? mfuGorn;
  final String? orderStatus;
  final String? approvalLink;

  LumpsumResModel({
    this.success,
    this.message,
    this.mfuOrderId,
    this.mfuGorn,
    this.orderStatus,
    this.approvalLink,
  });

  factory LumpsumResModel.fromJson(Map<String, dynamic> json) {
    return LumpsumResModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      mfuOrderId: json['mfu_order_id'] as int?,
      mfuGorn: json['mfu_gorn'] as String?,
      orderStatus: json['order_status'] as String?,
      approvalLink: json['approval_link'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'mfu_order_id': mfuOrderId,
    'mfu_gorn': mfuGorn,
    'order_status': orderStatus,
    'approval_link': approvalLink,
  };
}
