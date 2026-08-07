class MfuMandateCreateRequest {
  final String mandateType;
  final int? bankId;

  // eNACH only
  final String? regMode; // "PN" (NetBanking) or "PD" (Debit Card)

  // UPI only
  final String? workflowType; // "C" (Approval Link) or "I" (Deep Link)
  final String? upiId;

  // optional legacy fields
  final int? uid;
  final double? amount;
  final String? startDate;
  final String? endDate;

  MfuMandateCreateRequest._({
    required this.mandateType,
    this.bankId,
    this.regMode,
    this.workflowType,
    this.upiId,
    this.uid,
    this.amount,
    this.startDate,
    this.endDate,
  });

  // ── eNACH ─────────────────────────────────────────────────────────────────
  factory MfuMandateCreateRequest.enach({
    String regMode = "PN",
    int? bankId,
    int? uid,
    double? amount,
    String? startDate,
    String? endDate,
  }) {
    return MfuMandateCreateRequest._(
      mandateType: "enach",
      regMode: regMode,
      bankId: bankId,
      uid: uid,
      amount: amount,
      startDate: startDate,
      endDate: endDate,
    );
  }

  // ── UPI ───────────────────────────────────────────────────────────────────
  factory MfuMandateCreateRequest.upi({
    String workflowType = "C",
    String? upiId,
    int? bankId,
    int? uid,
    double? amount,
    String? endDate,
  }) {
    return MfuMandateCreateRequest._(
      mandateType: "upi",
      workflowType: workflowType,
      upiId: upiId,
      bankId: bankId,
      uid: uid,
      amount: amount,
      endDate: endDate,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {"mandate_type": mandateType};

    if (bankId != null) data["bank_id"] = bankId;
    if (regMode != null) data["reg_mode"] = regMode;
    if (workflowType != null) data["workflow_type"] = workflowType;
    if (upiId != null && upiId!.isNotEmpty) data["upi_id"] = upiId;

    // Optional legacy fields for backward compatibility
    if (uid != null) data["uid"] = uid;
    if (amount != null) data["amount"] = amount;
    if (startDate != null) data["startDate"] = startDate;
    if (endDate != null) data["endDate"] = endDate;

    return data;
  }
}
