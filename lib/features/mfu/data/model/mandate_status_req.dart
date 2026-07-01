// features/mfu/data/model/mfu_mandate_status_request.dart

class MfuMandateStatusRequest {
  final int userId;
  final String mandateMode;
  final String can;
  final String? mmrn;   // eNACH
  final String? mumrn;  // UPI

  MfuMandateStatusRequest._({
    required this.userId,
    required this.mandateMode,
    required this.can,
    this.mmrn,
    this.mumrn,
  });

  // ── eNACH ─────────────────────────────────────────────────────────────────
  factory MfuMandateStatusRequest.enach({
    required int userId,
    required String can,
    required String mmrn,
  }) {
    return MfuMandateStatusRequest._(
      userId: userId,
      mandateMode: "enach",
      can: can,
      mmrn: mmrn,
    );
  }

  // ── UPI ───────────────────────────────────────────────────────────────────
  factory MfuMandateStatusRequest.upi({
    required int userId,
    required String can,
    required String mumrn,
  }) {
    return MfuMandateStatusRequest._(
      userId: userId,
      mandateMode: "upi",
      can: can,
      mumrn: mumrn,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "user_id": userId,
      "mandate_mode": mandateMode,
      "can": can,
    };

    if (mmrn != null) data["mmrn"] = mmrn;
    if (mumrn != null) data["mumrn"] = mumrn;

    return data;
  }
}