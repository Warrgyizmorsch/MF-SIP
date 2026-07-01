
import 'package:my_sip/core/utils/helper/custom_json_parser.dart';

class DeleteGoalFundModel {
  final bool? status;
  final String? message;

  DeleteGoalFundModel({this.status, this.message});

  factory DeleteGoalFundModel.fromJson(Map<String, dynamic> json) {
    return DeleteGoalFundModel(
      status: json.parse<bool>('status'),
      message: json.parse<String>('message'),
    );
  }
}