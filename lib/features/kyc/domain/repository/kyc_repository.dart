import 'package:dartz/dartz.dart';
import 'package:my_sip/features/personalization/domain/entity/bank_entity.dart';

import '../../../../core/utils/api/api_error.dart';
import '../../../../core/utils/api/api_result.dart';

abstract class KycRepository {
  Future<Either<Result<BankResponseListEntity>,ApiError>>getAllBanks(Map<String,dynamic> data);

}