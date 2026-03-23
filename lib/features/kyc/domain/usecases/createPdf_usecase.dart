import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/kyc/domain/entity/createPdf_entity.dart';
import 'package:my_sip/features/kyc/domain/repository/kyc_repository.dart';

class CreatePdfUseCase {
  final KycRepository kycRepository;
  CreatePdfUseCase({required this.kycRepository});

  Future<Either<Result<CreatePdfEntity>, ApiError>> call(Map<String, dynamic> data) async {
    return await kycRepository.createPdf(data);
  }
}