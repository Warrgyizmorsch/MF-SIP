import 'package:dartz/dartz.dart';
import 'package:my_sip/features/authentication/domain/repositories/auth_repository.dart';

import '../../../../core/utils/api/api_error.dart';
import '../../../../core/utils/api/api_result.dart';
import '../entitites/auth_entity.dart';

class VerifyOtpUseCase {
  final AuthRepository _authRepository;

  VerifyOtpUseCase({required AuthRepository authRepository}) : _authRepository = authRepository;

  Future<Either<Result<LoginResponseEntity>,ApiError>>call(Map<String,dynamic> data)async {
    return await _authRepository.verifyOtpForLogin(data);
  }

}