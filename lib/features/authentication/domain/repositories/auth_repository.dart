import 'package:dartz/dartz.dart';

import '../../../../core/utils/api/api_error.dart';
import '../../../../core/utils/api/api_result.dart';

abstract class AuthRepository {
  Future<Either<Result<String>,ApiError>>login(Map<String,dynamic> data);
}