import 'package:equatable/equatable.dart';
import 'package:my_sip/features/kyc/data/model/create_esign_url_model.dart';

class CreateEsignUrlEntity extends Equatable {
  final String esignUrl;

  const CreateEsignUrlEntity({required this.esignUrl});

  @override
  List<Object?> get props => [esignUrl];
}

extension CreateEsignUrlModelMapper on CreateEsignUrlModel {
  CreateEsignUrlEntity toEntity() {
    return CreateEsignUrlEntity(
      esignUrl: esignUrl ?? '',
    );
  }
}