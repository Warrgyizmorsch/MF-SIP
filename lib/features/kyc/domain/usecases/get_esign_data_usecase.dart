import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import '../entity/get_esign_data_entity.dart';
import '../repository/kyc_repository.dart';

class GetEsignDataUseCase {
  final KycRepository kycRepository;

  GetEsignDataUseCase({required this.kycRepository});

  Future<Either<Result<GetEsignDataEntity>, ApiError>> call(Map<String, dynamic> data) async {
    return await kycRepository.getEsignData(data);
  }
}