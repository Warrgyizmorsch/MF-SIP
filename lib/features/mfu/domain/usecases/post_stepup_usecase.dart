import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/mfu/data/model/stepup_req_model.dart';
import 'package:my_sip/features/mfu/data/model/stepup_res_model.dart';
import 'package:my_sip/features/mfu/domain/repository/mfu_repository_abstract.dart';

class PostStepUpUseCase {
  final MfuRepository _repository;

  PostStepUpUseCase(this._repository);

  Future<Either<Result<StepUpResModel>, ApiError>> call(
    StepUpReqModel request,
  ) {
    return _repository.postStepUp(request);
  }
}
