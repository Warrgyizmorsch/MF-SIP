import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/mfu/data/model/systematic_txn_req_model.dart';
import 'package:my_sip/features/mfu/domain/entity/systematic_txn_entity.dart';
import 'package:my_sip/features/mfu/domain/repository/mfu_repository_abstract.dart';

class MfuSystematicTxnUseCase {
  final MfuRepository mfuRepository;

  MfuSystematicTxnUseCase({required this.mfuRepository});

  Future<Either<Result<MfuSystematicTxnEntity>, ApiError>> call(
    MfuSystematicTxnRequest request,
  ) async {
    return await mfuRepository.systematicTransaction(request);
  }
}
