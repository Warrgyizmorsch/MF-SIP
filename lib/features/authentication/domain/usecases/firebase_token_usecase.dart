
import 'package:dartz/dartz.dart';

import '../../../../core/utils/api/api_error.dart';
import '../../../../core/utils/api/api_result.dart';
import '../entitites/auth_entity.dart';
import '../repositories/auth_repository.dart';

class FcmDeviceTokenUseCase {
final AuthRepository authRepository;

FcmDeviceTokenUseCase(this.authRepository);

Future<Either<Result<FcmDeviceTokenEntity>, ApiError>> call(Map<String, dynamic> data) async {
return await authRepository.fcmDeviceToken(data);
}
}