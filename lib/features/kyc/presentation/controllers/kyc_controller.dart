import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_sip/common/widget/animated/popups.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/helper/helpers.dart';
import 'package:my_sip/features/kyc/data/model/onboarding_login_model.dart';
import 'package:my_sip/features/kyc/data/model/token_data_model.dart';
import 'package:my_sip/features/kyc/domain/entity/file_upload_entity.dart';
import 'package:my_sip/features/kyc/domain/entity/poi_step_1_entity.dart';
import 'package:my_sip/features/kyc/domain/usecases/kyc_use_cases.dart';
import 'package:my_sip/features/personalization/domain/usecases/add_nominee_use_case.dart';
import 'package:my_sip/features/personalization/domain/usecases/update_profile_usecases.dart';
import 'package:my_sip/services/session_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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
    // final bool tokenSuccess = await getTokenData();

    final bool tokenCred = await saveOnboardingData();

    // 3. Only proceed if token data was successfully fetched
    // if (tokenSuccess) {
    //   // Now it is safe to call other APIs that might need the token
    // await getCaptcha();
    // } else {
    //   Get.snackbar(
    //     "Error While Initiating KYC Process",
    //     "Please try Later....",
    //   );
    // }

    // 4. Unblock UI
    isLoading.value = false;
  }

  final KycUseCases kycUseCases;

  // --- Controllers ---
  final PageController pageController = PageController();

  // --- State Variables ---
  final currentStep = 0.obs;
  final isLoading = false.obs;

  final taxStatusList = [
    "Resident Individual",
    "Person of Indian Origin",
    "Foreign National",
  ];
  final selectedTaxStatus = "Resident Individual".obs;

  // --- Gender Data ---
  final genderList = ["MALE", "FEMALE", "OTHER"];
  final selectedGender = "MALE".obs;

  // --- Gender Data ---
  final maritalList = ["MARRIED", "UNMARRIED", "OTHERS"];
  final selectedMaritalStatus = "MARRIED".obs;

  // Mode of Holding ---
  final modeOfHoldingList = ["Single", "Joint", "Anyone or Survivor"];
  final selectedModeOfHolding = "Single".obs;

  //  Resident list
  final resdStatusList = [
    "Resident Individual",
    "Non-Resident Indian",
    "Foreign National",
    "Hindu Undivided Family",
  ];
  final resdStatus = "Resident Individual".obs;

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

  // --- LIVE PHOTO STATE ---
  final userPhotoBytes = Rxn<Uint8List>();
  final isUploadingPhoto = false.obs;
  final photoUploadSuccess = false.obs;
  final uploadedPhotoUrl = "".obs;

  // --- CAPTCHA STATE ---
  final captchaImage = Rxn<Uint8List>();
  final isLoadingCaptcha = false.obs;
  final TextEditingController captchaTextEditingController =
      TextEditingController();

  // --- Token Data ---
  final isLoadingTokenData = false.obs;
  final tokenData = Rxn<TokenDataModel>();
  final onboardingResult = Rxn<OnboardingResponse>();

  final occupationList = [
    "Business",
    "Service",
    "Retired Professional",
    "Professional",
    "Other",
  ];
  final selectedOccupation = "".obs;
  final wealthSourceList = [
    "Salary",
    "Business Income",
    "Gift",
    "Ancestral Property",
    "Rental Income",
    "Prize money",
    "Royalty",
    "Other",
  ];
  final incomeSlabList = [
    "Below 1 Lakh",
    "1 Lacs - 5 Lacs",
    "5 Lacs - 10 Lacs",
    "10 Lacs - 25 Lacs",
    "25 Lacs - 1 Cr.",
    "Above 1 Cr.",
  ];
  final nomineeRelationList = ['Father', 'Spouse'];
  final nomineeDocumentSelectionList = [
    "Pan",
    "Aadhaar",
    "Driving License",
    "Passport",
  ];
  final selectedNomineeDocument = "Pan".obs;
  final TextEditingController panTextEditingController =
      TextEditingController();
  final TextEditingController dateOfBirthTextEditingController =
      TextEditingController();
  final TextEditingController occupationTextEditingController =
      TextEditingController();
  final TextEditingController nameTextEditingController =
      TextEditingController();
  final TextEditingController wealthSourceTextEditingController =
      TextEditingController();
  final TextEditingController incomeSlabTextEditingController =
      TextEditingController();
  final TextEditingController addressTextEditingController =
      TextEditingController();
  final TextEditingController pinCodeTextEditingController =
      TextEditingController();
  final TextEditingController fatherNameTextEditingController =
      TextEditingController();
  final TextEditingController motherNameTextEditingController =
      TextEditingController();
  final TextEditingController occupationOtherTextEditingController =
      TextEditingController();

  bool isMinor = false;
  final TextEditingController nomineeNameTextEditingController =
      TextEditingController();
  final TextEditingController nomineeSelectedDocumentTextEditingController =
      TextEditingController();
  final TextEditingController nomineeRelationTextEditingController =
      TextEditingController();
  final TextEditingController nomineeDateOfBirthTextEditingController =
      TextEditingController();
  final TextEditingController nomineeMobileTextEditingController =
      TextEditingController();
  final TextEditingController nomineeEmailTextEditingController =
      TextEditingController();
  final TextEditingController nomineeAddressTextEditingController =
      TextEditingController();
  final TextEditingController nomineePinCodeTextEditingController =
      TextEditingController();
  // --- Nominee Address Checkbox State ---
  final isNomineeAddressSameAsApplicant = false.obs;

  final step1FormKey = GlobalKey<FormState>();
  final step2FormKey = GlobalKey<FormState>();
  final step3FormKey = GlobalKey<FormState>();
  final step4_1FormKey = GlobalKey<FormState>();
  final step4_2FormKey = GlobalKey<FormState>();
  final step5FormKey = GlobalKey<FormState>();
  final step6FormKey = GlobalKey<FormState>();

  final panKeyboardType = TextInputType.name.obs;

  final session = SessionManager.instance;

  KycController(this.kycUseCases);

  final updateUserData = Get.find<UpdateProfileUsecases>();
  final saveDataNominee = Get.find<AddNomineeUseCase>();

  // ===========================================================================
  // CENTRAL NAVIGATION LOGIC
  // Call this from your BottomNavigationBar button: controller.onNextTap
  // ===========================================================================
  Future<void> onNextTap() async {
    // 1. Prevent multiple clicks if any process is loading
    if (isLoading.value ||
        isExecutingPOIStep1.value ||
        isExecutingPOIStep2.value) {
      return;
    }

    // 2. Decide logic based on the current step
    switch (currentStep.value) {
      case 0:
        // --- STEP 0: IDENTITY (DigiLocker Flow) ---
        if (step1FormKey.currentState!.validate()) {
          final bool needsKyc = await checkKycStatus();
          if (needsKyc) {
            await _handleDigiLockerFlow();
          } else {
            Get.snackbar(
              "KYC Verified",
              "Your KYC is already completed! You can start investing.",
            );
            // Get.offAllNamed(AppRoutes.navMenuBar);
          }
        }
        break;

      case 1:
        // --- STEP 1: PERSONAL DETAILS ---
        if (step2FormKey.currentState!.validate()) {
          _goToNextPage();
        }
        break;

      case 2:
        // --- STEP 2: ADDITIONAL INFO ---
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
          _updateFormKycDataSubmission(); // This method should call _goToNextPage() on success
        }
        break;

      case 5:
        // --- STEP 5: LIVE PHOTO ONLY (Old Step 6) ---
        // 🔴 Signature requirement completely removed!
        if (!photoUploadSuccess.value) {
          Get.snackbar("Alert", "Please capture your live photo.");
          return;
        }
        _goToNextPage();
        break;

      case 6:
        // --- STEP 6: AADHAAR E-SIGN (Old Step 7) ---
        await startEsignProcess();
        break;

      default:
        _goToNextPage();
    }
    // switch (currentStep.value) {
    //   case 0:

    //     // --- STEP 0: IDENTITY (DigiLocker Flow) ---
    //     if (step1FormKey.currentState!.validate()) {
    //       // 1. Check Backend Status First
    //       final bool needsKyc = await checkKycStatus();
    //       // await _handleDigiLockerFlow();
    //       if (needsKyc) {
    //         // 2. Proceed to Signzy DigiLocker
    //         await _handleDigiLockerFlow();
    //       } else {
    //         // 3. Stop flow and redirect
    //         Get.snackbar(
    //           "KYC Verified",
    //           "Your KYC is already completed! You can start investing.",
    //         );
    //         // Get.offAllNamed(AppRoutes.navMenuBar); // Redirect user
    //       }
    //     }
    //     break;

    //   case 1:
    //     // --- STEP 1: PERSONAL DETAILS ---
    //     // Validate Personal Details Form
    //     if (step2FormKey.currentState!.validate()) {
    //       // If you have an update API for this step, await it here
    //       // _handlePersonalDetailsSubmission();
    //       _goToNextPage();
    //     }
    //     break;

    //   case 2:
    //     // --- STEP 2: ADDITIONAL INFO ---
    //     // Validate Additional Info Form
    //     if (step3FormKey.currentState!.validate()) {
    //       _handleAdditionalInfoSubmission();
    //     }
    //     break;

    //   case 3:
    //     // --- STEP 3: NOMINEE DETAILS ---
    //     if (step4_1FormKey.currentState!.validate()) {
    //       _goToNextPage();
    //     }
    //     break;

    //   case 4:
    //     // --- STEP 4: NOMINEE VERIFICATION ---
    //     if (step4_2FormKey.currentState!.validate()) {
    //       _updateFormKycDataSubmission();
    //     }
    //     break;

    //   case 5:

    //     // --- STEP 5: BANK DETAILS ---
    //     if (selectedBank.value == null) {
    //       Get.snackbar("Error", "Please select a bank");
    //       return;
    //     }

    //     // 1. Validate Form
    //     if (step5FormKey.currentState!.validate()) {
    //       // ULoaders.showLoading(message: 'Bank Processing');
    //       // 2. Execute Penny Drop Verification
    //       final bool isVerified = await executePennydrop();

    //       // ULoaders.stopLoading();

    //       // 3. Navigate only if verification passed
    //       if (isVerified) {
    //         // change to true when dynamic merchant ID
    //         await Future.delayed(const Duration(seconds: 2));
    //         await _submitFinalBankDetails();
    //         _goToNextPage();
    //       }
    //     }
    //     break;

    //   case 6:
    //     // --- STEP 6: FINISH / SUBMIT ---
    //     if (!signatureUploadSuccess.value) {
    //       Get.snackbar("Alert", "Please upload your signature first.");

    //       return;
    //     }

    //     if (!photoUploadSuccess.value) {
    //       Get.snackbar("Alert", "Please capture your live photo.");

    //       return;
    //     }

    //     _goToNextPage();
    //     break;
    //   case 7:
    //     // --- STEP 7: AADHAAR E-SIGN ---

    //     await startEsignProcess();

    //     break;

    //   default:
    //     _goToNextPage();
    // }
  }

  Future<bool> checkKycStatus() async {
    try {
      isLoading.value = true;
      ULoaders.showLoading(message: "Verifying PAN Details...");

      // 1. Translate the UI values for the backend API
      final requestData = {
        "pan_card": panTextEditingController.text.toUpperCase(),
        "modeOfHld": getModeOfHldCode(selectedModeOfHolding.value),
        "resdStatus": getResdStatusCode(selectedTaxStatus.value),
      };

      // 2. Call the UseCase
      final result = await kycUseCases.checkKycUseCase.call(requestData);
      ULoaders.stopLoading();

      // 3. Handle the Fold (Left = Success Result, Right = ApiError)
      return result.fold(
        (success) {
          // Extract the entity from your Result class
          final entity = success.data;
          final currentStatus = entity?.currentStatus?.toLowerCase() ?? "";

          if (currentStatus == "Approved") {
            return false; // KYC is done! Do NOT launch Signzy.
          } else {
            return true; // KYC is needed (e.g., "timed out" or "pending")
          }
        },
        (error) {
          ULoaders.stopLoading();
          Get.snackbar(
            "Error",
            "Check KYC failed: ${error.message}. Proceeding to verification.",
          );
          return true; // Fallback to Signzy flow if the API crashes
        },
      );
    } catch (e) {
      ULoaders.stopLoading();
      Get.snackbar("Error", "Unexpected error: $e");
      return true; // Fallback
    } finally {
      isLoading.value = false;
    }
  }

  // ===========================================================================
  // DIGILOCKER FLOW HELPER
  // ===========================================================================
  Future<void> _handleDigiLockerFlow() async {
    // --- PHASE 1: GENERATE URL ---
    ULoaders.showLoading(message: "Initiating DigiLocker...");
    final bool step1Success = await executePOIStep1();
    ULoaders.stopLoading(); // Stop before opening the WebView

    // If failed, the function itself should show a snackbar, so we just return
    if (!step1Success) return;

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

    // --- PHASE 2: OPEN WEBVIEW ---
    final bool? isWebViewSuccess = await Get.to(
      () => HtmlWebViewPage(title: "Identity Verification", url: startUrl!),
    );

    // --- PHASE 3: PROCESS RESULT ---
    if (isWebViewSuccess == true) {
      try {
        // Start loader for the background data processing
        ULoaders.showLoading(message: "Verifing Aadhaar Details...");

        final bool step2Success = await executePOIStep2();

        if (step2Success) {
          final requestData = {
            "merchantId": SessionManager
                .instance
                .getOnboardingData
                ?.dbRecord
                ?.signzyUserId,
            "save": "formData",
            "type": 'identityProof',
            "data": {
              "type": "aadhaarDigiLocker",
              "name":
                  nameTextEditingController.text ??
                  executePOIStep2Data.value?.result.output.name,
              "uid": executePOIStep2Data.value?.result.output.uid,
              "dob": executePOIStep2Data.value?.result.output.dob,
              "gender": executePOIStep2Data.value?.result.output.gender,
              "address": executePOIStep2Data.value?.result.output.address,
              "pincode":
                  executePOIStep2Data.value?.result.output.splitAddress.pincode,
              "city":
                  executePOIStep2Data.value?.result.output.splitAddress.city,
              "state":
                  executePOIStep2Data.value?.result.output.splitAddress.state,
              "district": executePOIStep2Data
                  .value
                  ?.result
                  .output
                  .splitAddress
                  .district,
            },
          };

          isLoading.value = true;
          final bool poiSaved = await updateForm(data: requestData);
          isLoading.value = false;

          if (poiSaved) {
            await _submitUserForensics("identity");

            // Stop the loader and show success message
            ULoaders.stopLoading();
            ULoaders.success(
              title: "Verified",
              message: "Identity details saved successfully.",
            );

            // Brief pause so the user can read the success message
            await Future.delayed(const Duration(seconds: 1));

            _goToNextPage(); // Move to Personal Details page
          } else {
            ULoaders.stopLoading(); // Stop if form update fails
          }
        } else {
          ULoaders.stopLoading(); // Stop if fetching details fails
        }
      } catch (e) {
        ULoaders.stopLoading(); // Failsafe
        Get.snackbar(
          "Error",
          "An unexpected error occurred processing your data.",
        );
      }
    } else {
      // User cancelled or failed in WebView (pressed back or closed)
      Get.snackbar("Cancelled", "Verification process was cancelled");
    }
  }
  // Future<void> _handleDigiLockerFlow() async {
  //   // 1. Call YOUR existing Step 1 function (Generates URL)
  //   ULoaders.showLoading(message: "Initiating DigiLocker...");
  //   final bool step1Success = await executePOIStep1();
  //   ULoaders.stopLoading(); // Stop before opening the WebView

  //   // If failed, the function itself should show a snackbar, so we just return
  //   if (!step1Success) return;

  //   // 2. Extract URL safely from your data variable
  //   // We check both result.url (common structure) or direct url property
  //   String? startUrl;
  //   if (executePOIStep1Data.value?.result?.url != null) {
  //     startUrl = executePOIStep1Data.value!.result.url;
  //   } else {
  //     startUrl = executePOIStep1Data.value?.result.url;
  //   }

  //   if (startUrl == null || startUrl.isEmpty) {
  //     Get.snackbar("Error", "URL not found in server response");
  //     return;
  //   }

  //   // 3. Open WebView and wait for 'true' signal (Success callback)
  //   final bool? isWebViewSuccess = await Get.to(
  //     () => HtmlWebViewPage(title: "Identity Verification", url: startUrl!),
  //   );

  //   if (isWebViewSuccess == true) {
  //     // 4. Call YOUR existing Step 2 function
  //     // (This automatically Fetches details & Fills your text controllers)
  //     final bool step2Success = await executePOIStep2();

  //     if (step2Success) {
  //       final requestData = {
  //         // "merchantId": "69aac24da01541001c853d48",
  //         "merchantId":
  //             SessionManager.instance.getOnboardingData?.dbRecord?.signzyUserId,

  //         "save": "formData",
  //         "type": 'identityProof',
  //         "data": {
  //           "type": "aadhaarDigiLocker",
  //           "name":
  //               nameTextEditingController.text ??
  //               executePOIStep2Data.value?.result.output.name,
  //           "uid": executePOIStep2Data.value?.result.output.uid,
  //           "dob": executePOIStep2Data.value?.result.output.dob,
  //           "gender": executePOIStep2Data.value?.result.output.gender,
  //           "address": executePOIStep2Data.value?.result.output.address,
  //           "pincode":
  //               executePOIStep2Data.value?.result.output.splitAddress.pincode,
  //           "city": executePOIStep2Data.value?.result.output.splitAddress.city,
  //           "state":
  //               executePOIStep2Data.value?.result.output.splitAddress.state,
  //           "district":
  //               executePOIStep2Data.value?.result.output.splitAddress.district,
  //         },
  //       };
  //       isLoading.value = true;
  //       final bool poiSaved = await updateForm(data: requestData);
  //       isLoading.value = false;

  //       if (poiSaved) {
  //         await _submitUserForensics("identity");
  //         _goToNextPage(); // Move to Personal Details page
  //       }
  //     }
  //   } else {
  //     // User cancelled or failed in WebView (pressed back or closed)
  //     Get.snackbar("Cancelled", "Verification process was cancelled");
  //   }
  // }

  void toggleNomineeAddressSameAsApplicant(bool? value) {
    isNomineeAddressSameAsApplicant.value = value ?? false;

    if (isNomineeAddressSameAsApplicant.value) {
      // Copy applicant's address and PIN to nominee fields
      nomineeAddressTextEditingController.text =
          addressTextEditingController.text;
      nomineePinCodeTextEditingController.text =
          pinCodeTextEditingController.text;
    } else {
      // Clear them if the user unchecks the box
      nomineeAddressTextEditingController.clear();
      nomineePinCodeTextEditingController.clear();
    }
  }

  // Aadhar Esign ------------
  Future<void> startEsignProcess() async {
    isLoading.value = true;

    try {
      ULoaders.showLoading(message: "Generating Contract...");
      // Fetching dynamic merchant ID (fallback to your hardcoded one if session is null)
      final currentMerchantId = "69aac24da01541001c853d48";

      // ---------------------------------------------------------
      // STEP 1: Generate the Unsigned Contract PDF
      // ---------------------------------------------------------
      final createPdfRequest = {
        // "merchantId": currentMerchantId,
        "merchantId":
            SessionManager.instance.getOnboardingData?.dbRecord?.signzyUserId,

        "inputData": {"service": "esign", "task": "createPdf", "type": ""},
      };

      final pdfResult = await kycUseCases.createPdfUseCase.call(
        createPdfRequest,
      );

      await pdfResult.fold(
        (pdfSuccess) async {
          // Extracted cleanly using the new Entity!
          final String combinedPdfUrl = pdfSuccess.data?.combinedPdfUrl ?? "";

          if (combinedPdfUrl.isEmpty) {
            ULoaders.stopLoading();
            isLoading.value = false;
            Get.snackbar("Error", "Failed to generate contract PDF");
            return;
          }

          // ---------------------------------------------------------
          // STEP 2: Generate the Aadhaar E-Sign URL
          // ---------------------------------------------------------
          final esignUrlRequest = {
            // "merchantId": currentMerchantId,
            "merchantId": SessionManager
                .instance
                .getOnboardingData
                ?.dbRecord
                ?.signzyUserId,

            "inputData": {
              "service": "esign",
              "task": "createEsignUrl",
              "type": "",
              "data": {
                "inputFile": combinedPdfUrl,
                "signatureType": "aadhaaresign",
                "redirectUrl": "https://signzy.com",
              },
            },
          };

          final esignResult = await kycUseCases.createEsignUrlUseCase.call(
            esignUrlRequest,
          );

          await esignResult.fold(
            (esignSuccess) async {
              ULoaders.stopLoading();
              isLoading.value = false;

              // Extracted cleanly using the new Entity!
              final String esignUrl = esignSuccess.data?.esignUrl ?? "";

              if (esignUrl.isNotEmpty) {
                // STEP 3: Open WebView for User to Sign
                final bool? isSignSuccess = await Get.to(
                  () => HtmlWebViewPage(title: "Aadhaar E-Sign", url: esignUrl),
                );

                // STEP 4: Save & Verify the Signed Document
                if (isSignSuccess == true) {
                  await _verifyAndSaveEsign();
                }
              } else {
                // Get.snackbar("Error", "E-Sign URL not found in response");
                ULoaders.error(
                  title: "Error",
                  message: "E-Sign URL not found in response",
                );
              }
            },
            (error) {
              isLoading.value = false;
              ULoaders.stopLoading();
              // Get.snackbar(
              //   "Error",
              //   "Failed to generate E-sign URL: ${error.message}",
              // );
              ULoaders.error(
                title: "Error",
                message: "Failed to generate E-sign URL: ${error.message}",
              );
            },
          );
        },
        (error) {
          isLoading.value = false;
          ULoaders.stopLoading();
          // Get.snackbar("Error", "Failed to create contract: ${error.message}");
          ULoaders.error(
            title: "Error",
            message: "Failed to create contract: ${error.message}",
          );
        },
      );
    } catch (e) {
      isLoading.value = false;
      // Get.snackbar("Error", "Unexpected Error during E-Sign: $e");
      ULoaders.error(
        title: "Error",
        message: "Unexpected Error during E-Sign: $e",
      );
    }
  }

  // --- Helper to finalize and fetch the signed document status ---
  Future<void> _verifyAndSaveEsign() async {
    isLoading.value = true;
    try {
      ULoaders.showLoading(message: "Verifying Digital Signature...");
      final requestData = {
        // "merchantId": "69aac24da01541001c853d48",
        "merchantId":
            SessionManager.instance.getOnboardingData?.dbRecord?.signzyUserId,

        "inputData": {"service": "esign", "task": "getEsignData", "type": ""},
      };

      // Call the strictly typed GetEsignData API
      final result = await kycUseCases.getEsignDataUseCase.call(requestData);

      result.fold(
        (success) async {
          final isSigned = success.data?.isCompleted ?? false;
          final signedPdfUrl = success.data?.signedPdfUrl ?? "";

          if (isSigned && signedPdfUrl.isNotEmpty) {
            // Get.snackbar("Success", "Contract Signed Successfully!");

            final isSaved = await saveSignedPdfToForm(signedPdfUrl);

            if (isSaved) {
              // 2. DOWNLOAD THE CONTRACT TO DEVICE
              ULoaders.showLoading(message: "Downloading signed contract...");
              await downloadSignedPdf(signedPdfUrl);

              await _submitUserForensics("contract");

              // final gpsSaved = await _submitUserForensics();

              // if (gpsSaved) {
              // 🔴 3. RUN FINAL VERIFICATION ENGINE
              ULoaders.showLoading(
                message: "Running final compliance checks...",
              );
              final isFullyVerified = await runVerificationEngine();

              ULoaders.stopLoading();

              if (isFullyVerified) {
                await SessionManager.instance.setKycVerified(true);

                ULoaders.success(
                  title: '🎉 KYC COMPLETE',
                  message: 'Your application is fully verified!',
                );

                // Get.snackbar(
                //   "🎉 KYC COMPLETE",
                //   "Your application is fully verified!",
                // );
              } else {
                ULoaders.stopLoading();
              }
              // }

              // 3. FINAL NAV (Uncomment to go to dashboard)
              Get.offAllNamed(AppRoutes.navMenuBar);
            }
          } else {
            ULoaders.stopLoading();
            Get.snackbar(
              "Pending",
              "E-sign process was not completed or cancelled by the user.",
            );
          }
        },
        (error) {
          ULoaders.stopLoading();
          Get.snackbar(
            "Error",
            "Failed to fetch E-sign status: ${error.message}",
          );
        },
      );
    } catch (e) {
      ULoaders.stopLoading();
      Get.snackbar("Error", "Exception verifying signature: $e");
    } finally {
      isLoading.value = false;
      ULoaders.stopLoading();
    }
  }

  // pdf download
  /* // Future<void> downloadSignedPdf(String url) async {
  //   try {
  //     Get.snackbar("Downloading", "Please wait, downloading your contract...");

  //     // 1. Download the file into memory
  //     // (PDFs are small, so this is very fast and safe)
  //     final response = await Dio().get(
  //       url,
  //       options: Options(responseType: ResponseType.bytes),
  //     );

  //     final Uint8List bytes = Uint8List.fromList(response.data);

  //     // 2. Define the file name (DO NOT include .pdf here, FileSaver adds it)
  //     final fileName = "Kyc_Esign_${DateTime.now().millisecondsSinceEpoch}";

  //     // 3. Save directly to the Public Downloads folder!
  //     // FileSaver natively handles Android 11+ Scoped Storage & iOS Files app
  //     final String savedFilePath = await FileSaver.instance.saveFile(
  //       name: fileName,
  //       bytes: bytes,
  //       fileExtension: "pdf",
  //       mimeType: MimeType.pdf,
  //     );

  //     Get.snackbar(
  //       "Download Complete",
  //       "Saved to your public Downloads folder!",
  //       mainButton: TextButton(
  //         onPressed: () {
  //           // OpenFilex.open(savedFilePath); // Uncomment to let users open it instantly
  //         },
  //         child: const Text("OPEN", style: TextStyle(color: Colors.blue)),
  //       ),
  //     );
  //   } catch (e) {
  //     Get.snackbar("Download Failed", "Could not download the document: $e");
  //     createLog(
  //       "Download Failed"
  //       "Could not download the document: $e",
  //     );
  //   }
  // }
  */

  Future<void> downloadSignedPdf(String url) async {
    try {
      // 1. Request Storage Permission (Crucial for Android)
      if (Platform.isAndroid) {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          await Permission.storage.request();
        }
      }

      Get.snackbar("Downloading", "Please wait, downloading your contract...");

      // 2. Get the Directory
      Directory? directory;
      if (Platform.isAndroid) {
        // Try to save directly to the public Downloads folder on Android
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        // iOS documents directory
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) throw "Could not access local storage";

      // 3. Create File Path
      final fileName = "KYC_ESIGN_${DateTime.now().millisecondsSinceEpoch}.pdf";
      final savePath = "${directory.path}/$fileName";

      // 4. Download with Dio
      final dio = Dio();
      await dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            // You can update an RxDouble here if you want a progress bar in the UI!
            // final progress = (received / total * 100);
          }
        },
      );

      Get.snackbar(
        "Download Complete",
        "Saved to $savePath",
        // mainButton: TextButton(
        //   onPressed: () => OpenFilex.open(savePath), // Opens the PDF immediately
        //   child: const Text("OPEN", style: TextStyle(color: Colors.white)),
        // ),
      );
    } catch (e) {
      Get.snackbar("Download Failed", "Could not download the document: $e");
    }
  }

  // SAVE SIGNED PDF TO FORM
  Future<bool> saveSignedPdfToForm(String signedPdfUrl) async {
    try {
      final requestData = {
        // "merchantId": "69aac24da01541001c853d48",
        "merchantId":
            SessionManager.instance.getOnboardingData?.dbRecord?.signzyUserId,

        "save": "esign",
        "data": {"signedPdf": signedPdfUrl},
      };

      final result = await kycUseCases.updateFormUseCase.call(requestData);

      return result.fold(
        (success) {
          debugPrint("Signed PDF linked to application successfully!");
          return true;
        },
        (error) {
          Get.snackbar("Error", "Failed to link signed PDF: ${error.message}");
          return false;
        },
      );
    } catch (e) {
      Get.snackbar("Error", "Exception saving signed PDF: $e");
      return false;
    }
  }

  //  --------------  Update Form Photo  --------  /////

  // LIVE PHOTO CAPTURE & UPLOAD
  Future<void> captureAndUploadPhoto() async {
    try {
      final ImagePicker picker = ImagePicker();

      // Force ImageSource.camera for Live Photo requirement!
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxHeight: 1024,
        maxWidth: 1024,
      );

      if (image == null) return;

      final Uint8List imageBytes = await image.readAsBytes();

      // Check file size (e.g., limit to 2MB)
      if (imageBytes.length > 2 * 1024 * 1024) {
        Get.snackbar("Error", "Photo must be less than 2MB");
        return;
      }

      userPhotoBytes.value = imageBytes;
      isUploadingPhoto.value = true;

      final extension = image.name.split('.').last.toLowerCase();

      final fields = {
        "merchantId":
            SessionManager.instance.getOnboardingData?.dbRecord?.signzyUserId ??
            '',

        "type": "photo",
        "fileType": extension,
      };

      final files = [imageBytes];
      final fileNames = ["live_photo.$extension"];

      // 1. Upload raw image to get Signzy URL
      final result = await kycUseCases.uploadToSignzyUseCase.call(
        fields,
        files,
        fileNames,
      );

      await result.fold(
        (success) async {
          final imageUrl = success.data?.directURL;

          if (imageUrl == null || imageUrl.isEmpty) {
            isUploadingPhoto.value = false;
            Get.snackbar("Error", "Invalid upload response from server");
            return;
          }

          uploadedPhotoUrl.value = imageUrl;

          // 2. Link the URL to the KYC Form
          await _savePhotoToForm(imageUrl, "69aac24da01541001c853d48");
        },
        (error) {
          isUploadingPhoto.value = false;
          Get.snackbar("Error", "Photo Upload Failed: ${error.message}");
        },
      );
    } catch (e) {
      isUploadingPhoto.value = false;
      Get.snackbar("Error", "Failed to capture photo: $e");
    }
  }

  // UPDATE FORM WITH USER PHOTO
  Future<void> _savePhotoToForm(String photoUrl, String merchantId) async {
    try {
      // Strictly matching the Signzy Document payload
      final requestData = {
        // "merchantId": merchantId,
        "merchantId":
            SessionManager.instance.getOnboardingData?.dbRecord?.signzyUserId,

        "save": "formData",
        "type": "userPhoto",
        "data": {"photoUrl": photoUrl},
      };

      final result = await kycUseCases.updateFormUseCase.call(requestData);

      result.fold(
        (success) async {
          photoUploadSuccess.value = true;
          isUploadingPhoto.value = false;
          Get.snackbar("Success", "Live Photo Saved Successfully");
          await _submitUserForensics("photo");
        },
        (error) {
          isUploadingPhoto.value = false;
          Get.snackbar("Error", "Failed to link photo: ${error.message}");
        },
      );
    } catch (e) {
      isUploadingPhoto.value = false;
      Get.snackbar("Error", "Exception saving photo: $e");
    }
  }

  ///  ---------   Update Form Signature   --------------  ///
  Future<void> pickAndUploadSignature(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();

      final XFile? image = await picker.pickImage(
        // source: ImageSource.gallery,
        source: source,
        // imageQuality: 80,
        imageQuality:
            50, // Lower quality slightly (50 is still very clear for a signature)
        maxWidth: 1024, // Force the image to scale down if it's huge
        maxHeight: 1024, // Force the image to scale down
      );

      if (image == null) return;

      final Uint8List imageBytes = await image.readAsBytes();

      // File size validation (1MB)
      if (imageBytes.length > 1024 * 1024) {
        Get.snackbar("Error", "Signature must be less than 1MB");
        return;
      }

      signatureImage.value = imageBytes;
      isUploadingSignature.value = true;

      // Detect extension
      final extension = image.name.split('.').last.toLowerCase();

      final fields = {
        // "merchantId": "69aac24da01541001c853d48",
        "merchantId":
            SessionManager.instance.getOnboardingData?.dbRecord?.signzyUserId ??
            '',

        "type": "signature",
        "fileType": extension,
      };

      final files = [imageBytes];
      final fileNames = ["signature.$extension"];

      final result = await kycUseCases.uploadToSignzyUseCase.call(
        fields,
        files,
        fileNames,
      );

      result.fold(
        (success) async {
          final imageUrl = success.data?.directURL;

          if (imageUrl == null || imageUrl.isEmpty) {
            isUploadingSignature.value = false;
            Get.snackbar("Error", "Invalid upload response from server");
            return;
          }

          signatureUploadResponse.value = success.data;

          // Get.snackbar("Success", "Signature Uploaded Successfully");

          // Save signature to KYC form
          log("image url ------------${imageUrl}");
          await saveSignature(imageUrl);

          isUploadingSignature.value = false;
        },
        (error) {
          isUploadingSignature.value = false;
          Get.snackbar("Error", "Upload Failed: ${error.message}");
        },
      );
    } catch (e) {
      isUploadingSignature.value = false;
      Get.snackbar("Error", "Failed to pick signature: $e");
    }
  }

  ////////////   signature save //

  /*  pickAndUploadSignature
  // Future<void> pickAndUploadSignature() async {
  //   try {
  //     // 1. Pick Image (Requires image_picker package)
  //     final ImagePicker picker = ImagePicker();
  //     final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  //     if (image != null) {
  //       // 2. Convert to Bytes
  //       final Uint8List imageBytes = await image.readAsBytes();

  //       if (imageBytes.length > 1024 * 1024) {
  //         Get.snackbar("Error", "Signature must be less than 1MB");
  //         return;
  //       }

  //       signatureImage.value = imageBytes; // Update UI immediately

  //       // 3. Prepare Data for API
  //       isUploadingSignature.value = true;

  //       final fields = {
  //         "merchantId": "69aac24da01541001c853d48",
  //         "type": "signature", // Tagging this as signature
  //         "fileType": "jpg", // or png, dynamic based on extension
  //       };

  //       final files = [imageBytes];
  //       final fileNames = ["signature.jpg"]; // or use image.name

  //       // 4. Call API (Replace with your actual UseCase call)
  //       // Assuming your UseCase signature matches: call({fields, files, fileNames})
  //       final result = await kycUseCases.uploadToSignzyUseCase.call(
  //         fields,
  //         files,
  //         fileNames,
  //       );

  //       result.fold(
  //         (success) async {
  //           final imageUrl = success.data?.directURL;

  //           // isUploadingSignature.value = false;
  //           // signatureUploadSuccess.value = true;
  //           // signatureUploadResponse.value = success.data;

  //           //
  //           if (imageUrl == null) {
  //             Get.snackbar("Error", "Invalid signature upload response");
  //             return;
  //           }

  //           Get.snackbar("Success", "Signature Uploaded Successfully");

  //           await saveSignature(imageUrl);

  //           // 5. CRITICAL: Lock the Bank Details now that Signature is present
  //           // await _submitFinalBankDetails();
  //         },
  //         (error) {
  //           isUploadingSignature.value = false;
  //           Get.snackbar("Error", "Upload Failed: ${error.message}");
  //         },
  //       );
  //     }
  //   } catch (e) {
  //     isUploadingSignature.value = false;
  //     Get.snackbar("Error", "Failed to pick signature: $e");
  //   }
  // }
 */

  // Save url signature
  Future<void> saveSignature(String imageUrl) async {
    final requestData = {
      // "merchantId": "69aac24da01541001c853d48",
      "merchantId":
          SessionManager.instance.getOnboardingData?.dbRecord?.signzyUserId,

      "save": "formData",
      "type": "signature",
      "data": {
        "type": "signature",
        "signatureImageUrl": imageUrl,
        "consent": "true",
      },
    };

    final result = await kycUseCases.updateFormUseCase.call(requestData);

    result.fold(
      (success) async {
        signatureUploadSuccess.value = true;

        Get.snackbar("Success", "Signature Saved Successfully");
        await _submitUserForensics("signature");
        // showCustomToast(

        //   title: 'Success',
        //   message: 'Signature Saved Successfully',
        //   backgroundColor: Colors.blue,
        //   icon: Icons.fork_right,
        // );

        // await _submitFinalBankDetails();
      },
      (error) {
        Get.snackbar("Error", "Signature Save Failed: ${error.message}");
      },
    );
  }

  Future<void> _handleAdditionalInfoSubmission() async {
    try {
      isLoading.value = true;
      ULoaders.showLoading(message: "Saving Additional Details...");

      final poaRequestData = {
        // "merchantId":
        //     "69aac24da01541001c853d48", // from investor login Response User Id
        "merchantId":
            SessionManager.instance.getOnboardingData?.dbRecord?.signzyUserId,

        "inputData": {
          "service": "identity",
          "type": "aadhaarDigiLocker",
          "task": "getDetails",
          "data": {"images": [], "proofType": "address"},
        },
      };

      final requestData = {
        // "merchantId": "69aac24da01541001c853d48",
        "merchantId":
            SessionManager.instance.getOnboardingData?.dbRecord?.signzyUserId,

        "save": "formData",
        "type": 'addressProof',
        "data": {
          "type": "aadhaarDigiLocker",
          "name":
              nameTextEditingController.text ??
              executePOIStep2Data.value?.result.output.name,
          "uid": executePOIStep2Data.value?.result.output.uid,
          "dob": executePOIStep2Data.value?.result.output.dob,
          "gender": executePOIStep2Data.value?.result.output.gender,
          "address": executePOIStep2Data.value?.result.output.address,
          "pincode":
              executePOIStep2Data.value?.result.output.splitAddress.pincode,
          "city": executePOIStep2Data.value?.result.output.splitAddress.city,
          "state": executePOIStep2Data.value?.result.output.splitAddress.state,
          "district":
              executePOIStep2Data.value?.result.output.splitAddress.district,
        },
      };

      final Map<String, dynamic> saveData = {
        'id': session.getUserData?.id,

        'name': nameTextEditingController.text,
        // 'email': emailController.text,
        'mobile': session.getUserData?.mobile,
        'pan_card': panTextEditingController.text,
        'dob': formatToSqlDate(dateOfBirthTextEditingController.text),
        'address': addressTextEditingController.text,
        // 'adhar': adharController.text,
        'wealth_source': wealthSourceTextEditingController.text,
        'yearly_income': getYearlyIncomeAsInt(
          incomeSlabTextEditingController.text,
        ),
        'occupation': occupationTextEditingController.text,
        'marital_status': materialTextSelectionControls.toString(),
        'father_name': fatherNameTextEditingController.text,
        'mother_name': motherNameTextEditingController.text,
        'adhar': executePOIStep2Data.value?.result.output.uid,
      };

      final poaExecuteResult = await executePOA(data: poaRequestData);

      // final saveData = updateUserData(data);
      // 3. Save to YOUR backend
      await saveUserData(saveData);

      if (poaExecuteResult) {
        // Send the Address Data as "addressProof"
        // This saves whatever is currently in your address text controllers
        final bool formUpdated = await updateForm(data: requestData);

        isLoading.value = false;

        if (formUpdated) {
          await _submitUserForensics("address");
          ULoaders.stopLoading();
          ULoaders.success(
            title: "Success",
            message: "Additional details saved successfully.",
          );
          await Future.delayed(const Duration(seconds: 1));
          _goToNextPage(); // Move to Additional Info
        } else {
          ULoaders.stopLoading();
          isLoading.value = false;
        }
      } else {
        ULoaders.stopLoading();
        isLoading.value = false;
      }
    } catch (e) {
      ULoaders.stopLoading();
      isLoading.value = false;
      Get.snackbar("Error", "Unexpected error: $e");
    }
  }

  //SAVE DATA TO  OWN BACKEND
  Future<void> saveUserData(Map<String, dynamic> requestData) async {
    try {
      // Assuming updateProfileUsecases is injected via your constructor/binding
      final result = await updateUserData.call(requestData);

      result.fold(
        (success) async {
          log("✅ User profile successfully synced to our local database.");

          // Update local session storage so the app knows about the new data instantly
          if (success.data != null) {
            final currentLocalUser = SessionManager.instance.getUserData;
            final apiData = success.data!;

            if (currentLocalUser != null) {
              final updatedUser = currentLocalUser.copyWith(
                name: apiData.data?.name ?? currentLocalUser.name,
                email: apiData.data?.email ?? currentLocalUser.email,

                // panCard: apiData.data?.panCard ?? currentLocalUser.panCard,
                // Add any other fields your copyWith supports
              );

              await SessionManager.instance.updateUserData(updatedUser);
            }
          }
        },
        (error) {
          log("❌ Failed to sync profile to local DB: ${error.message}");
        },
      );
    } catch (e) {
      log("Exception syncing to local DB: $e");
    }
  }

  //  SUBMIT USER FORENSICS (MANDATORY GPS DATA)
  // SILENTLY SUBMIT USER FORENSICS FOR A SPECIFIC STEP
  Future<bool> _submitUserForensics(String stepName) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return false;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return false;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final merchantId =
          SessionManager.instance.getOnboardingData?.dbRecord?.signzyUserId ??
          "";
      if (merchantId.isEmpty) return false;

      // STRICT PAYLOAD MATCHING SIGNZY DOCS
      final requestData = {
        "merchantId": merchantId,
        "save": "formData",
        "type": "userForensics",
        "data": {
          "type": "usersData",
          "userData": {
            stepName: {
              // <-- DYNAMIC KEY (identity, bankaccount, address, etc.)
              "geoLocationData": {},
              "browserData": {
                "browserName": "Flutter Mobile App",
                "cookieEnabled": "true",
                "browserLanguage": "en",
                "os": Platform.isAndroid ? "Android" : "iOS",
                "userAgent": "Mobile App",
                "pluginsInstalled": [],
                "browserVersion": "1.0",
                "screenWidth": Get.width.toInt().toString(),
                "screenHeight": Get.height.toInt().toString(),
                "screenPixelDepth": "24",
                "screenColorDepth": "24",
                "deviceInfo": {
                  "complete_device_name": Platform.isAndroid
                      ? "Android Mobile"
                      : "iPhone",
                  "form_factor": "Mobile",
                  "is_mobile": true,
                },
                "signzyPlatformUsed": "Mobile",
                "userLat": position.latitude,
                "userLong": position.longitude,
              },
              "pageName": stepName, // <-- SIBLING TO browserData
            },
          },
        },
      };

      final result = await kycUseCases.updateFormUseCase.call(requestData);

      return result.fold(
        (success) {
          log("📍 Forensics securely logged for step: $stepName");
          return true;
        },
        (error) {
          log("Forensics Failed for $stepName: ${error.message}");
          return false;
        },
      );
    } catch (e) {
      log("Exception in GPS Forensics for $stepName: $e");
      return false;
    }
  }
  // Future<bool> _submitUserForensics() async {
  //   try {
  //     isLoading.value = true;
  //     Get.snackbar("Location", "Securing GPS coordinates for compliance...");

  //     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //     if (!serviceEnabled) {
  //       Get.snackbar(
  //         "Error",
  //         "Location services are disabled. Please enable GPS.",
  //       );
  //       return false;
  //     }

  //     LocationPermission permission = await Geolocator.checkPermission();
  //     if (permission == LocationPermission.denied) {
  //       permission = await Geolocator.requestPermission();
  //       if (permission == LocationPermission.denied) {
  //         Get.snackbar("Error", "Location permissions denied.");
  //         return false;
  //       }
  //     }

  //     Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high,
  //     );

  //     final merchantId =
  //         SessionManager.instance.getOnboardingData?.dbRecord?.signzyUserId ??
  //         "";
  //     if (merchantId.isEmpty) return false;

  //     // Reusable browser data block
  //     Map<String, dynamic> generateBrowserData(String pageName) {
  //       return {
  //         "browserName": "Flutter Mobile App",
  //         "cookieEnabled": "true",
  //         "os": Platform.isAndroid ? "Android" : "iOS",
  //         "deviceInfo": {
  //           "complete_device_name": Platform.isAndroid
  //               ? "Android Mobile"
  //               : "iPhone",
  //           "form_factor": "Mobile",
  //           "is_mobile": true,
  //         },
  //         "signzyPlatformUsed": "Mobile",
  //         "userLat": position.latitude,
  //         "userLong": position.longitude,
  //         "pageName": pageName,
  //       };
  //     }

  //     final requestData = {
  //       "merchantId": merchantId,
  //       "save": "formData",
  //       "type": "userForensics",
  //       "data": {
  //         "type": "usersData",
  //         "userData": {
  //           "identity": {"browserData": generateBrowserData("identity")},
  //           "address": {"browserData": generateBrowserData("address")},
  //           "bankaccount": {"browserData": generateBrowserData("bankaccount")},
  //           "documents": {"browserData": generateBrowserData("documents")},
  //           "contract": {"browserData": generateBrowserData("contract")},
  //           "thankyou": {"browserData": generateBrowserData("thankyou")},
  //         },
  //       },
  //     };

  //     final result = await kycUseCases.updateFormUseCase.call(requestData);

  //     return result.fold((success) => true, (error) {
  //       Get.snackbar("Error", "Forensics Failed: ${error.message}");
  //       return false;
  //     });
  //   } catch (e) {
  //     Get.snackbar("Error", "Exception in GPS Forensics: $e");
  //     return false;
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // EXECUTE FINAL VERIFICATION ENGINE
  Future<bool> runVerificationEngine() async {
    try {
      isLoading.value = true;
      // Get.snackbar("Verifying", "Running final compliance checks...");

      final merchantId =
          SessionManager.instance.getOnboardingData?.dbRecord?.signzyUserId ??
          "";

      final requestData = {
        "merchantId": merchantId,
        "inputData": {
          "service": "verificationEngine",
          "merchantId": merchantId,
        },
      };

      // NOTE: Ensure you have executeVerificationEngineUseCase created!
      final result = await kycUseCases.executeVerificationEngineUseCase.call(
        requestData,
      );

      return result.fold((success) => true, (error) {
        Get.snackbar(
          "Verification Failed",
          "Data Incomplete or Invalid: ${error.message}",
        );
        return false;
      });
    } catch (e) {
      Get.snackbar("Error", "Exception in Verification Engine: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Submit Correspondence Address (Required by AMC)
  Future<bool> _submitCorrespondenceAddress() async {
    try {
      final requestData = {
        "merchantId":
            SessionManager.instance.getOnboardingData?.dbRecord?.signzyUserId,
        "save": "formData",
        "type": "corrAddressProof",
        "data": {"sameAsPermanent": "true"},
      };

      final result = await kycUseCases.updateFormUseCase.call(requestData);

      return result.fold((success) => true, (error) {
        Get.snackbar(
          "Error",
          "Correspondence Address Failed: ${error.message}",
        );
        return false;
      });
    } catch (e) {
      Get.snackbar("Error", "Correspondence Address Exception: $e");
      return false;
    }
  }

  Future<void> _updateFormKycDataSubmission() async {
    try {
      isLoading.value = true;
      ULoaders.showLoading(message: "Submitting KYC Data...");

      final requestData = {
        // "merchantId": "69aac24da01541001c853d48", // Use dynamic ID
        "merchantId":
            SessionManager.instance.getOnboardingData?.dbRecord?.signzyUserId,

        "save": "formData",
        "type": "kycdata",
        "data": {
          "type": "kycdata",
          "kycData": {
            "name":
                nameTextEditingController.text, // Required for PAN verification
            "dob": dateOfBirthTextEditingController
                .text, // Required for PAN verification
            // "panNumber": panTextEditingController.text,
            "panNumber":
                // SessionManager.instance.getUserData?.panCard ??
                panTextEditingController.text,

            // 1. NOMINEE DETAILS
            "nomineeRelationShip": nomineeRelationTextEditingController.text
                .toUpperCase(), // FATHER, SPOUSE, etc.
            // 2. APPLICANT DETAILS (MANDATORY RE-SEND)
            // Personal
            "gender": selectedGender.value == "MALE" ? "M" : "F",
            "maritalStatus": selectedMaritalStatus.value, // MARRIED / UNMARRIED
            "fatherTitle": "Mr.",
            "fatherName": fatherNameTextEditingController.text, // REQUIRED
            "motherTitle": "Mrs.",
            "motherName": motherNameTextEditingController.text, // REQUIRED
            // Identity
            // "panNumber": panTextEditingController.text,
            // Use raw UID from DigiLocker data if available, else empty string
            "aadhaarNumber": executePOIStep2Data.value?.result.output.uid ?? "",

            // Contact (User's info)
            "mobileNumber": SessionManager
                .instance
                .getUserData
                ?.mobile, // Get from User Profile
            "emailId": SessionManager
                .instance
                .getUserData
                ?.email, // Get from User Profile
            "countryCode": 91,

            // Financials (Send CODES, e.g., "01", "32")
            "occupationCode": getOccupationCode(
              occupationTextEditingController.text,
            ),

            "occupationDescription": occupationTextEditingController.text,
            "annualIncome": getIncomeCode(incomeSlabTextEditingController.text),
            "occupationOther": occupationOtherTextEditingController.text,

            // Regulatory Flags
            // "residentForTaxInIndia": "YES",
            // "rpep": "NO", // Relative of Politically Exposed Person
            // "pep": "NO",  // Politically Exposed Person
            "residentialStatus": selectedTaxStatus.value,
            "applicationStatusDescription": selectedTaxStatus.value,
            "applicationStatusCode": getApplicationStatusCode(
              selectedTaxStatus.value,
            ),
            // "citizenshipCountryCode": "IN",
            "citizenshipCountry": "India",
            "placeOfBirth": "India",
            "kycAccountCode": "01",
            "kycAccountDescription": "New",

            // Address Codes (Required defaults)
            "permanentAddressCode": "01", // Residential
            "permanentAddressType": "Residential",
            "communicationAddressCode": "01", // Residential
            "communicationAddressType": "Residential",
            "citizenshipCountryCode": "101",
          },
        },
      };

      // Send the Address Data as "addressProof"
      // This saves whatever is currently in your address text controllers
      final bool nomineeSaved = await updateForm(data: requestData);

      final saveRequestData = {
        "customer_id": session.getUserData?.id,
        "name": nomineeNameTextEditingController.text,
        "relation": nomineeRelationTextEditingController.text,
        "dob": formatToSqlDate(nomineeDateOfBirthTextEditingController.text),
        "allocation_percent": '100',
        // Send 1 if minor, 0 if not
        "is_minor": 0,
        "guardian_name": '',
        "email": nomineeEmailTextEditingController.text,
        "phone_number": nomineeMobileTextEditingController.text,
        "document_type": selectedNomineeDocument.toString(),
        "document_number": nomineeSelectedDocumentTextEditingController.text,
        "address": nomineeAddressTextEditingController.text,
      };

      await saveNomineeToDatabase(saveRequestData);

      isLoading.value = false;

      if (nomineeSaved) {
        final result = await _submitFatcaData();
        if (result == true) {
          await _submitUserForensics("fatca");
          final corrResult = await _submitCorrespondenceAddress();
          // _goToNextPage(); // Move to Additional Info
          if (corrResult == true) {
            // 2. STOP LOADER & SHOW SUCCESS
            ULoaders.stopLoading();
            ULoaders.success(
              title: "Success",
              message: "Nominee & FATCA details verified.",
            );
            await Future.delayed(const Duration(seconds: 1));
            _goToNextPage(); // Move to the next screen safely!
          }
        }
      }
      ULoaders.stopLoading();
      isLoading.value = false;
    } catch (e) {
      ULoaders.stopLoading();
      isLoading.value = false;
      Get.snackbar("Error", "Unexpected error: $e");
    }
  }

  // SILENTLY SAVE NOMINEE TO YOUR OWN BACKEND
  Future<void> saveNomineeToDatabase(Map<String, dynamic> requestData) async {
    try {
      final result = await saveDataNominee.call(requestData);

      result.fold(
        (success) {
          log("✅ Nominee data successfully synced to our local database.");
        },
        (error) {
          log("❌ Failed to sync nominee to local DB: ${error.message}");
        },
      );
    } catch (e) {
      log("Exception syncing nominee to local DB: $e");
    }
  }

  Future<bool> _submitFatcaData() async {
    try {
      final isResident = selectedTaxStatus.value.contains("Resident");
      final taxResidentOutsideIndia = isResident ? "NO" : "YES";

      final requestData = {
        // "merchantId": "69aac24da01541001c853d48",
        "merchantId":
            SessionManager.instance.getOnboardingData?.dbRecord?.signzyUserId,
        "save": "formData",
        "type": "fatca", // <--- KEY TYPE
        "data": {
          "type": "fatca",
          "fatcaData": {
            // "NO" means "I am NOT a tax resident of any other country" (Standard for Locals)
            "residentForTaxInIndia": taxResidentOutsideIndia,

            "pep": "NO", // Politically Exposed Personult to  (DefaNO)
            "rpep": "NO", // Related to PEP (Default to NO)
            "relatedPerson": "NO",

            // Required Location Fields
            "placeOfBirth":
                "India", // You should probably add a TextController for this
            "countryOfBirth": "India",
            "countryCodeOfBirth": "IN",

            // Address Type for Tax Purposes
            "addressType": "01", // 01 = Residential
            "addressCountry": "India",
            "addressCountryCode": "IN",

            // Note: If 'residentForTaxInIndia' is "YES" (NRI), you MUST provide:
            // "countryCodeJurisdictionResidence": "US", (Example)
            // "taxIdentificationNumber": "123456",
          },
        },
      };

      final result = await kycUseCases.updateFormUseCase.call(requestData);

      return result.fold((success) => true, (error) {
        Get.snackbar("Error", "FATCA Verification Failed: ${error.message}");
        return false;
      });
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
        },
      );
    } catch (e) {
      Get.snackbar("Error", "getTokenData Error: $e");
      return false;
    } finally {
      isLoadingTokenData.value = false;
    }
  }

  // Onboarding and Login Data
  Future<bool> saveOnboardingData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final Map<String, dynamic> requestBody = {
        "user_id": SessionManager.instance.getUserData?.id,
      };

      final result = await kycUseCases.saveOnboardingDataUseCase.call(
        requestBody,
      );

      return result.fold(
        (success) async {
          onboardingResult.value = success.data;
          await SessionManager.instance.saveOnboardingData(
            onboardingResult.value,
          );

          createLog(
            "Onboarding Initiated Successfully: ${success.data?.message}",
          );

          return true;
        },
        (error) {
          errorMessage.value = error.message;
          Get.snackbar("KYC Initiation Error", error.message);
          return false;
        },
      );
    } catch (e) {
      errorMessage.value = "An unexpected error occurred.";
      createLog("Exception in saveOnboardingData: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> getCaptcha() async {
    try {
      isLoadingCaptcha.value = true;

      // Call the UseCase (which now returns Uint8List?)
      final result = await kycUseCases.getCaptchaUseCase.call({});

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
        },
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
      ULoaders.showLoading(message: "Verifying Bank Account...");

      final requestData = {
        // "merchantId": "69aac24da01541001c853d48",
        "merchantId":
            SessionManager.instance.getOnboardingData?.dbRecord?.signzyUserId,

        "inputData": {
          "service": "nonRoc",
          "type": "bankaccountverifications",
          "task": "bankTransfer",
          "data": {
            "searchParam": {
              "beneficiaryAccount": accountNoController.text,
              "beneficiaryIFSC": ifscController.text,
            },
          },
        },
      };

      final result = await kycUseCases.executePennyDropUseCase.call(
        requestData,
      );
      ULoaders.stopLoading();

      return result.fold(
        (success) {
          // 3. Handle Success
          log("🕵️ DEBUG ACTIVE STATUS: '${success.data?.active}'");
          if ((success.data?.active == "yes")) {
            final output = success.data;

            // // Extract Name (adjust key based on actual API response)
            // final bankName = output['beneficiaryName'] ??
            //     output['data']?['beneficiaryName'] ??
            //     "Verified Account";

            verifiedBankName.value = output;
            ULoaders.success(
              title: "Account Found",
              message: "We've successfully verified}.",
            );

            return true;
          } else {
            ULoaders.error(
              title: "Invalid Account",
              message: "Verification failed.",
            );
            return false;
          }
        },
        (error) {
          // ULoaders.error(title: "Pennydrop Failed", message: error.message);
          final userFriendlyMessage = UErrorMessages.getReadableError(
            error.message,
          );
          // ULoaders.error(
          //   title: "Verification Failed",
          //   message:
          //       "We couldn't verify this account. Please check the Account/IFSC details.",
          // );
          ULoaders.error(
            title: "Verification Failed",
            message: userFriendlyMessage,
          );
          return false;
        },
      );
    } catch (e) {
      // ULoaders.error(title: "System Error", message: e.toString());
      ULoaders.stopLoading();
      ULoaders.error(
        title: "Connection Error",
        message: "Unable to reach bank servers.",
      );
      return false;
    } finally {
      // 5. Stop Loading (Critical!)
      isVerifyingBank.value = false;
      isLoading.value = false;
    }
  }

  Future<void> _submitFinalBankDetails() async {
    try {
      isLoading.value = true;
      ULoaders.showLoading(message: "Securing Bank Details...");

      // final requestData = {
      //   "merchantId": "69aac24da01541001c853d48",
      //   "service": "nonRoc",
      //   "type": "bankaccountverifications",
      //   "task": "verifyAmount",
      //   "data": {
      //     "images": [],
      //     "toVerifyData": {},
      //     "searchParam": {
      //       "amount": "1",
      //       // "signzyId": verifiedBankName.value?.signzyReferenceId,
      //       "signzyId": "wvDrsqnCP26ycHabL9NRkhMmfEmPFcJqO5rALaZi3LaPrIqlTd17",
      //     },
      //   },
      // };

      final signzyId = verifiedBankName.value?.signzyReferenceId;
      if (signzyId == null || signzyId.isEmpty) {
        ULoaders.stopLoading();
        // Get.snackbar("Error", "Reference ID is missing. Please retry.");
        // ULoaders.error(title: "Error", message: "Reference ID is missing. Please retry.");
        ULoaders.error(
          title: "Session Expired",
          message:
              "We couldn't find your verification ID. Please restart the process.",
        );
        isLoading.value = false;
        return;
      }
      final requestData = {
        "merchantId":
            SessionManager.instance.getOnboardingData?.dbRecord?.signzyUserId ??
            "",

        "inputData": {
          "service": "nonRoc",
          "type": "bankaccountverifications",
          "task": "verifyAmount",
          "data": {
            "searchParam": {
              "amount": 1,
              // "signzyId": verifiedBankName.value?.signzyReferenceId,
              "signzyId": signzyId,
            },
          },
        },
      };

      final result = await kycUseCases.executeVerifyAmountUseCase.call(
        requestData,
      );

      isLoading.value = false;
      ULoaders.stopLoading();

      result.fold(
        (success) async {
          // Get.snackbar("Success", "Bank Details Verified & Locked!");
          // Move to Success Screen or Finish Flow
          // _goToNextPage();
          if (success.data?.amountMatch == "true") {
            // Get.snackbar("Success", "Bank Details Verified & Locked!");
            ULoaders.success(
              title: "Verification Successful",
              message: "Your bank account has been securely linked.",
            );
            await _submitUserForensics("bankaccount");
          } else {
            // Get.snackbar("Error", "Bank Verification Failed: Amount mismatch");
            ULoaders.warning(
              title: "Amount Mismatch",
              message:
                  "The penny drop amount entered does not match our records.",
            );
          }
        },
        (error) {
          // Get.snackbar("Error", "Final Bank Lock Failed: ${error.message}");
          ULoaders.error(
            title: "Verification Failed",
            message: UErrorMessages.getReadableError(error.message),
          );
        },
      );
    } catch (e) {
      isLoading.value = false;
      ULoaders.stopLoading();
      // Get.snackbar("Error", "Unexpected Error: $e");
      ULoaders.error(
        title: "Connection Error",
        message: "We're unable to reach the verification service right now.",
      );
    }
  }

  // ===========================================================================
  // NAVIGATION HELPERS
  void _goToNextPage() {
    if (currentStep.value < 6) {
      // 6 is the max index based on your 7 steps
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

    // Exact string matching based on your incomeSlabList
    switch (value) {
      case "Below 1 Lakh":
        return "31";
      case "1 Lacs - 5 Lacs":
        return "32";
      case "5 Lacs - 10 Lacs":
        return "33";
      case "10 Lacs - 25 Lacs":
        return "34";
      case "25 Lacs - 1 Cr.":
        return "35";
      case "Above 1 Cr.":
        return "36";
      default:
        // Default fallback just in case
        return "31";
    }
  }

  // String getIncomeCode(String text) {
  //   final value = text.trim();

  //   // Mapping based on Signzy Table 1.8
  //   if (value.contains("Below 1")) return "31"; // Below 1 Lac
  //   if (value.contains("1") && value.contains("5")) return "32"; // 1-5 Lacs
  //   if (value.contains("5") && value.contains("10")) return "33"; // 5-10 Lacs
  //   if (value.contains("10") && value.contains("25")) return "34"; // 10-25 Lacs
  //   if (value.contains("25") && value.contains("1"))
  //     return "35"; // 25 Lacs-1 crore
  //   if (value.contains("Above 1") || value.contains("> 1"))
  //     return "36"; // > 1 crore

  //   // Default fallback (e.g., 1-5 Lacs)
  //   return "32";
  // }

  String getResdStatusCode(String text) {
    if (text == "Resident Individual") return "RI";
    if (text == "Non-Resident Indian") return "NRI";
    if (text == "Foreign National") return "FN";
    if (text == "Hindu Undivided Family") return "HUF";
    return "RI";
  }

  String getModeOfHldCode(String text) {
    if (text == "Single") return "SI";
    if (text == "Joint") return "JO";
    if (text == "Anyone or Survivor") return "AS";
    return "SI";
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

    if (value.contains("private")) return "01"; // Private Sector
    if (value.contains("public")) return "02"; // Public Sector
    if (value.contains("business")) return "03"; // Business
    if (value.contains("professional")) return "04"; // Professional
    if (value.contains("retired")) return "06"; // Retired
    if (value.contains("housewife")) return "07"; // Housewife
    if (value.contains("student")) return "08"; // Student
    if (value.contains("government")) return "10"; // Government Sector
    if (value.contains("self")) return "11"; // Self Employed

    // Default to "Others" if no match found
    return "99";
  }

  Future<bool> updateForm({required Map<String, dynamic> data}) async {
    try {
      final requestData = data;

      final result = await kycUseCases.updateFormUseCase.call(requestData);
      return result.fold(
        (success) {
          return true;
        },
        (error) {
          ULoaders.stopLoading();
          Get.snackbar("Error", error.message ?? "Update Form Failed");
          return false;
        },
      );
    } catch (e) {
      ULoaders.stopLoading();
      Get.snackbar("Error", "Unexpected error: $e");
      return false;
    }
  }

  Future<bool> executePOA({required Map<String, dynamic> data}) async {
    try {
      final requestData = data;

      final result = await kycUseCases.executePoaUseCase.call(requestData);
      return result.fold(
        (success) {
          return true;
        },
        (error) {
          Get.snackbar("Error", error.message ?? "Update Form Failed");
          return false;
        },
      );
    } catch (e) {
      Get.snackbar("Error", "Unexpected error: $e");
      return false;
    }
  }

  Future<bool> executePOIStep1() async {
    try {
      isExecutingPOIStep1.value = true;

      final requestData = {
        // "merchantId":
        //     "69aac24da01541001c853d48", // from investor login Response User Id
        "merchantId":
            SessionManager.instance.getOnboardingData?.dbRecord?.signzyUserId,

        "inputData": {
          "service": "identity",
          "type": "aadhaarDigiLocker",
          "task": "createUrl",
          "data": {"images": [], "proofType": "identity"},
        },
      };

      final result = await kycUseCases.executePoiStep1UseCase.call(requestData);

      return result.fold(
        (success) {
          if (success.data != null) {
            executePOIStep1Data.value = success.data;
            return true;
          } else {
            ULoaders.stopLoading();
            Get.snackbar("Error", "Invalid server response");
            return false;
          }
        },
        (error) {
          ULoaders.stopLoading();
          Get.snackbar("Error", error.message ?? "Execute POI Step 1 Failed");
          return false;
        },
      );
    } catch (e) {
      ULoaders.stopLoading();
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
        // "merchantId":
        //     "69aac24da01541001c853d48", // from investor login Response User Id
        "merchantId":
            SessionManager.instance.getOnboardingData?.dbRecord?.signzyUserId,

        "inputData": {
          "service": "identity",
          "type": "aadhaarDigiLocker",
          "task": "getDetails",
          "data": {"images": [], "proofType": "identity"},
        },
      };

      final result = await kycUseCases.executePoiStep2UseCase.call(requestData);

      return result.fold(
        (success) {
          if (success.data != null) {
            executePOIStep2Data.value = success.data;
            nameTextEditingController.text =
                executePOIStep2Data.value?.result.output.name ?? '';
            dateOfBirthTextEditingController.text =
                executePOIStep2Data.value?.result.output.dob ?? '';
            selectedGender.value =
                executePOIStep2Data.value?.result.output.gender ?? '';
            addressTextEditingController.text =
                executePOIStep2Data.value?.result.output.address ?? '';

            pinCodeTextEditingController.text =
                executePOIStep2Data.value?.result.output.splitAddress.pincode ??
                '';

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

  int getYearlyIncomeAsInt(String text) {
    final value = text.trim();

    // Translate the dropdown string into a raw integer for your database
    switch (value) {
      case "Below 1 Lakh":
        return 90000; // Using 90,000 as seen in your success log
      case "1 Lacs - 5 Lacs":
        return 500000;
      case "5 Lacs - 10 Lacs":
        return 1000000;
      case "10 Lacs - 25 Lacs":
        return 2500000;
      case "25 Lacs - 1 Cr.":
        return 10000000;
      case "Above 1 Cr.":
        return 50000000;
      default:
        return 0;
    }
  }

  void onBankSelectedFromName(String bankName) {
    final bank = bankList.firstWhereOrNull(
      (element) => element.bankName == bankName,
    );
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
    if (selectedBank.value == null) {
      Get.snackbar("Error", "Please select a banka");
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
