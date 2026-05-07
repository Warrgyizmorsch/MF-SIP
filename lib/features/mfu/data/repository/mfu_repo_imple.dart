import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/mfu/data/datasource/mfu_remote_data_source.dart';
import 'package:my_sip/features/mfu/domain/entity/can_register_entity.dart';
import 'package:my_sip/features/mfu/domain/entity/can_status_entity.dart';
import 'package:my_sip/features/mfu/domain/repository/mfu_repository_abstract.dart';

class MfuRepositoryImpl extends MfuRepository {
  final MfuRemoteDataSource _remoteDataSource;

  MfuRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Result<MfuCanResponseEntity>, ApiError>> canRegister({
    required int uid,
    String reqEvent = "CR",
  }) async {
    try {
      final response = await _remoteDataSource.canRegister(
        uid: uid,
        reqEvent: reqEvent,
      );

      return response.fold((successResult) {
        final entity = successResult.data!.toEntity();
        return Left(Result.success(entity));
      }, (error) => Right(error));
    } catch (e) {
      return Right(ApiError(message: e.toString()));
    }
  }

  @override
  Future<Either<Result<MfuCanStatusEntity>, ApiError>> getCanStatus({
    required String can,
  }) async {
    try {
      final response = await _remoteDataSource.getCanStatus(can: can);
      return response.fold(
        (successResult) => Left(Result.success(successResult.data!.toEntity())),
        (error) => Right(error),
      );
    } catch (e) {
      return Right(ApiError(message: e.toString()));
    }
  }
}
