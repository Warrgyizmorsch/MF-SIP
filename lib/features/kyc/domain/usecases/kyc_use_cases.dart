
import 'package:my_sip/features/kyc/domain/usecases/execute_poi_step1_use_case.dart';
import 'package:my_sip/features/kyc/domain/usecases/get_all_banks_use_case.dart';

import 'execute_poi_step2_use_case.dart';

class KycUseCases {
  final GetAllBanksUseCases getAllBanksUseCases;
  final ExecutePoiStep1UseCase executePoiStep1UseCase;
  final ExecutePoiStep2UseCase executePoiStep2UseCase;


  KycUseCases({required this.getAllBanksUseCases, required this.executePoiStep1UseCase, required this.executePoiStep2UseCase});
}