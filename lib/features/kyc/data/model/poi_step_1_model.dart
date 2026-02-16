

import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

class ExecutePOIStep1Model {
  final ResultPOIStep1Model result;

  ExecutePOIStep1Model({
    required this.result,
  });

  factory ExecutePOIStep1Model.fromJson(Map<String, dynamic> json) {
    return ExecutePOIStep1Model(
      result: ResultPOIStep1Model.fromJson(json['result']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result.toJson(),
    };
  }
}


class ResultPOIStep1Model {
  final String url;
  final String requestId;


  ResultPOIStep1Model({
    required this.url,
    required this.requestId,
  });

  factory ResultPOIStep1Model.fromJson(Map<String, dynamic> json) {
    return ResultPOIStep1Model(
      url: json.parse<String>('url')!,
      requestId: json.parse<String>('requestId') ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'requestId': requestId,
    };
  }
}

