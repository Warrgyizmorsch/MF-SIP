import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_sip/common/widget/animated/dialog_button.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/features/mfu/presentation/controller/mfu_controller.dart';
import 'package:my_sip/features/personalization/presentation/controllers/personalisation_controller.dart';
import 'package:my_sip/services/session_manager.dart';

class GatekeeperHelper {
  /// Runs the validation waterfall for investments.
  /// Sequential Order:
  /// 1. KYC Approved
  /// 2. Personal Details (Additional Info) Complete
  /// 3. Bank Account Linked
  /// 4. CAN (Common Account Number) Approved
  /// 5. Mandate (Auto Pay) Approved -- required ONLY for SIP purchases.
  ///    Lumpsum investments bypass the mandate requirement completely.
  /// If [onInvestAsLumpsum] is provided and user attempts SIP without a mandate,
  /// they are given the option to switch and invest as Lumpsum directly.
  static void runWithPrerequisites({
    required Function() onSuccess,
    bool isLumpsum = false,
    VoidCallback? onInvestAsLumpsum,
  }) {
    final userCtrl = Get.find<PersonalisationController>();
    final bool isDesktop = Get.width > 600;

    // 🛑 1. Check KYC Status
    final String sessionKyc =
        (SessionManager.instance.getUserData?.kycStatus ?? '').trim().toLowerCase();
    final String userCtrlKyc =
        (userCtrl.userData.value?.kycStatus ?? '').trim().toLowerCase();

    final bool isKycDone = userCtrl.isKycVerified.value ||
        SessionManager.instance.isKycVerified.value ||
        sessionKyc == 'approved' ||
        sessionKyc == 'verified' ||
        userCtrlKyc == 'approved' ||
        userCtrlKyc == 'verified';

    if (isKycDone) {
      userCtrl.isKycVerified.value = true;
    }

    if (!isKycDone) {
      DialogHelper.showPrerequisiteDialog(
        title: 'KYC Required',
        message:
            'Your KYC verification is pending or incomplete. Please complete your KYC to invest.',
        buttonText: 'Complete KYC',
        onTap: () {
          Get.back();
          Get.toNamed(AppRoutes.kycScreen, id: isDesktop ? 1 : null);
        },
      );
      return;
    }

    // 🛑 2. Check Additional Info (Personal Details)
    if (!userCtrl.hasPersonalDetails.value) {
      DialogHelper.showPrerequisiteDialog(
        title: 'Additional Info Required',
        message:
            'Please provide a few more personal details (like family details) to complete your investor profile.',
        buttonText: 'Add Details',
        onTap: () {
          Get.back();
          Get.toNamed(AppRoutes.additionalInfo, id: isDesktop ? 1 : null);
        },
      );
      return;
    }

    // 🛑 3. Check Bank Account
    if (!userCtrl.hasBank.value) {
      DialogHelper.showPrerequisiteDialog(
        title: 'Bank Account Required',
        message:
            'Please link a bank account to process your investments and receive withdrawals.',
        buttonText: 'Add Bank',
        onTap: () {
          Get.back();
          Get.toNamed(AppRoutes.addanotherbank, id: isDesktop ? 1 : null);
        },
      );
      return;
    }

    // 🛑 4. Check CAN (Common Account Number) Status & Approval
    final userData = userCtrl.userData.value;
    final String canNumber = (userData?.canNumber ?? SessionManager.instance.getUserData?.canNumber ?? '').trim();
    final String canStatus = (userData?.canStatus ?? SessionManager.instance.getUserData?.canStatus ?? '').trim().toLowerCase();
    final String? canError = userData?.canErrorMessage;

    final bool isCanApproved =
        canNumber.isNotEmpty &&
        (canStatus == 'approved' || canStatus == 'active');

    if (!isCanApproved) {
      // Auto-trigger registration only if CAN does not exist and is not cancelled/rejected
      if (canNumber.isEmpty && canStatus.isEmpty && (canError == null || canError.isEmpty)) {
        userCtrl.checkAndTriggerCanRegistration();
      }

      if (canStatus == 'cancelled') {
        DialogHelper.showPrerequisiteDialog(
          title: 'CAN Account Cancelled',
          message:
              'Your investment account (CAN) has been cancelled by MFU/KRA. Please contact our support team at +91 78508 88522 for assistance.',
          buttonText: 'Call Support',
          onTap: () async {
            Get.back();
            final Uri callUri = Uri(scheme: 'tel', path: '+917850888522');
            if (await canLaunchUrl(callUri)) {
              await launchUrl(callUri);
            }
          },
        );
      } else if (canStatus.contains('pending') ||
          canStatus.contains('hold') ||
          canStatus.contains('process') ||
          canStatus == 'verified') {
        DialogHelper.showPrerequisiteDialog(
          title: 'Account Activation Pending',
          message:
              'Your investment account (CAN) is currently being set up by MF Utility. Orders will unlock as soon as account activation completes.',
          buttonText: 'Check Status',
          onTap: () {
            Get.back();
            if (Get.isRegistered<MfuController>()) {
              Get.find<MfuController>().getCanStatus();
            }
          },
        );
      } else if (canError != null && canError.isNotEmpty) {
        DialogHelper.showPrerequisiteDialog(
          title: 'CAN Registration Failed',
          message:
              'We could not generate your CAN because: \n\n"$canError"\n\nPlease resolve this issue to proceed.',
          buttonText: 'Try Again',
          onTap: () {
            userCtrl.checkAndTriggerCanRegistration(isManualTrigger: true);
            Get.back();
          },
        );
      } else {
        DialogHelper.showPrerequisiteDialog(
          title: 'Account Setup In Progress',
          message:
              'Your profile details are complete. We are setting up your Common Account Number (CAN) with MF Utility to enable mutual fund investing.',
          buttonText: 'Check Status',
          onTap: () {
            Get.back();
            if (Get.isRegistered<MfuController>()) {
              Get.find<MfuController>().getCanStatus();
            }
          },
        );
      }
      return;
    }

    // 🛑 5. Check Mandate (Auto Pay) Status - Required ONLY for SIP purchases
    if (!isLumpsum && !userCtrl.hasApprovedMandate) {
      DialogHelper.showPrerequisiteDialog(
        title: 'Auto Pay Required for SIP',
        message:
            'Auto Pay mandate is required for automated monthly SIP investments. Would you like to set up Auto Pay, or invest as Lumpsum today without a mandate?',
        buttonText: 'Set Up Auto Pay',
        onTap: () {
          Get.back();
          Get.toNamed(
            AppRoutes.paymentScreen,
            arguments: {'isMandate': true, 'amount': '100000'},
            id: isDesktop ? 1 : null,
          );
        },
        secondaryButtonText:
            onInvestAsLumpsum != null ? 'Invest as Lumpsum' : null,
        onSecondaryTap: onInvestAsLumpsum != null
            ? () {
                Get.back();
                onInvestAsLumpsum();
              }
            : null,
      );
      return;
    }

    // ✅ ALL CHECKS PASSED: Trigger the intended action!
    onSuccess();
  }
}
