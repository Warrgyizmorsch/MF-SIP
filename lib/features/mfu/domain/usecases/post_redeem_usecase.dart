import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/mfu/data/model/redeem_req_model.dart';
import 'package:my_sip/features/mfu/data/model/redeem_res_model.dart';
import 'package:my_sip/features/mfu/domain/repository/mfu_repository_abstract.dart';

class PostRedeemUseCase {
  final MfuRepository _repository;

  PostRedeemUseCase(this._repository);

  Future<Either<Result<RedeemResModel>, ApiError>> call(RedeemReqModel req) {
    return _repository.postRedeem(req);
  }
}
