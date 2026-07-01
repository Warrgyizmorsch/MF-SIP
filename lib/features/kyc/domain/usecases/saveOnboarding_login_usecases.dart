// ignore_for_file: file_names

import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/kyc/data/model/onboarding_login_model.dart';
import 'package:my_sip/features/kyc/domain/repository/kyc_repository.dart';

class SaveOnboardingDataUseCase {
  final KycRepository kycRepository;

  SaveOnboardingDataUseCase(this.kycRepository);

  Future<Either<Result<OnboardingResponse>, ApiError>> call(
    Map<String, dynamic> data,
  ) async {
    return await kycRepository.saveOnboardingData(data);
  }
}
