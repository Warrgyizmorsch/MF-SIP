import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/nfo/data/datasource/nfo_remote_ds.dart';
import 'package:my_sip/features/nfo/domain/entity/nfo_list_entity.dart';
import 'package:my_sip/features/nfo/domain/repositories/nfo_repo.dart';

class NfoRepoImpl extends NfoRepo {
  final NfoRemoteDs nfoRemoteDs;
  NfoRepoImpl(this.nfoRemoteDs);

  @override
  Future<Either<Result<NfoListEntity>, ApiError>> getNfoList(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await nfoRemoteDs.getNfoList(data);
      return result.fold(
        (success) {
          if (success.isSuccess) {
            final result = success.data?.toEntity();
            return Left(Result.success(result));
          } else {
            return Right(ApiError(message: 'Get nfo fund list Failed'));
          }
        },
        (error) {
          return Right(ApiError(message: 'Get nfo fund list  Failed $error'));
        },
      );
    } catch (e) {
      return Right(ApiError(message: 'Get nfo fund list  Failed $e'));
    }
  }
}
