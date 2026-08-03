import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/kyc/domain/entity/cams_response_entity.dart';
import 'package:my_sip/features/kyc/domain/repository/kyc_repository.dart';

class CheckCamsStatusUseCase {
  final KycRepository repository;

  CheckCamsStatusUseCase(this.repository);

  Future<Either<Result<CamsResponseEntity>, ApiError>> call(
    String onboardingId,
  ) async {
    return await repository.checkCamsStatus(onboardingId);
  }
}
