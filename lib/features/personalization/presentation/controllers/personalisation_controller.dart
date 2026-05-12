import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:image_picker/image_picker.dart';
import 'package:my_sip/common/widget/animated/popups.dart';
import 'package:my_sip/config/routes/app_routes.dart';
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

// class PersonalisationController extends GetxController {
//   final PersonalisationUseCases _useCases;

//   @override
//   void onInit() {
//     super.onInit();
//     // Fetch data once when the controller is initialized
//     loadRiskQuestions();
//   }

//   // API Risk Question ------ //

//   // --- Reactive State ---
//   final isLoading = false.obs;
//   final questions = <QuestionEnitity>[].obs;
//   final selectedAnswersApi = <int, OptionsEntity>{}.obs;

//   Future<void> loadRiskQuestions() async {
//     // Prevent multiple API calls if data exists
//     if (questions.isNotEmpty) return;

//     isLoading(true);

//     // Using the specific usecase from your wrapper
//     final result = await _useCases.getRiskquestionUseCases.call({});

//     result.fold(
//       (entity) {
//         questions.assignAll(entity.data!.data);
//         isLoading(false);
//         log('risk questions ----- $questions');
//       },
//       (failure) {
//         isLoading(false);
//         Get.snackbar("Error", "Could not load questions");
//       },
//     );
//   }

//   // Track user choices
//   void selectOptionApi(int questionId, OptionsEntity option) {
//     selectedAnswersApi[questionId] = option;
//   }

//   // UI State
//   final PageController pageController = PageController();

//   // Observables for Progress & Selection
//   var currentQuestionIndex = 0.obs;
//   var selectedAnswers = <int, String>{}.obs;

//   // Observables for Analysis Screen
//   var isAnalyzing = false.obs;
//   var analysisText = "Initializing analysis...".obs;

//   final List<RiskQuestion> riskQuestions = [
//     RiskQuestion(
//       id: 1,
//       question:
//           "Your Income (Only from Salary, Profession or business and not from investments) is :",
//       options: [
//         RiskOption(id: 'a', text: "Much more than household expense."),
//         RiskOption(id: 'b', text: "Almost equal to household expenses."),
//         RiskOption(
//           id: 'c',
//           text:
//               "Less than household expenses that you have to borrow or depend on your investments.",
//         ),
//         RiskOption(
//           id: 'd',
//           text:
//               "There is no income in form of salary or professional income and you are entirely dependent on income from investments.",
//         ),
//       ],
//     ),
//     RiskQuestion(
//       id: 2,
//       question: "How much debt outstanding you have as % of total investments?",
//       options: [
//         RiskOption(id: 'a', text: "More than 75%."),
//         RiskOption(id: 'b', text: "Between 50% and 75%."),
//         RiskOption(id: 'c', text: "Between 25% and 50%."),
//         RiskOption(id: 'd', text: "Less than 25%."),
//       ],
//     ),
//     RiskQuestion(
//       id: 3,
//       question:
//           "Number of people (other than yourself) dependent on your income?",
//       options: [
//         RiskOption(id: 'a', text: "None"),
//         RiskOption(id: 'b', text: "1 or 2"),
//         RiskOption(id: 'c', text: "3 to 5"),
//         RiskOption(id: 'd', text: "More than 5."),
//       ],
//     ),
//     RiskQuestion(
//       id: 4,
//       question:
//           "Approximately when would you need the money being invested right now?",
//       options: [
//         RiskOption(id: 'a', text: "Within 3 years."),
//         RiskOption(id: 'b', text: "Between 3 and 5 years."),
//         RiskOption(id: 'c', text: "In 5 to 10 years."),
//         RiskOption(id: 'd', text: "More than 10 years."),
//       ],
//     ),
//     RiskQuestion(
//       id: 5,
//       question: "What has been your experience with investments?",
//       options: [
//         RiskOption(
//           id: 'a',
//           text:
//               "I have been very comfortable with my investments and I know all that I need to know.",
//         ),
//         RiskOption(
//           id: 'b',
//           text:
//               "I have been investing for a long time but I do not understand much.",
//         ),
//         RiskOption(
//           id: 'c',
//           text: "I only rely on my advisor and do not ask any questions.",
//         ),
//         RiskOption(
//           id: 'd',
//           text:
//               "I only invest in bank deposits and Govt. guaranteed investment schemes.",
//         ),
//       ],
//     ),
//     RiskQuestion(
//       id: 6,
//       question: "What is your view regarding the stability of your income?",
//       options: [
//         RiskOption(id: 'a', text: "Very Stable"),
//         RiskOption(id: 'b', text: "Not so Stable"),
//         RiskOption(id: 'c', text: "Uncertain"),
//         RiskOption(id: 'd', text: "I do not have any professional income."),
//       ],
//     ),
//     RiskQuestion(
//       id: 7,
//       question: "You have three investment options to choose from:",
//       options: [
//         RiskOption(
//           id: 'a',
//           text:
//               "Where the value of your investment may go up and down significantly on a monthly basis. However, there is a possibility to be able to improve your living standard.",
//         ),
//         RiskOption(
//           id: 'b',
//           text:
//               "The value of investment may go up and down but not as much as option A. You may barely be able to maintain your lifestyle with such an investment approach",
//         ),
//         RiskOption(
//           id: 'c',
//           text:
//               "The value of your portfolio will see a slow and steady increase, but your ability to maintain your living standards will be seriously hampered",
//         ),
//       ],
//     ),
//   ];

//   PersonalisationController(this._useCases);

//   @override
//   void onClose() {
//     pageController.dispose();
//     super.onClose();
//   }

//   void selectOption(int questionId, String optionId) {
//     selectedAnswers[questionId] = optionId;

//     Future.delayed(const Duration(milliseconds: 300), () {
//       nextPage();
//     });
//   }

//   void nextPage() {
//     if (currentQuestionIndex.value < riskQuestions.length - 1) {
//       pageController.nextPage(
//         duration: const Duration(milliseconds: 500),
//         curve: Curves.easeInOutCubic,
//       );
//     } else {
//       startRiskAnalysis();
//     }
//   }

//   void previousPage() {
//     if (currentQuestionIndex.value > 0) {
//       pageController.previousPage(
//         duration: const Duration(milliseconds: 400),
//         curve: Curves.easeInOut,
//       );
//     } else {
//       Get.back();
//     }
//   }

//   void onPageChanged(int index) {
//     currentQuestionIndex.value = index;
//   }

//   void startRiskAnalysis() async {
//     isAnalyzing.value = true;

//     analysisText.value = "Securing your responses...";
//     await Future.delayed(const Duration(milliseconds: 1500));

//     analysisText.value = "Analyzing financial patterns...";
//     await Future.delayed(const Duration(milliseconds: 1500));

//     analysisText.value = "Calculating risk appetite...";
//     await Future.delayed(const Duration(milliseconds: 1500));

//     analysisText.value = "Finalizing your profile...";
//     await Future.delayed(const Duration(milliseconds: 1000));

//     isAnalyzing.value = false;
//     submitRiskProfile();
//   }

//   void submitRiskProfile() {
//     Get.back();
//     Get.snackbar(
//       "Assessment Complete",
//       "Your risk profile has been generated successfully.",
//       backgroundColor: Colors.green.shade50,
//       colorText: Colors.green.shade800,
//       icon: Icon(Icons.check_circle, color: Colors.green.shade800),
//     );
//   }
// }
import 'package:my_sip/features/personalization/domain/entity/profile_update_entity.dart'
    as profileEntity;

class PersonalisationController extends GetxController {
  final PersonalisationUseCases _useCases;
  PersonalisationController(this._useCases);

  PersonalisationUseCases get useCases => _useCases;

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
  final linkedBankAccount = Rxn<dynamic>();

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

  void clearBankFields() {
    bankNameController.clear();
    bankAccountNumberController.clear();
    bankIfscController.clear();
    bankMicrController.clear();
    bankAccountType.value = 'SB';
    autoFetchedBank.value = '';
    resolvedBranch.value = '';
    isFetchingIFSC.value = false;
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
            linkedBankAccount.value = profileData.bankAccount;
            hasBank.value = profileData.bankAccount != null;

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

            _checkAndTriggerCanRegistration();
            final mfuController = Get.find<MfuController>();
            mfuController.resumePollingIfNeeded();
          } else {
            linkedBankAccount.value = null;
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
  void _checkAndTriggerCanRegistration() {
    // ✅ CAN already exists on server → skip forever
    final existingCan = session.getUserData?.canNumber ?? '';
    if (existingCan.isNotEmpty) {
      log("[CAN] Already exists ($existingCan) — skipping registration");
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
      final missing = [
        if (!kycDone) 'KYC',
        if (!bankDone) 'Bank',
        if (!personalDetailsDone) 'Personal Details',
      ].join(', ');
      log("[CAN] ⏳ Skipped — missing: $missing");
    }
  }

  Future<void> _triggerCanRegistration() async {
    try {
      final mfuController = Get.find<MfuController>();
      await mfuController.canRegister(reqEvent: "CR");

      if (mfuController.errorMessage.value.isEmpty) {
        // ✅ Refresh session so canNumber is populated from server
        // await session.refreshUserData();
        final canNumber = mfuController.mfuCanResponse.value?.can ?? '';
        if (canNumber.isNotEmpty) {
          final currentUser = session.getUserData;
          if (currentUser != null) {
            await session.updateUserData(
              currentUser.copyWith(canNumber: canNumber),
            );
          }
        }

        log("[CAN] ✅ Registered — CAN: $canNumber");

        await fetchUserDetails();
        Get.find<MfuController>().resumePollingIfNeeded();
      } else {
        log("[CAN] ❌ Failed: ${mfuController.errorMessage.value}");
      }
    } catch (e) {
      log("[CAN] ❌ Exception: $e");
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
      Get.snackbar("Required", "Please fill all bank details");
      return;
    }

    isBankAdding.value = true;

    try {
      final Map<String, dynamic> data = {
        "id": session.getUserData?.id,
        "account_holder_name": bankAccHdNameController.text,
        "account_number": bankAccountNumberController.text.trim(),
        "ifsc_code": bankIfscController.text.trim().toUpperCase(),
        "bank_name": bankNameController.text.trim(),
        // "micr_code": bankMicrController.text.trim(),
        "account_type": bankAccountType.value,
      };

      log("Submitting Bank Data: $data");

      final result = await _useCases.updateProfileUsecases.call(data);
      fetchUserDetails();

      result.fold(
        (success) {
          clearBankFields();
          Get.back();
          // fetchUserDetails();
          if (success.data?.data?.bankAccount != null) {
            linkedBankAccount.value = success.data!.data?.bankAccount;
          } else {
            // Fallback just in case
            fetchUserDetails();
          }
          Get.snackbar(
            "Success",
            "Bank account added successfully",
            backgroundColor: Colors.green.shade50,
            colorText: Colors.green.shade900,
          );
        },
        (error) {
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
    } finally {
      isBankAdding.value = false;
    }
  }

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

        'occupation': selectedOccupation.value == "Other"
            ? occupationOtherTextEditingController.text
            : selectedOccupation.value,
        'wealth_source': wealthSource.text,
        'yearly_income': getYearlyIncomeAsInt(yearlyIncome.text),

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

    if (status == 'approved' || status == 'pending') {
      //   || status == 'timed out'    add for testing
      canEditPan.value = false;
    }
    // else if (status == 'not started' || status == null || status.isEmpty) {
    //   canEditPan.value = true;
    // }
    else {
      canEditPan.value = true;
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

  @override
  void onInit() {
    super.onInit();
    panController.addListener(_onPanTextChanged);
    loadRiskQuestions();
    _checkPanEditPermission();
    fetchBanks();
    fetchUserDetails();
    bankIfscController.addListener(() {
      final text = bankIfscController.text;
      if (text.length == 11) {
        _fetchBankDetailsFromIFSC(text);
      } else {
        resolvedBranch.value = '';
      }
    });
    // bankNameController.addListener(() {
    //   if (bankNameController.text.isNotEmpty &&
    //       bankNameController.text != autoFetchedBank.value) {

    //     bankIfscController.clear();
    //     resolvedBranch.value = '';
    //     autoFetchedBank.value = '';

    //     ULoaders.warning(
    //       title: "Bank Changed",
    //       message: "Please enter the IFSC code for your newly selected bank.",
    //     );
    //   }
    // });
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
      Get.snackbar("Required", "Please fill all the fields");
      return;
    }

    // Additional validation for Guardian
    if (isNomineeMinor.value &&
        nomineeMinorsGuardianTextEditingController.text.isEmpty) {
      Get.snackbar("Required", "Guardian Name is required for minors");
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
        "allocation_percent": 100,
        // nomineeAllocationPercentTextEditingController.text,
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

      result.fold(
        (success) {
          getNominee();
          _clearNomineeFields();

          Get.back();
          Get.snackbar("Success", "Nominee added successfully");

          // Get.back();
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
          Get.snackbar("Success", "Nominee deleted successfully");
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

  // On close

  @override
  void onClose() {
    panController.removeListener(_onPanTextChanged);
    panFocusNode.dispose();
    pageController.dispose();
    super.onClose();
  }
}
