import 'package:dartz/dartz.dart';
import 'package:my_sip/features/kyc/domain/repository/kyc_repository.dart';

import '../../../../core/utils/api/api_error.dart';
import '../../../../core/utils/api/api_result.dart';
import '../entity/bank_verification_entity.dart';

class ExecutePennyDropUseCase {
  final KycRepository kycRepository;

  ExecutePennyDropUseCase({required this.kycRepository});

  Future<Either<Result<BankVerificationEntity>, ApiError>> call(Map<String, dynamic> data) async {
    return await kycRepository.executePennyDrop(data);
  }
}