// class MfuSystematicTxnRequest {
//   final int uid;
//   final String can;
//   final String txnType;
//   final String schemeCode;
//   final String folio;
//   final int amount;
//   final String frequency;
//   final String day;
//   final String startMonth;
//   final String startYear;
//   final String endMonth;
//   final String endYear;
//   final String paymentMode;
//   final String accType;
//   final String accNo;
//   final String ifsc;
//   final String micr;
//   final String mandateRefNo;

//   MfuSystematicTxnRequest._({
//     required this.uid,
//     required this.can,
//     required this.txnType,
//     required this.schemeCode,
//     required this.folio,
//     required this.amount,
//     required this.frequency,
//     required this.day,
//     required this.startMonth,
//     required this.startYear,
//     required this.endMonth,
//     required this.endYear,
//     required this.paymentMode,
//     required this.accType,
//     required this.accNo,
//     required this.ifsc,
//     required this.micr,
//     required this.mandateRefNo,
//   });

//   // ── SIP ───────────────────────────────────────────────────────────────────
//   factory MfuSystematicTxnRequest.sip({
//     required int uid,
//     required String can,
//     required String schemeCode,
//     required String folio,
//     required int amount,
//     required String frequency,
//     required String day,
//     required String startMonth,
//     required String startYear,
//     required String endMonth,
//     required String endYear,
//     required String paymentMode,
//     required String accType,
//     required String accNo,
//     required String ifsc,
//     required String micr,
//     required String mandateRefNo,
//   }) {
//     return MfuSystematicTxnRequest._(
//       uid: uid,
//       can: can,
//       txnType: "sip",
//       schemeCode: schemeCode,
//       folio: folio,
//       amount: amount,
//       frequency: frequency,
//       day: day,
//       startMonth: startMonth,
//       startYear: startYear,
//       endMonth: endMonth,
//       endYear: endYear,
//       paymentMode: paymentMode,
//       accType: accType,
//       accNo: accNo,
//       ifsc: ifsc,
//       micr: micr,
//       mandateRefNo: mandateRefNo,
//     );
//   }

//   // ── SWP ───────────────────────────────────────────────────────────────────
//   factory MfuSystematicTxnRequest.swp({
//     required int uid,
//     required String can,
//     required String schemeCode,
//     required String folio,
//     required int amount,
//     required String frequency,
//     required String day,
//     required String startMonth,
//     required String startYear,
//     required String endMonth,
//     required String endYear,
//     required String paymentMode,
//     required String accType,
//     required String accNo,
//     required String ifsc,
//     required String micr,
//     required String mandateRefNo,
//   }) {
//     return MfuSystematicTxnRequest._(
//       uid: uid,
//       can: can,
//       txnType: "swp",
//       schemeCode: schemeCode,
//       folio: folio,
//       amount: amount,
//       frequency: frequency,
//       day: day,
//       startMonth: startMonth,
//       startYear: startYear,
//       endMonth: endMonth,
//       endYear: endYear,
//       paymentMode: paymentMode,
//       accType: accType,
//       accNo: accNo,
//       ifsc: ifsc,
//       micr: micr,
//       mandateRefNo: mandateRefNo,
//     );
//   }

//   // ── STP ───────────────────────────────────────────────────────────────────
//   factory MfuSystematicTxnRequest.stp({
//     required int uid,
//     required String can,
//     required String schemeCode,
//     required String folio,
//     required int amount,
//     required String frequency,
//     required String day,
//     required String startMonth,
//     required String startYear,
//     required String endMonth,
//     required String endYear,
//     required String paymentMode,
//     required String accType,
//     required String accNo,
//     required String ifsc,
//     required String micr,
//     required String mandateRefNo,
//   }) {
//     return MfuSystematicTxnRequest._(
//       uid: uid,
//       can: can,
//       txnType: "stp",
//       schemeCode: schemeCode,
//       folio: folio,
//       amount: amount,
//       frequency: frequency,
//       day: day,
//       startMonth: startMonth,
//       startYear: startYear,
//       endMonth: endMonth,
//       endYear: endYear,
//       paymentMode: paymentMode,
//       accType: accType,
//       accNo: accNo,
//       ifsc: ifsc,
//       micr: micr,
//       mandateRefNo: mandateRefNo,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       "uid": uid,
//       "can": can,
//       "txn_type": txnType,
//       "scheme_code": schemeCode,
//       "folio": folio,
//       "amount": amount,
//       "frequency": frequency,
//       "day": day,
//       "start_month": startMonth,
//       "start_year": startYear,
//       "end_month": endMonth,
//       "end_year": endYear,
//       "payment_mode": paymentMode,
//       "acc_type": accType,
//       "acc_no": accNo,
//       "ifsc": ifsc,
//       "micr": micr,
//       "mandate_ref_no": mandateRefNo,
//     };
//   }
// }
// features/mfu/data/model/mfu_systematic_txn_request.dart

class MfuSysTxnScheme {
  final String schemeCode;
  final int amount;
  final String folio;
  final String divOpt;

  MfuSysTxnScheme({
    required this.schemeCode,
    required this.amount,
    required this.folio,
    this.divOpt = "N", // N = Normal/Growth by default
  });

  Map<String, dynamic> toJson() {
    return {
      "scheme_code": schemeCode,
      "amount": amount,
      "folio": folio,
      "div_opt": divOpt,
    };
  }
}

class MfuSystematicTxnRequest {
  final int uid;
  final String can;
  final int? goalId;
  final String txnType;
  final String frequency;
  final String day;
  final String startMonth;
  final String startYear;
  final String endMonth;
  final String endYear;
  final String paymentMode;
  final String accType;
  final String accNo;
  final String ifsc;
  final String micr;
  final String mandateRefNo;
  final List<MfuSysTxnScheme> schemes; // 🚀 New: List of Schemes

  MfuSystematicTxnRequest._({
    required this.uid,
    required this.can,
    this.goalId,
    required this.txnType,
    required this.frequency,
    required this.day,
    required this.startMonth,
    required this.startYear,
    required this.endMonth,
    required this.endYear,
    required this.paymentMode,
    required this.accType,
    required this.accNo,
    required this.ifsc,
    required this.micr,
    required this.mandateRefNo,
    required this.schemes,
  });

  // ── SIP Single Scheme (Legacy Support for direct Buy) ─────────────────────
  factory MfuSystematicTxnRequest.sip({
    required int uid,
    required String can,
    required String schemeCode,
    required String folio,
    required int amount,
    required String frequency,
    required String day,
    required String startMonth,
    required String startYear,
    required String endMonth,
    required String endYear,
    required String paymentMode,
    required String accType,
    required String accNo,
    required String ifsc,
    required String micr,
    required String mandateRefNo,
  }) {
    return MfuSystematicTxnRequest._(
      uid: uid,
      can: can,
      txnType: "sip",
      frequency: frequency,
      day: day,
      startMonth: startMonth,
      startYear: startYear,
      endMonth: endMonth,
      endYear: endYear,
      paymentMode: paymentMode,
      accType: accType,
      accNo: accNo,
      ifsc: ifsc,
      micr: micr,
      mandateRefNo: mandateRefNo,
      schemes: [
        MfuSysTxnScheme(
          schemeCode: schemeCode,
          amount: amount,
          folio: folio.isEmpty ? "NEW" : folio,
        ),
      ],
    );
  }

  // 🚀 NEW: SIP Multiple Schemes (For Cart Checkout) ─────────────────────────
  factory MfuSystematicTxnRequest.sipMultiple({
    required int uid,
    required String can,
    int? goalId,
    required String frequency,
    required String day,
    required String startMonth,
    required String startYear,
    required String endMonth,
    required String endYear,
    required String paymentMode,
    required String accType,
    required String accNo,
    required String ifsc,
    required String micr,
    required String mandateRefNo,
    required List<MfuSysTxnScheme> schemes,
  }) {
    return MfuSystematicTxnRequest._(
      uid: uid,
      can: can,
      goalId: goalId,
      txnType: "sip",
      frequency: frequency,
      day: day,
      startMonth: startMonth,
      startYear: startYear,
      endMonth: endMonth,
      endYear: endYear,
      paymentMode: paymentMode,
      accType: accType,
      accNo: accNo,
      ifsc: ifsc,
      micr: micr,
      mandateRefNo: mandateRefNo,
      schemes: schemes,
    );
  }

  // ... (You can duplicate the same pattern for SWP and STP if needed)

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "uid": uid,
      "can": can,
      "txn_type": txnType,
      "payment_mode": paymentMode,
      "acc_type": accType,
      "acc_no": accNo,
      "ifsc": ifsc,
      "micr": micr,
      "mandate_ref_no": mandateRefNo,
      "frequency": frequency,
      "day": day,
      "start_month": startMonth,
      "start_year": startYear,
      "end_month": endMonth,
      "end_year": endYear,
      "schemes": schemes.map((s) => s.toJson()).toList(), // 🚀 Maps the list
    };
    if (goalId != null) data["goal_id"] = goalId;
    return data;
  }
}
