// ignore_for_file: unused_local_variable, dead_null_aware_expression, dead_code

import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/animated/custom_toast.dart';
import 'package:my_sip/features/mfu/data/model/mandate_status_req.dart';
import 'package:my_sip/features/mfu/data/model/mfu_mandate_create_req.dart';
import 'package:my_sip/features/mfu/data/model/normal_txn_req_model.dart';
import 'package:my_sip/features/mfu/data/model/systematic_txn_req_model.dart';
import 'package:my_sip/features/mfu/domain/entity/can_register_entity.dart';
import 'package:my_sip/features/mfu/domain/entity/can_status_entity.dart';
import 'package:my_sip/features/mfu/domain/entity/emandate_status_entity.dart';
import 'package:my_sip/features/mfu/domain/entity/mandate_entity.dart';
import 'package:my_sip/features/mfu/data/model/lumpsum_req_model.dart';
import 'package:my_sip/features/mfu/data/model/lumpsum_res_model.dart';
import 'package:my_sip/features/mfu/data/model/sip_req_model.dart';
import 'package:my_sip/features/mfu/data/model/sip_res_model.dart';
import 'package:my_sip/features/mfu/data/model/stepup_req_model.dart';
import 'package:my_sip/features/mfu/data/model/stepup_res_model.dart';
import 'package:my_sip/features/mfu/data/model/redeem_req_model.dart';
import 'package:my_sip/features/mfu/data/model/redeem_res_model.dart';
import 'package:my_sip/features/mfu/domain/entity/mfu_bank_validation_entity.dart';
import 'package:my_sip/features/mfu/domain/entity/normal_txn_entity.dart';
import 'package:my_sip/features/mfu/domain/entity/systematic_txn_entity.dart';
import 'package:my_sip/common/widget/animated/popups.dart';
import 'package:my_sip/features/mfu/domain/usecases/mfu_usecases.dart';
import 'package:my_sip/features/mfu/presentation/pages/mandate_waiting_screen.dart';
import 'package:my_sip/features/mfu/presentation/pages/purchase_page.dart';
import 'package:my_sip/features/personalization/presentation/controllers/personalisation_controller.dart';
import 'package:my_sip/services/session_manager.dart';
import 'package:url_launcher/url_launcher.dart';

enum RedeemType { amount, allFree, units }

class MfuController extends GetxController {
  final MfuUseCases mfuUseCases;
  final session = SessionManager.instance;

  MfuController(this.mfuUseCases);

  @override
  void onInit() {
    super.onInit();
    redeemAmountCtrl.addListener(_onRedeemAmountTyped);
    resumePollingIfNeeded();
  }

  // ─── State ───────────────────────────────────────────────────────────────────

  final isLoading = false.obs;
  final isLoadingMandateStatus = false.obs;
  final isLoadingCanStatus = false.obs;
  final isVerified = false.obs;
  final isVerifying = false.obs;
  final isCreatingMandate = false.obs;
  final isSubmittingTxn = false.obs;
  final isSubmittingSystematicTxn = false.obs;
  final isValidatingCanBank = false.obs;
  final isSubmittingLumpsum = false.obs;
  final lumpsumResponse = Rxn<LumpsumResModel>();
  final isSubmittingSip = false.obs;
  final sipResponse = Rxn<SipResModel>();
  final isSubmittingStepUp = false.obs;
  final stepUpResponse = Rxn<StepUpResModel>();
  final isSubmittingRedeem = false.obs;
  final redeemResponse = Rxn<RedeemResModel>();

  // ─── Redeem State ────────────────────────────────────────────────────────────

  final redeemType = RedeemType.amount.obs;
  final redeemInputError = RxnString();
  final redeemAmountInWords = ''.obs;

  final redeemAmountCtrl = TextEditingController();
  final redeemUnitsCtrl = TextEditingController();

  final mandateCreateResponse = Rxn<MfuMandateCreateEntity>();
  final mfuCanResponse = Rxn<MfuCanResponseEntity>();
  final mandateStatusResponse = Rxn<MfuMandateStatusEntity>();
  final canStatusResponse = Rxn<MfuCanStatusEntity>();
  final normalTxnResponse = Rxn<MfuNormalTxnEntity>();
  final systematicTxnResponse = Rxn<MfuSystematicTxnEntity>();
  final canBankValidationResponse = Rxn<MfuCanBankValidationEntity>();

  final errorMessage = ''.obs;
  final selectedMethod = 'upi'.obs; // 'upi' | 'netbanking'
  final upiId = ''.obs;
  final TextEditingController upiNumber = TextEditingController();

  // ─── Convenience Getters ─────────────────────────────────────────────────────

  bool get isSubmittingAny =>
      isSubmittingTxn.value ||
      isSubmittingSystematicTxn.value ||
      isSubmittingLumpsum.value ||
      isSubmittingSip.value ||
      isSubmittingStepUp.value ||
      isSubmittingRedeem.value;

  String get canNumber => mfuCanResponse.value?.can ?? '';
  String get canStatus => mfuCanResponse.value?.canStatus ?? '';
  String get canStatusMessage => mfuCanResponse.value?.canStatusMessage ?? '';
  bool get isCanPending => canStatus.toLowerCase() != 'approved';

  List<BlockRespEntity> get blockRespList =>
      mfuCanResponse.value?.canStatusResponse?.respBody?.blockRespList ?? [];

  bool get hasRegistrationError =>
      mfuCanResponse.value?.canRegistrationResponse?.respHeader?.isSuccess ==
      false;

  String get registrationError =>
      mfuCanResponse.value?.canRegistrationResponse?.respHeader?.errorMsg ?? '';

  Timer? _canStatusTimer;
  static const _pollInterval = Duration(hours: 2);

  ////  SIP PURCHASE — State & Logic
  final Rx<SipPurchaseArgs> sipArgs = Rx<SipPurchaseArgs>(
    const SipPurchaseArgs(schemeCode: '', fundName: ''),
  );

  // ─── Investment State ─────────────────────────────────────────────────────────

  final Rx<InvType> sipInvType = Rx<InvType>(InvType.sip);
  final RxInt sipAmount = 500.obs;
  final RxInt sipDay = 16.obs;
  final Rx<SipFrequency> sipFreq = Rx<SipFrequency>(SipFrequency.monthly);
  final RxInt sipWeekDay = 1.obs; // 1 = Monday

  // Step-up specific
  final RxInt sipStepUpAmt = 0.obs;
  final RxInt sipStepUpPct = 10.obs;
  final RxBool sipStepByPct = false.obs;
  final RxString sipFrequency = '6'.obs; // '6' = half-yearly, '12' = yearly

  // Cap limit
  final RxBool sipCapByDate = true.obs;
  final Rx<DateTime?> sipCapDate = Rx<DateTime?>(null);
  final RxInt sipCapAmount = 0.obs;

  // ─── Validation Errors ────────────────────────────────────────────────────────

  final Rx<String?> sipAmountError = Rx<String?>(null);
  final Rx<String?> sipStepUpError = Rx<String?>(null);
  final Rx<String?> sipCapError = Rx<String?>(null);

  // ─── Computed ─────────────────────────────────────────────────────────────────

  int get sipCurrentMin => switch (sipInvType.value) {
    InvType.sip => sipArgs.value.minSip,
    InvType.lumpsum => sipArgs.value.minLumpsum,
    InvType.stepup => sipArgs.value.minSip,
  };

  bool get sipIsValid {
    if (sipAmountError.value != null) return false;
    if (sipInvType.value == InvType.stepup) {
      if (sipStepUpError.value != null) return false;
      if (sipCapError.value != null) return false;
    }
    return true;
  }

  void initSipPurchase(SipPurchaseArgs args) {
    sipArgs.value = args;
    sipAmount.value = args.minSip;
    sipStepUpAmt.value = args.minTopup;
    sipCapAmount.value = args.minSip + args.minTopup + 100;

    // Reset all errors and optional state
    sipAmountError.value = null;
    sipStepUpError.value = null;
    sipCapError.value = null;
    sipInvType.value = InvType.sip;
    sipFreq.value = SipFrequency.monthly;
    sipDay.value = 16;
    sipWeekDay.value = 1;
    sipStepByPct.value = false;
    sipStepUpPct.value = 10;
    sipFrequency.value = '6';
    sipCapByDate.value = true;
    sipCapDate.value = null;
  }

  // ─── Type Changed ─────────────────────────────────────────────────────────────

  void onSipTypeChanged(InvType t) {
    sipInvType.value = t;
    sipAmountError.value = null;
    sipStepUpError.value = null;
    sipCapError.value = null;
    sipAmount.value = switch (t) {
      InvType.lumpsum => sipArgs.value.minLumpsum,
      _ => sipArgs.value.minSip,
    };
  }

  // ─── Amount ───────────────────────────────────────────────────────────────────

  void onSipAddAmount(int delta) {
    sipAmount.value += delta;
    sipAmountError.value = _validateSipAmount(sipAmount.value);
  }

  void onSipAmountChanged(int v) {
    sipAmount.value = v;
    sipAmountError.value = _validateSipAmount(v);
  }

  String? _validateSipAmount(int v) {
    if (v < sipCurrentMin) return 'Min ₹$sipCurrentMin';
    if (v % 100 != 0) return 'Must be a multiple of ₹100';
    return null;
  }

  // ─── Step-up ──────────────────────────────────────────────────────────────────

  void onSipStepByPctToggle(bool byPct) {
    sipStepByPct.value = byPct;
    sipStepUpError.value = null;
  }

  void onSipStepAmtChanged(int v) {
    sipStepUpAmt.value = v;
    sipStepUpError.value = _validateStepUp();
  }

  void onSipStepPctChanged(int v) {
    sipStepUpPct.value = v;
    sipStepUpError.value = _validateStepUp();
  }

  void onSipFrequencyChanged(String f) => sipFrequency.value = f;

  String? _validateStepUp() {
    if (sipStepByPct.value) {
      if (sipStepUpPct.value <= 0) return 'Min 1%';
      if (sipStepUpPct.value > 100) return 'Max 100%';
    } else {
      if (sipStepUpAmt.value < sipArgs.value.minTopup) {
        return 'Min ₹${sipArgs.value.minTopup}';
      }
      if (sipStepUpAmt.value % 100 != 0) return 'Multiple of ₹100';
    }
    return null;
  }

  // ─── Cap ──────────────────────────────────────────────────────────────────────

  void onSipCapTypeToggle(bool byDate) {
    sipCapByDate.value = byDate;
    sipCapError.value = null;
  }

  void onSipCapDatePicked(DateTime d) {
    sipCapDate.value = d;
    sipCapError.value = _validateCap();
  }

  void onSipCapAmtChanged(int v) {
    sipCapAmount.value = v;
    sipCapError.value = _validateCap();
  }

  String? _validateCap() {
    if (sipCapByDate.value) {
      if (sipCapDate.value == null) return 'Select an end date';
      if (sipCapDate.value!.isBefore(DateTime.now())) {
        return 'Date must be in future';
      }
    } else {
      final minCap = sipArgs.value.minSip + sipArgs.value.minTopup;
      if (sipCapAmount.value <= minCap) return 'Must be > ₹$minCap';
      if (sipCapAmount.value % 100 != 0) return 'Multiple of ₹100';
    }
    return null;
  }

  // ─── SIP Frequency / Date pickers (delegates — call from View) ───────────────

  void setSipFrequency(SipFrequency f) => sipFreq.value = f;

  void setSipDay(int day) => sipDay.value = day;

  void setSipWeekDay(int weekDay) => sipWeekDay.value = weekDay;

  // ─── MFU Day Formatter ────────────────────────────────────────────────────────

  String formatMfuSipDay() {
    switch (sipFreq.value) {
      case SipFrequency.daily:
        // MFU Rule: For Daily frequency, date field must be blank / NA.
        return 'NA';

      case SipFrequency.weekly:
        // MFU Rule: 1=Monday … 5=Friday
        return sipWeekDay.value.toString();

      case SipFrequency.monthly:
        // MFU Rule: Pass the day number as a string, e.g. "10", "15"
        return sipDay.value.toString();
    }
  }

  String formatMfuSipFrequency() {
    switch (sipFreq.value) {
      case SipFrequency.daily:
        return 'D';
      case SipFrequency.weekly:
        return 'W';
      case SipFrequency.monthly:
        return 'M';
    }
  }

  // ─── Invest ───────────────────────────────────────────────────────────────────

  void onSipInvest() {
    //Step up block
    if (sipInvType.value == InvType.stepup) {
      CustomSnackbar.warning(
        title: 'Step-Up SIP Coming Soon 🚀',
        message:
            'Step-Up SIP is currently unavailable. Please select Normal SIP or Lump Sum to proceed.',
      );

      return;
    }
    // 1. Validate inputs
    final aErr = _validateSipAmount(sipAmount.value);
    final sErr = sipInvType.value == InvType.stepup ? _validateStepUp() : null;
    final cErr = sipInvType.value == InvType.stepup ? _validateCap() : null;

    sipAmountError.value = aErr;
    sipStepUpError.value = sErr;
    sipCapError.value = cErr;

    if (aErr != null || sErr != null || cErr != null) return;

    final args = sipArgs.value;
    final schemeCode = args.schemeCode;
    final amount = sipAmount.value.toDouble();
    final day = formatMfuSipDay();
    final folio = args.folio ?? 'NEW';

    // 2. Dispatch investment API based on selected InvType
    if (sipInvType.value == InvType.lumpsum) {
      executeLumpsum(schemeCode: schemeCode, amount: amount, folio: folio);
    } else if (sipInvType.value == InvType.sip) {
      executeSip(
        schemeCode: schemeCode,
        amount: amount,
        day: day,
        frequency: formatMfuSipFrequency(),
        folio: folio,
      );
    } else if (sipInvType.value == InvType.stepup) {
      executeStepUp(
        schemeCode: schemeCode,
        amount: amount,
        day: day,
        frequency: 'M',
      );
    }
  }

  void selectMethod(String method) {
    selectedMethod.value = method;
    isVerified.value = false;
    // upiId.value = '';
  }

  Future<void> verifyUpi() async {
    final currentUpi = upiId.value.trim();

    // 1. Check if empty
    if (currentUpi.isEmpty) {
      showCustomToast(
        title: 'Required',
        message: 'Please enter a UPI ID',
        backgroundColor: Colors.red,
        icon: Icons.warning,
      );
      return;
    }

    // 2. Frontend Validation using Regex
    // Allows alphanumeric, dot, hyphen, and underscore before '@'
    // Requires standard bank handle characters after '@'
    final RegExp upiRegex = RegExp(r'^[a-zA-Z0-9.\-_]{2,256}@[a-zA-Z]{2,64}$');

    if (!upiRegex.hasMatch(currentUpi)) {
      showCustomToast(
        title: 'Invalid Format',
        message: 'Please enter a valid UPI ID (e.g., 9876543210@ybl)',
        backgroundColor: Colors.orange, // Orange for validation warning
        icon: Icons.error_outline,
      );
      return; // Stop execution, don't proceed to "verification"
    }

    // 3. Fake Verification (Since you have no backend yet)
    isVerifying.value = true;

    // Simulate network delay for good UX
    await Future.delayed(const Duration(seconds: 2));

    isVerified.value = true;
    isVerifying.value = false;

    // Optional: Show Success Toast
    showCustomToast(
      title: 'Success',
      message: 'UPI ID Verified Successfully',
      backgroundColor: Colors.green,
      icon: Icons.check_circle,
    );
  }

  // ─── Actions ─────────────────────────────────────────────────────────────────

  // Future<void> canRegister() async {
  //   isLoading.value = true;
  //   errorMessage.value = '';

  //   // uid comes from the logged-in session
  //   final uid = session.getUserData?.id ?? 0;

  //   final result = await mfuUseCases.canRegisterUseCase(uid: uid);

  //   result.fold(
  //     (success) {
  //       mfuCanResponse.value = success.data;
  //     },
  //     (error) {
  //       errorMessage.value = error.message ?? 'Something went wrong';
  //       Get.snackbar('MFU Error', errorMessage.value);
  //     },
  //   );

  //   isLoading.value = false;
  // }
  Future<void> canRegister() async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await mfuUseCases.canRegisterUseCase();

    result.fold(
      (success) {
        mfuCanResponse.value = success.data;
      },
      (error) {
        errorMessage.value = error.message ?? 'Something went wrong';
        // CustomSnackbar.error(
        //   title: 'MFU Error',
        //   message: 'Something went wrong',
        // );
      },
    );

    isLoading.value = false;
  }

  Future<void> getCanStatus() async {
    final can = session.getUserData?.canNumber ?? '';

    if (can.isEmpty) {
      log("[MfuController] getCanStatus — no CAN number in session");
      return;
    }

    isLoadingCanStatus.value = true;
    errorMessage.value = '';

    final result = await mfuUseCases.getCanStatusUseCase.call(can: can);

    result.fold(
      (success) {
        canStatusResponse.value = success.data;
        log("[MfuController] CAN Status: ${success.data?.canStatus}");

        final rawStatus = (success.data?.canStatus ?? '').trim().toLowerCase();
        final isApproved = rawStatus == 'approved';

        if (isApproved) {
          _stopCanStatusPolling();

          if (Get.isRegistered<PersonalisationController>()) {
            Get.find<PersonalisationController>().fetchUserDetails();
          }

          ULoaders.success(
            title: "Account Activated! 🎉",
            message:
                "Your investment account (CAN) is approved. You can now set up Auto Pay!",
          );
        }
      },
      (error) {
        errorMessage.value = error.message ?? 'Something went wrong';
        log("[MfuController] CAN Status Error: ${errorMessage.value}");
      },
    );

    isLoadingCanStatus.value = false;
  }

  void _startCanStatusPolling() {
    // Cancel any existing timer before starting a new one
    _stopCanStatusPolling();

    final can =
        session.getUserData?.canNumber ?? mfuCanResponse.value?.can ?? '';

    if (can.isEmpty) {
      log("[MfuController] Cannot start polling — no CAN number");
      return;
    }

    log(
      "[MfuController] ⏱ Starting CAN status polling every 5 min for CAN: $can",
    );

    // ✅ Check immediately once, then every 5 minutes
    getCanStatus();

    _canStatusTimer = Timer.periodic(_pollInterval, (_) {
      log("[MfuController] ⏱ Polling CAN status...");
      getCanStatus();
    });
  }

  void _stopCanStatusPolling() {
    if (_canStatusTimer != null) {
      _canStatusTimer!.cancel();
      _canStatusTimer = null;
      log("[MfuController] ⏹ CAN status polling stopped");
    }
  }

  void resumePollingIfNeeded() {
    final canNumber = session.getUserData?.canNumber ?? '';
    final canStatus = session.getUserData?.canStatus?.toLowerCase() ?? '';

    if (canNumber.isNotEmpty && canStatus != 'approved') {
      log("[MfuController] 🔄 Resuming CAN status polling on app start");
      _startCanStatusPolling();
    }
  }

  //Bank Validation

  Future<void> canBankValidation() async {
    isValidatingCanBank.value = true;
    errorMessage.value = '';

    final uid = session.getUserData?.id ?? 0;

    final result = await mfuUseCases.mfuCanBankValidationUseCase(uid: uid);

    result.fold(
      (success) {
        canBankValidationResponse.value = success.data;
        log(
          "[MfuController] CAN Bank Validation — bankExist: ${success.data?.isBankLinked}",
        );
      },
      (error) {
        errorMessage.value = error.message ?? 'CAN Bank Validation Failed';
        Get.snackbar('Validation Error', errorMessage.value);
      },
    );

    isValidatingCanBank.value = false;
  }

  //   Usage from UI
  //   controller.canBankValidation();

  // // Check result
  // Obx(() {
  //   final response = controller.canBankValidationResponse.value;
  //   if (response?.isBankLinked == true) {
  //     // bank is linked to CAN ✅
  //   }
  // });
  /// ---------------------------

  /// ------   Mandate ----   ///
  Future<void> createMandate(MfuMandateCreateRequest request) async {
    isCreatingMandate.value = true;
    errorMessage.value = '';

    // 1. Show Loading Dialog
    CustomLoadingDialog.show(title: "Preparing secure gateway...");

    try {
      final result = await mfuUseCases.mfuMandateCreateUseCase(request);

      await result.fold(
        (success) async {
          mandateCreateResponse.value = success.data;

          // Get the mandate type (Fallback to selectedMethod if backend doesn't echo it)
          final mandateType = success.data?.mandateType ?? selectedMethod.value;

          log("[MfuController] Mandate created — type: $mandateType");

          final approveLink = success.data?.approveLink ?? '';

          // 2. Hide Loading Dialog before opening WebView
          CustomLoadingDialog.hide();

          if (approveLink.isNotEmpty) {
            // 3. Open WebView and wait for result
            final webViewResult = await Get.to(
              () => MandateWebView(url: approveLink),
            );

            debugPrint("==================================================");
            debugPrint("WEBPAGE RAW TEXT: $webViewResult");
            debugPrint("==================================================");

            // 4. Handle WebView Result
            if (webViewResult == 'success' || webViewResult == 'check_status') {
              final uid =
                  success.data?.mandate?.userId ?? session.getUserData?.id ?? 0;
              final can =
                  success.data?.can ?? session.getUserData?.canNumber ?? '';
              final freshMmrn = success.data?.mmrn ?? '';
              final freshMumrn = success.data?.mumrn ?? '';

              if (mandateType == 'upi') {
                if (freshMumrn.isEmpty) {
                  CustomSnackbar.error(
                    title: 'Error',
                    message: 'No UPI Mandate ID (MUMRN) found to verify.',
                  );
                  return;
                }

                // Save pending mandate to session for delayed background reconciliation
                await session.savePendingMandate(
                  can: can,
                  mumrn: freshMumrn,
                  upiId: request.upiId,
                  maxAmount: request.amount?.toString(),
                );

                // 4. Launch Native Mandate Waiting & Polling Screen
                await Get.to(
                  () => MandateWaitingScreen(
                    userId: uid,
                    can: can,
                    mumrn: freshMumrn,
                    upiId: request.upiId,
                    maxAmount: request.amount?.toString(),
                    deepLink: success.data?.deepLink,
                  ),
                );
              } else {
                // Handle eNACH verification
                if (freshMmrn.isEmpty) {
                  CustomSnackbar.error(
                    title: 'Error',
                    message: 'No eNACH Mandate ID found to verify.',
                  );
                  return;
                }
                await getMandateStatus(
                  MfuMandateStatusRequest.enach(
                    userId: uid,
                    can: can,
                    mmrn: freshMmrn,
                  ),
                );
              }
            } else if (webViewResult == 'failed') {
              CustomSnackbar.error(
                title: 'Failed',
                message: 'Mandate authorization failed or was cancelled.',
              );
            }
          }
        },
        (error) async {
          // Handle API Error
          CustomLoadingDialog.hide();
          await Future.delayed(const Duration(milliseconds: 300));

          errorMessage.value = error.message ?? 'Mandate creation failed';
          CustomSnackbar.error(
            title: 'Mandate Error',
            message: errorMessage.value,
          );
        },
      );
    } catch (e) {
      // Handle Unexpected Exception
      CustomLoadingDialog.hide();
      CustomSnackbar.error(
        title: 'Error',
        message: 'An unexpected error occurred.',
      );
    } finally {
      isCreatingMandate.value = false;
    }
  }

  Future<void> getMandateStatus(MfuMandateStatusRequest request) async {
    isLoadingMandateStatus.value = true;
    errorMessage.value = '';

    mandateStatusResponse.value = null;

    final result = await mfuUseCases.mfuMandateStatusUseCase(request);

    result.fold(
      (success) {
        mandateStatusResponse.value = success.data;
        log("[MfuController] Mandate Status: ${success.data?.mandateStatus}");
      },
      (error) {
        errorMessage.value = error.message ?? 'Failed to fetch mandate status';
        Get.snackbar('Mandate Status Error', errorMessage.value);
      },
    );

    isLoadingMandateStatus.value = false;
  }

  /// Reconcile pending mandate saved locally in session when user returns/refreshes
  Future<bool> checkPendingMandateReconciliation() async {
    final pendingData = await session.getPendingMandate();
    if (pendingData == null) return false;

    final can = pendingData['can'] as String? ?? '';
    final mumrn = pendingData['mumrn'] as String? ?? '';
    final uid = session.getUserData?.id ?? 0;

    if (can.isEmpty || mumrn.isEmpty || uid == 0) {
      await session.clearPendingMandate();
      return false;
    }

    log(
      "[MfuController] Reconciling pending mandate from session: MUMRN=$mumrn",
    );

    try {
      final request = MfuMandateStatusRequest.upi(
        userId: uid,
        can: can,
        mumrn: mumrn,
      );

      final result = await mfuUseCases.mfuMandateStatusUseCase(request);

      return result.fold(
        (success) async {
          final entity = success.data;
          final mfuStat = entity?.response?.regStatus.isNotEmpty == true
              ? entity?.response?.regStatus
              : entity?.mandateStatus;
          final aggrStat = entity?.response?.aggrStatus;

          final mfu = (mfuStat ?? '').trim().toUpperCase();
          final aggr = (aggrStat ?? '').trim().toUpperCase();

          final isApproved =
              (mfu == 'PA' || mfu == 'APPROVED' || mfu == 'SUCCESS') &&
              aggr == 'AC';
          final isTerminalFailure =
              mfu == 'PR' ||
              aggr == 'RA' ||
              mfu == 'CL' ||
              aggr == 'CL' ||
              aggr == 'MX' ||
              aggr == 'RV';

          if (isApproved) {
            log(
              "[MfuController] Pending mandate $mumrn is now APPROVED! Clearing session and reloading profile.",
            );
            await session.clearPendingMandate();
            if (Get.isRegistered<PersonalisationController>()) {
              await Get.find<PersonalisationController>().fetchUserDetails();
            }
            return true;
          } else if (isTerminalFailure) {
            log(
              "[MfuController] Pending mandate $mumrn failed with $mfu/$aggr. Clearing session.",
            );
            await session.clearPendingMandate();
            return false;
          }
          return false;
        },
        (error) async {
          log(
            "[MfuController] Pending mandate reconciliation check failed: ${error.message}",
          );
          return false;
        },
      );
    } catch (e) {
      log("[MfuController] Error during pending mandate reconciliation: $e");
      return false;
    }
  }

  Future<void> normalTransaction(MfuNormalTxnRequest request) async {
    isSubmittingTxn.value = true;
    errorMessage.value = '';

    final result = await mfuUseCases.mfuNormalTxnUseCase(request);

    result.fold(
      (success) async {
        normalTxnResponse.value = success.data;
        log(
          "[MfuController] Txn submitted — ref: ${success.data?.entGroupRefNo}",
        );

        if (success.data?.hasApprovalLink == true) {
          // openLink(success.data!.approvalLink);
          final webViewResult = await Get.to(
            () => MandateWebView(url: success.data!.approvalLink),
          );
        }
      },
      (error) {
        errorMessage.value = error.message ?? 'Transaction failed';
        Get.snackbar('Transaction Error', errorMessage.value);
      },
    );

    isSubmittingTxn.value = false;
  }

  Future<void> systematicTransaction(MfuSystematicTxnRequest request) async {
    isSubmittingSystematicTxn.value = true;
    errorMessage.value = '';

    final result = await mfuUseCases.mfuSystematicTxnUseCase(request);

    result.fold(
      (success) async {
        systematicTxnResponse.value = success.data;
        log(
          "[MfuController] Systematic Txn — ref: ${success.data?.entGroupRefNo}",
        );

        if (success.data?.hasErrors == true) {
          log("[MfuController] Txn Errors: ${success.data?.errors}");
        }

        if (success.data?.hasApprovalLink == true) {
          // openLink(success.data!.approvalLink);
          final webViewResult = await Get.to(
            () => MandateWebView(url: success.data!.approvalLink),
          );
        }
      },
      (error) {
        errorMessage.value = error.message ?? 'Systematic transaction failed';
        Get.snackbar('Transaction Error', errorMessage.value);
      },
    );

    isSubmittingSystematicTxn.value = false;
  }

  // Redeem
  void _onRedeemAmountTyped() {
    final v = double.tryParse(redeemAmountCtrl.text) ?? 0;
    redeemAmountInWords.value = v > 0 ? '${_toWords(v.toInt())} only' : '';
    redeemInputError.value = null; // Clear error on typing
  }

  void selectRedeemType(RedeemType type) {
    redeemType.value = type;
    redeemInputError.value = null;
  }

  void useMaxRedeemAmount(double maxAmount) {
    redeemAmountCtrl.text = maxAmount.toStringAsFixed(2);
  }

  void useMaxRedeemUnits(double maxUnits) {
    redeemUnitsCtrl.text = maxUnits.toStringAsFixed(3);
    redeemInputError.value = null;
  }

  /// Flow 4: Lumpsum Redemption (`POST /api/v1/invest/redeem`)
  Future<void> executeRedeem(
    RedeemReqModel req, {
    Function(RedeemResModel)? onSuccess,
  }) async {
    isSubmittingRedeem.value = true;
    errorMessage.value = '';

    final res = await mfuUseCases.postRedeemUseCase(req);

    res.fold(
      (success) {
        final data = success.data;
        redeemResponse.value = data;
        log(
          "[MfuController] Redeem Success → Order ID: ${data?.mfuOrderId} | GORN: ${data?.mfuGorn} | Status: ${data?.orderStatus}",
        );

        // CustomSnackbar.success(
        //   title: 'Redemption Submitted 🎉',
        //   message:
        //       data?.message ?? 'Redemption request submitted successfully.',
        // );

        if (data?.hasApprovalLink == true) {
          openApprovalLink(data!.approvalLink!, title: 'Confirm Redemption');
        }

        if (onSuccess != null && data != null) {
          onSuccess(data);
        }
      },
      (error) {
        errorMessage.value = error.message;
        log("[MfuController] Redeem Error → ${error.message}");
        CustomSnackbar.error(
          title: 'Redemption Failed ❌',
          message: error.message,
        );
      },
    );

    isSubmittingRedeem.value = false;
  }

  void processRedemption({
    dynamic mfuOrderFundId,
    required String schemeCode,
    required String folio,
    required double freeUnits,
    required double freeValue,
    Function(RedeemResModel)? onSuccess,
  }) {
    redeemInputError.value = null;

    final targetId = mfuOrderFundId ?? schemeCode;

    switch (redeemType.value) {
      case RedeemType.amount:
        final v = double.tryParse(redeemAmountCtrl.text) ?? 0;
        if (v <= 0) {
          redeemInputError.value = 'Please enter an amount';
          return;
        }
        if (freeValue > 0 && v > freeValue) {
          redeemInputError.value =
              'Exceeds free value (Max: ₹${freeValue.toStringAsFixed(2)})';
          return;
        }
        executeRedeem(
          RedeemReqModel(mfuOrderFundId: targetId, folio: folio, amount: v),
          onSuccess: onSuccess,
        );
        break;

      case RedeemType.units:
        final v = double.tryParse(redeemUnitsCtrl.text) ?? 0;
        if (v <= 0) {
          redeemInputError.value = 'Please enter units';
          return;
        }
        if (freeUnits > 0 && v > freeUnits) {
          redeemInputError.value =
              'Exceeds free units (Max: ${freeUnits.toStringAsFixed(3)})';
          return;
        }
        executeRedeem(
          RedeemReqModel(mfuOrderFundId: targetId, folio: folio, units: v),
          onSuccess: onSuccess,
        );
        break;

      case RedeemType.allFree:
        executeRedeem(
          RedeemReqModel(
            mfuOrderFundId: targetId,
            folio: folio,
            units: freeUnits,
          ),
          onSuccess: onSuccess,
        );
        break;
    }
  }

  // ─── Number to Words Formatter ───────────────────────────────────────────────
  final List<String> _ones = const [
    '',
    'One',
    'Two',
    'Three',
    'Four',
    'Five',
    'Six',
    'Seven',
    'Eight',
    'Nine',
    'Ten',
    'Eleven',
    'Twelve',
    'Thirteen',
    'Fourteen',
    'Fifteen',
    'Sixteen',
    'Seventeen',
    'Eighteen',
    'Nineteen',
  ];
  final List<String> _tens = const [
    '',
    '',
    'Twenty',
    'Thirty',
    'Forty',
    'Fifty',
    'Sixty',
    'Seventy',
    'Eighty',
    'Ninety',
  ];
  String _toWords(int n) {
    if (n == 0) return 'Zero';
    if (n < 20) return _ones[n];
    if (n < 100) {
      return '${_tens[n ~/ 10]}${n % 10 > 0 ? ' ${_ones[n % 10]}' : ''}';
    }
    if (n < 1000) {
      return '${_ones[n ~/ 100]} Hundred${n % 100 > 0 ? ' ${_toWords(n % 100)}' : ''}';
    }
    if (n < 100000) {
      return '${_toWords(n ~/ 1000)} Thousand${n % 1000 > 0 ? ' ${_toWords(n % 1000)}' : ''}';
    }
    if (n < 10000000) {
      return '${_toWords(n ~/ 100000)} Lakh${n % 100000 > 0 ? ' ${_toWords(n % 100000)}' : ''}';
    }
    return '${_toWords(n ~/ 10000000)} Crore${n % 10000000 > 0 ? ' ${_toWords(n % 10000000)}' : ''}';
  }

  /// Opens MFU payment/order confirmation approval link (InAppWebView on mobile, external browser tab on Web)
  void openApprovalLink(
    String url, {
    String title = 'Order Confirmation',
  }) async {
    if (url.isEmpty) return;
    if (kIsWeb) {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } else {
      Get.to(() => MandateWebView(url: url, title: title));
    }
  }

  /// Flow 1: Lumpsum Purchase (`POST /api/v1/invest/lumpsum`)
  Future<void> executeLumpsum({
    String? schemeCode,
    double? amount,
    String folio = 'NEW',
    List<LumpsumFundItemModel>? funds,
    Function(LumpsumResModel)? onSuccess,
  }) async {
    isSubmittingLumpsum.value = true;
    errorMessage.value = '';

    final List<LumpsumFundItemModel> lumpsumFunds =
        funds ??
        [
          if (schemeCode != null && amount != null)
            LumpsumFundItemModel(
              schemeCode: schemeCode,
              amount: amount,
              folio: folio,
            ),
        ];

    final req = LumpsumReqModel(funds: lumpsumFunds);

    final res = await mfuUseCases.postLumpsumUseCase(req);

    res.fold(
      (success) {
        final data = success.data;
        lumpsumResponse.value = data;
        log(
          "[MfuController] Lumpsum Success → Order ID: ${data?.mfuOrderId} | GORN: ${data?.mfuGorn} | Status: ${data?.orderStatus}",
        );

        if (onSuccess != null && data != null) {
          onSuccess(data);
          if (data.approvalLink != null && data.approvalLink!.isNotEmpty) {
            openApprovalLink(data.approvalLink!, title: 'Confirm Investment');
          }
        } else if (data?.approvalLink != null &&
            data!.approvalLink!.isNotEmpty) {
          // CustomSnackbar.success(
          //   title: 'Lumpsum Submitted 🎉',
          //   message: 'Opening MFU approval page for payment confirmation.',
          // );
          openApprovalLink(data.approvalLink!, title: 'Confirm Investment');
        } else {
          // CustomSnackbar.success(
          //   title: 'Lumpsum Order Placed 🎉',
          //   message: 'Reference (GORN): ${data?.mfuGorn ?? "N/A"}',
          // );
        }
      },
      (error) {
        errorMessage.value = error.message;
        log("[MfuController] Lumpsum Error → ${error.message}");
        CustomSnackbar.error(
          title: 'Lumpsum Purchase Failed',
          message: error.message,
        );
      },
    );

    isSubmittingLumpsum.value = false;
  }

  /// Flow 2: SIP Registration (`POST /api/v1/invest/sip`)
  Future<void> executeSip({
    String? schemeCode,
    double? amount,
    String folio = 'NEW',
    String? day,
    String frequency = 'M',
    List<SipFundItemModel>? funds,
    Function(SipResModel)? onSuccess,
  }) async {
    isSubmittingSip.value = true;
    errorMessage.value = '';

    final List<SipFundItemModel> sipFunds =
        funds ??
        [
          if (schemeCode != null && amount != null && day != null)
            SipFundItemModel(
              schemeCode: schemeCode,
              amount: amount,
              folio: folio,
              frequency: frequency,
              day: day,
            ),
        ];

    final req = SipReqModel(funds: sipFunds);

    final res = await mfuUseCases.postSipUseCase(req);

    res.fold(
      (success) {
        final data = success.data;
        sipResponse.value = data;
        log(
          "[MfuController] SIP Success → Order ID: ${data?.mfuOrderId} | GORN: ${data?.mfuGorn} | Status: ${data?.orderStatus}",
        );

        if (onSuccess != null && data != null) {
          onSuccess(data);
          if (data.approvalLink != null && data.approvalLink!.isNotEmpty) {
            openApprovalLink(data.approvalLink!, title: 'Confirm SIP Order');
          }
        } else if (data?.approvalLink != null &&
            data!.approvalLink!.isNotEmpty) {
          // CustomSnackbar.success(
          //   title: 'SIP Submitted 🎉',
          //   message: 'Opening MFU approval page for SIP confirmation.',
          // );
          openApprovalLink(data.approvalLink!, title: 'Confirm SIP Order');
        } else {
          // CustomSnackbar.success(
          //   title: 'SIP Registered 🎉',
          //   message: 'Reference (GORN): ${data?.mfuGorn ?? "N/A"}',
          // );
        }
      },
      (error) {
        errorMessage.value = error.message;
        log("[MfuController] SIP Error → ${error.message}");
        CustomSnackbar.error(
          title: 'SIP Registration Failed',
          message: error.message,
        );
      },
    );

    isSubmittingSip.value = false;
  }

  /// Flow 3: SIP Step-Up (`POST /api/v1/invest/stepup`)
  Future<void> executeStepUp({
    required String schemeCode,
    required double amount,
    required String day,
    String frequency = 'M',
    Function(StepUpResModel)? onSuccess,
  }) async {
    isSubmittingStepUp.value = true;
    errorMessage.value = '';

    final req = StepUpReqModel(
      schemeCode: schemeCode,
      amount: amount,
      day: day,
      frequency: frequency,
    );

    final res = await mfuUseCases.postStepUpUseCase(req);

    res.fold(
      (success) {
        final data = success.data;
        stepUpResponse.value = data;
        log(
          "[MfuController] StepUp Success → Order ID: ${data?.mfuOrderId} | Status: ${data?.orderStatus}",
        );

        if (onSuccess != null && data != null) {
          onSuccess(data);
        } else {
          // CustomSnackbar.success(
          //   title: 'SIP Step-Up Requested 🎉',
          //   message:
          //       'Order ID: ${data?.mfuOrderId ?? "N/A"} | Status: ${data?.orderStatus ?? "RQ"}',
          // );
        }
      },
      (error) {
        errorMessage.value = error.message;
        log("[MfuController] StepUp Error → ${error.message}");
        CustomSnackbar.error(
          title: 'SIP Step-Up Failed',
          message: error.message,
        );
      },
    );

    isSubmittingStepUp.value = false;
  }

  @override
  void onClose() {
    _stopCanStatusPolling();
    redeemAmountCtrl.dispose();
    redeemUnitsCtrl.dispose();
    super.onClose();
  }
}

bool _isMfuSuccessUrl(String url) {
  final lower = url.toLowerCase();
  return lower.contains('epayeezdebitreshandler.do') ||
      lower.contains('calinv2success.jsp') ||
      lower.contains('respflag=s') ||
      (lower.contains('page=s') && lower.contains('remarks=transaction'));
}

bool _isMfuFailureUrl(String url) {
  final lower = url.toLowerCase();
  return lower.contains('calinv2error.jsp') ||
      lower.contains('calinv2fail.jsp') ||
      (lower.contains('respflag=f') && !lower.contains('respflag=s')) ||
      (lower.contains('respflag=e') && !lower.contains('respflag=s'));
}

class MandateWebView extends StatefulWidget {
  final String url;
  final String title;

  const MandateWebView({
    super.key,
    required this.url,
    this.title = 'Approve Mandate',
  });

  @override
  State<MandateWebView> createState() => _MandateWebViewState();
}

class _MandateWebViewState extends State<MandateWebView> {
  bool _succeeded = false;

  static const _desktopUA =
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
      "(KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36";

  InAppWebViewSettings get _settings => InAppWebViewSettings(
    javaScriptEnabled: true,
    domStorageEnabled: true,
    thirdPartyCookiesEnabled: true,
    supportMultipleWindows: true,
    javaScriptCanOpenWindowsAutomatically: true,
    useShouldOverrideUrlLoading: true,
    mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
    userAgent: _desktopUA,
  );

  String get _bridgeHtml =>
      '''
    <html><body>
    <script>
      window.onload = function() { window.open('${widget.url}', '_blank'); };
    </script>
    </body></html>
  ''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () =>
              Get.back(result: _succeeded ? 'success' : 'check_status'),
        ),
      ),
      body: InAppWebView(
        initialData: InAppWebViewInitialData(data: _bridgeHtml),
        initialSettings: _settings,

        shouldOverrideUrlLoading: (controller, action) async {
          final url = action.request.url?.toString() ?? '';
          if (_isMfuSuccessUrl(url)) {
            _succeeded = true;
            if (mounted) Get.back(result: 'success');
            return NavigationActionPolicy.CANCEL;
          }
          if (_isMfuFailureUrl(url)) {
            if (mounted) Get.back(result: 'failed');
            return NavigationActionPolicy.CANCEL;
          }
          return NavigationActionPolicy.ALLOW;
        },

        onLoadStart: (controller, url) async {
          final currentUrl = url?.toString() ?? '';
          if (_isMfuSuccessUrl(currentUrl)) {
            _succeeded = true;
            if (mounted) Get.back(result: 'success');
          } else if (_isMfuFailureUrl(currentUrl)) {
            if (mounted) Get.back(result: 'failed');
          }
        },

        onLoadStop: (controller, url) async {
          final currentUrl = url?.toString() ?? '';
          debugPrint("Page Loaded: $currentUrl");
          if (_isMfuSuccessUrl(currentUrl)) {
            _succeeded = true;
            if (mounted) Get.back(result: 'success');
          } else if (_isMfuFailureUrl(currentUrl)) {
            if (mounted) Get.back(result: 'failed');
          }
        },

        onUpdateVisitedHistory: (controller, url, isReload) async {
          final currentUrl = url?.toString() ?? '';
          if (_isMfuSuccessUrl(currentUrl)) {
            _succeeded = true;
            if (mounted) Get.back(result: 'success');
          } else if (_isMfuFailureUrl(currentUrl)) {
            if (mounted) Get.back(result: 'failed');
          }
        },

        onReceivedHttpError: (controller, request, errorResponse) async {
          final reqUrl = request.url.toString();
          debugPrint("HTTP Error ${errorResponse.statusCode} on $reqUrl");
          if (_isMfuSuccessUrl(reqUrl)) {
            debugPrint(
              "🎉 Intercepted HTTP Error on Success URL! Auto-closing WebView as Success...",
            );
            _succeeded = true;
            if (mounted) Get.back(result: 'success');
          }
        },

        onCreateWindow: (controller, action) async {
          final result = await Get.to(
            () => _PopupWebView(
              windowId: action.windowId,
              desktopUA: _desktopUA,
              title: widget.title,
            ),
          );
          if (mounted) Get.back(result: result ?? 'check_status');
          return true;
        },

        onReceivedServerTrustAuthRequest: (controller, challenge) async =>
            ServerTrustAuthResponse(
              action: ServerTrustAuthResponseAction.PROCEED,
            ),
      ),
    );
  }
}

// ─── Popup ────────────────────────────────────────────────────────────────────

class _PopupWebView extends StatefulWidget {
  final int windowId;
  final String desktopUA;
  final String title;

  const _PopupWebView({
    required this.windowId,
    required this.desktopUA,
    this.title = 'Order Confirmation',
  });

  @override
  State<_PopupWebView> createState() => _PopupWebViewState();
}

class _PopupWebViewState extends State<_PopupWebView> {
  bool _succeeded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () =>
              Get.back(result: _succeeded ? 'success' : 'check_status'),
        ),
      ),
      body: InAppWebView(
        windowId: widget.windowId,
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          domStorageEnabled: true,
          thirdPartyCookiesEnabled: true,
          supportMultipleWindows: true,
          javaScriptCanOpenWindowsAutomatically: true,
          useShouldOverrideUrlLoading: true,
          mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
          userAgent: widget.desktopUA,
        ),

        shouldOverrideUrlLoading: (controller, action) async {
          final url = action.request.url?.toString() ?? '';

          // Check MFU Success callback (e.g. EPayeezDebitResHandler.do or CalinV2Success.jsp or respFlag=S)
          if (_isMfuSuccessUrl(url)) {
            debugPrint(
              "🎉 Intercepted MFU Success URL in shouldOverrideUrlLoading: $url",
            );
            _succeeded = true;
            if (mounted) Get.back(result: 'success');
            return NavigationActionPolicy.CANCEL;
          }

          if (_isMfuFailureUrl(url)) {
            debugPrint(
              "⚠️ Intercepted MFU Failure URL in shouldOverrideUrlLoading: $url",
            );
            if (mounted) Get.back(result: 'failed');
            return NavigationActionPolicy.CANCEL;
          }

          // External app (UPI, intent://, etc.)
          final scheme = Uri.tryParse(url)?.scheme.toLowerCase() ?? '';
          if (![
            'http',
            'https',
            'about',
            'data',
            'javascript',
          ].contains(scheme)) {
            final uri = Uri.parse(url);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
            return NavigationActionPolicy.CANCEL;
          }

          return NavigationActionPolicy.ALLOW;
        },

        onLoadStart: (controller, url) async {
          final currentUrl = url?.toString() ?? '';
          debugPrint("Page Load Started: $currentUrl");
          if (_isMfuSuccessUrl(currentUrl)) {
            debugPrint(
              "🎉 Intercepted MFU Success URL in onLoadStart: $currentUrl",
            );
            _succeeded = true;
            if (mounted) Get.back(result: 'success');
          } else if (_isMfuFailureUrl(currentUrl)) {
            if (mounted) Get.back(result: 'failed');
          }
        },

        onLoadStop: (controller, url) async {
          final currentUrl = url?.toString() ?? '';
          debugPrint("Page Loaded: $currentUrl");

          if (_isMfuSuccessUrl(currentUrl)) {
            debugPrint("🎉 MFU Flow Complete! Auto-closing WebView...");
            _succeeded = true;
            if (mounted) {
              Get.back(result: 'success');
            }
          } else if (_isMfuFailureUrl(currentUrl)) {
            if (mounted) {
              Get.back(result: 'failed');
            }
          }
        },

        onUpdateVisitedHistory: (controller, url, isReload) async {
          final currentUrl = url?.toString() ?? '';
          if (_isMfuSuccessUrl(currentUrl)) {
            debugPrint(
              "🎉 Intercepted MFU Success URL in onUpdateVisitedHistory: $currentUrl",
            );
            _succeeded = true;
            if (mounted) {
              Get.back(result: 'success');
            }
          } else if (_isMfuFailureUrl(currentUrl)) {
            if (mounted) {
              Get.back(result: 'failed');
            }
          }
        },

        onReceivedHttpError: (controller, request, errorResponse) async {
          final reqUrl = request.url.toString();
          debugPrint("HTTP Error ${errorResponse.statusCode} on $reqUrl");
          if (_isMfuSuccessUrl(reqUrl)) {
            debugPrint(
              "🎉 Intercepted HTTP Error on Success URL! Auto-closing WebView as Success...",
            );
            _succeeded = true;
            if (mounted) {
              Get.back(result: 'success');
            }
          }
        },

        onCloseWindow: (controller) {
          if (!_succeeded && mounted) Get.back(result: 'check_status');
        },

        onReceivedServerTrustAuthRequest: (controller, challenge) async =>
            ServerTrustAuthResponse(
              action: ServerTrustAuthResponseAction.PROCEED,
            ),

        gestureRecognizers: {
          Factory<VerticalDragGestureRecognizer>(
            () => VerticalDragGestureRecognizer(),
          ),
          Factory<HorizontalDragGestureRecognizer>(
            () => HorizontalDragGestureRecognizer(),
          ),
          Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()),
          Factory<TapGestureRecognizer>(() => TapGestureRecognizer()),
        },
      ),
    );
  }
}
