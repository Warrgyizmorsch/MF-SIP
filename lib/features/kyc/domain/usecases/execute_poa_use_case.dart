import 'package:dartz/dartz.dart';
import 'package:my_sip/features/kyc/domain/repository/kyc_repository.dart';

import '../../../../core/utils/api/api_error.dart';
import '../../../../core/utils/api/api_result.dart';
import '../entity/execute_poi_step2_entity.dart';

class ExecutePoaUseCase {
  final KycRepository kycRepository;

  ExecutePoaUseCase({required this.kycRepository});

  Future<Either<Result<ExecutePOIStep2Entity>, ApiError>> call(Map<String, dynamic> data) async {
    return await kycRepository.executePOA(data);
  }
}