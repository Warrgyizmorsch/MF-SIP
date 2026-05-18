
import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

class MfuMandateStatusModel {
  final bool? success;
  final String? message;
  final int? mandateId;
  final String? mandateType;
  final String? status;

  MfuMandateStatusModel({
    this.success,
    this.message,
    this.mandateId,
    this.mandateType,
    this.status,
  });

  factory MfuMandateStatusModel.fromJson(Map<String, dynamic> json) {
    return MfuMandateStatusModel(
      success: json.parse<bool>('success'),
      message: json.parse<String>('message'),
      mandateId: json.parse<int>('mandate_id'),
      mandateType: json.parse<String>('mandate_type'),
      status: json.parse<String>('status'),
    );
  }
}