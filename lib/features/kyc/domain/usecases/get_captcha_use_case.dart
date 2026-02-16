import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:my_sip/features/kyc/domain/repository/kyc_repository.dart';

import '../../../../core/utils/api/api_error.dart';
import '../../../../core/utils/api/api_result.dart';

class GetCaptchaUseCase {
  final KycRepository kycRepository;

  GetCaptchaUseCase({required this.kycRepository});

  Future<Either<Result<Uint8List?>, ApiError>> call(Map<String, dynamic> data)async{
    return await kycRepository.getCaptcha(data);
  }
}