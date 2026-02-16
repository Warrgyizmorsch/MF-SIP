import 'package:dartz/dartz.dart';

import '../../../../core/utils/api/api_error.dart';
import '../../../../core/utils/api/api_result.dart';
import '../repository/kyc_repository.dart';

class UpdateFormUseCase {
  final KycRepository kycRepository;

  UpdateFormUseCase({required this.kycRepository});

  Future<Either<Result<String>, ApiError>> call(Map<String, dynamic> data) async {
    return await kycRepository.updateForm(data);
  }

}