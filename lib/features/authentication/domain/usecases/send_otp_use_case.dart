import 'package:dartz/dartz.dart';
import 'package:my_sip/features/authentication/domain/repositories/auth_repository.dart';

import '../../../../core/utils/api/api_error.dart';
import '../../../../core/utils/api/api_result.dart';

class SendOtpUseCase {
  final AuthRepository authRepository;

  SendOtpUseCase({required this.authRepository});

  Future<Either<Result<String>, ApiError>> call(Map<String, dynamic> data) async {
    return await authRepository.sendOtpForLogin(data);
  }
}