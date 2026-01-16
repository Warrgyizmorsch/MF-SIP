import 'package:my_sip/features/authentication/domain/usecases/login_use_case.dart';
import 'package:my_sip/features/authentication/domain/usecases/register_use_case.dart';

class AuthUseCases {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;

  AuthUseCases({required this.loginUseCase , required this.registerUseCase});
}