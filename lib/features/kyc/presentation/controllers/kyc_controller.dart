import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class KycController extends GetxController {
  // --- Controllers ---
  final PageController pageController = PageController();

  // --- State Variables ---
  final currentStep = 0.obs; // Tracks which screen is visible
  final isLoading = false.obs; // For the button spinner

  final taxStatusList = ["Individual", "On Behalf Of Minor", "NRI", "NRI - Repatriable (NRO)"];
  final selectedTaxStatus = "Individual".obs;

  // --- NEW: Gender Data ---
  final genderList = ["Male", "Female", "Other"];
  final selectedGender = "Male".obs;

  final TextEditingController panTextEditingController = TextEditingController();
  final panKeyboardType = TextInputType.name.obs;

  // --- Logic ---
  void onPanInputChanged(String val) {
    // (Keep your existing logic here)
  }

  // --- MAIN NEXT BUTTON LOGIC ---
  Future<void> onNextTap() async {
    isLoading.value = true;

    try {
      bool isSuccess = false;

      // Switch based on which page we are currently on
      switch (currentStep.value) {
        case 0:
          isSuccess = await _verifyPanAndTaxStatus(); // Page 1 API
          break;
        case 1:
          isSuccess = await _apiCallStep2(); // Page 2 API
          break;
        case 2:
          isSuccess = await _apiCallStep3(); // Page 3 API
          break;
      // ... Add cases for 3, 4, 5
      }

      // If API was successful, move to next page
      if (isSuccess && currentStep.value < 5) {
        pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut
        );
        currentStep.value++;
      }
    } finally {
      isLoading.value = false;
    }
  }

  // --- API Functions (Placeholders) ---
  Future<bool> _verifyPanAndTaxStatus() async {
    // Validate inputs
    if(panTextEditingController.text.length != 10) {
      Get.snackbar("Error", "Invalid PAN Number");
      return false;
    }

    // TODO: Perform your actual API Call here
    await Future.delayed(const Duration(seconds: 2)); // Mocking API delay
    print("PAN Verified: ${panTextEditingController.text}");
    return true; // Return true if API is success
  }

  Future<bool> _apiCallStep2() async {
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }

  Future<bool> _apiCallStep3() async {
    return true;
  }

  @override
  void onClose() {
    pageController.dispose();
    panTextEditingController.dispose();
    super.onClose();
  }
}