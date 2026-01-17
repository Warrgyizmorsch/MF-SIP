import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/explore/data/datasources/fund_house_remote_ds.dart';
import 'package:my_sip/features/explore/domain/entities/fund_house_entity.dart';
import 'package:my_sip/features/explore/domain/repositories/fund_house_repository.dart';

class FundHouseRepoImple extends FundHouseRepository {
  final FundHouseRemoteDs _remoteDs;

  FundHouseRepoImple(this._remoteDs);

  @override
  Future<Either<Result<FundHouseItemEntity>, ApiError>> getFundHouse(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _remoteDs.getFundHouse(data);
      return result.fold(
        (success) {
          if (success.isSuccess) {
            final result = success.data?.toEntity();
            return Left(Result.success(result));
          } else {
            return Right(ApiError(message: 'Get fundhouse Failed'));
          }
        },
        (error) {
          return Right(ApiError(message: 'Get fundhouse Failed $error'));
        },
      );
    } catch (e) {
      return Right(ApiError(message: 'Get fundhouse Failed $e'));
    }
  }
}
