import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/personalization/data/model/risk_result_model.dart';
import 'package:my_sip/features/personalization/domain/entity/account_statement_entity.dart';
import 'package:my_sip/features/personalization/domain/entity/add_bank_response_entity.dart';
import 'package:my_sip/features/personalization/domain/entity/bank_entity.dart';
import 'package:my_sip/features/personalization/domain/entity/capital_gs_entity.dart';
import 'package:my_sip/features/personalization/domain/entity/delete_bank_entity.dart';
import 'package:my_sip/features/personalization/domain/entity/nominee_entity.dart';
import 'package:my_sip/features/personalization/domain/entity/profile_update_entity.dart';
import 'package:my_sip/features/personalization/domain/entity/risk_question_entity.dart';
import 'package:my_sip/features/personalization/domain/entity/risk_result_entity.dart';
import 'package:my_sip/features/personalization/domain/repository/personalisation_repository.dart';

import '../datasource/personalisation_remote_data_source.dart';

class PersonalisationRepositoryImpl extends PersonalisationRepository {
  final PersonalisationRemoteDataSource _remoteDataSource;

  PersonalisationRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Result<BankResponseListEntity>, ApiError>> getBanks(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _remoteDataSource.getBank(data);
      return result.fold(
        (success) {
          if (success.isSuccess) {
            final result = success.data?.toEntity();
            return Left(Result.success(result));
          } else {
            return Right(ApiError(message: 'Get Bank Failed'));
          }
        },
        (error) {
          return Right(ApiError(message: 'Get Bank Failed $error'));
        },
      );
    } catch (e) {
      return Right(ApiError(message: 'Get Bank Failed $e'));
    }
  }

  // Risk Questions Entity
  @override
  Future<Either<Result<RiskQuestionEntity>, ApiError>> getRiskQuestions(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _remoteDataSource.getQuestions(data);
      return result.fold(
        (success) {
          if (success.isSuccess) {
            final result = success.data?.toEntity();
            return Left(Result.success(result));
          } else {
            return Right(ApiError(message: 'Get Bank Failed'));
          }
        },
        (error) {
          return Right(ApiError(message: 'Get Bank Failed $error'));
        },
      );
    } catch (e) {
      return Right(ApiError(message: 'Get Bank Failed $e'));
    }
  }

  // Risk result
  @override
  Future<Either<Result<RiskResultModel>, ApiError>> riskSubmitResult(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _remoteDataSource.submitRiskAssesment(data);
      return result.fold(
        (success) {
          if (success.isSuccess) {
            final result = success.data;
            return Left(Result.success(result));
          } else {
            return Right(ApiError(message: 'Risk Result Failed'));
          }
        },
        (error) {
          return Right(ApiError(message: 'Risk Result Failed $error'));
        },
      );
    } catch (e) {
      return Right(ApiError(message: 'Risk Result Failed $e'));
    }
  }

  @override
  Future<Either<Result<String>, ApiError>> addNominee(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _remoteDataSource.addNominee(data);
      return result.fold(
        (success) {
          if (success.isSuccess) {
            final result = success.data;
            return Left(Result.success(result));
          } else {
            return Right(ApiError(message: 'addNominee Failed'));
          }
        },
        (error) {
          return Right(ApiError(message: 'addNominee Failed $error'));
        },
      );
    } catch (e) {
      return Right(ApiError(message: 'addNominee Failed $e'));
    }
  }

  @override
  Future<Either<Result<NomineeResponseEntity>, ApiError>> getNominee(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _remoteDataSource.getNominee(data);
      return result.fold(
        (success) {
          if (success.isSuccess) {
            final result = success.data?.toEntity();
            return Left(Result.success(result));
          } else {
            return Right(ApiError(message: 'getNominee Failed'));
          }
        },
        (error) {
          return Right(ApiError(message: 'getNominee Failed $error'));
        },
      );
    } catch (e) {
      return Right(ApiError(message: 'getNominee Failed $e'));
    }
  }

  @override
  Future<Either<Result<String>, ApiError>> deleteNominee(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _remoteDataSource.deleteNominee(data);
      return result.fold(
        (success) {
          if (success.isSuccess) {
            final result = success.data;
            return Left(Result.success(result));
          } else {
            return Right(ApiError(message: 'deleteNominee Failed'));
          }
        },
        (error) {
          return Right(ApiError(message: 'deleteNominee Failed $error'));
        },
      );
    } catch (e) {
      return Right(ApiError(message: 'deleteNominee Failed $e'));
    }
  }

  // Profile Update
  @override
  Future<Either<Result<ProfileUpdateResponseEntity>, ApiError>> updateProfile(
    Map<String, dynamic> data,
  ) async {
    try {
      // 1. Call the Remote Data Source
      final result = await _remoteDataSource.updateProfile(data);

      return result.fold(
        (success) {
          if (success.isSuccess) {
            // 2. Map Model to Entity using your extension
            final entity = success.data?.toEntity();
            return Left(Result.success(entity));
          } else {
            return Right(
              ApiError(message: 'Profile Update Failed: Success was false'),
            );
          }
        },
        (error) {
          // 3. Forward the specific API error message
          return Right(
            ApiError(message: 'Profile Update Failed: ${error.message}'),
          );
        },
      );
    } catch (e) {
      // 4. Catch unexpected local exceptions
      return Right(
        ApiError(message: 'Profile Update Failed with Exception $e'),
      );
    }
  }

  @override
  Future<Either<Result<CapitalGainStatementEntity>, ApiError>>
  requestCapitalGainStatement({
    required int uid,
    required String type,
    String? email,
    required String folioNo,
    required String startDate,
    required String endDate,
  }) async {
    try {
      final response = await _remoteDataSource.requestCapitalGainStatement(
        uid: uid,
        type: type,
        email: email,
        folioNo: folioNo,
        startDate: startDate,
        endDate: endDate,
      );

      return response.fold(
        (successResult) => Left(Result.success(successResult.data!.toEntity())),
        (error) => Right(error),
      );
    } catch (e) {
      return Right(ApiError(message: e.toString()));
    }
  }

  @override
  Future<Either<Result<AccountStatementEntity>, ApiError>>
  requestAccountStatement({
    required int uid,
    required String type,
    String? email,
    required String folioNo,
    required String startDate,
    required String endDate,
  }) async {
    try {
      final response = await _remoteDataSource.requestAccountStatement(
        uid: uid,
        type: type,
        email: email,
        folioNo: folioNo,
        startDate: startDate,
        endDate: endDate,
      );

      return response.fold(
        (successResult) => Left(Result.success(successResult.data!.toEntity())),
        (error) => Right(error),
      );
    } catch (e) {
      return Right(ApiError(message: e.toString()));
    }
  }

  @override
  Future<Either<Result<AddBankResponseEntity>, ApiError>> addBankAccount({
    required int uid,
    required String accountHolderName,
    required String accountNumber,
    required String ifscCode,
    required String micrCode,
    required String accountType,
    required String bankName,
    required String bankProofType,
    required Uint8List? bankProofBytes,
    required String? bankProofFileName,
  }) async {
    try {
      final response = await _remoteDataSource.addBankAccount(
        uid: uid,
        accountHolderName: accountHolderName,
        accountNumber: accountNumber,
        ifscCode: ifscCode,
        micrCode: micrCode,
        accountType: accountType,
        bankName: bankName,
        bankProofType: bankProofType,
        bankProofBytes: bankProofBytes,
        bankProofFileName: bankProofFileName,
      );

      return response.fold(
        (successResult) => Left(Result.success(successResult.data!.toEntity())),
        (error) => Right(error),
      );
    } catch (e) {
      return Right(ApiError(message: e.toString()));
    }
  }

  @override
  Future<Either<Result<DeleteBankEntity>, ApiError>> deleteBank({
    required int uid,
    required int bankId,
  }) async {
    try {
      final response = await _remoteDataSource.deleteBank(
        uid: uid,
        bankId: bankId,
      );
      return response.fold(
        (successResult) => Left(Result.success(successResult.data!.toEntity())),
        (error) => Right(error),
      );
    } catch (e) {
      return Right(ApiError(message: e.toString()));
    }
  }
}
