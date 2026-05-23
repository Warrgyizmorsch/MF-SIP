
class MfuMandateCreateRequest {
  final int uid;
  final String mandateType;
  final double amount;

  // eNACH only
  final String? regMode;
  final String? startDate;

  // UPI only
  final String? workflowType;
  final String? vpaId;

  // shared
  final String? endDate;

  MfuMandateCreateRequest._({
    required this.uid,
    required this.mandateType,
    required this.amount,
    this.regMode,
    this.startDate,
    this.workflowType,
    this.vpaId,
    this.endDate,
  });

  // ── eNACH ─────────────────────────────────────────────────────────────────
  factory MfuMandateCreateRequest.enach({
    required int uid,
    required double amount,
    required String startDate,
    required String endDate,
    String regMode = "PD",
  }) {
    return MfuMandateCreateRequest._(
      uid: uid,
      mandateType: "enach",
      amount: amount,
      regMode: regMode,
      startDate: startDate,
      endDate: endDate,
    );
  }

  // ── UPI ───────────────────────────────────────────────────────────────────
  factory MfuMandateCreateRequest.upi({
    required int uid,
    required double amount,
    required String vpaId,
    required String endDate,
    String workflowType = "I",
  }) {
    return MfuMandateCreateRequest._(
      uid: uid,
      mandateType: "upi",
      amount: amount,
      vpaId: vpaId,
      endDate: endDate,
      workflowType: workflowType,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "uid": uid,
      "mandate_type": mandateType,
      "amount": amount,
    };

    if (regMode != null) data["regMode"] = regMode;
    if (startDate != null) data["startDate"] = startDate;
    if (workflowType != null) data["workflowType"] = workflowType;
    if (vpaId != null) data["vpaId"] = vpaId;
    if (endDate != null) data["endDate"] = endDate;

    return data;
  }
}