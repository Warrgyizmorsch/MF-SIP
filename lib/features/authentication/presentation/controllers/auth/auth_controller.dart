import 'package:get/get.dart';
import 'package:my_sip/features/authentication/domain/usecases/auth_use_cases.dart';

class AuthController extends GetxController {
  final AuthUseCases authUseCases;

  AuthController({required this.authUseCases});


}