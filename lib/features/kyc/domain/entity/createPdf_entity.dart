import 'package:equatable/equatable.dart';
import 'package:my_sip/features/kyc/data/model/contractPdf_model.dart';

class CreatePdfEntity extends Equatable {
  final String combinedPdfUrl;

  const CreatePdfEntity({required this.combinedPdfUrl});

  @override
  List<Object?> get props => [combinedPdfUrl];
}

// Mapper
extension CreatePdfModelMapper on CreatePdfModel {
  CreatePdfEntity toEntity() {
    return CreatePdfEntity(
      combinedPdfUrl: combinedPdf ?? '',
    );
  }
}