// features/mfu/domain/usecases/mfu_can_bank_validation_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/mfu/domain/entity/mfu_bank_validation_entity.dart';
import 'package:my_sip/features/mfu/domain/repository/mfu_repository_abstract.dart';

class MfuCanBankValidationUseCase {
  final MfuRepository mfuRepository;

  MfuCanBankValidationUseCase({required this.mfuRepository});

  Future<Either<Result<MfuCanBankValidationEntity>, ApiError>> call({
    required int uid,
  }) async {
    return await mfuRepository.canBankValidation(uid: uid);
  }
}
