import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/mfu/data/model/lumpsum_req_model.dart';
import 'package:my_sip/features/mfu/data/model/lumpsum_res_model.dart';
import 'package:my_sip/features/mfu/domain/repository/mfu_repository_abstract.dart';

class PostLumpsumUseCase {
  final MfuRepository _repository;

  PostLumpsumUseCase(this._repository);

  Future<Either<Result<LumpsumResModel>, ApiError>> call(
    LumpsumReqModel request,
  ) {
    return _repository.postLumpsum(request);
  }
}
