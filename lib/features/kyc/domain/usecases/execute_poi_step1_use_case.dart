import 'package:dartz/dartz.dart';
import 'package:my_sip/features/kyc/domain/repository/kyc_repository.dart';

import '../../../../core/utils/api/api_error.dart';
import '../../../../core/utils/api/api_result.dart';
import '../entity/poi_step_1_entity.dart';

class ExecutePoiStep1UseCase {
  final KycRepository kycRepository;

  ExecutePoiStep1UseCase({required this.kycRepository});

  Future<Either<Result<ExecutePOIStep1Entity>, ApiError>> call(Map<String, dynamic> data) async {
    return await kycRepository.executePOIStep1(data);
  }
}