import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/features/personalization/data/model/bank_model.dart';

import '../../../../core/network/network_api_service.dart';
import '../../../../core/utils/helper/helpers.dart';

class PersonalisationRemoteDataSource {
  final NetworkServicesApi _apiService;

  PersonalisationRemoteDataSource(this._apiService);


  Future<Either<Result<BankListResponseModel>,ApiError>>getBank(Map<String,dynamic> data) async {
    try {
      final resp =    await _apiService.postFormData("${Appurl.baseUrl}/banks", data);
      createLog("[Personalisation Remote Data Source] BankListResponseModel Response: ${resp.body}");
      if(resp.statusCode == 200){
        final result = BankListResponseModel.fromJson(resp.body);

        return Left(Result.success(result));
      } else {
        return Right(ApiError(message: 'BankListResponseModel Failed'));
      }
    } catch(e){
      return Right(ApiError(message: 'BankListResponseModel Failed with Exception $e'));
    }
  }
}