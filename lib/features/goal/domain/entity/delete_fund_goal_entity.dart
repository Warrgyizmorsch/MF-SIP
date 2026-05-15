
import 'package:equatable/equatable.dart';
import 'package:my_sip/features/goal/data/model/delete_fund_goal.model.dart';

class DeleteGoalFundEntity extends Equatable {
  final bool status;
  final String message;

  const DeleteGoalFundEntity({
    required this.status,
    required this.message,
  });

  @override
  List<Object?> get props => [status, message];
}

extension DeleteGoalFundMapper on DeleteGoalFundModel {
  DeleteGoalFundEntity toEntity() {
    return DeleteGoalFundEntity(
      status: status ?? false,
      message: message ?? '',
    );
  }
}