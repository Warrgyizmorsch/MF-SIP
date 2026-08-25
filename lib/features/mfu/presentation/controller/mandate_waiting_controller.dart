// features/mfu/presentation/controller/mandate_waiting_controller.dart

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/features/mfu/data/model/mandate_status_req.dart';
import 'package:my_sip/features/mfu/domain/entity/emandate_status_entity.dart';
import 'package:my_sip/features/mfu/domain/entity/mandate_ui_status.dart';
import 'package:my_sip/features/mfu/domain/usecases/mfu_usecases.dart';

class MandateWaitingController extends GetxController
    with WidgetsBindingObserver {
  final MfuUseCases _mfuUseCases;

  final int userId;
  final String can;
  final String mumrn;
  final String? upiId;
  final String? maxAmount;
  final String? deepLink;

  MandateWaitingController({
    required MfuUseCases mfuUseCases,
    required this.userId,
    required this.can,
    required this.mumrn,
    this.upiId,
    this.maxAmount,
    this.deepLink,
  }) : _mfuUseCases = mfuUseCases;

  final uiStatus = MandateUiStatus.pendingApproval.obs;
  final isChecking = false.obs;
  final errorMessage = ''.obs;
  final statusEntity = Rxn<MfuMandateStatusEntity>();
  final pollCount = 0.obs;
  final hasTimedOutPolling = false.obs;

  Timer? _pollingTimer;

  static const int maxPollAttempts = 12; // 12 attempts * 4s = ~48s
  static const Duration pollInterval = Duration(seconds: 4);

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    checkMandateStatus();
    _startPolling();
  }

  @override
  void onClose() {
    _stopPolling();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      log(
        "[MandateWaitingController] App resumed -> checking mandate status immediately...",
      );
      if (!uiStatus.value.isTerminal) {
        checkMandateStatus();
      }
    }
  }

  void _startPolling() {
    _stopPolling();
    hasTimedOutPolling.value = false;
    _pollingTimer = Timer.periodic(pollInterval, (_) async {
      if (uiStatus.value.isTerminal) {
        _stopPolling();
        return;
      }

      if (pollCount.value >= maxPollAttempts) {
        log("[MandateWaitingController] Bounded polling time limit reached.");
        hasTimedOutPolling.value = true;
        _stopPolling();
        return;
      }

      pollCount.value++;
      await checkMandateStatus();
    });
  }

  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  Future<void> checkMandateStatus() async {
    if (isChecking.value) return;

    isChecking.value = true;
    errorMessage.value = '';

    try {
      final request = MfuMandateStatusRequest.upi(
        userId: userId,
        can: can,
        mumrn: mumrn,
      );

      final result = await _mfuUseCases.mfuMandateStatusUseCase(request);

      result.fold(
        (success) {
          final entity = success.data;
          statusEntity.value = entity;

          final mfuStat = entity?.response?.regStatus.isNotEmpty == true
              ? entity?.response?.regStatus
              : entity?.mandateStatus;
          final aggrStat = entity?.response?.aggrStatus;

          final newUiStatus = getMandateUiStatus(
            mfuStatus: mfuStat,
            aggrStatus: aggrStat,
          );

          log(
            "[MandateWaitingController] Polled status: MFU=$mfuStat, AGGR=$aggrStat -> UI=$newUiStatus",
          );

          uiStatus.value = newUiStatus;

          if (newUiStatus.isTerminal) {
            _stopPolling();
          }
        },
        (error) {
          log(
            "[MandateWaitingController] Status check network error: ${error.message}",
          );
          errorMessage.value =
              "Unable to check the status right now.\nYour mandate may still be processing.";
        },
      );
    } catch (e) {
      log("[MandateWaitingController] Unexpected status check error: $e");
      errorMessage.value =
          "Unable to check the status right now.\nYour mandate may still be processing.";
    } finally {
      isChecking.value = false;
    }
  }

  void retryPolling() {
    pollCount.value = 0;
    hasTimedOutPolling.value = false;
    errorMessage.value = '';
    checkMandateStatus();
    _startPolling();
  }

  String get maskedUpiId {
    if (upiId == null || upiId!.isEmpty) return 'UPI AutoPay';
    final parts = upiId!.split('@');
    if (parts.length != 2) return upiId!;
    final handle = parts[0];
    final domain = parts[1];

    if (handle.length <= 3) {
      return "${handle[0]}***@$domain";
    }
    final first = handle.substring(0, 2);
    final last = handle.substring(handle.length - 1);
    return "$first*****$last@$domain";
  }
}
