// // features/mfu/data/model/mfu_normal_txn_request.dart

// class MfuNormalTxnRequest {
//   final int uid;
//   final String txnType;
//   final String schemeCode;
//   final String folio;
//   final double? amount;
//   final double? units;
//   final String? txnVolType;

//   MfuNormalTxnRequest._({
//     required this.uid,
//     required this.txnType,
//     required this.schemeCode,
//     required this.folio,
//     this.amount,
//     this.units,
//     this.txnVolType,
//   });

//   // ── Buy Lumpsum — New Folio ───────────────────────────────────────────────
//   factory MfuNormalTxnRequest.lumpsumNewFolio({
//     required int uid,
//     required String schemeCode,
//     required double amount,
//   }) {
//     return MfuNormalTxnRequest._(
//       uid: uid,
//       txnType: "lumpsum",
//       schemeCode: schemeCode,
//       folio: "NEW",
//       amount: amount,
//     );
//   }

//   // ── Buy Lumpsum — Existing Folio ──────────────────────────────────────────
//   factory MfuNormalTxnRequest.lumpsumExistingFolio({
//     required int uid,
//     required String schemeCode,
//     required double amount,
//     required String folio,
//   }) {
//     return MfuNormalTxnRequest._(
//       uid: uid,
//       txnType: "lumpsum",
//       schemeCode: schemeCode,
//       folio: folio,
//       amount: amount,
//     );
//   }

//   // ── Redeem by Unit ────────────────────────────────────────────────────────
//   factory MfuNormalTxnRequest.redeemByUnit({
//     required int uid,
//     required String schemeCode,
//     required double units,
//     required String folio,
//   }) {
//     return MfuNormalTxnRequest._(
//       uid: uid,
//       txnType: "redeem",
//       schemeCode: schemeCode,
//       folio: folio,
//       units: units,
//       txnVolType: "U",
//     );
//   }

//   // ── Redeem by Amount ──────────────────────────────────────────────────────
//   factory MfuNormalTxnRequest.redeemByAmount({
//     required int uid,
//     required String schemeCode,
//     required double amount,
//     required String folio,
//   }) {
//     return MfuNormalTxnRequest._(
//       uid: uid,
//       txnType: "redeem",
//       schemeCode: schemeCode,
//       folio: folio,
//       amount: amount,
//       txnVolType: "A",
//     );
//   }

//   // ── Full Redeem ───────────────────────────────────────────────────────────
//   factory MfuNormalTxnRequest.fullRedeem({
//     required int uid,
//     required String schemeCode,
//     required String folio,
//   }) {
//     return MfuNormalTxnRequest._(
//       uid: uid,
//       txnType: "redeem",
//       schemeCode: schemeCode,
//       folio: folio,
//       txnVolType: "E",
//     );
//   }

//   // ── toJson — only includes fields relevant to each type ───────────────────
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {
//       "uid": uid,
//       "txn_type": txnType,
//       "scheme_code": schemeCode,
//       "folio": folio,
//     };

//     if (amount != null) data["amount"] = amount;
//     if (units != null) data["units"] = units;
//     if (txnVolType != null) data["txn_vol_type"] = txnVolType;

//     return data;
//   }
// }
// features/mfu/data/model/mfu_normal_txn_request.dart

class MfuTxnScheme {
  final String schemeCode;
  final String folio;
  final double? amount;
  final double? units;
  final String? txnVolType;
  final String? divOpt;

  MfuTxnScheme({
    required this.schemeCode,
    required this.folio,
    this.amount,
    this.units,
    this.txnVolType,
    this.divOpt,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "scheme_code": schemeCode,
      "folio": folio,
    };

    if (amount != null) data["amount"] = amount;
    if (units != null) data["units"] = units;
    if (txnVolType != null) data["txn_vol_type"] = txnVolType;
    if (divOpt != null) data["div_opt"] = divOpt;

    return data;
  }
}

class MfuNormalTxnRequest {
  final int uid;
  final int? goalId;
  final String txnType;
  final List<MfuTxnScheme> schemes;

  MfuNormalTxnRequest._({
    required this.uid,
    required this.txnType,
    this.goalId,
    required this.schemes,
  });

  // ── Buy Lumpsum — Single New Folio (Legacy Support) ───────────
  factory MfuNormalTxnRequest.lumpsumNewFolio({
    required int uid,
    required String schemeCode,
    required double amount,
  }) {
    return MfuNormalTxnRequest._(
      uid: uid,
      txnType: "lumpsum",
      schemes: [
        MfuTxnScheme(
          schemeCode: schemeCode,
          amount: amount,
          folio: "NEW",
          divOpt: "N",
        ),
      ],
    );
  }

  // ── Buy Lumpsum — Single Existing Folio (Legacy Support) ──────
  factory MfuNormalTxnRequest.lumpsumExistingFolio({
    required int uid,
    required String schemeCode,
    required double amount,
    required String folio,
  }) {
    return MfuNormalTxnRequest._(
      uid: uid,
      txnType: "lumpsum",
      schemes: [
        MfuTxnScheme(
          schemeCode: schemeCode,
          amount: amount,
          folio: folio,
          divOpt: "N",
        ),
      ],
    );
  }

  // 🚀 NEW: Buy Lumpsum — Multiple Schemes (For Cart Checkout) ───
  factory MfuNormalTxnRequest.lumpsumMultiple({
    required int uid,
    int? goalId,
    required List<MfuTxnScheme> schemes,
  }) {
    return MfuNormalTxnRequest._(
      uid: uid,
      goalId: goalId,
      txnType: "lumpsum",
      schemes: schemes,
    );
  }

  // ── Redeem by Unit ────────────────────────────────────────────
  factory MfuNormalTxnRequest.redeemByUnit({
    required int uid,
    required String schemeCode,
    required double units,
    required String folio,
  }) {
    return MfuNormalTxnRequest._(
      uid: uid,
      txnType: "redeem",
      schemes: [
        MfuTxnScheme(
          schemeCode: schemeCode,
          folio: folio,
          units: units,
          txnVolType: "U",
        ),
      ],
    );
  }

  // ── Redeem by Amount ──────────────────────────────────────────
  factory MfuNormalTxnRequest.redeemByAmount({
    required int uid,
    required String schemeCode,
    required double amount,
    required String folio,
  }) {
    return MfuNormalTxnRequest._(
      uid: uid,
      txnType: "redeem",
      schemes: [
        MfuTxnScheme(
          schemeCode: schemeCode,
          folio: folio,
          amount: amount,
          txnVolType: "A",
        ),
      ],
    );
  }

  // ── Full Redeem ───────────────────────────────────────────────
  factory MfuNormalTxnRequest.fullRedeem({
    required int uid,
    required String schemeCode,
    required String folio,
  }) {
    return MfuNormalTxnRequest._(
      uid: uid,
      txnType: "redeem",
      schemes: [
        MfuTxnScheme(schemeCode: schemeCode, folio: folio, txnVolType: "E"),
      ],
    );
  }

  // ── toJson — Automatically converts the list of schemes ───────
  // Map<String, dynamic> toJson() {
  //   return {
  //     "uid": uid,
  //     "txn_type": txnType,
  //     "schemes": schemes.map((scheme) => scheme.toJson()).toList(),
  //   };
  // }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "uid": uid,
      "txn_type": txnType,
      "schemes": schemes.map((scheme) => scheme.toJson()).toList(),
    };
    if (goalId != null) {
      data["goal_id"] = goalId; // 🚀 Appends to JSON if exists
    }
    return data;
  }
}
