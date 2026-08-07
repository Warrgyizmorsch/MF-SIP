import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/mfu/domain/entity/can_register_entity.dart';
import 'package:my_sip/features/mfu/domain/repository/mfu_repository_abstract.dart';

class CanRegisterUseCase {
  final MfuRepository mfuRepository;

  CanRegisterUseCase({required this.mfuRepository});

  Future<Either<Result<MfuCanResponseEntity>, ApiError>> call() async {
    return await mfuRepository.canRegister();
  }
}
