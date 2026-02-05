import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:my_sip/features/kyc/domain/usecases/kyc_use_cases.dart';
import '../../../personalization/domain/entity/bank_entity.dart';

class KycController extends GetxController {
  final KycUseCases kycUseCases;

  // --- Controllers ---
  final PageController pageController = PageController();

  // --- State Variables ---
  final currentStep = 0.obs;
  final isLoading = false.obs;

  final taxStatusList = ["Individual", "On Behalf Of Minor", "NRI", "NRI - Repatriable (NRO)"];
  final selectedTaxStatus = "Individual".obs;

  // --- Gender Data ---
  final genderList = ["Male", "Female", "Other"];
  final selectedGender = "Male".obs;

  // --- Bank Data ---
  final bankList = <BankItemEntity>[].obs;
  final isLoadingBanks = false.obs;
  final errorMessage = ''.obs;
  final selectedBank = Rxn<BankItemEntity>();
  final bankSelectionController = TextEditingController();
  final accountNoController = TextEditingController();
  final ifscController = TextEditingController();




  final occupationList = ["Business", "Service", "Retired Professional", "Professional", "Other"];
  final wealthSourceList = ["Salary", "Business Income", "Gift", "Ancestral Property" "Rental Income", "Prize money", "Royalty","Other"];
  final incomeSlabList = ["Below 1 Lakh", "1 Lacs - 5 Lacs", "5 Lacs - 10 Lacs" ,"10 Lacs - 25 Lacs", "25 Lacs - 1 Cr.", "Above 1 Cr."];
  final nomineeRelationList = ['Aunt', 'Brother-In-Law', 'Brother', 'Daughter', 'Daughter-In-Law', 'Father', 'Father-In-Law', 'Grand Daughter', 'Grand Father', 'Grand Mother', 'Mother', 'Mother-In-Law', 'Son', 'Spouse', 'Testing',];
  final nomineeDocumentSelectionList = ["Pan", "Aadhar", "Driving License", "Passport"];
  final selectedNomineeDocument = "Pan".obs;
  final TextEditingController panTextEditingController = TextEditingController();
  final TextEditingController dateOfBirthTextEditingController = TextEditingController();
  final TextEditingController occupationTextEditingController = TextEditingController();
  final TextEditingController nameTextEditingController = TextEditingController();
  final TextEditingController wealthSourceTextEditingController = TextEditingController();
  final TextEditingController incomeSlabTextEditingController = TextEditingController();
  final TextEditingController addressTextEditingController = TextEditingController();
  final TextEditingController pinCodeTextEditingController = TextEditingController();


  final TextEditingController nomineeNameTextEditingController = TextEditingController();
  final TextEditingController nomineeSelectedDocumentTextEditingController = TextEditingController();
  final TextEditingController nomineeRelationTextEditingController = TextEditingController();
  final TextEditingController nomineeDateOfBirthTextEditingController = TextEditingController();
  final TextEditingController nomineeMobileTextEditingController = TextEditingController();
  final TextEditingController nomineeEmailTextEditingController = TextEditingController();
  final TextEditingController nomineeAddressTextEditingController = TextEditingController();
  final TextEditingController nomineePinCodeTextEditingController = TextEditingController();


   final step1FormKey = GlobalKey<FormState>();
   final step2FormKey = GlobalKey<FormState>();
   final step3FormKey = GlobalKey<FormState>();
   final step4_1FormKey = GlobalKey<FormState>();
   final step4_2FormKey = GlobalKey<FormState>();
   final step5FormKey = GlobalKey<FormState>();
   final step6FormKey = GlobalKey<FormState>();

  final panKeyboardType = TextInputType.name.obs;


  KycController(this.kycUseCases);

  Future<void> onNextTap() async {
    isLoading.value = true;

    try {
      bool isSuccess = false;

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
        case 3:
          isSuccess = await _apiCallStep4_1(); // Page 4 API
          break;
        case 4:
          isSuccess = await _apiCallStep4_2(); // Page 5 API
          break;
        case 5:
          isSuccess = await _apiCallStep5(); // Page 6 API
          break;
          case 6:
          isSuccess = await _apiCallStep6(); // Page 6 API
          break;
      }

      // If API was successful, move to next page
      if (isSuccess && currentStep.value < 6) {
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


  Future<bool> _verifyPanAndTaxStatus() async {
    // 1. Check if the form is valid
    // The '!' is important here. If NOT valid, stop.
    if (!step1FormKey.currentState!.validate()) {
      // The CustomTextField will automatically turn red and show the error message.
      // You can optionally show a snackbar too, but it's usually redundant.
      return false;
    }

    // 2. Extra Logic (Optional)
    // If you have logic that Form validators can't catch (like checking PAN length manually if not using regex)
    if (panTextEditingController.text.length != 10) {
      Get.snackbar("Error", "PAN Number must be 10 characters");
      return false;
    }

    // 3. Proceed to API
    await Future.delayed(const Duration(seconds: 2));
    print("PAN Verified: ${panTextEditingController.text}");
    return true;
  }
  Future<void> fetchBanks() async {
    try {
      isLoadingBanks(true);
      final result = await kycUseCases.getAllBanksUseCases.call({});
      result.fold(
            (success) {
          if (success.data != null) {
            bankList.assignAll(success.data!.data);
          }
        },
            (error) {
          errorMessage.value = error.message ?? "Failed to load banks";
          Get.snackbar("Error", errorMessage.value);
        },
      );
    } catch (e) {
      errorMessage.value = "An unexpected error occurred: $e";
    } finally {
      isLoadingBanks(false);
    }
  }

  void onBankSelectedFromName(String bankName) {
    final bank = bankList.firstWhereOrNull((element) => element.bankName == bankName);
    if (bank != null) {
      selectedBank.value = bank;

    }
  }

  void clearSelectedBank() {
    selectedBank.value = null;
    accountNoController.clear();
    ifscController.clear();
    bankSelectionController.clear();
  }


  Future<bool> _apiCallStep2() async {
    // 1. Check if the form is valid
    // If validate() returns false (invalid), we negate it to true and enter the block
    if (!step2FormKey.currentState!.validate()) {
      return false; // Stop! The form has errors.
    }

    // 2. If we pass the check above, the form is valid. Proceed.
    await Future.delayed(const Duration(seconds: 2));

    return true;
  }

  Future<bool> _apiCallStep3() async {
    // 1. Check if the form is valid
    // If validate() returns false (invalid), we negate it to true and enter the block
    if (!step3FormKey.currentState!.validate()) {
      return false; // Stop! The form has errors.
    }

    // 2. If we pass the check above, the form is valid. Proceed.
    await Future.delayed(const Duration(seconds: 2));

    return true;
  }
  Future<bool> _apiCallStep4_1() async {
    // 1. Check if the form is valid
    // If validate() returns false (invalid), we negate it to true and enter the block
    if (!step4_1FormKey.currentState!.validate()) {
      return false; // Stop! The form has errors.
    }

    // 2. If we pass the check above, the form is valid. Proceed.
    await Future.delayed(const Duration(seconds: 2));

    return true;
  }
  Future<bool> _apiCallStep4_2() async {
    // 1. Check if the form is valid
    // If validate() returns false (invalid), we negate it to true and enter the block
    if (!step4_2FormKey.currentState!.validate()) {
      return false; // Stop! The form has errors.
    }

    // 2. If we pass the check above, the form is valid. Proceed.
    await Future.delayed(const Duration(seconds: 2));

    return true;
  }
  Future<bool> _apiCallStep5() async {

    if(selectedBank.value == null){
      Get.snackbar("Error", "Please select a bank");
      return false;
    }
    // 1. Check if the form is valid
    // If validate() returns false (invalid), we negate it to true and enter the block
    if (!step5FormKey.currentState!.validate()) {
      return false; // Stop! The form has errors.
    }

    // 2. If we pass the check above, the form is valid. Proceed.
    await Future.delayed(const Duration(seconds: 2));

    return true;
  }
  Future<bool> _apiCallStep6() async {
    return true;
  }



  @override
  void onClose() {
    pageController.dispose();
    panTextEditingController.dispose();
    super.onClose();
  }
}