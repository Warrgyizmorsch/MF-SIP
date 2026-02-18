import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_sip/features/kyc/data/model/token_data_model.dart';
import 'package:my_sip/features/kyc/domain/entity/file_upload_entity.dart';
import 'package:my_sip/features/kyc/domain/entity/poi_step_1_entity.dart';
import 'package:my_sip/features/kyc/domain/usecases/kyc_use_cases.dart';
import 'package:my_sip/services/session_manager.dart';
import '../../../../common/widget/webview/webview.dart';
import '../../../personalization/domain/entity/bank_entity.dart';
import '../../domain/entity/bank_verification_entity.dart';
import '../../domain/entity/execute_poi_step2_entity.dart';

class KycController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  /// Wrapper to ensure sequential execution
  Future<void> _initializeApp() async {
    // 1. (Optional) Block the UI while initializing
    isLoading.value = true;

    // 2. Await Token Data FIRST
    final bool tokenSuccess = await getTokenData();

    // 3. Only proceed if token data was successfully fetched
    if (tokenSuccess) {
      // Now it is safe to call other APIs that might need the token
      await getCaptcha();
    } else {
      Get.snackbar("Error While Initiating KYC Process", "Please try Later....");
    }

    // 4. Unblock UI
    isLoading.value = false;
  }

  final KycUseCases kycUseCases;

  // --- Controllers ---
  final PageController pageController = PageController();

  // --- State Variables ---
  final currentStep = 0.obs;
  final isLoading = false.obs;

  final taxStatusList = ["Resident Individual", "Person of Indian Origin", "Foreign National"];
  final selectedTaxStatus = "Resident Individual".obs;

  // --- Gender Data ---
  final genderList = ["MALE", "FEMALE", "OTHER"];
  final selectedGender = "Male".obs;

  // --- Gender Data ---
  final maritalList = ["MARRIED", "UNMARRIED", "OTHERS"];
  final selectedMaritalStatus = "MARRIED".obs;

  // --- Bank Data ---
  final bankList = <BankItemEntity>[].obs;
  final isLoadingBanks = false.obs;
  final errorMessage = ''.obs;
  final selectedBank = Rxn<BankItemEntity>();
  final bankSelectionController = TextEditingController();
  final accountNoController = TextEditingController();
  final ifscController = TextEditingController();

  final isVerifyingBank = false.obs;
  final verifiedBankName = Rxn<BankVerificationEntity>();

  // --- Execute POI step 1 ---
  final isExecutingPOIStep1 = false.obs;
  final executePOIStep1Data = Rxn<ExecutePOIStep1Entity>();

  // --- Execute POI step 2 ---
  final isExecutingPOIStep2 = false.obs;
  final executePOIStep2Data = Rxn<ExecutePOIStep2Entity>();

  // --- SIGNATURE UPLOAD STATE ---
  final signatureImage = Rxn<Uint8List>(); // Store image bytes
  final isUploadingSignature = false.obs;
  final signatureUploadSuccess = false.obs; // To track if upload is done
  final signatureUploadResponse = Rxn<FileEntity>();

  // --- CAPTCHA STATE ---
  final captchaImage = Rxn<Uint8List>();
  final isLoadingCaptcha = false.obs;
  final TextEditingController captchaTextEditingController = TextEditingController();

  // --- Token Data ---
  final isLoadingTokenData = false.obs;
  final tokenData = Rxn<TokenDataModel>();



  final occupationList = ["Business", "Service", "Retired Professional", "Professional", "Other"];
  final selectedOccupation = "".obs;
  final wealthSourceList = ["Salary", "Business Income", "Gift", "Ancestral Property", "Rental Income", "Prize money", "Royalty","Other"];
  final incomeSlabList = ["Below 1 Lakh", "1 Lacs - 5 Lacs", "5 Lacs - 10 Lacs" ,"10 Lacs - 25 Lacs", "25 Lacs - 1 Cr.", "Above 1 Cr."];
  final nomineeRelationList = ['Father',  'Spouse',];
  final nomineeDocumentSelectionList = ["Pan", "Aadhaar", "Driving License", "Passport"];
  final selectedNomineeDocument = "Pan".obs;
  final TextEditingController panTextEditingController = TextEditingController();
  final TextEditingController dateOfBirthTextEditingController = TextEditingController();
  final TextEditingController occupationTextEditingController = TextEditingController();
  final TextEditingController nameTextEditingController = TextEditingController();
  final TextEditingController wealthSourceTextEditingController = TextEditingController();
  final TextEditingController incomeSlabTextEditingController = TextEditingController();
  final TextEditingController addressTextEditingController = TextEditingController();
  final TextEditingController pinCodeTextEditingController = TextEditingController();
  final TextEditingController fatherNameTextEditingController = TextEditingController();
  final TextEditingController motherNameTextEditingController = TextEditingController();
  final TextEditingController occupationOtherTextEditingController = TextEditingController();


  bool isMinor = false;
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
          // _handlePersonalDetailsSubmission();
          _goToNextPage();
        }
        break;

      case 2:
      // --- STEP 2: ADDITIONAL INFO ---
      // Validate Additional Info Form
        if (step3FormKey.currentState!.validate()) {
          _handleAdditionalInfoSubmission();
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
          _updateFormKycDataSubmission();
        }
        break;

      case 5:
      // --- STEP 5: BANK DETAILS ---
        if (selectedBank.value == null) {
          Get.snackbar("Error", "Please select a bank");
          return;
        }

        // 1. Validate Form
        if (step5FormKey.currentState!.validate()) {

          // 2. Execute Penny Drop Verification
          final bool isVerified = await executePennydrop();

          // 3. Navigate only if verification passed
          if (isVerified) {
            // Optional: Add a small delay for UX so user sees the success snackbar
            await Future.delayed(const Duration(seconds: 1));
            _goToNextPage();
          }
        }
        break;
      // case 5:
      // // --- STEP 5: BANK DETAILS ---
      //   if (selectedBank.value == null) {
      //     Get.snackbar("Error", "Please select a bank");
      //     return;
      //   }
      //   if (step5FormKey.currentState!.validate()) {
      //     _goToNextPage();
      //   }
      //   break;

      case 6:
      // --- STEP 6: FINISH / SUBMIT ---
        if (!signatureUploadSuccess.value) {
          Get.snackbar("Alert", "Please upload your signature first.");
          return;
        }
        // Final Success logic
        // Get.offAllNamed("/dashboard"); // or show success dialog
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

        final requestData = {
          "merchantId": "698eb1747a225b001538fe7e",
          "save": "formData",
          "type": 'identityProof',
          "data": {
            "type": "aadhaarDigiLocker",
            "name": nameTextEditingController.text ?? executePOIStep2Data.value?.result.output.name,
            "uid": executePOIStep2Data.value?.result.output.uid,
            "dob": executePOIStep2Data.value?.result.output.dob,
            "gender": executePOIStep2Data.value?.result.output.gender,
            "address": executePOIStep2Data.value?.result.output.address,
            "pincode": executePOIStep2Data.value?.result.output.splitAddress.pincode,
            "city": executePOIStep2Data.value?.result.output.splitAddress.city,
            "state": executePOIStep2Data.value?.result.output.splitAddress.state,
            "district": executePOIStep2Data.value?.result.output.splitAddress.district
          }
        };
        isLoading.value = true;
        final bool poiSaved = await updateForm( data: requestData);
        isLoading.value = false;

        if (poiSaved) {

          _goToNextPage(); // Move to Personal Details page
        }

      }
    } else {
      // User cancelled or failed in WebView (pressed back or closed)
      Get.snackbar("Cancelled", "Verification process was cancelled");
    }
  }

  Future<void> pickAndUploadSignature() async {
    try {
      // 1. Pick Image (Requires image_picker package)
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        // 2. Convert to Bytes
        final Uint8List imageBytes = await image.readAsBytes();
        signatureImage.value = imageBytes; // Update UI immediately

        // 3. Prepare Data for API
        isUploadingSignature.value = true;

        final fields = {
          "merchantId": "698eb1747a225b001538fe7e",
          "type": "signature", // Tagging this as signature
          "fileType": "jpg" // or png, dynamic based on extension
        };

        final files = [imageBytes];
        final fileNames = ["signature.jpg"]; // or use image.name

        // 4. Call API (Replace with your actual UseCase call)
        // Assuming your UseCase signature matches: call({fields, files, fileNames})
        final result = await kycUseCases.uploadToSignzyUseCase.call(
          fields,
           files,
       fileNames
        );

        result.fold(
                (success) async {
              isUploadingSignature.value = false;
              signatureUploadSuccess.value = true;
              signatureUploadResponse.value = success.data;
              Get.snackbar("Success", "Signature Uploaded Successfully");

              // 5. CRITICAL: Lock the Bank Details now that Signature is present
              await _submitFinalBankDetails();
            },
                (error) {
              isUploadingSignature.value = false;
              Get.snackbar("Error", "Upload Failed: ${error.message}");
            }
        );
      }
    } catch (e) {
      isUploadingSignature.value = false;
      Get.snackbar("Error", "Failed to pick signature: $e");
    }
  }

  Future<void> _submitFinalBankDetails() async {
    try {
      isLoading.value = true;

      final requestData = {
        "merchantId": "698eb1747a225b001538fe7e",
        "service": "nonRoc",
        "type": "bankaccountverifications",
        "task": "verifyAmount",
        "data": {
          "images": [],
          "toVerifyData": {},
          "searchParam": {
            "amount": "1",
            "signzyId": verifiedBankName.value?.signzyReferenceId
          }
        }
      };

      final result = await kycUseCases.updateFormUseCase.call(requestData);

      isLoading.value = false;

      result.fold(
              (success) {
            Get.snackbar("Success", "Bank Details Verified & Locked!");
            // Move to Success Screen or Finish Flow
            // _goToNextPage();
          },
              (error) {
            Get.snackbar("Error", "Final Bank Lock Failed: ${error.message}");
          }
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", "Unexpected Error: $e");
    }
  }
  Future<void> _handleAdditionalInfoSubmission() async {
    try {
      isLoading.value = true;


      final poaRequestData = {
        "merchantId": "698eb1747a225b001538fe7e", // from investor login Response User Id
        "inputData": {
          "service": "identity",
          "type": "aadhaarDigiLocker",
          "task": "getDetails",
          "data": {
            "images": [],
            "proofType": "address"
          }
        }
      };

      final requestData = {
        "merchantId": "698eb1747a225b001538fe7e",
        "save": "formData",
        "type": 'addressProof',
        "data": {
          "type": "aadhaarDigiLocker",
          "name": nameTextEditingController.text ?? executePOIStep2Data.value?.result.output.name,
          "uid": executePOIStep2Data.value?.result.output.uid,
          "dob": executePOIStep2Data.value?.result.output.dob,
          "gender": executePOIStep2Data.value?.result.output.gender,
          "address": executePOIStep2Data.value?.result.output.address,
          "pincode": executePOIStep2Data.value?.result.output.splitAddress.pincode,
          "city": executePOIStep2Data.value?.result.output.splitAddress.city,
          "state": executePOIStep2Data.value?.result.output.splitAddress.state,
          "district": executePOIStep2Data.value?.result.output.splitAddress.district
        }
      };

      final poaExecuteResult = await executePOA(data: poaRequestData);

      if(poaExecuteResult) {
        // Send the Address Data as "addressProof"
        // This saves whatever is currently in your address text controllers
        final bool formUpdated = await updateForm(data: requestData);

        isLoading.value = false;

        if (formUpdated) {
          _goToNextPage(); // Move to Additional Info
        }
      }


    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", "Unexpected error: $e");
    }
  }
  Future<void>  _updateFormKycDataSubmission() async{
    try {
      isLoading.value = true;

      final requestData = {
        "merchantId": "698eb1747a225b001538fe7e", // Use dynamic ID
        "save": "formData",
        "type": "kycdata",
        "data": {
          "type": "kycdata",
          "kycData": {
            // --- CRITICAL FIX: ADD THESE TWO FIELDS ---
            "name": nameTextEditingController.text, // Required for PAN verification
            "dob": dateOfBirthTextEditingController.text, // Required for PAN verification
            "panNumber": panTextEditingController.text,
            // ====================================================
            // 1. NOMINEE DETAILS (Your Current Focus)
            // ====================================================
            "nomineeRelationShip": nomineeRelationTextEditingController.text.toUpperCase(), // FATHER, SPOUSE, etc.
            // ====================================================
            // 2. APPLICANT DETAILS (MANDATORY RE-SEND)
            // ====================================================
            // You must include these, or the API might error out on "Missing Fields"

            // Personal
            "gender": selectedGender.value == "Male" ? "M" : "F",
            "maritalStatus": selectedMaritalStatus.value, // MARRIED / UNMARRIED
            "fatherTitle" : "Mr.",
            "fatherName": fatherNameTextEditingController.text,      // REQUIRED
            "motherTitle" : "Mrs.",
            "motherName": motherNameTextEditingController.text,      // REQUIRED

            // Identity
            // "panNumber": panTextEditingController.text,
            // Use raw UID from DigiLocker data if available, else empty string
            "aadhaarNumber": executePOIStep2Data.value?.result.output.uid ?? "",

            // Contact (User's info)
            "mobileNumber": SessionManager.instance.getUserData?.mobile, // Get from User Profile
            "emailId": SessionManager.instance.getUserData?.email,  // Get from User Profile
            "countryCode": 91,

            // Financials (Send CODES, e.g., "01", "32")
            "occupationCode": getOccupationCode(occupationTextEditingController.text),

            "occupationDescription" : occupationTextEditingController.text,
            "annualIncome": getIncomeCode(incomeSlabTextEditingController.text),
            "occupationOther" : occupationOtherTextEditingController.text,

            // Regulatory Flags
            // "residentForTaxInIndia": "YES",
            // "rpep": "NO", // Relative of Politically Exposed Person
            // "pep": "NO",  // Politically Exposed Person
            "residentialStatus" : selectedTaxStatus.value,
            "applicationStatusDescription": selectedTaxStatus.value,
            "applicationStatusCode" :getApplicationStatusCode(selectedTaxStatus.value),
            // "citizenshipCountryCode": "IN",
            "citizenshipCountry": "India",
            "placeOfBirth": "India",
            "kycAccountCode" : "01",
            "kycAccountDescription" : "New",

            // Address Codes (Required defaults)
            "permanentAddressCode": "01",      // Residential
            "permanentAddressType": "Residential",
            "communicationAddressCode": "01",  // Residential
            "communicationAddressType": "Residential",
            "citizenshipCountryCode" : "101"
          }
        }
      };

      // Send the Address Data as "addressProof"
      // This saves whatever is currently in your address text controllers
      final bool nomineeSaved = await updateForm(data: requestData);

      isLoading.value = false;

      if (nomineeSaved) {

        final result = await _submitFatcaData();
        if(result == true){
          _goToNextPage(); // Move to Additional Info

        }
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", "Unexpected error: $e");
    }
  }
  Future<bool> _submitFatcaData() async {
    try {

      final isResident = selectedTaxStatus.value.contains("Resident");
      final taxResidentOutsideIndia = isResident ? "NO" : "YES";

      final requestData = {
        "merchantId": "698eb1747a225b001538fe7e",
        "save": "formData",
        "type": "fatca", // <--- KEY TYPE
        "data": {
          "type": "fatca",
          "fatcaData": {
            // "NO" means "I am NOT a tax resident of any other country" (Standard for Locals)
            "residentForTaxInIndia": taxResidentOutsideIndia,

            "pep": "NO",  // Politically Exposed Person (Default to NO)
            "rpep": "NO", // Related to PEP (Default to NO)
            "relatedPerson": "NO",

            // Required Location Fields
            "placeOfBirth": "India", // You should probably add a TextController for this
            "countryOfBirth": "India",
            "countryCodeOfBirth": "IN",

            // Address Type for Tax Purposes
            "addressType": "01", // 01 = Residential
            "addressCountry": "India",
            "addressCountryCode": "IN"

            // Note: If 'residentForTaxInIndia' is "YES" (NRI), you MUST provide:
            // "countryCodeJurisdictionResidence": "US", (Example)
            // "taxIdentificationNumber": "123456",
          }
        }
      };

      final result = await kycUseCases.updateFormUseCase.call(requestData);

      return result.fold(
              (success) => true,
              (error) {
            Get.snackbar("Error", "FATCA Verification Failed: ${error.message}");
            return false;
          }
      );
    } catch (e) {
      Get.snackbar("Error", "FATCA Error: $e");
      return false;
    }
  }

  Future<bool> getTokenData() async {
    try {
      isLoadingTokenData.value = true;
      // Call the UseCase (which now returns Uint8List?)
      final result = await kycUseCases.getTokenDataUseCase.call();
      return result.fold(
              (success) async {
            if (success.data != null) {
              // Update the observable with the image bytes
              tokenData.value = success.data;
             await SessionManager.instance.saveTokenData(tokenData.value);
              return true;
            }
            return false;
          },
              (error) {
            Get.snackbar("Error", "getTokenData Failed: ${error.message}");
            return false;
          }
      );
    } catch (e) {
      Get.snackbar("Error", "getTokenData Error: $e");
      return false;
    } finally {
      isLoadingTokenData.value = false;
    }
  }

  Future<bool> getCaptcha() async {
    try {
      isLoadingCaptcha.value = true;

      final requestData = {
        "username": "Hinger_icici_preprod",
        "password": "3uQ01VPPZfyNwCAq"
      };

      // Call the UseCase (which now returns Uint8List?)
      final result = await kycUseCases.getCaptchaUseCase.call(requestData);

      return result.fold(
              (success) {
            if (success.data != null) {
              // Update the observable with the image bytes
              captchaImage.value = success.data;
              return true;
            }
            return false;
          },
              (error) {
            Get.snackbar("Error", "Captcha Failed: ${error.message}");
            return false;
          }
      );
    } catch (e) {
      Get.snackbar("Error", "Captcha Error: $e");
      return false;
    } finally {
      isLoadingCaptcha.value = false;
    }
  }

  Future<bool> executePennydrop() async {
    try {
      // 1. Start Loading
      isVerifyingBank.value = true;
      isLoading.value = true; // Block global navigation too

      final requestData = {
        "merchantId": "698eb1747a225b001538fe7e",
        "inputData": {
          "service": "nonRoc",
          "type": "bankaccountverifications",
          "task": "bankTransfer",
          "data": {
            "searchParam": {
              "beneficiaryAccount": accountNoController.text,
              "beneficiaryIFSC": ifscController.text,
            }
          }
        }
      };

      // 2. Call the UseCase (Assuming you have updated it to use the generic executePoiStep1UseCase)
      // Note: If you created a dedicated 'executePennyDropUseCase' as discussed, use that instead.
      // Here I am reusing 'executePoiStep1UseCase' as it fits the generic 'execute' pattern.
      final result = await kycUseCases.executePennyDropUseCase.call(requestData);

      return result.fold(
            (success) {
          // 3. Handle Success
          if (success.data != null && success.data != null) {
            final output = success.data;

            // // Extract Name (adjust key based on actual API response)
            // final bankName = output['beneficiaryName'] ??
            //     output['data']?['beneficiaryName'] ??
            //     "Verified Account";

            verifiedBankName.value = output;
            Get.snackbar("Success", "Bank Account Verified: ${verifiedBankName.value?.auditTrail?.value}");
            return true;
          } else {
            Get.snackbar("Error", "Bank verification failed: No data returned");
            return false;
          }
        },
            (error) {
          // 4. Handle Failure
          Get.snackbar("Error", "Pennydrop Failed: ${error.message}");
          return false;
        },
      );
    } catch (e) {
      Get.snackbar("Error", "Pennydrop Exception: $e");
      return false;
    } finally {
      // 5. Stop Loading (Critical!)
      isVerifyingBank.value = false;
      isLoading.value = false;
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

  String getIncomeCode(String text) {
    final value = text.trim();

    // Mapping based on Signzy Table 1.8
    if (value.contains("Below 1")) return "31";        // Below 1 Lac
    if (value.contains("1") && value.contains("5")) return "32"; // 1-5 Lacs
    if (value.contains("5") && value.contains("10")) return "33"; // 5-10 Lacs
    if (value.contains("10") && value.contains("25")) return "34"; // 10-25 Lacs
    if (value.contains("25") && value.contains("1")) return "35"; // 25 Lacs-1 crore
    if (value.contains("Above 1") || value.contains("> 1")) return "36"; // > 1 crore

    // Default fallback (e.g., 1-5 Lacs)
    return "32";
  }

  String getApplicationStatusCode(String selectedStatus) {
    // Normalize string to handle variations
    final status = selectedStatus.trim().toLowerCase();

    if (status.contains("resident") && !status.contains("non")) {
      return "R"; // Resident Indian
    } else if (status.contains("nri") || status.contains("non-resident")) {
      return "N"; // Non-Resident Indian
    } else if (status.contains("foreign")) {
      return "P"; // Foreign National
    } else if (status.contains("origin") || status.contains("pio")) {
      return "I"; // Person of Indian Origin
    }

    // Default Fallback
    return "R";
  }
  String getOccupationCode(String text) {
    // Normalize text to handle slight variations (case-insensitive)
    final value = text.trim().toLowerCase();

    if (value.contains("private")) return "01";       // Private Sector
    if (value.contains("public")) return "02";        // Public Sector
    if (value.contains("business")) return "03";      // Business
    if (value.contains("professional")) return "04";  // Professional
    if (value.contains("retired")) return "06";       // Retired
    if (value.contains("housewife")) return "07";     // Housewife
    if (value.contains("student")) return "08";       // Student
    if (value.contains("government")) return "10";    // Government Sector
    if (value.contains("self")) return "11";          // Self Employed

    // Default to "Others" if no match found
    return "99";
  }
  Future<bool> updateForm({required Map<String,dynamic> data}) async {
    try {
      final requestData = data;

      final result = await kycUseCases.updateFormUseCase.call(requestData);
      return result.fold(
              (success){
                return true;
              },
              (error){
                Get.snackbar("Error", error.message ?? "Update Form Failed");
                return false;
              }
      );
    } catch(e) {
      Get.snackbar("Error", "Unexpected error: $e");
      return false;
    }
  }

  Future<bool> executePOA({required Map<String,dynamic> data}) async {
    try {
      final requestData = data;

      final result = await kycUseCases.executePoaUseCase.call(requestData);
      return result.fold(
              (success){
            return true;
          },
              (error){
            Get.snackbar("Error", error.message ?? "Update Form Failed");
            return false;
          }
      );
    } catch(e) {
      Get.snackbar("Error", "Unexpected error: $e");
      return false;
    }
  }


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