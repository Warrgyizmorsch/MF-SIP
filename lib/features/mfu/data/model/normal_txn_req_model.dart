// features/mfu/data/model/mfu_normal_txn_request.dart

class MfuNormalTxnRequest {
  final int uid;
  final String txnType;
  final String schemeCode;
  final String folio;
  final double? amount;
  final double? units;
  final String? txnVolType;

  MfuNormalTxnRequest._({
    required this.uid,
    required this.txnType,
    required this.schemeCode,
    required this.folio,
    this.amount,
    this.units,
    this.txnVolType,
  });

  // ── Buy Lumpsum — New Folio ───────────────────────────────────────────────
  factory MfuNormalTxnRequest.lumpsumNewFolio({
    required int uid,
    required String schemeCode,
    required double amount,
  }) {
    return MfuNormalTxnRequest._(
      uid: uid,
      txnType: "lumpsum",
      schemeCode: schemeCode,
      folio: "NEW",
      amount: amount,
    );
  }

  // ── Buy Lumpsum — Existing Folio ──────────────────────────────────────────
  factory MfuNormalTxnRequest.lumpsumExistingFolio({
    required int uid,
    required String schemeCode,
    required double amount,
    required String folio,
  }) {
    return MfuNormalTxnRequest._(
      uid: uid,
      txnType: "lumpsum",
      schemeCode: schemeCode,
      folio: folio,
      amount: amount,
    );
  }

  // ── Redeem by Unit ────────────────────────────────────────────────────────
  factory MfuNormalTxnRequest.redeemByUnit({
    required int uid,
    required String schemeCode,
    required double units,
    required String folio,
  }) {
    return MfuNormalTxnRequest._(
      uid: uid,
      txnType: "redeem",
      schemeCode: schemeCode,
      folio: folio,
      units: units,
      txnVolType: "U",
    );
  }

  // ── Redeem by Amount ──────────────────────────────────────────────────────
  factory MfuNormalTxnRequest.redeemByAmount({
    required int uid,
    required String schemeCode,
    required double amount,
    required String folio,
  }) {
    return MfuNormalTxnRequest._(
      uid: uid,
      txnType: "redeem",
      schemeCode: schemeCode,
      folio: folio,
      amount: amount,
      txnVolType: "A",
    );
  }

  // ── Full Redeem ───────────────────────────────────────────────────────────
  factory MfuNormalTxnRequest.fullRedeem({
    required int uid,
    required String schemeCode,
    required String folio,
  }) {
    return MfuNormalTxnRequest._(
      uid: uid,
      txnType: "redeem",
      schemeCode: schemeCode,
      folio: folio,
      txnVolType: "E",
    );
  }

  // ── toJson — only includes fields relevant to each type ───────────────────
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "uid": uid,
      "txn_type": txnType,
      "scheme_code": schemeCode,
      "folio": folio,
    };

    if (amount != null) data["amount"] = amount;
    if (units != null) data["units"] = units;
    if (txnVolType != null) data["txn_vol_type"] = txnVolType;

    return data;
  }
}