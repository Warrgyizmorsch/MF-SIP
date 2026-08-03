import 'dart:convert';
import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

class CamsResponseModel {
  final String? onboardingId;
  final CamsResponseDetailsModel? camsResponse;

  CamsResponseModel({this.onboardingId, this.camsResponse});

  factory CamsResponseModel.fromJson(Map<String, dynamic> json) {
    return CamsResponseModel(
      onboardingId: json.parse<String>('onboardingId'),
      camsResponse: json['camsResponse'] != null
          ? CamsResponseDetailsModel.fromJson(
              json['camsResponse'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class CamsResponseDetailsModel {
  final int? lastUpdated;
  final String? status;
  final List<CamsEventModel>? resp;

  CamsResponseDetailsModel({this.lastUpdated, this.status, this.resp});

  factory CamsResponseDetailsModel.fromJson(Map<String, dynamic> json) {
    var respList = json['resp'] as List?;
    return CamsResponseDetailsModel(
      lastUpdated: json.parse<int>('lastUpdated'),
      status: json.parse<String>('status'),
      resp: respList != null
          ? respList
                .map((e) => CamsEventModel.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
    );
  }
}

class CamsEventModel {
  final String? uuid;
  final String? result;
  final int? timestamp;
  final CamsRawResponseModel? rawResponse;

  CamsEventModel({this.uuid, this.result, this.timestamp, this.rawResponse});

  factory CamsEventModel.fromJson(Map<String, dynamic> json) {
    return CamsEventModel(
      uuid: json.parse<String>('uuid'),
      result: json.parse<String>('result'),
      timestamp: json.parse<int>('timestamp'),
      rawResponse: json['rawResponse'] != null
          ? CamsRawResponseModel.fromJson(
              json['rawResponse'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class CamsRawResponseModel {
  final String? statusCode;
  final dynamic respBody;

  CamsRawResponseModel({this.statusCode, this.respBody});

  factory CamsRawResponseModel.fromJson(Map<String, dynamic> json) {
    return CamsRawResponseModel(
      statusCode: json['statusCode']?.toString(),
      respBody: json['respBody'],
    );
  }

  /// Helper to extract error message inside CAMS response body
  String get cleanErrorMessage {
    if (respBody == null) return "KYC submission failed.";

    // Case 1: respBody is a Map directly
    if (respBody is Map) {
      final map = respBody as Map;
      if (map['Response_Message'] != null) {
        return map['Response_Message'].toString();
      }
      if (map['ErrMSG'] != null) {
        return map['ErrMSG'].toString();
      }
      return map.toString();
    }

    // Case 2: respBody is a String
    final respStr = respBody.toString();
    if (respStr.isEmpty) return "KYC submission failed.";
    if (respStr == "INSERTED SUCCESSFULLY") return "";

    try {
      final decoded = jsonDecode(respStr);
      if (decoded is List && decoded.isNotEmpty) {
        final firstError = decoded.first;
        if (firstError is Map) {
          if (firstError['ErrMSG'] != null) {
            return firstError['ErrMSG'].toString();
          }
          if (firstError['Response_Message'] != null) {
            return firstError['Response_Message'].toString();
          }
        }
      } else if (decoded is Map) {
        if (decoded['Response_Message'] != null) {
          return decoded['Response_Message'].toString();
        }
        if (decoded['ErrMSG'] != null) {
          return decoded['ErrMSG'].toString();
        }
      }
    } catch (_) {}

    return respStr;
  }
}
