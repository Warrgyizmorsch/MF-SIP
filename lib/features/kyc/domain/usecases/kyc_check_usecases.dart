import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/kyc/domain/entity/kyc_check_entity.dart';
import 'package:my_sip/features/kyc/domain/repository/kyc_repository.dart';

class CheckKycUseCase {
  final KycRepository repository;

  CheckKycUseCase(this.repository);

  Future<Either<Result<KycCheckEntity>, ApiError>> call(
    Map<String, dynamic> data,
  ) async {
    return await repository.checkKycStatus(data);
  }
}