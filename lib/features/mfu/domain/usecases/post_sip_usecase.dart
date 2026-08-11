import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/mfu/data/model/sip_req_model.dart';
import 'package:my_sip/features/mfu/data/model/sip_res_model.dart';
import 'package:my_sip/features/mfu/domain/repository/mfu_repository_abstract.dart';

class PostSipUseCase {
  final MfuRepository _repository;

  PostSipUseCase(this._repository);

  Future<Either<Result<SipResModel>, ApiError>> call(SipReqModel request) {
    return _repository.postSip(request);
  }
}
