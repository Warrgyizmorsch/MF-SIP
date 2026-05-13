import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:my_sip/features/mfu/domain/entity/can_register_entity.dart';
import 'package:my_sip/features/mfu/domain/entity/can_status_entity.dart';
import 'package:my_sip/features/mfu/domain/entity/mandate_entity.dart';
import 'package:my_sip/features/mfu/domain/usecases/mfu_usecases.dart';
import 'package:my_sip/services/session_manager.dart';

class MfuController extends GetxController {
  final MfuUseCases mfuUseCases;
  final session = SessionManager.instance;

  MfuController(this.mfuUseCases);

  // ─── State ───────────────────────────────────────────────────────────────────

  final isLoading = false.obs;
  final mfuCanResponse = Rxn<MfuCanResponseEntity>();
  final errorMessage = ''.obs;

  final isLoadingCanStatus = false.obs;
  final canStatusResponse = Rxn<MfuCanStatusEntity>();

  // ─── Convenience Getters ─────────────────────────────────────────────────────

  String get canNumber => mfuCanResponse.value?.can ?? '';
  String get canStatus => mfuCanResponse.value?.canStatus ?? '';
  String get canStatusMessage => mfuCanResponse.value?.canStatusMessage ?? '';
  bool get isCanPending => canStatus.toLowerCase() == 'pending';

  List<BlockRespEntity> get blockRespList =>
      mfuCanResponse.value?.canStatusResponse?.respBody?.blockRespList ?? [];

  bool get hasRegistrationError =>
      mfuCanResponse.value?.canRegistrationResponse?.respHeader?.isSuccess ==
      false;

  String get registrationError =>
      mfuCanResponse.value?.canRegistrationResponse?.respHeader?.errorMsg ?? '';

  Timer? _canStatusTimer;
  static const _pollInterval = Duration(hours: 2);

  /// -------   Bank  -----------  //
  final selectedMethod = 'upi'.obs; // 'upi' | 'netbanking'
  final upiId = ''.obs;
  final isVerified = false.obs;
  final isVerifying = false.obs;

  void selectMethod(String method) {
    selectedMethod.value = method;
    isVerified.value = false;
    upiId.value = '';
  }

  Future<void> verifyUpi() async {
    if (upiId.value.isEmpty) return;
    isVerifying.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isVerified.value = true;
    isVerifying.value = false;
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
  Future<void> canRegister({String reqEvent = "CR"}) async {
    isLoading.value = true;
    errorMessage.value = '';

    final uid = session.getUserData?.id ?? 0;

    final result = await mfuUseCases.canRegisterUseCase(
      uid: uid,
      reqEvent: reqEvent,
    );

    result.fold(
      (success) {
        mfuCanResponse.value = success.data;
      },
      (error) {
        errorMessage.value = error.message ?? 'Something went wrong';
        Get.snackbar('MFU Error', errorMessage.value);
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
      },
      (error) {
        errorMessage.value = error.message ?? 'Something went wrong';
        Get.snackbar('MFU Error', errorMessage.value);
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

    if (canNumber.isNotEmpty && canStatus == 'pending') {
      log("[MfuController] 🔄 Resuming CAN status polling on app start");
      _startCanStatusPolling();
    }
  }

  /// ------   Mandate ----   ///
  final isCreatingMandate = false.obs;
  final mandateCreateResponse = Rxn<MfuMandateCreateEntity>();

  Future<void> createMandate({required String mandateType}) async {
    isCreatingMandate.value = true;
    errorMessage.value = '';

    final uid = session.getUserData?.id ?? 0;

    final result = await mfuUseCases.mfuMandateCreateUseCase(
      uid: uid,
      mandateType: mandateType,
    );

    result.fold(
      (success) {
        mandateCreateResponse.value = success.data;
        log(
          "[MfuController] Mandate created — type: $mandateType | mmrn: ${success.data?.mmrn}",
        );
      },
      (error) {
        errorMessage.value = error.message;
        Get.snackbar('Mandate Error', errorMessage.value);
      },
    );

    isCreatingMandate.value = false;
  }

  @override
  void onClose() {
    _stopCanStatusPolling();
    super.onClose();
  }
}
