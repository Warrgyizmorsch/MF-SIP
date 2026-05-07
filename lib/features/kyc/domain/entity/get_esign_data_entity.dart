import 'package:equatable/equatable.dart';
import 'package:my_sip/features/kyc/data/model/get_esign_data_model.dart';
// Save Aadhaar Esign Signed PDF

class GetEsignDataEntity extends Equatable {
  final String signedPdfUrl;
  final bool isCompleted;

  const GetEsignDataEntity({
    required this.signedPdfUrl,
    required this.isCompleted,
  });

  @override
  List<Object?> get props => [signedPdfUrl, isCompleted];
}

extension GetEsignDataModelMapper on GetEsignDataModel {
  GetEsignDataEntity toEntity() {
    return GetEsignDataEntity(
      signedPdfUrl: signedPdfUrl ?? '',
      isCompleted: isCompleted ?? false,
    );
  }
}
