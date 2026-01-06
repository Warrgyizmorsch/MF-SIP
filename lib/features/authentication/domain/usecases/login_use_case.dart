import 'package:dartz/dartz.dart';
import 'package:my_sip/features/authentication/domain/repositories/auth_repository.dart';

import '../../../../core/utils/api/api_error.dart';
import '../../../../core/utils/api/api_result.dart';

class LoginUseCase {
  final AuthRepository authRepository;

  LoginUseCase(this.authRepository);

  Future<Either<Result<String>, ApiError>> login(Map<String, dynamic> data) async {
    return await authRepository.login(data);
  }
}