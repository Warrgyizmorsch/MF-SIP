import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/kyc/data/model/token_data_model.dart';
import 'package:my_sip/features/kyc/domain/entity/bank_verification_entity.dart';
import 'package:my_sip/features/kyc/domain/entity/createPdf_entity.dart';
import 'package:my_sip/features/kyc/domain/entity/create_esign_url_entity.dart';
import 'package:my_sip/features/kyc/domain/entity/execute_poi_step2_entity.dart';
import 'package:my_sip/features/kyc/domain/entity/file_upload_entity.dart';
import 'package:my_sip/features/kyc/domain/entity/get_esign_data_entity.dart';
import 'package:my_sip/features/kyc/domain/entity/poi_step_1_entity.dart';
import 'package:my_sip/features/kyc/domain/entity/verify_bank_account_entity.dart';
import 'package:my_sip/features/kyc/domain/repository/kyc_repository.dart';
import 'package:my_sip/features/personalization/domain/entity/bank_entity.dart';

import '../datasource/kyc_remote_data_source.dart';

class KycRepositoryImpl extends KycRepository {
  final KycRemoteDataSource _remoteDataSource;

  KycRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Result<BankResponseListEntity>, ApiError>> getAllBanks(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _remoteDataSource.getAllBanks(data);
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

  @override
  Future<Either<Result<ExecutePOIStep1Entity>, ApiError>> executePOIStep1(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _remoteDataSource.executePOIStep1(data);
      return result.fold(
        (success) {
          if (success.isSuccess) {
            final result = success.data?.toEntity();
            return Left(Result.success(result));
          } else {
            return Right(ApiError(message: 'ExecutePOIStep1 Failed'));
          }
        },
        (error) {
          return Right(ApiError(message: 'ExecutePOIStep1 Failed $error'));
        },
      );
    } catch (e) {
      return Right(ApiError(message: 'ExecutePOIStep1 Failed $e'));
    }
  }

  @override
  Future<Either<Result<ExecutePOIStep2Entity>, ApiError>> executePOIStep2(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _remoteDataSource.executePOIStep2(data);
      return result.fold(
        (success) {
          if (success.isSuccess) {
            final result = success.data?.toEntity();
            return Left(Result.success(result));
          } else {
            return Right(ApiError(message: 'ExecutePOIStep2 Failed'));
          }
        },
        (error) {
          return Right(ApiError(message: 'ExecutePOIStep2 Failed $error'));
        },
      );
    } catch (e) {
      return Right(ApiError(message: 'ExecutePOIStep2 Failed $e'));
    }
  }

  @override
  Future<Either<Result<String>, ApiError>> updateForm(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _remoteDataSource.updateForm(data);
      return result.fold(
        (success) {
          if (success.isSuccess) {
            final result = success.data;
            return Left(Result.success(result));
          } else {
            return Right(ApiError(message: 'updateForm Failed'));
          }
        },
        (error) {
          return Right(ApiError(message: 'updateForm Failed $error'));
        },
      );
    } catch (e) {
      return Right(ApiError(message: 'updateForm Failed $e'));
    }
  }

  @override
  Future<Either<Result<ExecutePOIStep2Entity>, ApiError>> executePOA(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _remoteDataSource.executePOA(data);
      return result.fold(
        (success) {
          if (success.isSuccess) {
            final result = success.data?.toEntity();
            return Left(Result.success(result));
          } else {
            return Right(ApiError(message: 'executePOA Failed'));
          }
        },
        (error) {
          return Right(ApiError(message: 'executePOA Failed $error'));
        },
      );
    } catch (e) {
      return Right(ApiError(message: 'executePOA Failed $e'));
    }
  }

  @override
  Future<Either<Result<BankVerificationEntity>, ApiError>> executePennyDrop(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _remoteDataSource.executePennyDrop(data);
      return result.fold(
        (success) {
          if (success.isSuccess) {
            final result = success.data?.toEntity();
            return Left(Result.success(result));
          } else {
            return Right(ApiError(message: 'executePennyDrop Failed'));
          }
        },
        (error) {
          return Right(ApiError(message: 'executePennyDrop Failed $error'));
        },
      );
    } catch (e) {
      return Right(ApiError(message: 'executePennyDrop Failed $e'));
    }
  }

  @override
  Future<Either<Result<VerifyAmountEntity>, ApiError>> executeVerifyAmount(Map<String, dynamic> data) async {
    try {
      final result = await _remoteDataSource.executeVerifyAmount(data);
      
      return result.fold(
        (success) {
          if (success.isSuccess && success.data != null) {
            // Map the Model to Entity safely
            final entityResult = success.data!.toEntity();
            return Left(Result.success(entityResult));
          } else {
            return Right(ApiError(message: 'executeVerifyAmount Failed: Invalid data structure'));
          }
        },
        (error) {
          return Right(ApiError(message: 'executeVerifyAmount Failed: ${error.message}'));
        },
      );
    } catch (e) {
      return Right(ApiError(message: 'executeVerifyAmount Failed Exception: $e'));
    }
  }

  @override
  Future<Either<Result<FileEntity>, ApiError>> uploadToSignZy(
    Map<String, String> data,
    List<Uint8List> files,
    List<String> fileNames,
  ) async {
    try {
      final result = await _remoteDataSource.uploadToSignZy(
        data,
        files,
        fileNames,
      );
      return result.fold(
        (success) {
          if (success.isSuccess) {
            final result = success.data?.toEntity();
            return Left(Result.success(result));
          } else {
            return Right(ApiError(message: 'uploadToSignZy Failed'));
          }
        },
        (error) {
          return Right(ApiError(message: 'uploadToSignZy Failed $error'));
        },
      );
    } catch (e) {
      return Right(ApiError(message: 'uploadToSignZy Failed $e'));
    }
  }

  @override
  Future<Either<Result<Uint8List?>, ApiError>> getCaptcha(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _remoteDataSource.getCaptcha(data);
      return result.fold(
        (success) {
          if (success.isSuccess) {
            final result = success.data;
            return Left(Result.success(result));
          } else {
            return Right(ApiError(message: 'getCaptcha Failed'));
          }
        },
        (error) {
          return Right(ApiError(message: 'getCaptcha Failed $error'));
        },
      );
    } catch (e) {
      return Right(ApiError(message: 'getCaptcha Failed $e'));
    }
  }

  @override
  Future<Either<Result<TokenDataModel>, ApiError>> getData() async {
    try {
      final result = await _remoteDataSource.getData();
      return result.fold(
        (success) {
          if (success.isSuccess) {
            final result = success.data;
            return Left(Result.success(result));
          } else {
            return Right(ApiError(message: 'getData Failed'));
          }
        },
        (error) {
          return Right(ApiError(message: 'getData Failed $error'));
        },
      );
    } catch (e) {
      return Right(ApiError(message: 'getData Failed $e'));
    }
  }

  //
  @override
  Future<Either<Result<CreatePdfEntity>, ApiError>> createPdf(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _remoteDataSource.createPdf(data);
      return result.fold(
        (success) {
          if (success.isSuccess && success.data != null) {
            // Map the Model to the Entity
            final entityResult = success.data!.toEntity();
            return Left(Result.success(entityResult));
          } else {
            return Right(ApiError(message: 'createPdf Failed'));
          }
        },
        (error) {
          return Right(ApiError(message: 'createPdf Failed $error'));
        },
      );
    } catch (e) {
      return Right(ApiError(message: 'createPdf Failed $e'));
    }
  }

  @override
  Future<Either<Result<CreateEsignUrlEntity>, ApiError>> createEsignUrl(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _remoteDataSource.createEsignUrl(data);
      return result.fold(
        (success) {
          if (success.isSuccess && success.data != null) {
            // Map the Model to the Entity
            final entityResult = success.data!.toEntity();
            return Left(Result.success(entityResult));
          } else {
            return Right(ApiError(message: 'createEsignUrl Failed'));
          }
        },
        (error) {
          return Right(ApiError(message: 'createEsignUrl Failed $error'));
        },
      );
    } catch (e) {
      return Right(ApiError(message: 'createEsignUrl Failed $e'));
    }
  }

  // Save Aadhaar Esign Signed PDF

  @override
  Future<Either<Result<GetEsignDataEntity>, ApiError>> getEsignData(
    Map<String, dynamic> data,
  ) async {
    try {
      // 1. Call the remote data source
      final result = await _remoteDataSource.getEsignData(data);

      return result.fold(
        (success) {
          if (success.isSuccess && success.data != null) {
            // 2. Map the Model to the Entity using the mapper we created
            final entityResult = success.data!.toEntity();
            return Left(Result.success(entityResult));
          } else {
            return Right(
              ApiError(message: 'getEsignData Failed: Invalid data'),
            );
          }
        },
        (error) {
          return Right(
            ApiError(message: 'getEsignData Failed: ${error.message}'),
          );
        },
      );
    } catch (e) {
      return Right(ApiError(message: 'getEsignData Failed with Exception: $e'));
    }
  }
}
