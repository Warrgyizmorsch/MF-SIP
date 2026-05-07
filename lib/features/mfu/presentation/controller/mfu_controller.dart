import 'package:get/get.dart';
import 'package:my_sip/features/mfu/domain/entity/can_register_entity.dart';
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
}
