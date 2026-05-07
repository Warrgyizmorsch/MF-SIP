import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/mfu/domain/entity/can_status_entity.dart';
import 'package:my_sip/features/mfu/domain/repository/mfu_repository_abstract.dart';

class GetCanStatusUseCase {
  final MfuRepository mfuRepository;

  GetCanStatusUseCase({required this.mfuRepository});

  Future<Either<Result<MfuCanStatusEntity>, ApiError>> call({
    required String can,
  }) async {
    return await mfuRepository.getCanStatus(can: can);
  }
}
