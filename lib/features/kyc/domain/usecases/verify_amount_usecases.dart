import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/kyc/domain/entity/verify_bank_account_entity.dart';
import '../repository/kyc_repository.dart';

class ExecuteVerifyAmountUseCase {
  final KycRepository kycRepository;

  ExecuteVerifyAmountUseCase({required this.kycRepository});

  Future<Either<Result<VerifyAmountEntity>, ApiError>> call(Map<String, dynamic> data) async {
    return await kycRepository.executeVerifyAmount(data);
  }
}