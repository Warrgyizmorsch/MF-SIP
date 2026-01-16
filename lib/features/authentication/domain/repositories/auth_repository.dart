import 'package:dartz/dartz.dart';
import 'package:my_sip/features/authentication/domain/entitites/auth_entity.dart';

import '../../../../core/utils/api/api_error.dart';
import '../../../../core/utils/api/api_result.dart';

abstract class AuthRepository {
 // entity for repository String is Entity
  Future<Either<Result<LoginResponseEntity>,ApiError>>login(Map<String,dynamic> data);
  Future<Either<Result<RegisterResponseEntity>,ApiError>>registerUser(Map<String,dynamic> data);
}