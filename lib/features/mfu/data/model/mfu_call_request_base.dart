// features/mfu/data/model/request/mfu_call_request_base.dart

sealed class MfuCallRequestBase {
  /// apiType sent to backend e.g. "CAN-REG", "NORMAL-TXN"
  String get apiType;

  /// Each subclass builds its own payload
  Map<String, dynamic> buildPayload();

  /// Final body sent to API — never override this
  Map<String, dynamic> toRequestBody() => {
        "apiType": apiType,
        "payload": buildPayload(),
      };
}


class MfuCanStatusRequest extends MfuCallRequestBase {
  final String can;

   MfuCanStatusRequest({required this.can});

  @override
  String get apiType => "CAN-STATUS";

  @override
  Map<String, dynamic> buildPayload() => {"can": can};
}



class MfuCanValRequest extends MfuCallRequestBase {
  final String can;
  final String pan;
  final String dob;
  final String emailId;

   MfuCanValRequest({
    required this.can,
    required this.pan,
    required this.dob,
    required this.emailId,
  });

  @override
  String get apiType => "CAN-VAL";

  @override
  Map<String, dynamic> buildPayload() => {
        "can": can,
        "pan": pan,
        "dob": dob,
        "emailId": emailId,
      };
}