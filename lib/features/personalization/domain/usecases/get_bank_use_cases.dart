import 'package:dartz/dartz.dart';
import 'package:my_sip/features/personalization/domain/repository/personalisation_repository.dart';

import '../../../../core/utils/api/api_error.dart';
import '../../../../core/utils/api/api_result.dart';
import '../entity/bank_entity.dart';

class GetBankUseCases {
  final PersonalisationRepository _repository;

  GetBankUseCases(this._repository);

  Future<Either<Result<BankResponseListEntity>,ApiError>>call(Map<String,dynamic> data) async {
    return await _repository.getBanks(data);
  }
}