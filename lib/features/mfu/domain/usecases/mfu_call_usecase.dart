// mfu_call_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/mfu/data/model/mfu_call_request_base.dart';
import 'package:my_sip/features/mfu/data/model/mfu_call_response_wrapper.dart';
import 'package:my_sip/features/mfu/domain/repository/mfu_repository_abstract.dart';

class MfuCallUseCase {
  final MfuRepository mfuRepository;

  MfuCallUseCase({required this.mfuRepository});

  Future<Either<Result<MfuCallResponseWrapper>, ApiError>> call(
    MfuCallRequestBase request,
  ) async {
    return await mfuRepository.mfuCall(request);
  }
}