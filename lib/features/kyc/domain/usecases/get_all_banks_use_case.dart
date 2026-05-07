import 'package:dartz/dartz.dart';
import 'package:my_sip/features/kyc/domain/repository/kyc_repository.dart';
import '../../../../core/utils/api/api_error.dart';
import '../../../../core/utils/api/api_result.dart';
import '../../../personalization/domain/entity/bank_entity.dart';

class GetAllBanksUseCases {
  final KycRepository _repository;

  GetAllBanksUseCases(this._repository);

  Future<Either<Result<BankResponseListEntity>,ApiError>>call(Map<String,dynamic> data) async {
    return await _repository.getAllBanks(data);
  }
}