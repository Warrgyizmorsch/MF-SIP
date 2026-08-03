import 'package:equatable/equatable.dart';
import '../../data/model/cams_response_model.dart';

class CamsResponseEntity extends Equatable {
  final String onboardingId;
  final String status; // "success" | "failed" | "inProgress"
  final String errorMessage;

  const CamsResponseEntity({
    required this.onboardingId,
    required this.status,
    required this.errorMessage,
  });

  bool get isSuccess => status.toLowerCase() == 'success';
  bool get isFailed => status.toLowerCase() == 'failed';
  bool get isInProgress =>
      status.toLowerCase() == 'inprogress' ||
      status.toLowerCase() == 'in progress';

  @override
  List<Object?> get props => [onboardingId, status, errorMessage];
}

// Map Data Model to Domain Entity
extension CamsResponseMapper on CamsResponseModel {
  CamsResponseEntity toEntity() {
    final statusVal = camsResponse?.status ?? "inProgress";
    String errorMsg = "";

    if (statusVal.toLowerCase() == 'failed' &&
        camsResponse?.resp != null &&
        camsResponse!.resp!.isNotEmpty) {
      errorMsg =
          camsResponse!.resp!.last.rawResponse?.cleanErrorMessage ??
          "KYC submission failed.";
    }

    return CamsResponseEntity(
      onboardingId: onboardingId ?? "",
      status: statusVal,
      errorMessage: errorMsg,
    );
  }
}
