import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/kyc/domain/entity/create_esign_url_entity.dart';
import 'package:my_sip/features/kyc/domain/repository/kyc_repository.dart';

class CreateEsignUrlUseCase {
  final KycRepository kycRepository;

  CreateEsignUrlUseCase({required this.kycRepository});

  Future<Either<Result<CreateEsignUrlEntity>, ApiError>> call(Map<String, dynamic> data) async {
    return await kycRepository.createEsignUrl(data);
  }
}