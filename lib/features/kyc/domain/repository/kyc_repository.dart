import 'package:dartz/dartz.dart';
import 'package:my_sip/features/kyc/domain/entity/poi_step_1_entity.dart';
import 'package:my_sip/features/personalization/domain/entity/bank_entity.dart';

import '../../../../core/utils/api/api_error.dart';
import '../../../../core/utils/api/api_result.dart';
import '../entity/execute_poi_step2_entity.dart';

abstract class KycRepository {
  Future<Either<Result<BankResponseListEntity>,ApiError>>getAllBanks(Map<String,dynamic> data);
  Future<Either<Result<ExecutePOIStep1Entity>,ApiError>>executePOIStep1(Map<String,dynamic> data);
  Future<Either<Result<ExecutePOIStep2Entity>,ApiError>>executePOIStep2(Map<String,dynamic> data);
  Future<Either<Result<ExecutePOIStep2Entity>,ApiError>>executePOA(Map<String,dynamic> data);
  Future<Either<Result<String>, ApiError>> updateForm(Map<String, dynamic> data,);

}