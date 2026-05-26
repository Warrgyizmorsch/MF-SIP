import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:my_sip/features/authentication/domain/entitites/auth_entity.dart';
import 'package:my_sip/features/authentication/domain/repositories/auth_repository.dart';


class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Result<LoginResponseEntity>, ApiError>> login(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _remoteDataSource.loginWithEmailAndPassword(data);
      return result.fold(
        (success) {
          if (success.isSuccess) {
            final result = success.data?.toEntity();
            return Left(Result.success(result));
          } else {
            return Right(ApiError(message: 'Login Failed'));
          }
        },
        (error) {
          return Right(ApiError(message: 'Login Failed $error'));
        },
      );
    } catch (e) {
      return Right(ApiError(message: 'Login Failed $e'));
    }
  }

  @override
  Future<Either<Result<RegisterResponseEntity>, ApiError>> registerUser(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _remoteDataSource.registerUser(data);
      return result.fold(
        (success) {
          if (success.isSuccess) {
            final result = success.data?.toEntity();
            return Left(Result.success(result));
          } else {
            return Right(ApiError(message: 'Register Failed'));
          }
        },
        (error) {
          return Right(ApiError(message: error.message));
        },
      );
    } catch (e) {
      return Right(ApiError(message: e.toString()));
    }
  }

  @override
  Future<Either<Result<String>, ApiError>> sendOtpForLogin(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _remoteDataSource.sendOtpForLogin(data);
      return result.fold(
        (success) {
          if (success.isSuccess) {
            final result = success.data;
            return Left(Result.success(result));
          } else {
            return Right(ApiError(message: 'Send Otp Failed'));
          }
        },
        (error) {
          return Right(ApiError(message: 'Send Otp Failed $error'));
        },
      );
    } catch (e) {
      return Right(ApiError(message: 'Send Otp Failed $e'));
    }
  }

  @override
  Future<Either<Result<LoginResponseEntity>, ApiError>> verifyOtpForLogin(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _remoteDataSource.verifyOtpForLogin(data);
      return result.fold(
        (success) {
          if (success.isSuccess) {
            final result = success.data?.toEntity();
            return Left(Result.success(result));
          } else {
            return Right(ApiError(message: 'Login Failed'));
          }
        },
        (error) {
          return Right(ApiError(message: 'Login Failed $error'));
        },
      );
    } catch (e) {
      return Right(ApiError(message: 'Login Failed $e'));
    }
  }

  @override
  Future<Either<Result<FcmDeviceTokenEntity>, ApiError>> fcmDeviceToken(
      Map<String, dynamic> data,) async {
    try {
      final result = await _remoteDataSource.fcmDeviceToken(data);

      return result.fold(
            (success) {
          if (success.isSuccess) {
            final result = success.data?.toEntity();

            return Left(Result.success(result));
          } else {
            return Right(ApiError(message: 'FCM Device Token Failed'));
          }
        },
            (error) {
          return Right(ApiError(message: 'FCM Device Token Failed $error'));
        },
      );
    } catch (e) {
      return Right(ApiError(message: 'FCM Device Token Failed $e'));
    }
  }
}
