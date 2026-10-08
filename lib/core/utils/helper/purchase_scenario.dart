import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_sip/common/widget/animated/dialog_button.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/features/mfu/presentation/controller/mfu_controller.dart';
import 'package:my_sip/features/personalization/presentation/controllers/personalisation_controller.dart';

class GatekeeperHelper {
  /// Runs the validation waterfall. If all checks pass, [onSuccess] is executed.
  static void runWithPrerequisites({
    required Function() onSuccess,
    bool isLumpsum = false,
  }) {
    final userCtrl = Get.find<PersonalisationController>();
    final bool isDesktop = Get.width > 600;

    // 🛑 1. Check KYC Status
    if (!userCtrl.isKycVerified.value) {
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
    final String canNumber = userData?.canNumber ?? '';
    final String canStatus = (userData?.canStatus ?? '').trim().toLowerCase();
    final String? canError = userData?.canErrorMessage;

    final bool isCanApproved =
        canNumber.isNotEmpty &&
        (canStatus == 'approved' || canStatus == 'active');

    if (!isCanApproved) {
      // If CAN is not approved yet, ensure Nominee is added first before CAN can be created
      if (!userCtrl.hasNominee.value) {
        DialogHelper.showPrerequisiteDialog(
          title: 'Nominee Details Required',
          message:
              'Please add a nominee to secure your investments and set up your investment account (CAN).',
          buttonText: 'Add Nominee',
          onTap: () {
            Get.back();
            Get.toNamed(AppRoutes.nomineeDetail, id: isDesktop ? 1 : null);
          },
        );
        return;
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
              'Your profile details are complete. We are setting up your Common Account Number (CAN) with MF Utility. If this takes longer than expected, please contact our support team at +91 78508 88522.',
          buttonText: 'Call Support',
          onTap: () async {
            Get.back();
            final Uri callUri = Uri(scheme: 'tel', path: '+917850888522');
            if (await canLaunchUrl(callUri)) {
              await launchUrl(callUri);
            }
          },
        );
      }
      return;
    }

    // 🛑 5. Check Mandate (Auto Pay) Status - Required ONLY for SIP purchases
    if (!isLumpsum && !userCtrl.hasApprovedMandate) {
      DialogHelper.showPrerequisiteDialog(
        title: 'Auto Pay Required',
        message:
            'Please set up your Auto Pay mandate to continue with your SIP purchase.',
        buttonText: 'Set Up Auto Pay',
        onTap: () {
          Get.back();
          Get.toNamed(
            AppRoutes.paymentScreen,
            arguments: {'isMandate': true, 'amount': '100000'},
            id: isDesktop ? 1 : null,
          );
        },
      );
      return;
    }

    // ✅ ALL CHECKS PASSED: Trigger the intended action!
    onSuccess();
  }
}
