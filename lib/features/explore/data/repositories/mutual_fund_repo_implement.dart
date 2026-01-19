import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/explore/data/datasources/mutualfund_remote_ds.dart';
import 'package:my_sip/features/explore/domain/entities/mutual_fund_list_entity.dart';
import 'package:my_sip/features/explore/domain/repositories/mutual_fund_repository.dart';

class MutualFundRepoImplement extends MutualFundRepository {
final MutualfundRemoteDs _mutualfundRemoteDs;

  MutualFundRepoImplement(this._mutualfundRemoteDs);

  @override
  Future<Either<Result<MutualFundListResponseEntity>, ApiError>> getMutualFundList(Map<String, dynamic> data) async {

try {
      final result = await _mutualfundRemoteDs.getFundHouse(data);
      return result.fold(
        (success) {
          if (success.isSuccess) {
            final result = success.data?.toEntity();
            return Left(Result.success(result));
          } else {
            return Right(ApiError(message: 'Get mutual fund list Failed'));
          }
        },
        (error) {
          return Right(ApiError(message: 'Get mutaul fund list  Failed $error'));
        },
      );
    } catch (e) {
      return Right(ApiError(message: 'Get mutual fund list  Failed $e'));
    }

  }
}