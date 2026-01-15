import 'package:get/get.dart';
import 'package:my_sip/features/authentication/domain/usecases/auth_use_cases.dart';

class AuthController extends GetxController {
  final AuthUseCases _authUseCases;


  final RxBool isLoginLoading = false.obs;
  final RxBool isRegisterLoading = false.obs;
  final RxBool isVerifyLoading = false.obs;

  AuthController({required AuthUseCases authUseCases}) : _authUseCases = authUseCases;

  Future<void> login(String email, String password) async {
    isLoginLoading.value = true;

    final requestData = {"email" : email, "password" : password};
    final result = await _authUseCases.loginUseCase.call(requestData);

    result.fold(
            (success) {
          isLoginLoading.value = false;
        },
            (error) {
          Get.snackbar("Login Failed", error.message);
          isLoginLoading.value = false;
        }
    );
  }

  // Future<void> register(String name, String email) async {
  //   isRegisterLoading.value = true; // Start loading
  //
  //   final result = await _authUseCases.register(name, email);
  //
  //
  //   isRegisterLoading.value = false;
  // }
}