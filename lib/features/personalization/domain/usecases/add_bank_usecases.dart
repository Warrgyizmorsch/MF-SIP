// features/kyc/domain/usecases/add_bank_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/personalization/domain/entity/add_bank_response_entity.dart';
import 'package:my_sip/features/personalization/domain/repository/personalisation_repository.dart';

class AddBankUseCase {
  final PersonalisationRepository personalisationRepository;

  AddBankUseCase({required this.personalisationRepository});

  Future<Either<Result<AddBankResponseEntity>, ApiError>> call({
    required int uid,
    required String accountHolderName,
    required String accountNumber,
    required String ifscCode,
    required String micrCode,
    required String accountType,
    required String bankName,
  }) async {
    return await personalisationRepository.addBankAccount(
      uid: uid,
      accountHolderName: accountHolderName,
      accountNumber: accountNumber,
      ifscCode: ifscCode,
      micrCode: micrCode,
      accountType: accountType,
      bankName: bankName,
    );
  }
}
