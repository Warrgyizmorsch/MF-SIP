import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/features/personalization/domain/entity/delete_bank_entity.dart';
import 'package:my_sip/features/personalization/domain/repository/personalisation_repository.dart';

class DeleteBankUseCase {
  final PersonalisationRepository repository;

  DeleteBankUseCase({required this.repository});

  Future<Either<Result<DeleteBankEntity>, ApiError>> call({
    required int uid,
    required int bankId,
  }) async {
    return await repository.deleteBank(uid: uid, bankId: bankId);
  }
}
