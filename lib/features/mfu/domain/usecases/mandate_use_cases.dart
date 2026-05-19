import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/mfu/domain/entity/mandate_entity.dart';
import 'package:my_sip/features/mfu/domain/repository/mfu_repository_abstract.dart';

class MfuMandateCreateUseCase {
  final MfuRepository mfuRepository;

  MfuMandateCreateUseCase({required this.mfuRepository});

  Future<Either<Result<MfuMandateCreateEntity>, ApiError>> call({
    required int uid,
    required String mandateType,
    String? upiId,
  }) async {
    return await mfuRepository.createMandate(
      uid: uid,
      mandateType: mandateType,
      upiId: upiId,
    );
  }
}
