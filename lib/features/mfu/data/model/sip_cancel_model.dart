// lib/features/mfu/data/model/sip_cancel_model.dart

class SipCancelSendOtpReqModel {
  final dynamic mfuOrderFundId;

  SipCancelSendOtpReqModel({required this.mfuOrderFundId});

  Map<String, dynamic> toJson() {
    return {'mfu_order_fund_id': mfuOrderFundId};
  }
}

class SipCancelSendOtpResModel {
  final bool? success;
  final bool? alreadyCancelled;
  final String? message;
  final String? mobile;

  SipCancelSendOtpResModel({
    this.success,
    this.alreadyCancelled,
    this.message,
    this.mobile,
  });

  factory SipCancelSendOtpResModel.fromJson(Map<String, dynamic> json) {
    return SipCancelSendOtpResModel(
      success: json['success'] as bool?,
      alreadyCancelled: json['already_cancelled'] as bool?,
      message: json['message'] as String?,
      mobile: json['mobile'] as String?,
    );
  }
}

class SipCancelVerifyOtpReqModel {
  final dynamic mfuOrderFundId;
  final dynamic otp;

  SipCancelVerifyOtpReqModel({required this.mfuOrderFundId, required this.otp});

  Map<String, dynamic> toJson() {
    return {'mfu_order_fund_id': mfuOrderFundId, 'otp': otp};
  }
}

class SipCancelVerifyOtpResModel {
  final bool? success;
  final String? message;
  final int? cancelOrderId;
  final int? parentOrderId;
  final String? cancelRef;
  final String? mfuGorn;
  final int? cancelledItems;
  final String? status;

  SipCancelVerifyOtpResModel({
    this.success,
    this.message,
    this.cancelOrderId,
    this.parentOrderId,
    this.cancelRef,
    this.mfuGorn,
    this.cancelledItems,
    this.status,
  });

  factory SipCancelVerifyOtpResModel.fromJson(Map<String, dynamic> json) {
    return SipCancelVerifyOtpResModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      cancelOrderId: json['cancel_order_id'] as int?,
      parentOrderId: json['parent_order_id'] as int?,
      cancelRef: json['cancel_ref'] as String?,
      mfuGorn: json['mfu_gorn'] as String?,
      cancelledItems: json['cancelled_items'] as int?,
      status: json['status'] as String?,
    );
  }
}
