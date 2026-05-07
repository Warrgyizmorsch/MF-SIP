import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:my_sip/features/kyc/domain/repository/kyc_repository.dart';

import '../../../../core/utils/api/api_error.dart';
import '../../../../core/utils/api/api_result.dart';
import '../entity/file_upload_entity.dart';

class UploadToSignzyUseCase {
  final KycRepository kycRepository;

  UploadToSignzyUseCase({required this.kycRepository});

  Future<Either<Result<FileEntity>, ApiError>> call(Map<String, String> data, List<Uint8List> files, List<String> fileNames) async {
    return await kycRepository.uploadToSignZy(data, files, fileNames);
  }
}