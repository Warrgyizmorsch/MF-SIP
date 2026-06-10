import 'package:get/get.dart';
import 'package:my_sip/common/widget/animated/dialog_button.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/features/personalization/presentation/controllers/personalisation_controller.dart';

class GatekeeperHelper {
  /// Runs the validation waterfall. If all checks pass, [onSuccess] is executed.
  static void runWithPrerequisites({required Function() onSuccess}) {
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

    // 🛑 4. Check CAN (Common Account Number) Status
    final userData = userCtrl.userData.value;
    final String? canNumber = userData?.canNumber;
    final String? canError = userData?.canErrorMessage;

    if (canNumber == null || canNumber.isEmpty) {
      if (canError != null && canError.isNotEmpty) {
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
          title: 'CAN Registration Pending',
          message:
              'Your Common Account Number (CAN) has not been generated or approved yet. This is mandatory for mutual fund investments.',
          buttonText: 'Check Status',
          onTap: () {
            Get.back();
            Get.toNamed(AppRoutes.profilePage, id: isDesktop ? 1 : null);
          },
        );
      }
      return;
    }

    // 🛑 5. Check Mandate (Auto Pay) Status
    if (!userCtrl.hasApprovedMandate) {
      DialogHelper.showPrerequisiteDialog(
        title: 'Auto Pay Required',
        message:
            'Please set up your Auto Pay mandate to continue with your purchase.',
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
