
import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/mfu/domain/entity/emandate_status_entity.dart';
import 'package:my_sip/features/mfu/domain/repository/mfu_repository_abstract.dart';

class MfuMandateStatusUseCase {
  final MfuRepository mfuRepository;

  MfuMandateStatusUseCase({required this.mfuRepository});

  Future<Either<Result<MfuMandateStatusEntity>, ApiError>> call({
    required int uid,
    required String mandateType,
  }) async {
    return await mfuRepository.getMandateStatus(
      uid: uid,
      mandateType: mandateType,
    );
  }
}