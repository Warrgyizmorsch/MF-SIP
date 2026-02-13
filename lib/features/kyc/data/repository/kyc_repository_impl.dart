

import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/kyc/domain/entity/execute_poi_step2_entity.dart';
import 'package:my_sip/features/kyc/domain/entity/poi_step_1_entity.dart';
import 'package:my_sip/features/kyc/domain/repository/kyc_repository.dart';
import 'package:my_sip/features/personalization/domain/entity/bank_entity.dart';

import '../datasource/kyc_remote_data_source.dart';

class KycRepositoryImpl extends KycRepository{

  final KycRemoteDataSource _remoteDataSource;

  KycRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Result<BankResponseListEntity>, ApiError>> getAllBanks(Map<String, dynamic> data) async {
    try{
      final result = await _remoteDataSource.getAllBanks(data);
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

  @override
  Future<Either<Result<ExecutePOIStep1Entity>, ApiError>> executePOIStep1(Map<String, dynamic> data) async {
    try{
      final result = await _remoteDataSource.executePOIStep1(data);
      return  result.fold(
              (success){
            if(success.isSuccess){
              final result = success.data?.toEntity();
              return Left(Result.success(result));
            } else {
              return Right(ApiError(message: 'ExecutePOIStep1 Failed'));
            }
          },
              (error){
            return Right(ApiError(message: 'ExecutePOIStep1 Failed $error'));
          });
    } catch(e){
      return Right(ApiError(message: 'ExecutePOIStep1 Failed $e'));
    }
  }

  @override
  Future<Either<Result<ExecutePOIStep2Entity>, ApiError>> executePOIStep2(Map<String, dynamic> data) async {
    try{
      final result = await _remoteDataSource.executePOIStep2(data);
      return  result.fold(
              (success){
            if(success.isSuccess){
              final result = success.data?.toEntity();
              return Left(Result.success(result));
            } else {
              return Right(ApiError(message: 'ExecutePOIStep1 Failed'));
            }
          },
              (error){
            return Right(ApiError(message: 'ExecutePOIStep1 Failed $error'));
          });
    } catch(e){
      return Right(ApiError(message: 'ExecutePOIStep1 Failed $e'));
    }
  }
}