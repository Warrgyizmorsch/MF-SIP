import 'package:my_sip/features/kyc/domain/usecases/createPdf_usecase.dart';
import 'package:my_sip/features/kyc/domain/usecases/create_esign_url_usecase.dart';
import 'package:my_sip/features/kyc/domain/usecases/execute_penny_drop_use_case.dart';
import 'package:my_sip/features/kyc/domain/usecases/execute_poa_use_case.dart';
import 'package:my_sip/features/kyc/domain/usecases/execute_poi_step1_use_case.dart';
import 'package:my_sip/features/kyc/domain/usecases/get_all_banks_use_case.dart';
import 'package:my_sip/features/kyc/domain/usecases/get_captcha_use_case.dart';
import 'package:my_sip/features/kyc/domain/usecases/get_esign_data_usecase.dart';
import 'package:my_sip/features/kyc/domain/usecases/get_token_data_use_case.dart';
import 'package:my_sip/features/kyc/domain/usecases/saveOnboarding_login_usecases.dart';
import 'package:my_sip/features/kyc/domain/usecases/update_form_use_case.dart';
import 'package:my_sip/features/kyc/domain/usecases/upload_to_signZy_use_case.dart';
import 'package:my_sip/features/kyc/domain/usecases/verify_amount_usecases.dart';

import 'execute_poi_step2_use_case.dart';

class KycUseCases {
  final GetAllBanksUseCases getAllBanksUseCases;
  final ExecutePoiStep1UseCase executePoiStep1UseCase;
  final ExecutePoiStep2UseCase executePoiStep2UseCase;
  final UpdateFormUseCase updateFormUseCase;
  final ExecutePoaUseCase executePoaUseCase;
  final ExecutePennyDropUseCase executePennyDropUseCase;
  final UploadToSignzyUseCase uploadToSignzyUseCase;
  final GetCaptchaUseCase getCaptchaUseCase;
  final GetTokenDataUseCase getTokenDataUseCase;
  final CreatePdfUseCase createPdfUseCase;
  final CreateEsignUrlUseCase createEsignUrlUseCase;
  final GetEsignDataUseCase getEsignDataUseCase;
  final ExecuteVerifyAmountUseCase executeVerifyAmountUseCase;
  final SaveOnboardingDataUseCase saveOnboardingDataUseCase ;

  

  KycUseCases({
    required this.getAllBanksUseCases,
    required this.executePoiStep1UseCase,
    required this.executePoiStep2UseCase,
    required this.updateFormUseCase,
    required this.executePoaUseCase,
    required this.executePennyDropUseCase,
    required this.executeVerifyAmountUseCase,
    required this.uploadToSignzyUseCase,
    required this.getCaptchaUseCase,
    required this.getTokenDataUseCase,
    required this.createPdfUseCase,
    required this.createEsignUrlUseCase,
    required this.getEsignDataUseCase,
    required this.saveOnboardingDataUseCase
  });
}
