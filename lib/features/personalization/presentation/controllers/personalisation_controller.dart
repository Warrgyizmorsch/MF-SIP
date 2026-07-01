// ignore_for_file: dead_null_aware_expression, dead_code

import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:image_picker/image_picker.dart';
import 'package:my_sip/common/widget/animated/custom_toast.dart';
import 'package:my_sip/common/widget/animated/popups.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/helper/helpers.dart';
import 'package:my_sip/features/mfu/presentation/controller/mfu_controller.dart';
import 'package:my_sip/features/personalization/data/model/risk_result_model.dart';
import 'package:my_sip/features/personalization/data/model/risk_submit_rq.dart';
import 'package:my_sip/features/personalization/domain/entity/bank_entity.dart';
import 'package:my_sip/features/personalization/domain/entity/nominee_entity.dart';
import 'package:my_sip/features/personalization/domain/entity/risk_question_entity.dart';
import 'package:my_sip/features/personalization/domain/usecases/personalisation_use_cases.dart';
import 'package:my_sip/services/session_manager.dart';

import 'dart:async';

import 'package:my_sip/features/personalization/domain/entity/profile_update_entity.dart'
    as profileEntity;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class PersonalisationController extends GetxController {
  final PersonalisationUseCases _useCases;
  PersonalisationController(this._useCases);

  PersonalisationUseCases get useCases => _useCases;

  @override
  void onInit() {
    super.onInit();
    panController.addListener(_onPanTextChanged);
    loadRiskQuestions();
    _checkPanEditPermission();
    // fetchBanks();
    fetchUserDetails();
    bankIfscController.addListener(() {
      final text = bankIfscController.text;
      if (text.length == 11) {
        _fetchBankDetailsFromIFSC(text);
      } else {
        resolvedBranch.value = '';
      }
    });

    bankNameController.addListener(() {
      if (bankNameController.text.isNotEmpty) {
        if (bankIfscController.text.isNotEmpty &&
            bankNameController.text != autoFetchedBank.value) {
          bankIfscController.clear();
          resolvedBranch.value = '';
          autoFetchedBank.value = '';

          Future.delayed(const Duration(milliseconds: 600), () {
            Get.closeAllSnackbars();

            ULoaders.warning(
              title: "Bank Changed",
              message:
                  "Please enter the IFSC code for your newly selected bank.",
            );
          });
        } else {
          print(
            "❌ Conditions not met. Either IFSC is empty, or the bank names match.",
          );
        }
      }
    });
  }

  final panKeyboardType = TextInputType.text.obs;
  final FocusNode panFocusNode = FocusNode();
  final personalDetailsFormKey = GlobalKey<FormState>();

  // --- State Variables ---
  final isLoading = false.obs;
  final isAnalyzing = false.obs;
  final riskQuestions = <QuestionEnitity>[].obs;
  final selectedAnswers = <int, int>{}.obs; // Key: QuestionID, Value: OptionID
  final currentQuestionIndex = 0.obs;
  final analysisText = "Analyzing your profile...".obs;
  final riskResult = Rxn<RiskResultModel>();
  final applock = false.obs;
  final canEditPan = false.obs;
  // 1. ADD THESE TWO LINES AT THE TOP OF THE CONTROLLER
  bool _isRegisteringCan = false;
  bool _hasAttemptedCanReg = false;

  // --- Onboarding Status Flags ---
  final isKycPending = false.obs;
  final isKycVerified = false.obs;
  final hasRiskProfile = false.obs;
  final hasNominee = false.obs;
  final hasBank = false.obs;
  final hasPersonalDetails = false.obs;
  final isProfileLoading = true.obs;

  // --- UI Controllers ---
  final PageController pageController = PageController();

  final session = SessionManager.instance;

  final isDeleteLoading = <int, bool>{}.obs;
  final addNomineeLoading = false.obs;
  final isNomineeLoading = false.obs;
  final isNomineeMinor = false.obs;
  final GlobalKey<FormState> nomineeFormKey = GlobalKey<FormState>();
  final nomineeList = Rxn<NomineeResponseEntity>();

  final userData = Rxn<profileEntity.ProfileDataEntity>();

  // ------------ Mandate status  -------------        /////
  // 1. Check if a mandate is currently processing
  bool get hasPendingMandate {
    final status = userData.value?.mfuMandate?.status?.toLowerCase();
    return status == 'pending';
  }

  // 2. Check if a mandate is fully approved and active
  bool get hasApprovedMandate {
    final status = userData.value?.mfuMandate?.status?.toLowerCase();
    return status == 'approved' || status == 'success' || status == 'initiated';
  }

  // 3. Grab the MMRN or MMURN to pass into the SIP API
  String? get activeMmrn {
    return userData.value?.mfuMandate?.mmrn;
  }

  String? get activeMmurn {
    return userData.value?.mfuMandate?.mumrn;
  }

  final nomineeDocumentSelectionList = [
    "Pan",
    "Aadhaar",
    "Driving License",
    "Passport",
  ];
  final nomineeRelationSelectionList = [
    'Aunt',
    'Brother-In-Law',
    'Brother',
    'Daughter',
    'Daughter-In-Law',
    'Father',
    'Father-In-Law',
    'Grand Daughter',
    'Grand Father',
    'Grand Mother',
    'Mother',
    'Mother-In-Law',
    'Son',
    'Spouse',
    'Testing',
  ];

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

  final TextEditingController occupationTextEditingController =
      TextEditingController();

  final TextEditingController incomeSlabTextEditingController =
      TextEditingController();

  final TextEditingController pinCodeTextEditingController =
      TextEditingController();
  final TextEditingController fatherNameTextEditingController =
      TextEditingController();
  final TextEditingController motherNameTextEditingController =
      TextEditingController();
  final TextEditingController occupationOtherTextEditingController =
      TextEditingController();

  final TextEditingController cityTextEditingController =
      TextEditingController();
  final TextEditingController stateTextEditingController =
      TextEditingController();

  final nomineeNameTextEditingController = TextEditingController();
  final nomineeDobTextEditingController = TextEditingController();
  final nomineeEmailTextEditingController = TextEditingController();
  final nomineePhoneTextEditingController = TextEditingController();
  final nomineeDocumentTypeTextEditingController = TextEditingController();
  final nomineeDocumentNumberTextEditingController = TextEditingController();
  final nomineeRelationTextEditingController = TextEditingController();
  final nomineeAllocationPercentTextEditingController = TextEditingController();
  final nomineeMinorsGuardianTextEditingController = TextEditingController();
  final nomineeAddressTextEditingController = TextEditingController();
  final nomineeAddress2TextEditingController = TextEditingController();
  final nomineePincodeTextEditingController = TextEditingController();
  final nomineeCityTextEditingController = TextEditingController();
  final nomineeContryTextEditingController = TextEditingController();

  // ------------------------ Update Profile ---------------------------------------///

  // Observable states
  final isLoadingPU = false.obs;
  final imagePath = ''.obs;
  XFile? selectedImageFile;

  // Form Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final panController = TextEditingController();
  final adharController = TextEditingController();
  final addressController = TextEditingController();
  final dobController = TextEditingController();
  final wealthSource = TextEditingController();
  final yearlyIncome = TextEditingController();

  // ------------------------ Bank List Fetching State ------------------------///
  final isBankListLoading = false.obs;
  final bankList = <BankItemEntity>[].obs;
  final bankErrorMessage = ''.obs;
  // --- Linked Bank Account State ---
  final isLinkedBankLoading = false.obs;
  // final linkedBankAccount = Rxn<dynamic>();
  final linkedBankAccounts = <profileEntity.BankAccountEntity>[].obs;

  final RxBool isFetchingIFSC = false.obs;
  final RxString resolvedBranch = ''.obs;
  final RxString autoFetchedBank = ''.obs;

  // ------------------------ Add Bank Account State --------------------------///
  final isBankAdding = false.obs;
  final bankNameController = TextEditingController();
  final bankAccountNumberController = TextEditingController();
  final bankIfscController = TextEditingController();
  final bankMicrController = TextEditingController();
  final bankAccHdNameController = TextEditingController();
  final bankAccountType = 'SB'.obs; // SB = Savings, CA = Current
  bool get canAddMoreBanks => linkedBankAccounts.length < 3;
  final isDeletingBank = <int, bool>{}.obs;

  void clearBankFields() {
    bankNameController.clear();
    bankAccountNumberController.clear();
    bankIfscController.clear();
    bankMicrController.clear();
    bankAccountType.value = 'SB';
    autoFetchedBank.value = '';
    resolvedBranch.value = '';
    isFetchingIFSC.value = false;
    bankAccHdNameController.clear();
  }

  Future<void> fetchBanks() async {
    try {
      isBankListLoading(true);
      bankErrorMessage('');

      final result = await _useCases.getBankUseCases.call({});

      result.fold(
        (success) {
          if (success.data != null) {
            bankList.assignAll(success.data!.data);
            log("Successfully assigned ${bankList.length} banks");
          }
        },
        (error) {
          bankErrorMessage.value = error.message ?? "Failed to load banks";
        },
      );
    } catch (e) {
      bankErrorMessage.value = "An unexpected error occurred: $e";
    } finally {
      isBankListLoading(false);
    }
  }

  // --- Fetch User's Linked Bank ---
  // --- Fetch User Profile & Evaluate Onboarding Status ---
  Future<void> fetchUserDetails() async {
    isProfileLoading.value = true;
    final userId = session.getUserData?.id;
    if (userId == null) return;

    log('Fetching user profile for onboarding status...');

    isLinkedBankLoading.value = true;
    try {
      final data = {'id': userId};

      final result = await _useCases.updateProfileUsecases.call(data);

      result.fold(
        (success) {
          final profileData = success.data?.data;

          if (profileData != null) {
            // 1. Check Bank Account
            userData.value = profileData;
            // linkedBankAccount.value = profileData.bankAccount;
            // hasBank.value = profileData.bankAccount != null;
            // final hasBanks =
            //     profileData.bankAccounts != null &&
            //     profileData.bankAccounts!.isNotEmpty;
            // linkedBankAccount.value = hasBanks
            //     ? profileData.bankAccounts!.first
            //     : null;
            if (profileData.bankAccounts != null) {
              linkedBankAccounts.assignAll(profileData.bankAccounts!);
            } else {
              linkedBankAccounts.clear(); // Empty the list if null
            }
            hasBank.value = linkedBankAccounts.isNotEmpty;

            // 2. Check KYC Status (Using toLowerCase to be safe against API text changes)
            final kyc = profileData.kycStatus?.toLowerCase() ?? '';
            isKycPending.value = kyc == 'pending' || kyc == 'in progress';
            isKycVerified.value = kyc == 'approved' || kyc == 'verified';

            // 3. Check Risk Profile (True if riskProfile object exists OR a score exists)
            hasRiskProfile.value =
                profileData.riskProfile != null ||
                (profileData.riskScore != null &&
                    profileData.riskScore!.isNotEmpty);

            // 4. Check Nominee
            hasNominee.value = profileData.nominee != null;

            hasPersonalDetails.value =
                profileData.customerDetails != null &&
                profileData.customerDetails?.motherName != null &&
                (profileData.customerDetails?.fatherName ?? '').isNotEmpty;

            loadDataIntoProfileScreen(profileData);

            log('--- Onboarding Status ---');
            log(
              'KYC Verified: ${isKycVerified.value} | Pending: ${isKycPending.value}',
            );
            log('Has Bank: ${hasBank.value}');
            log('Has Nominee: ${hasNominee.value}');
            log('Has Risk Profile: ${hasRiskProfile.value}');

            checkAndTriggerCanRegistration();
            final mfuController = Get.find<MfuController>();
            mfuController.resumePollingIfNeeded();
          } else {
            linkedBankAccounts.clear();
          }
        },
        (error) {
          log("Error fetching profile status: ${error.message}");
        },
      );
    } catch (e) {
      log("Fetch Profile Status Exception: $e");
    } finally {
      isLinkedBankLoading.value = false;
      isProfileLoading.value = false;
    }
  }

  // ------------ Can Check and Create -------------  //
  // void _checkAndTriggerCanRegistration() {
  //   // ✅ CAN already exists on server → skip forever
  //   final existingCan = session.getUserData?.canNumber ?? '';
  //   if (existingCan.isNotEmpty) {
  //     log("[CAN] Already exists ($existingCan) — skipping registration");
  //     return;
  //   }

  //   final kycDone = isKycVerified.value;
  //   final bankDone = hasBank.value;
  //   final personalDetailsDone = hasPersonalDetails.value;

  //   log(
  //     "[CAN] Check → KYC: $kycDone | Bank: $bankDone | PersonalDetails: $personalDetailsDone",
  //   );

  //   if (kycDone && bankDone && personalDetailsDone) {
  //     log("[CAN] ✅ All conditions met — triggering CAN registration");
  //     _triggerCanRegistration();
  //   } else {
  //     final missing = [
  //       if (!kycDone) 'KYC',
  //       if (!bankDone) 'Bank',
  //       if (!personalDetailsDone) 'Personal Details',
  //     ].join(', ');
  //     log("[CAN] ⏳ Skipped — missing: $missing");
  //   }
  // }
  void checkAndTriggerCanRegistration({bool isManualTrigger = false}) {
    // 2. ADD THIS GUARD CHECK AT THE TOP OF THE FUNCTION
    // if (_isRegisteringCan || _hasAttemptedCanReg) {
    //   return;
    // }
    if (_isRegisteringCan) {
      log("[CAN] Already registering, please wait...");
      return;
    }
    if (!isManualTrigger && _hasAttemptedCanReg) {
      return;
    }

    final existingCan = session.getUserData?.canNumber ?? '';
    final exitstingCan1 = userData.value?.canNumber ?? '';
    if (existingCan.isNotEmpty || exitstingCan1.isNotEmpty) {
      log(
        "[CAN] Already exists ($existingCan --- $exitstingCan1) — skipping registration",
      );
      return;
    }

    final kycDone = isKycVerified.value;
    final bankDone = hasBank.value;
    final personalDetailsDone = hasPersonalDetails.value;

    log(
      "[CAN] Check → KYC: $kycDone | Bank: $bankDone | PersonalDetails: $personalDetailsDone",
    );

    if (kycDone && bankDone && personalDetailsDone) {
      log("[CAN] ✅ All conditions met — triggering CAN registration");
      _triggerCanRegistration();
    } else {
      if (isManualTrigger) {
        CustomSnackbar.warning(
          title: 'Action Required',
          message: 'Please complete KYC, Bank, and Personal Details first.',
        );
      }
      final missing = [
        if (!kycDone) 'KYC',
        if (!bankDone) 'Bank',
        if (!personalDetailsDone) 'Personal Details',
      ].join(', ');
      log("[CAN] ⏳ Skipped — missing: $missing");
    }
  }

  // Future<void> _triggerCanRegistration() async {
  //   try {
  //     final mfuController = Get.find<MfuController>();
  //     await mfuController.canRegister(reqEvent: "CR");

  //     if (mfuController.errorMessage.value.isEmpty) {
  //       // ✅ Refresh session so canNumber is populated from server
  //       // await session.refreshUserData();
  //       final canNumber = mfuController.mfuCanResponse.value?.can ?? '';
  //       if (canNumber.isNotEmpty) {
  //         final currentUser = session.getUserData;
  //         if (currentUser != null) {
  //           await session.updateUserData(
  //             currentUser.copyWith(canNumber: canNumber),
  //           );
  //         }
  //       }

  //       log("[CAN] ✅ Registered — CAN: $canNumber");

  //       await fetchUserDetails();
  //       Get.find<MfuController>().resumePollingIfNeeded();
  //     } else {
  //       log("[CAN] ❌ Failed: ${mfuController.errorMessage.value}");
  //     }
  //   } catch (e) {
  //     log("[CAN] ❌ Exception: $e");
  //   }
  // }
  Future<void> _triggerCanRegistration() async {
    // 3. LOCK THE GUARDS
    _isRegisteringCan = true;
    _hasAttemptedCanReg = true;

    try {
      final mfuController = Get.find<MfuController>();
      await mfuController.canRegister(reqEvent: "CR");

      final canResponse = mfuController.mfuCanResponse.value;
      final canNumber = canResponse?.can ?? '';

      // 4. CHECK IF CAN NUMBER ACTUALLY CAME BACK
      if (canNumber.isNotEmpty) {
        final currentUser = session.getUserData;
        if (currentUser != null) {
          await session.updateUserData(
            currentUser.copyWith(canNumber: canNumber),
          );
        }

        log("[CAN] ✅ Registered — CAN: $canNumber");

        await fetchUserDetails();
        mfuController.resumePollingIfNeeded();
      } else {
        // 5. EXTRACT THE INNER MFU ERROR (e.g., "First Nominee ID is Invalid")
        final mfuErrorMsg =
            canResponse?.canRegistrationResponse?.respHeader?.errorMsg;
        String actualError = mfuErrorMsg != null && mfuErrorMsg.isNotEmpty
            ? mfuErrorMsg
            : mfuController.errorMessage.value;

        actualError = actualError
            .replaceAll('canRegister Failed with Exception:', '')
            .replaceAll('Fetch Error:', '')
            .replaceAll('Exception:', '')
            .trim(); //

        log("[CAN] ❌ Failed to generate CAN: $actualError");

        // 6. SHOW THE ERROR TO THE USER
        if (actualError.isNotEmpty) {
          CustomSnackbar.warning(
            title: 'Registration Issue',
            message: actualError,
          );
        }
      }
    } catch (e) {
      log("[CAN] ❌ Exception: $e");
    } finally {
      // 7. UNLOCK THE RUNNING GUARD
      _isRegisteringCan = false;
    }
  }

  // Future<void> fetchUserDetails() async {
  //   final userId = session.getUserData?.id;
  //   if (userId == null) return;

  //   log('bank user fetch ');

  //   isLinkedBankLoading.value = true;
  //   try {
  //     final data = {'id': userId};

  //     final result = await _useCases.updateProfileUsecases.call(data);

  //     result.fold(
  //       (success) {
  //         log('bank user fetch ${success.data?.data?.bankAccount} name ');

  //         if (success.data?.data?.bankAccount != null) {
  //           linkedBankAccount.value = success.data!.data?.bankAccount;

  //           log('bank user fetch ${linkedBankAccount.value} ');
  //         } else {
  //           linkedBankAccount.value = null;
  //         }
  //       },
  //       (error) {
  //         log("Error fetching linked bank: ${error.message}");
  //       },
  //     );
  //   } catch (e) {
  //     log("Fetch Linked Bank Exception: $e");
  //   } finally {
  //     isLinkedBankLoading.value = false;
  //   }
  // }

  // ------------------------ Add Bank Account ----------------------------------///
  Future<void> addBankAccount() async {
    if (bankAccountNumberController.text.isEmpty ||
        bankIfscController.text.isEmpty ||
        bankAccHdNameController.text.isEmpty ||
        bankNameController.text.isEmpty) {
      CustomSnackbar.warning(
        title: "Required",
        message: "Please fill all bank details",
      );
      return;
    }

    isBankAdding.value = true;

    try {
      final uid = session.getUserData?.id ?? 0;
      if (uid == 0) {
        Get.snackbar("Error", "User session not found.");
        isBankAdding.value = false;
        return;
      }

      log("Submitting Bank Data: $uid");

      // final result = await _useCases.updateProfileUsecases.call(data);
      final result = await _useCases.addBankUseCase.call(
        uid: uid,
        accountHolderName: bankAccHdNameController.text,
        accountNumber: bankAccountNumberController.text.trim(),
        ifscCode: bankIfscController.text.trim().toUpperCase(),
        micrCode: bankMicrController.text.trim(),
        accountType: bankAccountType.value,
        bankName: bankNameController.text.trim(),
      );

      await result.fold(
        (success) async {
          log("✅ Bank added successfully: ${success.data?.message}");
          await fetchUserDetails();
          clearBankFields();

          Get.back();
          isBankAdding.value = false;

          CustomSnackbar.success(
            title: "Success",
            message: "Bank account added successfully",
          );
        },
        (error) async {
          isBankAdding.value = false;
          Get.snackbar(
            "Error",
            error.message ?? "Failed to add bank account",
            backgroundColor: Colors.red.shade50,
            colorText: Colors.red.shade900,
          );
        },
      );
    } catch (e) {
      log("Bank Addition Error: $e");
      Get.snackbar("Error", "Something went wrong while adding bank");
      isBankAdding.value = false;
    }
    // finally {
    //   isBankAdding.value = false;
    // }
  }

  Future<void> deleteBank(int bankId) async {
    // 1. Set loading state for this specific bank ID
    isDeletingBank[bankId] = true;

    final uid = session.getUserData?.id ?? 0;

    // 2. Show loading overlay
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      final result = await _useCases.deleteBankUseCase(
        uid: uid,
        bankId: bankId,
      );

      result.fold(
        (success) {
          final data = success.data?.data;

          // 3. Update local state
          linkedBankAccounts.removeWhere((bank) => bank.id == bankId);
          hasBank.value = linkedBankAccounts.isNotEmpty;

          Get.back(); // Close loading dialog
          CustomSnackbar.success(
            title: "Success",
            message: success.data?.message ?? "Bank deleted successfully",
          );

          // 4. Refresh profile to ensure full data sync with server
          fetchUserDetails();

          if (data != null) {
            "[Bank] Remaining: ${data.count}/${data.maxAllowed} | Can add more: ${data.canAddMore}";
          }
        },
        (error) {
          Get.back(); // Close loading dialog
          CustomSnackbar.error(
            title: "Error", // Fixed title
            message: error.message ?? "Failed to delete bank",
          );
        },
      );
    } catch (e) {
      Get.back();
      log("Delete Bank Exception: $e");
    } finally {
      // 5. Clean up loading state
      isDeletingBank.remove(bankId);
    }
  }

  // Future<void> deleteBank(int bankId) async {
  //   isDeletingBank[bankId] = true;

  //   final uid = session.getUserData?.id ?? 0;
  //   Get.dialog(
  //     const Center(child: CircularProgressIndicator()),
  //     barrierDismissible: false,
  //   );

  //   final result = await _useCases.deleteBankUseCase(uid: uid, bankId: bankId);

  //   result.fold(
  //     (success) {
  //       final data = success.data?.data;
  //       linkedBankAccounts.removeWhere((bank) => bank.id == bankId);
  //       hasBank.value = linkedBankAccounts.isNotEmpty;
  //       Get.back(); // Close loading dialog
  //       CustomSnackbar.success(
  //         title: "Success",
  //         message: success.data?.message ?? "Bank deleted successfully",
  //       );

  //       // ✅ Refresh profile to update bank list
  //       fetchUserDetails();

  //       // ✅ Show remaining slots info
  //       if (data != null) {
  //         log(
  //           "[Bank] Remaining: ${data.count}/${data.maxAllowed} | Can add more: ${data.canAddMore}",
  //         );
  //       }
  //     },
  //     (error) {
  //       Get.back(); // Close loading dialog
  //       CustomSnackbar.error(
  //         title: "Success",
  //         message: error.message ?? "Failed to delete bank",
  //       );
  //     },
  //   );

  //   isDeletingBank[bankId] = false;
  // }

  Future<void> _fetchBankDetailsFromIFSC(String ifsc) async {
    try {
      isFetchingIFSC.value = true;
      resolvedBranch.value = '';

      // Using GetConnect (or you can use http/dio)
      final response = await GetConnect().get(
        'https://ifsc.razorpay.com/$ifsc',
      );

      if (response.statusCode == 200 && response.body != null) {
        // Auto-fill the Bank Name
        autoFetchedBank.value = response.body['BANK'];
        // bankNameController.text = response.body['BANK'];
        bankNameController.text = response.body['BANK'];
        bankMicrController.text = response.body['MICR'];

        // Show a helpful success message with the branch location
        resolvedBranch.value =
            "${response.body['BRANCH']}, ${response.body['STATE']}";
      } else {
        resolvedBranch.value = 'Invalid IFSC Code';
        bankNameController.clear();
        autoFetchedBank.value = '';
      }
    } catch (e) {
      resolvedBranch.value = 'Failed to fetch details. Enter manually.';
    } finally {
      isFetchingIFSC.value = false;
    }
  }

  // Pick Image Logic
  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: source,
      imageQuality: 50,
      maxHeight: 1024,
      maxWidth: 1024,
    );
    if (image != null) {
      imagePath.value = image.path;
      selectedImageFile = image;
    }
  }

  Future<void> updateProfile() async {
    isLoading.value = true;

    // Prepare Multipart Data
    final Map<String, dynamic> data = {
      'name': nameController.text,
      'email': emailController.text,
      'mobile': mobileController.text,
      'pan_card': panController.text,
      'dob': formatToSqlDate(dobController.text),
      'address': addressController.text,
      'adhar': adharController.text,
      'wealth_source': getWealthSourceId(wealthSource.text),
      'yearly_income': getIncomeSlabId(yearlyIncome.text),
      'occupation': getOccupationId(occupationTextEditingController.text),

      'id': session.getUserData?.id, // Matches your Postman test ID
    };

    // if (selectedImageFile != null) {
    //   if (kIsWeb) {
    //     final bytes = await selectedImageFile!.readAsBytes();
    //     data['image'] = dio.MultipartFile.fromBytes(
    //       bytes,
    //       filename: selectedImageFile!.name,
    //     );
    //   }
    // } else
    // if (imagePath.isNotEmpty) {
    //   // Use Dio's MultipartFile
    //   data['image'] = await dio.MultipartFile.fromFile(
    //     imagePath.value,
    //     filename: imagePath.value.split('/').last,
    //   );
    // }
    if (selectedImageFile != null) {
      if (kIsWeb) {
        final bytes = await selectedImageFile!.readAsBytes();
        data['image'] = dio.MultipartFile.fromBytes(
          bytes,
          filename: selectedImageFile!.name,
        );
      } else {
        data['image'] = await dio.MultipartFile.fromFile(
          selectedImageFile!.path,
          filename: selectedImageFile!.name,
        );
      }
    } else if (!kIsWeb &&
        imagePath.isNotEmpty &&
        !imagePath.value.startsWith('http')) {
      data['image'] = await dio.MultipartFile.fromFile(
        imagePath.value,
        filename: imagePath.value.split('/').last,
      );
    }

    final result = await _useCases.updateProfileUsecases.call(data);

    result.fold(
      (success) async {
        isLoading.value = false;

        if (success.data != null) {
          final currentLocalUser = session.getUserData;
          final apiData = success.data!; // ProfileDataEntity from API

          if (currentLocalUser != null) {
            // Merge the new data (especially the new image path)
            final updatedUser = currentLocalUser.copyWith(
              name: apiData.data?.name,
              email: apiData.data?.email,
              image: apiData.data?.image,
              panCard: apiData.data?.panCard,
              kycStatus: apiData.data?.kycStatus,

              // ... map other fields
            );

            // Update session and storage
            await session.updateUserData(updatedUser);
          }

          imagePath.value = '';
          selectedImageFile = null;
          // Get.snackbar("Success", "Profile Updated");
          Get.back();
          ULoaders.success(title: 'Success', message: 'Profile Updated');
          // fetchUserDetails();

          Get.back();
        }

        // Get.snackbar("Success", success.data?.message ?? "Profile Updated");

        ULoaders.success(title: 'Success', message: 'Profile Updated');

        // Update local user state if needed
      },
      (error) {
        isLoading.value = false;
        Get.snackbar("Error", error.message);
      },
    );
  }

  Future<void> submitAdditionalInfo() async {
    if (!personalDetailsFormKey.currentState!.validate()) {
      ULoaders.warning(title: 'Please fill in all required fields');
      return;
    }

    try {
      ULoaders.showLoading(message: "Saving Data...");

      final Map<String, dynamic> data = {
        'id': SessionManager.instance.getUserData?.id,
        'adhar': adharController.text,
        'dob': dobController.text,
        'father_name': fatherNameTextEditingController.text,
        'mother_name': motherNameTextEditingController.text,

        // 'occupation': selectedOccupation.value == "Other"
        //     ? occupationOtherTextEditingController.text
        //     : selectedOccupation.value,

        // 'wealth_source': wealthSource.text,
        // 'yearly_income': getYearlyIncomeAsInt(yearlyIncome.text),
        'wealth_source': getWealthSourceId(wealthSource.text),
        'yearly_income': getIncomeSlabId(yearlyIncome.text),

        'occupation': getOccupationId(occupationTextEditingController.text),
        'pin_code': pinCodeTextEditingController.text,
        "city": cityTextEditingController.text,

        "state": stateTextEditingController.text,
      };

      final result = await _useCases.updateProfileUsecases.call(data);
      fetchUserDetails();

      result.fold(
        (success) {
          ULoaders.stopLoading(); // Hide loader

          hasPersonalDetails.value = true;

          ULoaders.success(
            title: "Profile Updated!",
            message: "Your details have been saved securely.",
          );

          Get.offAllNamed(AppRoutes.navMenuBar);
        },
        (error) {
          ULoaders.stopLoading();
          ULoaders.error(title: "Update Failed", message: error.message);
        },
      );
    } catch (e) {
      ULoaders.stopLoading();
      ULoaders.error(
        title: "Error",
        message: "Something went wrong. Please try again.",
      );
    }
  }

  // ------------------------ Update Profile End ---------------------------------------///

  /// ------------- edit pan status --- ////////

  void _checkPanEditPermission() {
    final status = session.getUserData?.kycStatus?.toLowerCase();
    final isVerified = session.isKycVerified.value;
    final isPending = session.isKycPending.value;

    if (status == 'approved' ||
        isVerified ||
        isKycVerified.value ||
        isPending ||
        status == 'pending') {
      //   || status == 'timed out'    add for testing
      canEditPan.value = false;
      debugPrint("🔒 PAN STATUS: LOCKED (canEditPan is ${canEditPan.value})");
    }
    // else if (status == 'not started' || status == null || status.isEmpty) {
    //   canEditPan.value = true;
    // }
    else {
      canEditPan.value = true;
      print("🔓 PAN STATUS: UNLOCKED (canEditPan is ${canEditPan.value})");
    }
  }

  /// ------------- edit pan status --- ////////

  double get currentTotalAllocation {
    if (nomineeList.value == null || nomineeList.value!.nominees.isEmpty) {
      return 0.0;
    }
    // Sum up all existing nominees' allocation
    return nomineeList.value!.nominees.fold(
      0.0,
      (sum, item) => sum + item.allocationPercent,
    );
  }

  double get remainingAllocation => 100.0 - currentTotalAllocation;

  void _onPanTextChanged() {
    final text = panController.text;

    // Determine the target keyboard type
    TextInputType targetType = TextInputType.text;
    if (text.length >= 5 && text.length < 9) {
      targetType = TextInputType.number;
    }

    // If the keyboard type needs to change...
    if (panKeyboardType.value != targetType) {
      panKeyboardType.value = targetType; // This triggers the UI Obx to rebuild

      // Force the keyboard to reload safely
      _reloadKeyboard();
    }
  }

  void _reloadKeyboard() {
    if (panFocusNode.hasFocus) {
      // 1. Drop focus to hide the current keyboard
      panFocusNode.unfocus();

      // 2. Wait for the UI to FINISH rebuilding with the new keyboard type
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // 3. Add a tiny delay to let the OS register the keyboard close event
        Future.delayed(const Duration(milliseconds: 100), () {
          // Request focus back
          panFocusNode.requestFocus();

          // Ensure the cursor stays at the end of the text
          panController.selection = TextSelection.fromPosition(
            TextPosition(offset: panController.text.length),
          );
        });
      });
    }
  }

  // --- Logic Methods ---

  Future<void> loadRiskQuestions() async {
    isLoading(true);
    final result = await _useCases.getRiskquestionUseCases.call({});

    result.fold(
      (entity) => riskQuestions.assignAll(entity.data!.data),

      (failure) => Get.snackbar("Error", "Failed to load assessment"),
    );
    isLoading(false);
  }

  void selectOption(int questionId, int optionId) {
    selectedAnswers[questionId] = optionId;

    // Auto-advance to next page after a short delay for better UX
    Future.delayed(const Duration(milliseconds: 300), () {
      nextPage();
    });
  }

  void nextPage() {
    if (currentQuestionIndex.value < riskQuestions.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _startAnalysis();
    }
  }

  void previousPage() {
    if (currentQuestionIndex.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      Get.back();
    }
  }

  void onPageChanged(int index) {
    currentQuestionIndex.value = index;
  }

  void showLoading() {
    Get.dialog(
      const Center(child: CircularProgressIndicator(color: Ucolors.primary)),
      barrierDismissible: false,
    );
  }

  // --- Analysis Logic ---

  void _startAnalysis() async {
    isAnalyzing(true);

    // Simulate a professional analysis sequence
    List<String> statuses = [
      "Calculating risk tolerance...",
      "Evaluating financial stability...",
      "Optimizing asset allocation...",
      "Finalizing your profile...",
    ];

    for (var text in statuses) {
      analysisText.value = text;
      await Future.delayed(const Duration(seconds: 1));
    }

    // Navigate to results (Total score logic can be added here)
    // Get.offNamed('/risk-result');
    log(selectedAnswers.toString());
    await submitAssessment();
    Get.back();
    isAnalyzing.value = false;
    currentQuestionIndex.value = 0;
    // selectedAnswers.clear();
  }

  Future<void> submitAssessment() async {
    isAnalyzing(true);

    // Convert Map<int, int> selectedAnswers to List<Map<String, int>>
    final answersList = selectedAnswers.entries
        .map((e) => {"question_id": e.key, "option_id": e.value})
        .toList();

    final request = RiskSubmitRequest(
      userId: SessionManager.instance.getUserData?.id ?? 0,
      // Replace with your actual logged-in user ID
      answers: answersList,
    ).toJson();

    // Call your submit usecase
    final result = await _useCases.riskSubmitUsecases.call(request);
    fetchUserDetails();

    result.fold(
      (entity) async {
        final data = await SessionManager.instance.saveRiskScore(entity.data);
        if (data == true) {
          riskResult.value = entity.data;
        }
        // Small delay to let the 'Analyzing' animation finish naturally
      },
      (failure) {
        isAnalyzing(false);
        Get.snackbar("Error", "Submission failed. Please try again.");
      },
    );
  }

  // Get Nominee

  Future<void> getNominee() async {
    isNomineeLoading.value = true;
    try {
      final userId = session.getUserData?.id;

      if (userId == null) {
        Get.snackbar("Error", "User session invalid");
        isNomineeLoading.value = false;
        return;
      }

      final requestData = {"customer_id": userId};

      // Call the UseCase
      final result = await _useCases.getNomineeUseCase.call(requestData);

      result.fold(
        (success) {
          // Success: Update the observable with the Entity
          nomineeList.value = success.data;
        },
        (failure) {
          // Failure: Show error
          nomineeList.value = null;
          Get.snackbar("Error Fetching Nominees", failure.message);
        },
      );
    } catch (e) {
      log("Nominee Error: $e");
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isNomineeLoading.value = false;
    }
  }

  // Add Nominee

  Future<void> addNominee() async {
    if (nomineeFormKey.currentState?.validate() != true) {
      CustomSnackbar.warning(
        title: "Required",
        message: "Please fill all the fields",
      );
      return;
    }

    // Additional validation for Guardian
    if (isNomineeMinor.value &&
        nomineeMinorsGuardianTextEditingController.text.isEmpty) {
      CustomSnackbar.warning(
        title: "Required",
        message: "Guardian Name is required for minors",
      );
      return;
    }

    addNomineeLoading.value = true;
    try {
      final userId = session.getUserData?.id;
      if (userId == null) {
        Get.snackbar("Error", "User session invalid");
        return;
      }

      final requestData = {
        "customer_id": userId,
        "name": nomineeNameTextEditingController.text,
        "relation": nomineeRelationTextEditingController.text,
        "dob": nomineeDobTextEditingController.text,
        "allocation_percent":
            nomineeAllocationPercentTextEditingController.text,
        // Send 1 if minor, 0 if not
        "is_minor": isNomineeMinor.value ? 1 : 0,
        "guardian_name": nomineeMinorsGuardianTextEditingController.text,
        "email": nomineeEmailTextEditingController.text,
        "phone_number": nomineePhoneTextEditingController.text,
        "document_type": nomineeDocumentTypeTextEditingController.text,
        "document_number": nomineeDocumentNumberTextEditingController.text,
        "address": nomineeAddressTextEditingController.text,
        "pin_code": nomineePincodeTextEditingController.text,
        "city": nomineeCityTextEditingController.text,
      };

      final result = await _useCases.addNomineeUseCase.call(requestData);
      fetchUserDetails();

      Get.back();

      result.fold(
        (success) {
          getNominee();
          _clearNomineeFields();

          // Get.snackbar("Success", "Nominee added successfully");
          CustomSnackbar.success(
            title: 'Success',
            message: 'Nominee added successfully',
          );

          Get.back();
        },
        (failure) {
          Get.snackbar("Error Adding Nominee", failure.message);
        },
      );
    } catch (e) {
      log("Nominee Error: $e");
      Get.snackbar("Error", "Something went wrong");
    } finally {
      addNomineeLoading.value = false;
    }
  }

  // Delete Nominee

  Future<void> deleteNominee(NomineeEntity nominee) async {
    // 1. Set loading for this specific ID
    isDeleteLoading[nominee.id] = true;

    try {
      final requestData = {'id': nominee.id};

      final result = await _useCases.deleteNomineeUseCase.call(requestData);
      fetchUserDetails();

      result.fold(
        (success) {
          // 2. Refresh list on success
          getNominee();
          // Get.snackbar("Success", "Nominee deleted successfully");
          CustomSnackbar.error(
            title: 'Success',
            message: 'Nominee deleted successfully',
          );
        },
        (failure) {
          Get.snackbar("Error Deleting Nominee", failure.message);
        },
      );
    } catch (e) {
      log("Nominee Error: $e");
      Get.snackbar("Error", "Something went wrong");
    } finally {
      // 3. Clear loading state
      isDeleteLoading[nominee.id] = false;
    }
  }

  // Call this right after you successfully fetch the profile data from your API
  void loadDataIntoProfileScreen(
    profileEntity.ProfileDataEntity userProfileData,
  ) {
    // 1. Basic User Info (Usually comes from the main user object)
    // Assuming userProfileData has fields like name, email, phone, pan
    nameController.text = userProfileData.name ?? '';
    emailController.text = userProfileData.email ?? '';
    mobileController.text = userProfileData.mobile ?? '';
    panController.text =
        userProfileData.panCard ?? ''; // Or wherever PAN is stored

    // 2. Customer Details (The new data we just added)
    final details = userProfileData
        .customerDetails; // Adjust this to match your actual model

    if (details != null) {
      // Use the Date reverser we created earlier to format YYYY-MM-DD to DD/MM/YYYY
      dobController.text = formatToUIDate(details.dob);

      // Inject into the specific controllers used in _buildMobileLayout
      // wealthSource.text = details.wealthSource ?? '';
      wealthSource.text = getWealthSourceName(
        int.tryParse(details.wealthSource ?? ''),
      );
      log(
        "${details.wealthSource}   --------------------- Wealth Source ${wealthSource.text}",
      );
      // yearlyIncome.text = details.yearlyIncome?.toString() ?? '';
      yearlyIncome.text = getIncomeSlabName(
        int.tryParse(details.yearlyIncome ?? ''),
      );
      occupationTextEditingController.text = getOccupationName(
        int.tryParse(details.occupation ?? ''),
      );
      addressController.text = details.address ?? '';

      // The UI hint says "City, State, Pincode", so we format it if it's split in the backend
      String fullAddress = details.address ?? '';
      // if (details.city != null && details.city!.isNotEmpty) {
      //   fullAddress += ', ${details.city}';
      // }
      // if (details.state != null && details.state!.isNotEmpty) {
      //   fullAddress += ', ${details.state}';
      // }
      // if (details.pincode != null && details.pincode!.isNotEmpty) {
      //   fullAddress += ' - ${details.pincode}';
      // }

      // Clean up leading commas if address was initially null
      // if (fullAddress.startsWith(', ')) fullAddress = fullAddress.substring(2);

      addressController.text = fullAddress;
    }
  }

  void _clearNomineeFields() {
    nomineeNameTextEditingController.clear();
    nomineeDobTextEditingController.clear();
    nomineeEmailTextEditingController.clear();
    nomineePhoneTextEditingController.clear();
    nomineeDocumentTypeTextEditingController.clear();
    nomineeDocumentNumberTextEditingController.clear();
    nomineeRelationTextEditingController.clear();
    nomineeAllocationPercentTextEditingController.clear();
    nomineeMinorsGuardianTextEditingController.clear();
    nomineeAddressTextEditingController.clear();
    nomineeMinorsGuardianTextEditingController.clear();
    nomineeCityTextEditingController.clear();
    nomineePincodeTextEditingController.clear();
    isNomineeMinor.value = false;
  }

  void updateMinorStatus(DateTime dob) {
    final now = DateTime.now();
    int age = now.year - dob.year;

    // Adjust age if birthday hasn't happened yet this year
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }

    isNomineeMinor.value = age < 18;

    // Clear guardian field if not minor
    if (!isNomineeMinor.value) {
      nomineeMinorsGuardianTextEditingController.clear();
    }
  }

  int? getWealthSourceId(String? name) {
    if (name == null || name.isEmpty) return null;
    int index = wealthSourceList.indexOf(name);
    return index != -1 ? index + 1 : null;
  }

  int? getIncomeSlabId(String? name) {
    if (name == null || name.isEmpty) return null;
    int index = incomeSlabList.indexOf(name);
    return index != -1 ? index + 1 : null;
  }

  int? getOccupationId(String? name) {
    if (name == null || name.isEmpty) return null;
    int index = occupationList.indexOf(name);
    return index != -1 ? index + 1 : null;
  }

  String getWealthSourceName(int? id) {
    if (id == null || id <= 0 || id > wealthSourceList.length) return '';
    return wealthSourceList[id - 1];
  }

  String getIncomeSlabName(int? id) {
    if (id == null || id <= 0 || id > incomeSlabList.length) return '';
    return incomeSlabList[id - 1];
  }

  String getOccupationName(int? id) {
    if (id == null || id <= 0 || id > occupationList.length) return '';
    return occupationList[id - 1];
  }

  /////////   capital gain Statement    ------        DownLoad Statement                   //////////////

  final isCapitalGain = false.obs;
  final isRequestingAccountStatement = false.obs;

  // Statement type: 0 = PAN, 1 = Folio
  final statementTypeIndex = 0.obs;

  final startDate = Rx<DateTime?>(null);
  final endDate = Rx<DateTime?>(null);

  // PAN input
  final panControllerDownload = TextEditingController(text: 'ABCDE1234F');

  // Folio / scheme selections (mock values)
  final selectedFolio = 'CGFOLIO13001'.obs;
  final selectedScheme = 'Growth Fund - Direct'.obs;

  // Duration: 0=Current FY, 1=Previous FY, 2=Full Statement, 3=Custom
  final selectedDuration = 0.obs;

  final List<String> durations = [
    'Current FY',
    'Previous FY',
    'Full Statement',
    'Custom',
  ];

  void selectStatementType(int index) => statementTypeIndex.value = index;
  // void selectDuration(int index) => selectedDuration.value = index;
  void selectDuration(int index) {
    selectedDuration.value = index;
    // Optional: Clear dates if they switch away from custom
    if (index != 3) {
      startDate.value = null;
      endDate.value = null;
    }
  }

  void setStatementMode({required bool isCapital}) {
    debugPrint("isCapital :$isCapital");

    isCapitalGain.value = isCapital;
    debugPrint("isCapitalGain.value :${isCapitalGain.value}");

    // Optional: Reset other variables to default when opening the screen
    isCapital ? statementTypeIndex.value = 1 : statementTypeIndex.value = 0;
    // panController.text = 'ABCDE1234F';
  }

  // void onDownload() {
  //   if (selectedDuration.value == 3 &&
  //       (startDate.value == null || endDate.value == null)) {
  //     CustomSnackbar.warning(
  //       title: 'Missing Info',
  //       message: 'Please select both start and end dates',
  //     );
  //     return;
  //   }
  //   CustomSnackbar.success(title: 'Download', message: 'Generating statement…');
  // }
  void onDownload() {
    // Validation for custom dates
    if (selectedDuration.value == 3 &&
        (startDate.value == null || endDate.value == null)) {
      Get.snackbar('Missing Info', 'Please select both start and end dates');
      return;
    }

    final dates = _getStartAndEndDates();

    if (isCapitalGain.value) {
      requestCapitalGainStatement(
        type: "download",
        email: null,
        folioNo: selectedFolio.value, // passing the dynamically selected folio
        startDate: dates['start']!,
        endDate: dates['end']!,
      );
    } else {
      // Handle normal account statement download here
      requestAccountStatement(
        type: "download", // Change to "email" if user selects email
        email: null, // Pass user's email if type == "email"
        // folioNo: "CGFOLIO13001",
        // startDate: "2020-01-01",
        // endDate: "2030-01-01",
        folioNo: selectedFolio.value, // passing the dynamically selected folio
        startDate: dates['start']!,
        endDate: dates['end']!,
      );
    }
  }

  // void onEmail() {
  //   if (selectedDuration.value == 3 &&
  //       (startDate.value == null || endDate.value == null)) {
  //     CustomSnackbar.warning(
  //       title: 'Missing Info',
  //       message: 'Please select both start and end dates',
  //     );
  //     return;
  //   }
  //   CustomSnackbar.show(
  //     title: 'Email',
  //     message: 'Statement sent to ****@gmail.com',
  //   );
  // }
  void onEmail() {
    if (selectedDuration.value == 3 &&
        (startDate.value == null || endDate.value == null)) {
      Get.snackbar('Missing Info', 'Please select both start and end dates');
      return;
    }

    final dates = _getStartAndEndDates();

    if (isCapitalGain.value) {
      requestCapitalGainStatement(
        type: "email",
        email: userData
            .value
            ?.email, // Replace with user's actual registered email
        folioNo: selectedFolio.value,
        startDate: dates['start']!,
        endDate: dates['end']!,
      );
    } else {
      // Handle normal account statement email here
      requestAccountStatement(
        type: "email", // Change to "email" if user selects email
        email: userData.value?.email, // Pass user's email if type == "email"
        // folioNo: "CGFOLIO13001",
        // startDate: "2020-01-01",
        // endDate: "2030-01-01",
        folioNo: selectedFolio.value,
        startDate: dates['start']!,
        endDate: dates['end']!,
      );
    }
  }

  // Date Picker Logic
  Future<void> pickDate(BuildContext context, bool isStart) async {
    final initialDate = isStart
        ? (startDate.value ?? DateTime.now())
        : (endDate.value ?? DateTime.now());

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Ucolors.primary3,
              onPrimary: Ucolors.onPrimary,
              onSurface: Ucolors.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      if (isStart) {
        startDate.value = pickedDate;
        // Auto-clear end date if it's before the new start date
        if (endDate.value != null && endDate.value!.isBefore(pickedDate)) {
          endDate.value = null;
        }
      } else {
        // Prevent end date from being before start date
        if (startDate.value != null && pickedDate.isBefore(startDate.value!)) {
          CustomSnackbar.error(
            title: 'Invalid Date',
            message: 'End date cannot be before start date',
          );
          return;
        }
        endDate.value = pickedDate;
      }
    }
  }

  // Helper to show date in UI
  String formatDate(DateTime? date) {
    if (date == null) return 'DD/MM/YYYY';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  ////////////    --------------           ////////////
  final isRequestingStatement = false.obs;

  // Calculate dates based on the selected duration (Current FY, Prev FY, etc.)
  String _formatForApi(DateTime? date) {
    if (date == null) return "";
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Map<String, String> _getStartAndEndDates() {
    DateTime now = DateTime.now();
    DateTime start;
    DateTime end;

    if (selectedDuration.value == 3) {
      // Custom Dates
      return {
        "start": _formatForApi(startDate.value),
        "end": _formatForApi(endDate.value),
      };
    } else if (selectedDuration.value == 0) {
      // Current FY (April 1st to Today)
      int startYear = now.month >= 4 ? now.year : now.year - 1;
      start = DateTime(startYear, 4, 1);
      end = now;
    } else if (selectedDuration.value == 1) {
      // Previous FY
      int startYear = now.month >= 4 ? now.year - 1 : now.year - 2;
      start = DateTime(startYear, 4, 1);
      end = DateTime(startYear + 1, 3, 31);
    } else {
      // Full Statement (Fallback to a default old date)
      start = DateTime(2000, 1, 1);
      end = now;
    }

    return {"start": _formatForApi(start), "end": _formatForApi(end)};
  }

  // ── IN-APP DOWNLOAD TO PUBLIC FOLDER ──────────────────────
  Future<void> _downloadAndSavePdf(String url, String folio) async {
    try {
      CustomSnackbar.info(
        title: 'Downloading',
        message: 'Please wait while your statement downloads...',
      );

      // 1. Determine the correct public directory based on the OS
      Directory? directory;
      if (Platform.isAndroid) {
        // Target the public Downloads folder on Android
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          // Fallback if standard Downloads folder doesn't exist
          directory = (await getExternalStorageDirectory());
        }
      } else if (Platform.isIOS) {
        // Target the Documents folder on iOS (needs Info.plist update below)
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) {
        CustomSnackbar.error(
          title: 'Error',
          message: 'Could not access device storage.',
        );
        return;
      }

      // 2. Create a unique filename and path
      final String fileName = isCapitalGain.value
          ? "CapitalGain_${folio}_${DateTime.now().millisecondsSinceEpoch}.pdf"
          : "AccountStatement_${folio}_${DateTime.now().millisecondsSinceEpoch}.pdf";

      final String savePath = '${directory.path}/$fileName';

      // 3. Download the file using Dio
      final dio = Dio();
      await dio.download(url, savePath);

      log("[MfuController] File saved successfully to: $savePath");

      // 4. Open the file natively on the device
      final result = await OpenFilex.open(savePath);

      if (result.type != ResultType.done) {
        CustomSnackbar.success(
          title: 'Saved to Downloads',
          message: 'File downloaded successfully to your Downloads folder.',
        );
      }
    } catch (e) {
      log("[MfuController] Download error: $e");
      CustomSnackbar.error(
        title: 'Error',
        message: 'Failed to download the PDF file.',
      );
    }
  }

  // Future<void> _downloadAndSavePdf(String url, String folio) async {
  //   try {
  //     // 1. Get the app's local document directory
  //     final Directory dir = await getApplicationDocumentsDirectory();

  //     // 2. Create a unique filename
  //     final String fileName =
  //         "CapitalGain_${folio}_${DateTime.now().millisecondsSinceEpoch}.pdf";
  //     final String savePath = '${dir.path}/$fileName';

  //     // 3. Download the file using Dio
  //     Get.snackbar(
  //       'Downloading',
  //       'Please wait while your statement downloads...',
  //       snackPosition: SnackPosition.BOTTOM,
  //     );

  //     final dio = Dio();
  //     await dio.download(
  //       url,
  //       savePath,
  //       onReceiveProgress: (received, total) {
  //         if (total != -1) {
  //           // Optional: You could track download progress here
  //           final progress = (received / total * 100).toStringAsFixed(0);
  //           log("Downloading: $progress%");
  //         }
  //       },
  //     );

  //     log("[MfuController] File saved to: $savePath");

  //     // 4. Open the file natively on the device
  //     final result = await OpenFilex.open(savePath);

  //     if (result.type != ResultType.done) {
  //       Get.snackbar(
  //         'Notice',
  //         'File downloaded, but could not find a PDF viewer to open it.',
  //       );
  //     }
  //   } catch (e) {
  //     log("[MfuController] Download error: $e");
  //     Get.snackbar(
  //       'Error',
  //       'Failed to download the PDF file.',
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //   }
  // }

  Future<void> requestCapitalGainStatement({
    required String type, // "email" or "download"
    String? email,
    required String folioNo,
    required String startDate,
    required String endDate,
  }) async {
    isRequestingStatement.value = true;

    final uid = session.getUserData?.id ?? 0;

    ULoaders.showLoading(message: "Processing Capital Gain Statement...");

    // Make the API call
    final result = await _useCases.requestCapitalGainStatementUseCase(
      uid: 13001, // for testing
      // uid: uid,
      type: type,
      email: email,
      folioNo: folioNo,
      startDate: startDate,
      endDate: endDate,
    );

    result.fold(
      (success) async {
        // Marked async to await the url launch
        final data = success.data;

        if (data != null) {
          if (data.isDownload && data.downloadUrl.isNotEmpty) {
            ULoaders.stopLoading();
            log("[MfuController] Download link ready: ${data.downloadUrl}");
            await _downloadAndSavePdf(data.downloadUrl, folioNo);
          } else if (data.isEmail) {
            ULoaders.stopLoading();
            log("[MfuController] Email sent to: ${data.emailTo}");
            CustomSnackbar.success(
              title: 'Success',
              message:
                  'Statement sent to ${data.emailTo} successfully.' ??
                  data.message,
            );
          }
        } else {
          ULoaders.stopLoading();
        }
      },
      (error) {
        ULoaders.stopLoading();
        CustomSnackbar.error(title: 'Error', message: error.message);
      },
    );

    isRequestingStatement.value = false;
  }

  Future<void> requestAccountStatement({
    required String type, // "email" or "download"
    String? email,
    required String folioNo,
    required String startDate,
    required String endDate,
  }) async {
    isRequestingAccountStatement.value = true;

    ULoaders.showLoading(message: "Processing Account Statement...");

    final uid = session.getUserData?.id ?? 0;

    final result = await useCases.requestAccountStatementUseCase(
      uid: 13001, // for testing
      // uid: uid,
      type: type,
      email: email,
      folioNo: folioNo,
      startDate: startDate,
      endDate: endDate,
    );

    result.fold(
      (success) async {
        final data = success.data;

        if (data != null) {
          if (data.isDownload && data.downloadUrl.isNotEmpty) {
            ULoaders.stopLoading();
            log("[MfuController] Download link ready: ${data.downloadUrl}");
            await _downloadAndSavePdf(data.downloadUrl, folioNo);
          } else if (data.isEmail) {
            ULoaders.stopLoading();
            log("[MfuController] Email sent to: ${data.emailTo}");
            CustomSnackbar.success(
              title: 'Success',
              message:
                  'Statement sent to ${data.emailTo} successfully.' ??
                  data.message,
            );
          }
        } else {
          ULoaders.stopLoading();
        }
      },
      (error) {
        ULoaders.stopLoading();
        Get.snackbar('Error', error.message);
      },
    );

    isRequestingAccountStatement.value = false;
  }

  // On close

  @override
  void onClose() {
    panController.removeListener(_onPanTextChanged);
    panFocusNode.dispose();
    pageController.dispose();
    super.onClose();
  }
}
