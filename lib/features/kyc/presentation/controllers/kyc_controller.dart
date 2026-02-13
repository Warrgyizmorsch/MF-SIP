import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:my_sip/features/kyc/domain/entity/poi_step_1_entity.dart';
import 'package:my_sip/features/kyc/domain/usecases/kyc_use_cases.dart';
import '../../../../common/widget/webview/webview.dart';
import '../../../personalization/domain/entity/bank_entity.dart';
import '../../domain/entity/execute_poi_step2_entity.dart';

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
  final genderList = ["MALE", "FEMALE", "OTHER"];
  final selectedGender = "Male".obs;

  // --- Bank Data ---
  final bankList = <BankItemEntity>[].obs;
  final isLoadingBanks = false.obs;
  final errorMessage = ''.obs;
  final selectedBank = Rxn<BankItemEntity>();
  final bankSelectionController = TextEditingController();
  final accountNoController = TextEditingController();
  final ifscController = TextEditingController();

  // --- Execute POI step 1 ---
  final isExecutingPOIStep1 = false.obs;
  final executePOIStep1Data = Rxn<ExecutePOIStep1Entity>();

  // --- Execute POI step 2 ---
  final isExecutingPOIStep2 = false.obs;
  final executePOIStep2Data = Rxn<ExecutePOIStep2Entity>();




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

// ===========================================================================
  // CENTRAL NAVIGATION LOGIC
  // Call this from your BottomNavigationBar button: controller.onNextTap
  // ===========================================================================
  Future<void> onNextTap() async {
    // 1. Prevent multiple clicks if any process is loading
    if (isLoading.value || isExecutingPOIStep1.value || isExecutingPOIStep2.value) {
      return;
    }

    // 2. Decide logic based on the current step
    switch (currentStep.value) {
      case 0:
      // --- STEP 0: IDENTITY (DigiLocker Flow) ---
        await _handleDigiLockerFlow();
        break;

      case 1:
      // --- STEP 1: PERSONAL DETAILS ---
      // Validate Personal Details Form
        if (step2FormKey.currentState!.validate()) {
          // If you have an update API for this step, await it here
          _goToNextPage();
        }
        break;

      case 2:
      // --- STEP 2: ADDITIONAL INFO ---
      // Validate Additional Info Form
        if (step3FormKey.currentState!.validate()) {
          _goToNextPage();
        }
        break;

      case 3:
      // --- STEP 3: NOMINEE DETAILS ---
        if (step4_1FormKey.currentState!.validate()) {
          _goToNextPage();
        }
        break;

      case 4:
      // --- STEP 4: NOMINEE VERIFICATION ---
        if (step4_2FormKey.currentState!.validate()) {
          _goToNextPage();
        }
        break;

      case 5:
      // --- STEP 5: BANK DETAILS ---
        if (selectedBank.value == null) {
          Get.snackbar("Error", "Please select a bank");
          return;
        }
        if (step5FormKey.currentState!.validate()) {
          _goToNextPage();
        }
        break;

      case 6:
      // --- STEP 6: FINISH / SUBMIT ---
      // Add your final submission logic here
        break;

      default:
        _goToNextPage();
    }
  }

  // ===========================================================================
  // DIGILOCKER FLOW HELPER
  // ===========================================================================
  Future<void> _handleDigiLockerFlow() async {
    // 1. Call YOUR existing Step 1 function (Generates URL)
    final bool step1Success = await executePOIStep1();

    // If failed, the function itself should show a snackbar, so we just return
    if (!step1Success) return;

    // 2. Extract URL safely from your data variable
    // We check both result.url (common structure) or direct url property
    String? startUrl;
    if (executePOIStep1Data.value?.result?.url != null) {
      startUrl = executePOIStep1Data.value!.result.url;
    } else {
      startUrl = executePOIStep1Data.value?.result.url;
    }

    if (startUrl == null || startUrl.isEmpty) {
      Get.snackbar("Error", "URL not found in server response");
      return;
    }

    // 3. Open WebView and wait for 'true' signal (Success callback)
    final bool? isWebViewSuccess = await Get.to(() => HtmlWebViewPage(
      title: "Identity Verification",
      url: startUrl!,
    ));

    if (isWebViewSuccess == true) {
      // 4. Call YOUR existing Step 2 function
      // (This automatically Fetches details & Fills your text controllers)
      final bool step2Success = await executePOIStep2();

      if (step2Success) {
        // 5. Success! Move to Page 2 automatically
        _goToNextPage();
      }
    } else {
      // User cancelled or failed in WebView (pressed back or closed)
      Get.snackbar("Cancelled", "Verification process was cancelled");
    }
  }

  // ===========================================================================
  // NAVIGATION HELPERS
  // ===========================================================================
  void _goToNextPage() {
    if (currentStep.value < 6) { // 6 is the max index based on your 7 steps
      currentStep.value++;
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void goBack() {
    if (currentStep.value > 0) {
      currentStep.value--;
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.back();
    }
  }


  // Future<bool> _verifyPanAndTaxStatus() async {
  //   // 1. Check if the form is valid
  //   // The '!' is important here. If NOT valid, stop.
  //   if (!step1FormKey.currentState!.validate()) {
  //     // The CustomTextField will automatically turn red and show the error message.
  //     // You can optionally show a snackbar too, but it's usually redundant.
  //     return false;
  //   }
  //
  //   // 2. Extra Logic (Optional)
  //   // If you have logic that Form validators can't catch (like checking PAN length manually if not using regex)
  //   if (panTextEditingController.text.length != 10) {
  //     Get.snackbar("Error", "PAN Number must be 10 characters");
  //     return false;
  //   }
  //
  //   // 3. Proceed to API
  //   await Future.delayed(const Duration(seconds: 2));
  //   print("PAN Verified: ${panTextEditingController.text}");
  //   return true;
  // }





  Future<bool> executePOIStep1() async {
    try {
      isExecutingPOIStep1.value = true;

      final requestData = {
        "merchantId": "698eb1747a225b001538fe7e", // from investor login Response User Id
        "inputData": {
          "service": "identity",
          "type": "aadhaarDigiLocker",
          "task": "createUrl",
          "data": {
            "images": [],
            "proofType": "identity"
          }
        }
      };

      final result =
      await kycUseCases.executePoiStep1UseCase.call(requestData);

      return result.fold(
            (success) {
          if (success.data != null) {
            executePOIStep1Data.value = success.data;
            return true;
          } else {
            Get.snackbar("Error", "Invalid server response");
            return false;
          }
        },
            (error) {
          Get.snackbar("Error", error.message ?? "Execute POI Step 1 Failed");
          return false;
        },
      );
    } catch (e) {
      Get.snackbar("Error", "Unexpected error: $e");
      return false;
    } finally {
      isExecutingPOIStep1.value = false;
    }
  }

  Future<bool> executePOIStep2() async {
    try {
      isExecutingPOIStep2.value = true;

      final requestData = {
        "merchantId": "698eb1747a225b001538fe7e", // from investor login Response User Id
        "inputData": {
          "service": "identity",
          "type": "aadhaarDigiLocker",
          "task": "getDetails",
          "data": {
            "images": [],
            "proofType": "identity"
          }
        }
      };

      final result =
      await kycUseCases.executePoiStep2UseCase.call(requestData);

      return result.fold(
            (success) {
          if (success.data != null) {
            executePOIStep2Data.value = success.data;
            nameTextEditingController.text = executePOIStep2Data.value?.result.output.name ?? '';
            dateOfBirthTextEditingController.text = executePOIStep2Data.value?.result.output.dob ?? '';
            selectedGender.value = executePOIStep2Data.value?.result.output.gender ?? '';
            addressTextEditingController.text = executePOIStep2Data.value?.result.output.address ?? '';
            pinCodeTextEditingController.text = executePOIStep2Data.value?.result.output.splitAddress.pincode ?? '';

            return true;
          } else {
            Get.snackbar("Error", "Invalid server response");
            return false;
          }
        },
            (error) {
          Get.snackbar("Error", error.message ?? "Execute POI Step 2 Failed");
          return false;
        },
      );
    } catch (e) {
      Get.snackbar("Error", "Unexpected error: $e");
      return false;
    } finally {
      isExecutingPOIStep2.value = false;
    }
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