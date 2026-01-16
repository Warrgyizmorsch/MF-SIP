import 'package:get/get.dart';
import 'package:my_sip/features/authentication/domain/usecases/auth_use_cases.dart';
import 'package:flutter/material.dart';
import '../../pages/signup/verify_pan_otp.dart';

class AuthController extends GetxController {
  final AuthUseCases _authUseCases;

  // Loading States
  final RxBool isLoginLoading = false.obs;
  final RxBool isRegisterLoading = false.obs;
  final RxBool isVerifyLoading = false.obs;

  // -- Registration Form Controllers --
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController panController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // -- Checkbox State --
  final RxBool isAgreed = false.obs;

  AuthController({required AuthUseCases authUseCases}) : _authUseCases = authUseCases;

  @override
  void onClose() {

    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    panController.dispose();
    passwordController.dispose();
    super.onClose();
  }


  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Must be at least 8 characters';
    if (!value.contains(RegExp(r'[A-Z]'))) return 'Must contain an uppercase letter';
    if (!value.contains(RegExp(r'[a-z]'))) return 'Must contain a lowercase letter';
    if (!value.contains(RegExp(r'[0-9]'))) return 'Must contain a number';
    return null;
  }

  void toggleAgreement(bool? value) {
    isAgreed.value = value ?? false;
  }

  // -- Actions --

  void submitRegisterForm() {
    if (registerFormKey.currentState!.validate()) {
      if (!isAgreed.value) {
        Get.snackbar(
          "Error",
          "Please agree to the Terms and Privacy Policy",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
        );
        return;
      }

      register(nameController.text.trim(), emailController.text.trim(), mobileController.text.trim(), panController.text.trim(), passwordController.text.trim());
    }
  }

  Future<void> login(String email, String password) async {
    isLoginLoading.value = true;
    final requestData = {"email" : email, "password" : password};
    final result = await _authUseCases.loginUseCase.call(requestData);

    result.fold(
            (success) {
          isLoginLoading.value = false;
          // Todo do something after login success
          // Navigate or show success
        },
            (error) {
          Get.snackbar("Login Failed", error.message);
          isLoginLoading.value = false;
        }
    );
  }

  Future<void> register(String name, String email,String mobile,String pan,String password ) async {
    isRegisterLoading.value = true;
    final requestData = {
      "name" : name,
      "email" : email,
      "mobile" : mobile,
      "pan_card" : pan,
      "password" : password
    };

    final result = await _authUseCases.registerUseCase.call(requestData);
    result.fold(
            (success) {
          isRegisterLoading.value = false;
          // Navigate to OTP screen upon success
          Get.to(() => VerifyPanOtp());
        },
            (error) {
          Get.snackbar("Registration Failed", error.message);
          isRegisterLoading.value = false;
        }
    );
  }
}