import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/personalization/domain/entity/bank_entity.dart';
import 'package:my_sip/features/personalization/domain/repository/personalisation_repository.dart';

import '../datasource/personalisation_remote_data_source.dart';

class PersonalisationRepositoryImpl extends PersonalisationRepository{
  final PersonalisationRemoteDataSource _remoteDataSource;

  PersonalisationRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Result<BankResponseListEntity>, ApiError>> getBanks(Map<String, dynamic> data) async {
    try{
      final result = await _remoteDataSource.getBank(data);
      return  result.fold(
              (success){
            if(success.isSuccess){
              final result = success.data?.toEntity();
              return Left(Result.success(result));
            } else {
              return Right(ApiError(message: 'Get Bank Failed'));
            }
          },
              (error){
            return Right(ApiError(message: 'Get Bank Failed $error'));
          });
    } catch(e){
      return Right(ApiError(message: 'Get Bank Failed $e'));
    }
  }
}