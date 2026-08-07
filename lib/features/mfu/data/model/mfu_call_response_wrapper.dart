// features/mfu/data/model/response/mfu_call_response_wrapper.dart

import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

class MfuCallResponseWrapper {
  final bool? success;
  final String? apiType;
  final String? endpoint;
  final int? httpCode;

  /// Raw mfu_response — each use case parses this differently
  final Map<String, dynamic>? mfuResponse;

  MfuCallResponseWrapper({
    this.success,
    this.apiType,
    this.endpoint,
    this.httpCode,
    this.mfuResponse,
  });

  factory MfuCallResponseWrapper.fromJson(Map<String, dynamic> json) {
    return MfuCallResponseWrapper(
      success: json.parse<bool>('success'),
      apiType: json.parse<String>('api_type'),
      endpoint: json.parse<String>('endpoint'),
      httpCode: json.parse<int>('http_code'),
      mfuResponse: json['mfu_response'] as Map<String, dynamic>?,
    );
  }
}
