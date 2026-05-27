import 'package:my_sip/features/authentication/domain/usecases/firebase_token_usecase.dart';
import 'package:my_sip/features/authentication/domain/usecases/login_use_case.dart';
import 'package:my_sip/features/authentication/domain/usecases/register_use_case.dart';
import 'package:my_sip/features/authentication/domain/usecases/send_otp_use_case.dart';
import 'package:my_sip/features/authentication/domain/usecases/verify_otp_use_case.dart';

import 'google_sign_in_use_case.dart';

class AuthUseCases {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final SendOtpUseCase sendOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final FcmDeviceTokenUseCase fcmDeviceTokenUseCase;
  final GoogleSignInUseCase googleSignInUseCase;

  AuthUseCases({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.sendOtpUseCase,
    required this.verifyOtpUseCase,
    required this.fcmDeviceTokenUseCase,
    required this.googleSignInUseCase,
  });
}
