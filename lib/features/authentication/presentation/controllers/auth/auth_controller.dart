import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_sip/common/widget/animated/popups.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/helper/helpers.dart';
import 'package:my_sip/features/authentication/domain/entitites/auth_entity.dart';
import 'package:my_sip/features/authentication/domain/usecases/auth_use_cases.dart';
import 'package:flutter/material.dart';
import 'package:my_sip/features/personalization/data/model/risk_result_model.dart';
import 'package:my_sip/services/session_manager.dart';

class AuthController extends GetxController {
  final AuthUseCases _authUseCases;

  // Loading States
  final RxBool isLoginLoading = false.obs;
  final RxBool isRegisterLoading = false.obs;
  final RxBool isVerifyLoading = false.obs;
  final RxBool isOtpSendLoading = false.obs;
  final RxBool isOtpVerifyLoading = false.obs;
  final RxBool isNumberValid = true.obs;
  final RxBool isOtpError = false.obs;
  final RxBool isPhoneNotRegistered = false.obs;
  final RxBool isPhoneValidForLogin = false.obs;

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
  final phoneFocusNode = FocusNode();

  // -- Timer State --
  final RxInt remainingSeconds = 60.obs;
  final RxBool isResendEnabled = false.obs;
  Timer? _timer;

  // -- User Record
  Rxn<UserEntity> user = Rxn<UserEntity>();

  AuthController({required AuthUseCases authUseCases})
    : _authUseCases = authUseCases;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn.standard();

  /// GOOGLE SIGN IN
  /// GOOGLE SIGN IN
  Future<void> signInWithGoogle() async {
    try {
      debugPrint("========== GOOGLE SIGN IN START ==========");

      /// CLEAR PREVIOUS ACCOUNT
      await _googleSignIn.signOut();

      debugPrint("OLD GOOGLE SESSION CLEARED");

      /// OPEN GOOGLE ACCOUNT PICKER
      final GoogleSignInAccount? googleUser =
      await _googleSignIn.signIn();

      /// USER CANCELLED
      if (googleUser == null) {
        debugPrint("USER CANCELLED LOGIN");
        return;
      }

      debugPrint("SELECTED EMAIL : ${googleUser.email}");

      /// AUTH
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      /// CREDENTIAL
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      /// FIREBASE LOGIN
      final UserCredential userCredential =
      await _auth.signInWithCredential(
        credential,
      );

      /// USER
      final User? user = userCredential.user;

      if (user != null) {

        Map<String, dynamic> userJson = {
          "uid": user.uid,
          "email": user.email,
          "displayName": user.displayName,
          "photoURL": user.photoURL,
          "emailVerified": user.emailVerified,
          "phoneNumber": user.phoneNumber,
          "isAnonymous": user.isAnonymous,
          "metadata": {
            "creationTime":
            user.metadata.creationTime?.toIso8601String(),
            "lastSignInTime":
            user.metadata.lastSignInTime?.toIso8601String(),
          },
          "providerData": user.providerData.map((info) => {
            "providerId": info.providerId,
            "uid": info.uid,
            "displayName": info.displayName,
            "email": info.email,
            "photoURL": info.photoURL,
          }).toList(),
        };

        debugPrint("========== NEW USER JSON DATA ==========");
        debugPrint(userJson.toString());

        final bool isNewUser =
            userCredential.additionalUserInfo?.isNewUser ?? false;

        /// NEW USER
        if (isNewUser) {

          nameController.text =
              user.displayName ?? "";

          emailController.text =
              user.email ?? "";

          Get.offNamed(
            AppRoutes.registerAccountScreen,
          );

        } else {

          /// OLD USER
          // Get.offAllNamed(AppRoutes.bottomBar);

        }
      }

    } catch (e) {

      debugPrint("GOOGLE LOGIN ERROR : $e");

    }
  }

  /// LOGOUT
  Future<void> signOutGoogle() async {
    try {
      await _googleSignIn.signOut();

      await _auth.signOut();

      debugPrint("LOGOUT SUCCESS");

      Get.snackbar("Logout", "User logged out successfully");
    } catch (e) {
      debugPrint("LOGOUT ERROR : $e");
    }
  }

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

  void resetAuthForms() {
    mobileController.clear();
    nameController.clear();
    emailController.clear();
    panController.clear();

    isPhoneValidForLogin.value = false;
    isPhoneNotRegistered.value = false;
    isNumberValid.value = true;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Must be at least 8 characters';
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Must contain an uppercase letter';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Must contain a lowercase letter';
    }
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

      register(
        nameController.text.trim(),
        emailController.text.trim(),
        mobileController.text.trim(),
        panController.text.trim(),
        passwordController.text.trim(),
      );
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
    if (mobileController.text.isEmpty) {
      Get.snackbar(
        "Phone number required",
        "Please enter your mobile number to continue.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    isOtpSendLoading.value = true;
    isLoginLoading.value = true;

    startResendTimer();
    final requestData = {"phone": mobileController.text.trim()};
    final result = await _authUseCases.sendOtpUseCase.call(requestData);

    result.fold(
      (success) {
        isOtpSendLoading.value = false;
        isLoginLoading.value = false;

        // Get.snackbar(

        //   "Otp sent Successfully",
        //   "Hey, we just send an otp to ${mobileController.text.trim()}",
        //   colorText: Colors.white,
        //   backgroundColor: Colors.green,
        // );
        Get.snackbar(
          "", // Leave empty because we are using custom titleText
          "", // Leave empty because we are using custom messageText
          // 1. Modern Typography Hierarchy
          titleText: const Text(
            "OTP Sent Successfully",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          messageText: Text(
            "Hey, we just sent an OTP to ${mobileController.text.trim()}",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(
                0.9,
              ), // Slightly faded for contrast
              height: 1.4, // Better line spacing
            ),
          ),

          // 2. Premium Iconography
          icon: const Icon(
            Icons.check_circle_rounded, // Rounded modern icon
            color: Colors.white,
            size: 28,
          ),
          shouldIconPulse:
              false, // Disabling pulse makes it feel more solid/premium
          // 3. Layout & Positioning
          snackPosition: SnackPosition.TOP, // Top avoids blocking the keyboard!
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          borderRadius: 16, // Smooth modern corners
          // 4. Color & Elevation
          backgroundColor: const Color(
            0xFF2E7D32,
          ), // A deep, premium success green
          barBlur:
              20, // Adds a subtle glassmorphism effect if background is slightly transparent
          boxShadows: [
            BoxShadow(
              color: const Color(0xFF2E7D32).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],

          // 5. Smooth Animation
          animationDuration: const Duration(milliseconds: 400),
          duration: const Duration(
            seconds: 4,
          ), // Give them time to read the number
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
        );

        Get.toNamed(AppRoutes.otpVerificationScreen);
      },
      // (error) {
      //   isNumberValid.value = false;
      //   isLoginLoading.value = false;
      //   isPhoneNotRegistered.value = true;

      //   // mobileController.clear();

      //   createLog("Send Otp $error");
      //   // Get.snackbar("Send Otp Failed", error.message);
      //   Get.snackbar(
      //     "Account not found",
      //     'Please register using this mobile number.',
      //     backgroundColor: Ucolors.red,
      //     colorText: Colors.white,
      //   );
      //   isOtpSendLoading.value = false;
      // },
      (error) {
        isLoginLoading.value = false;
        isOtpSendLoading.value = false;

        createLog("Send Otp Error: ${error.message}");

        final errorMessage = error.message.toLowerCase();

        // 1. Check if the backend specifically rejected the number
        if (errorMessage.contains('not found') ||
            errorMessage.contains('register') ||
            errorMessage.contains('does not exist')) {
          isNumberValid.value = false;
          isPhoneNotRegistered.value = true;

          // Get.snackbar(
          //   "Account not found",
          //   'Please register using this mobile number.',
          //   backgroundColor: Ucolors.red,
          //   colorText: Colors.white,
          // );
          // showCustomToast(
          //   title: 'Account not found',
          //   message: '',
          //   backgroundColor: Colors.red,
          //   icon: Icons.error,
          // );
          ULoaders.error(
            title: 'Account not found',
            message: 'Please register using this mobile number.',
          );
        } else {
          // 2. Handle Network Timeouts and other crashes safely
          // Do NOT set isPhoneNotRegistered = true here!

          Get.snackbar(
            "Request Failed",
            error.message, // Shows the clean message from Step 1
            backgroundColor: Ucolors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 4),
          );
        }
      },
    );
  }

  Future<void> loginWithEmailAndPassword() async {
    if (emailController.text.isEmpty) {
      Get.snackbar("Error", "Please enter your Email");
      return;
    }
    if (passwordController.text.isEmpty) {
      Get.snackbar("Error", "Please enter your Password");
      return;
    }
    isLoginLoading.value = true;
    final requestData = {
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
    };

    final result = await _authUseCases.loginUseCase.call(requestData);

    result.fold(
      (success) {
        isLoginLoading.value = false;

        user.value = success.data!.userModel.toEntity();

        Get.snackbar(
          "Login Success",
          "User Logged in Successfully",
          colorText: Colors.white,
          backgroundColor: Colors.green,
        );
        Get.offAllNamed(AppRoutes.navMenuBar);
      },
      (error) {
        createLog("loginWithEmailAndPassword Error $error");
        Get.snackbar("loginWithEmailAndPassword Failed", error.message);
        isLoginLoading.value = false;
      },
    );
  }

  Future<void> verifyOtpAndLogin() async {
    isOtpVerifyLoading.value = true;
    final requestData = {
      "phone": mobileController.text.trim(),
      "otp": otpController.text.trim(),
    };

    final result = await _authUseCases.verifyOtpUseCase.call(requestData);

    result.fold(
      (success) async {
        final userModel = success.data?.userModel;
        await SessionManager.instance.setSession(
          jwtAccessToken: success.data?.token,
          userData: success.data?.userModel,
        );
        if (userModel?.riskProfileModel != null) {
          final profile = userModel!.riskProfileModel!;

          final riskResult = RiskResultModel(
            status: true,
            totalScore: int.tryParse(userModel.riskScore.toString()) ?? 0,
            riskSlabId: profile.id ?? 0,
            profileName: profile.profileName ?? '',
          );

          // This triggers the Obx in your Upgradebanner
          await SessionManager.instance.saveRiskScore(riskResult);
          
        } else {
          // Clear it if they are a new user without a profile
          await SessionManager.instance.saveRiskScore(null);
        }

        isOtpVerifyLoading.value = false;

        user.value = success.data!.userModel.toEntity();

        // Get.snackbar(
        //   "Verify Otp Success",
        //   "OTP Verified Successfully",
        //   colorText: Colors.white,
        //   backgroundColor: Colors.green,
        // );
        ULoaders.success(
          title: 'Verify Otp Success',
          message: 'OTP Verified Successfully',
        );
        await Future.delayed(const Duration(seconds: 2));
        Get.offAllNamed(AppRoutes.navMenuBar);
      },
      (error) {
        isOtpError.value = true;
        otpController.clear();

        createLog("Verify Otp Error $error");
        Get.snackbar(
          "Invalid OTP",
          "The OTP you entered is incorrect. Please try again.",

          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isOtpVerifyLoading.value = false;
      },
    );
  }

  Future<void> resendOtp() async {
    // We can reuse sendOtp logic
    await sendOtp();
  }

  Future<void> register(
    String name,
    String email,
    String mobile,
    String pan,
    String password,
  ) async {
    isRegisterLoading.value = true;
    final requestData = {
      "name": name,
      "email": email,
      "mobile": mobile,
      "pan_card": pan,
      // "password": password,
    };

    final result = await _authUseCases.registerUseCase.call(requestData);
    result.fold(
      (success) {
        isRegisterLoading.value = false;
        startResendTimer();
        otpController.clear();
        isOtpError.value = false;

        Get.toNamed(AppRoutes.otpVerificationScreen);
      },
      (error) {
        isRegisterLoading.value = false;
        String cleanMessage = error.message;
        if (cleanMessage.contains('message:')) {
          final match = RegExp(
            r'message:\s*(.*?)(?:,|$)',
          ).firstMatch(cleanMessage);
          if (match != null) {
            cleanMessage = match.group(1) ?? cleanMessage;
          }
        }

        // 3. Remove the annoying "(and 1 more error)" suffix
        if (cleanMessage.contains('(and')) {
          cleanMessage = cleanMessage.split('(and')[0].trim();
        }

        ULoaders.warning(title: 'Registration Failed', message: cleanMessage);
      },
    );
  }

  void logOut() {
    user.value = null;
    mobileController.clear();
    otpController.clear();
    SessionManager.instance.clearSession();

    Get.offAllNamed(AppRoutes.login);
  }

  //Pan validator
  String? validatePanCard(String? value) {
    if (value == null || value.isEmpty) {
      return 'PAN card number is required';
    }

    final pan = value.trim().toUpperCase();

    final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');

    if (!panRegex.hasMatch(pan)) {
      return 'Enter a valid PAN card number';
    }

    return null; // ✅ valid
  }
}
