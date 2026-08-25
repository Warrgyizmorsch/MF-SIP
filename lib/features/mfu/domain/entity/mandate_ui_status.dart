// features/mfu/domain/entity/mandate_ui_status.dart

enum MandateUiStatus {
  pendingApproval,
  processing,
  active,
  rejected,
  cancelled,
  expired,
  revoked,
  paused,
  unknown,
}

MandateUiStatus getMandateUiStatus({
  required String? mfuStatus,
  required String? aggrStatus,
}) {
  final mfu = (mfuStatus ?? '').trim().toUpperCase();
  final aggr = (aggrStatus ?? '').trim().toUpperCase();

  // 1. Terminal Rejections
  if (mfu == 'PR' || aggr == 'RA' || mfu == 'FAILED' || mfu == 'REJECTED') {
    return MandateUiStatus.rejected;
  }

  // 2. Terminal Cancellation
  if (mfu == 'CL' || aggr == 'CL' || mfu == 'CANCELLED') {
    return MandateUiStatus.cancelled;
  }

  // 3. Expired
  if (aggr == 'MX' || mfu == 'EXPIRED') {
    return MandateUiStatus.expired;
  }

  // 4. Revoked
  if (aggr == 'RV' || mfu == 'REVOKED') {
    return MandateUiStatus.revoked;
  }

  // 5. Paused
  if (aggr == 'PS' || mfu == 'PAUSED') {
    return MandateUiStatus.paused;
  }

  // 6. Active (MFU = PA AND Aggregator = AC)
  if ((mfu == 'PA' || mfu == 'APPROVED' || mfu == 'SUCCESS') && aggr == 'AC') {
    return MandateUiStatus.active;
  }

  // 7. Processing (MFU = PA AND Aggregator = PE)
  if ((mfu == 'PA' || mfu == 'APPROVED' || mfu == 'SUCCESS') &&
      (aggr == 'PE' || aggr.isEmpty)) {
    return MandateUiStatus.processing;
  }

  // 8. Pending Approval (MFU = RQ AND Aggregator = PE, or initial RQ/PE state)
  if (mfu == 'RQ' || aggr == 'PE' || mfu == 'PENDING' || mfu == 'INITIATED') {
    return MandateUiStatus.pendingApproval;
  }

  // 9. Default if status strings are empty/null during initial load
  if (mfu.isEmpty && aggr.isEmpty) {
    return MandateUiStatus.pendingApproval;
  }

  return MandateUiStatus.unknown;
}

extension MandateUiStatusX on MandateUiStatus {
  String get title {
    switch (this) {
      case MandateUiStatus.active:
        return 'UPI AutoPay Activated';
      case MandateUiStatus.pendingApproval:
        return 'Approve UPI AutoPay';
      case MandateUiStatus.processing:
        return 'Approval Received';
      case MandateUiStatus.rejected:
        return "Mandate Wasn't Approved";
      case MandateUiStatus.cancelled:
        return 'Mandate Cancelled';
      case MandateUiStatus.expired:
        return 'Mandate Request Expired';
      case MandateUiStatus.revoked:
        return 'Mandate Revoked';
      case MandateUiStatus.paused:
        return 'Mandate Paused';
      case MandateUiStatus.unknown:
        return 'Mandate Status Unknown';
    }
  }

  String get subtitle {
    switch (this) {
      case MandateUiStatus.active:
        return 'Your mandate has been registered successfully.';
      case MandateUiStatus.pendingApproval:
        return "We've sent a mandate approval request to your UPI app.\n\nOpen your UPI app and approve the request using your UPI PIN.\n\nWaiting for approval...";
      case MandateUiStatus.processing:
        return "Your approval has been received. We're waiting for final confirmation from the payment provider.\n\nChecking status...";
      case MandateUiStatus.rejected:
        return "The UPI AutoPay request was rejected.\n\nYou can try again or use another UPI ID.";
      case MandateUiStatus.cancelled:
        return "The UPI AutoPay request was cancelled.";
      case MandateUiStatus.expired:
        return "The UPI AutoPay request has expired. Please try creating a new mandate.";
      case MandateUiStatus.revoked:
        return "The UPI AutoPay mandate was revoked.";
      case MandateUiStatus.paused:
        return "The UPI AutoPay mandate is currently paused.";
      case MandateUiStatus.unknown:
        return "Unable to determine current mandate status.";
    }
  }

  bool get isTerminal =>
      this == MandateUiStatus.active ||
      this == MandateUiStatus.rejected ||
      this == MandateUiStatus.cancelled ||
      this == MandateUiStatus.expired ||
      this == MandateUiStatus.revoked ||
      this == MandateUiStatus.paused;
}
