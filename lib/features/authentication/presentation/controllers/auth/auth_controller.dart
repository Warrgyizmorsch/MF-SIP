import 'dart:async';

import 'package:get/get.dart';
import 'package:my_sip/config/routes/app_pages.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/helper/helpers.dart';
import 'package:my_sip/features/authentication/domain/usecases/auth_use_cases.dart';
import 'package:flutter/material.dart';
import '../../pages/signup/verify_pan_otp.dart';

class AuthController extends GetxController {
  final AuthUseCases _authUseCases;

  // Loading States
  final RxBool isLoginLoading = false.obs;
  final RxBool isRegisterLoading = false.obs;
  final RxBool isVerifyLoading = false.obs;
  final RxBool isOtpSendLoading = false.obs;
  final RxBool isOtpVerifyLoading = false.obs;

  // -- Registration Form Controllers --
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController panController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  // -- Checkbox State --
  final RxBool isAgreed = false.obs;

  // -- Timer State --
  final RxInt remainingSeconds = 60.obs;
  final RxBool isResendEnabled = false.obs;
  Timer? _timer;

  AuthController({required AuthUseCases authUseCases}) : _authUseCases = authUseCases;

  @override
  void onClose() {
    _timer?.cancel();
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    panController.dispose();
    passwordController.dispose();
    otpController.dispose();
    super.onClose();
  }
  void startResendTimer() {
    isResendEnabled.value = false;
    remainingSeconds.value = 60;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        isResendEnabled.value = true;
        timer.cancel();
      }
    });
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

  // Future<void> login(String email, String password) async {
  //   isLoginLoading.value = true;
  //   final requestData = {"email" : email, "password" : password};
  //   final result = await _authUseCases.loginUseCase.call(requestData);
  //
  //   result.fold(
  //           (success) {
  //         isLoginLoading.value = false;
  //         // Todo do something after login success
  //         // Navigate or show success
  //       },
  //           (error) {
  //         Get.snackbar("Login Failed", error.message);
  //         isLoginLoading.value = false;
  //       }
  //   );
  // }




  Future<void> sendOtp() async {
    if(mobileController.text.isEmpty){
      Get.snackbar("Error", "Please enter your mobile number");
      return;
    }
    isOtpSendLoading.value = true;
    startResendTimer();
    final requestData = {"phone" : mobileController.text.trim()};
    final result = await _authUseCases.sendOtpUseCase.call(requestData);

    result.fold(
            (success) {
              isOtpSendLoading.value = false;
              Get.snackbar("Otp sent Successfully", "Hey, we just send an otp to ${mobileController.text.trim()}", colorText: Colors.white, backgroundColor: Colors.green);
              Get.toNamed(AppRoutes.otpVerificationScreen);
            } ,
            (error) {
              createLog("Send Otp $error");
              Get.snackbar("Send Otp Failed", error.message);
              isOtpSendLoading.value = false;
            }
    );
  }

  Future<void> verifyOtpAndLogin() async {
    isOtpVerifyLoading.value = true;
    final requestData = {
      "phone": mobileController.text.trim(),
      "otp": otpController.text.trim()
    };

    final result = await _authUseCases.verifyOtpUseCase.call(requestData);

    result.fold(
            (success) {
          isOtpVerifyLoading.value = false;
          Get.snackbar("Verify Otp Success", "OTP Verified Successfully", colorText: Colors.white, backgroundColor: Colors.green);
          Get.offAllNamed(AppRoutes.navMenuBar);
        },
            (error) {
          createLog("Verify Otp Error $error");
          Get.snackbar("Verify Otp Failed", error.message);
          isOtpVerifyLoading.value = false;
        }
    );
  }
  Future<void> resendOtp() async {
    // We can reuse sendOtp logic
    await sendOtp();
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
          Get.offAllNamed(AppRoutes.login);
        },
            (error) {
          Get.snackbar("Registration Failed", error.message);
          isRegisterLoading.value = false;
        }
    );
  }
}