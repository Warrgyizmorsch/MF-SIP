import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/mfu/data/model/normal_txn_req_model.dart';
import 'package:my_sip/features/mfu/domain/entity/normal_txn_entity.dart';
import 'package:my_sip/features/mfu/domain/repository/mfu_repository_abstract.dart';

class MfuNormalTxnUseCase {
  final MfuRepository mfuRepository;

  MfuNormalTxnUseCase({required this.mfuRepository});

  Future<Either<Result<MfuNormalTxnEntity>, ApiError>> call(
    MfuNormalTxnRequest request,
  ) async {
    return await mfuRepository.normalTransaction(request);
  }
}