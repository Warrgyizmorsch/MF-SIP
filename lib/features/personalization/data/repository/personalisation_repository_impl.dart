import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/personalization/data/model/risk_result_model.dart';
import 'package:my_sip/features/personalization/domain/entity/bank_entity.dart';
import 'package:my_sip/features/personalization/domain/entity/nominee_entity.dart';
import 'package:my_sip/features/personalization/domain/entity/risk_question_entity.dart';
import 'package:my_sip/features/personalization/domain/entity/risk_result_entity.dart';
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


  // Risk Questions Entity 
  @override
  Future<Either<Result<RiskQuestionEntity>, ApiError>> getRiskQuestions(Map<String, dynamic> data) async {
    try{
      final result = await _remoteDataSource.getQuestions(data);
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

  // Risk result 
  @override
  Future<Either<Result<RiskResultModel>, ApiError>> riskSubmitResult(Map<String, dynamic> data) async {
    try{
      final result = await _remoteDataSource.submitRiskAssesment(data);
      return  result.fold(
              (success){
            if(success.isSuccess){
              final result = success.data;
              return Left(Result.success(result));
            } else {
              return Right(ApiError(message: 'Risk Result Failed'));
            }
          },
              (error){
            return Right(ApiError(message: 'Risk Result Failed $error'));
          });
    } catch(e){
      return Right(ApiError(message: 'Risk Result Failed $e'));
    }
  }

  @override
  Future<Either<Result<String>, ApiError>> addNominee(Map<String, dynamic> data) async {
    try{
      final result = await _remoteDataSource.addNominee(data);
      return  result.fold(
              (success){
            if(success.isSuccess){
              final result = success.data;
              return Left(Result.success(result));
            } else {
              return Right(ApiError(message: 'addNominee Failed'));
            }
          },
              (error){
            return Right(ApiError(message: 'addNominee Failed $error'));
          });
    } catch(e){
      return Right(ApiError(message: 'addNominee Failed $e'));
    }
  }

  @override
  Future<Either<Result<NomineeResponseEntity>, ApiError>> getNominee(Map<String, dynamic> data) async {
    try{
      final result = await _remoteDataSource.getNominee(data);
      return  result.fold(
              (success){
            if(success.isSuccess){
              final result = success.data?.toEntity();
              return Left(Result.success(result));
            } else {
              return Right(ApiError(message: 'getNominee Failed'));
            }
          },
              (error){
            return Right(ApiError(message: 'getNominee Failed $error'));
          });
    } catch(e){
      return Right(ApiError(message: 'getNominee Failed $e'));
    }
  }

  @override
  Future<Either<Result<String>, ApiError>> deleteNominee(Map<String, dynamic> data) async {
    try{
      final result = await _remoteDataSource.deleteNominee(data);
      return  result.fold(
              (success){
            if(success.isSuccess){
              final result = success.data;
              return Left(Result.success(result));
            } else {
              return Right(ApiError(message: 'deleteNominee Failed'));
            }
          },
              (error){
            return Right(ApiError(message: 'deleteNominee Failed $error'));
          });
    } catch(e){
      return Right(ApiError(message: 'deleteNominee Failed $e'));
    }
  }
}