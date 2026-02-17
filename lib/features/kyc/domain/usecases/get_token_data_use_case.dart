import 'package:dartz/dartz.dart';
import 'package:my_sip/features/kyc/domain/repository/kyc_repository.dart';

import '../../../../core/utils/api/api_error.dart';
import '../../../../core/utils/api/api_result.dart';
import '../../data/model/token_data_model.dart';

class GetTokenDataUseCase {
  final KycRepository kycRepository;

  GetTokenDataUseCase({required this.kycRepository});

  Future<Either<Result<TokenDataModel>, ApiError>> call() async {
    return await kycRepository.getData();
  }
}