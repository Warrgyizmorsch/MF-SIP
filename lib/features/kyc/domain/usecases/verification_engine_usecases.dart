import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/kyc/domain/repository/kyc_repository.dart';

class ExecuteVerificationEngineUseCase {
  final KycRepository kycRepository;


  ExecuteVerificationEngineUseCase({required this.kycRepository});

  Future<Either<Result<bool>, ApiError>> call(
      Map<String, dynamic> data) async {
    return await kycRepository.executeVerificationEngine(data);
  }
}