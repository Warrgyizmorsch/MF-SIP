

import 'package:dartz/dartz.dart';
import 'package:my_sip/features/authentication/domain/entitites/auth_entity.dart';

import '../../../../core/utils/api/api_error.dart';
import '../../../../core/utils/api/api_result.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository authRepository;

  RegisterUseCase(this.authRepository);

  Future<Either<Result<RegisterResponseEntity>, ApiError>> call(Map<String, dynamic> data) async {
    return await authRepository.registerUser(data);
  }
}