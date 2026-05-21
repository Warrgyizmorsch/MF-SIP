
class MfuSystematicTxnRequest {
  final int uid;
  final String can;
  final String txnType;
  final String schemeCode;
  final String folio;
  final int amount;
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

  MfuSystematicTxnRequest._({
    required this.uid,
    required this.can,
    required this.txnType,
    required this.schemeCode,
    required this.folio,
    required this.amount,
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
  });

  // ── SIP ───────────────────────────────────────────────────────────────────
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
      schemeCode: schemeCode,
      folio: folio,
      amount: amount,
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
    );
  }

  // ── SWP ───────────────────────────────────────────────────────────────────
  factory MfuSystematicTxnRequest.swp({
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
      txnType: "swp",
      schemeCode: schemeCode,
      folio: folio,
      amount: amount,
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
    );
  }

  // ── STP ───────────────────────────────────────────────────────────────────
  factory MfuSystematicTxnRequest.stp({
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
      txnType: "stp",
      schemeCode: schemeCode,
      folio: folio,
      amount: amount,
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "can": can,
      "txn_type": txnType,
      "scheme_code": schemeCode,
      "folio": folio,
      "amount": amount,
      "frequency": frequency,
      "day": day,
      "start_month": startMonth,
      "start_year": startYear,
      "end_month": endMonth,
      "end_year": endYear,
      "payment_mode": paymentMode,
      "acc_type": accType,
      "acc_no": accNo,
      "ifsc": ifsc,
      "micr": micr,
      "mandate_ref_no": mandateRefNo,
    };
  }
}