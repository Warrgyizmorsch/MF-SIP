import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/helper/app_notice_manager.dart';
import 'package:my_sip/features/goal/presentation/bindings/goal_binding.dart';
import 'package:my_sip/features/goal/presentation/controller/goal_sip_controller.dart';
import 'package:my_sip/features/mfu/presentation/controller/mfu_controller.dart';
import 'package:my_sip/features/personalization/presentation/controllers/personalisation_controller.dart';
import 'package:my_sip/services/firebase_services.dart';
import 'package:my_sip/services/session_manager.dart';

class AppOpenAlertCoordinator {
  static const int notifIdKyc = 1001;
  static const int notifIdPersonal = 1002;
  static const int notifIdBank = 1003;
  static const int notifIdCan = 1004;
  static const int notifIdMandate = 1005;
  static const int notifIdNominee = 1006;
  static const int notifIdGoal = 1007;

  /// Evaluates the end-to-end investment prerequisite and onboarding waterfall on app open.
  /// Shows exactly ONE popup every time the app opens until that step is complete,
  /// progressing in strict priority:
  ///
  /// Phase 1: Foundation (3 Core Steps)
  ///   1. KYC Verification
  ///   2. Personal Info / Additional Details
  ///   3. Bank Account Linking
  ///
  /// Phase 2: Common Account Number (CAN)
  ///   4. CAN Registration & Approval (Auto-triggered once Phase 1 is complete)
  ///
  /// Phase 3: Investment Gateways
  ///   5. Mandate / Auto Pay (Required for automated SIP; Lumpsum can proceed directly)
  ///
  /// Phase 4: Enhancements
  ///   6. Nominee Addition (Secures investor portfolio)
  ///   7. Financial Goals (Goal-based wealth creation)
  static Future<void> checkAndShowAlerts(BuildContext context) async {
    // 0. Only check for authenticated users
    final token = SessionManager.instance.getAccessToken;
    if (token == null || token.isEmpty) return;

    final userCtrl = Get.isRegistered<PersonalisationController>()
        ? Get.find<PersonalisationController>()
        : null;
    final notifService = Get.isRegistered<NotificationService>()
        ? Get.find<NotificationService>()
        : null;

    if (userCtrl == null) return;

    // 0b. Wait for profile data to finish loading from server to prevent race conditions
    if (userCtrl.isProfileLoading.value) {
      try {
        await userCtrl.isProfileLoading.stream
            .firstWhere((loading) => !loading)
            .timeout(const Duration(seconds: 4));
      } catch (_) {}
    }

    // ═════════════════════════════════════════════════════════════════════════
    // PHASE 1: THE 3 CORE FOUNDATION PREREQUISITES
    // ═════════════════════════════════════════════════════════════════════════

    // ── STEP 1: KYC Verification ─────────────────────────────────────────────
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
      final shown = await AppNoticeManager.showNoticeIfEligible(
        noticeId: 'onboarding_kyc',
        frequency: NoticeFrequency.everyOpen,
        condition: () {
          final sKyc = (SessionManager.instance.getUserData?.kycStatus ?? '').trim().toLowerCase();
          final uKyc = (userCtrl.userData.value?.kycStatus ?? '').trim().toLowerCase();
          return !userCtrl.isKycVerified.value &&
              !SessionManager.instance.isKycVerified.value &&
              sKyc != 'approved' &&
              sKyc != 'verified' &&
              uKyc != 'approved' &&
              uKyc != 'verified';
        },
        title: 'Complete Your KYC',
        message:
            'Your KYC verification is currently incomplete. Complete your KYC now to unlock mutual fund investments.',
        primaryButtonText: 'Verify Now',
        secondaryButtonText: 'Remind Later',
        icon: Icons.verified_user_outlined,
        iconColor: Ucolors.primary,
        onPrimaryTap: () => Get.toNamed(AppRoutes.kycScreen),
        onSecondaryTap: () {
          notifService?.scheduleReminder(
            id: notifIdKyc,
            title: 'Complete Your KYC Verification',
            body:
                'Take 2 minutes to complete your KYC and unlock instant SIP investments.',
            delay: const Duration(hours: 3),
            targetRoute: AppRoutes.kycScreen,
          );
        },
      );
      if (shown) return;
    }

    // ── STEP 2: Personal Info / Additional Details ──────────────────────────
    if (!userCtrl.hasPersonalDetails.value) {
      final shown = await AppNoticeManager.showNoticeIfEligible(
        noticeId: 'onboarding_personal_info',
        frequency: NoticeFrequency.everyOpen,
        condition: () => !userCtrl.hasPersonalDetails.value,
        title: 'Personal Info Required',
        message:
            'Please complete your investor profile by providing personal and family details.',
        primaryButtonText: 'Add Details',
        secondaryButtonText: 'Remind Later',
        icon: Icons.person_outline,
        iconColor: Colors.blue.shade700,
        onPrimaryTap: () => Get.toNamed(AppRoutes.additionalInfo),
        onSecondaryTap: () {
          notifService?.scheduleReminder(
            id: notifIdPersonal,
            title: 'Complete Your Investor Profile',
            body:
                'Provide your family details to finish setting up your account.',
            delay: const Duration(hours: 4),
            targetRoute: AppRoutes.additionalInfo,
          );
        },
      );
      if (shown) return;
    }

    // ── STEP 3: Bank Account ────────────────────────────────────────────────
    if (!userCtrl.hasBank.value) {
      final shown = await AppNoticeManager.showNoticeIfEligible(
        noticeId: 'onboarding_bank',
        frequency: NoticeFrequency.everyOpen,
        condition: () => !userCtrl.hasBank.value,
        title: 'Link Your Bank Account',
        message:
            'Add your bank account to enable auto-debit for your SIPs and receive redemption payouts.',
        primaryButtonText: 'Add Bank',
        secondaryButtonText: 'Remind Later',
        icon: Icons.account_balance_outlined,
        iconColor: Colors.indigo,
        onPrimaryTap: () => Get.toNamed(AppRoutes.addanotherbank),
        onSecondaryTap: () {
          notifService?.scheduleReminder(
            id: notifIdBank,
            title: 'Link Bank Account for Investments',
            body:
                'Link your bank account to start SIP auto-debit and withdrawals.',
            delay: const Duration(hours: 4),
            targetRoute: AppRoutes.addanotherbank,
          );
        },
      );
      if (shown) return;
    }

    // ═════════════════════════════════════════════════════════════════════════
    // PHASE 2: CAN (COMMON ACCOUNT NUMBER) CREATION & APPROVAL
    // ═════════════════════════════════════════════════════════════════════════

    final userData = userCtrl.userData.value;
    final String canNumber = (userData?.canNumber ?? SessionManager.instance.getUserData?.canNumber ?? '').trim();
    final String canStatus = (userData?.canStatus ?? SessionManager.instance.getUserData?.canStatus ?? '').trim().toLowerCase();
    final String? canError = userData?.canErrorMessage;

    // Only auto-trigger CAN registration if user has no CAN and is not cancelled/rejected
    if (canNumber.isEmpty && canStatus.isEmpty && (canError == null || canError.isEmpty)) {
      userCtrl.checkAndTriggerCanRegistration();
    }

    final bool isCanApproved = canNumber.isNotEmpty &&
        (canStatus == 'approved' || canStatus == 'active');

    if (!isCanApproved) {
      String canTitle = 'CAN Account Action Needed';
      String canMessage =
          'Your Common Account Number (CAN) requires setup or verification to enable investments.';
      String canBtnText = 'Resolve Issue';
      VoidCallback onCanTap =
          () => userCtrl.checkAndTriggerCanRegistration(isManualTrigger: true);

      if (canStatus == 'cancelled') {
        canTitle = 'CAN Account Cancelled';
        canMessage =
            'Your investment account (CAN) has been cancelled by MFU/KRA. Please contact our support team at +91 78508 88522 for assistance.';
        canBtnText = 'Call Support';
        onCanTap = () async {
          final Uri callUri = Uri(scheme: 'tel', path: '+917850888522');
          if (await canLaunchUrl(callUri)) {
            await launchUrl(callUri);
          }
        };
      } else if (canError != null && canError.isNotEmpty) {
        canTitle = 'CAN Registration Failed';
        canMessage =
            'We could not generate your CAN because:\n\n"$canError"\n\nPlease resolve this issue to proceed.';
        canBtnText = 'Try Again';
        onCanTap =
            () => userCtrl.checkAndTriggerCanRegistration(isManualTrigger: true);
      } else if (canStatus.contains('pending') ||
          canStatus.contains('hold') ||
          canStatus.contains('process') ||
          canStatus == 'verified') {
        canTitle = 'Account Activation Pending';
        canMessage =
            'Your investment account (CAN) is currently being set up by MF Utility. Orders will unlock once account activation completes.';
        canBtnText = 'Check Status';
        onCanTap = () {
          if (Get.isRegistered<MfuController>()) {
            Get.find<MfuController>().getCanStatus();
          }
        };
      } else {
        canTitle = 'Account Setup In Progress';
        canMessage =
            'Your profile details are complete. We are setting up your Common Account Number (CAN) with MF Utility to enable mutual fund investing.';
        canBtnText = 'Check Status';
        onCanTap = () {
          if (Get.isRegistered<MfuController>()) {
            Get.find<MfuController>().getCanStatus();
          }
        };
      }

      final shown = await AppNoticeManager.showNoticeIfEligible(
        noticeId: 'onboarding_can',
        frequency: NoticeFrequency.everyOpen,
        condition: () => true,
        title: canTitle,
        message: canMessage,
        primaryButtonText: canBtnText,
        secondaryButtonText: 'Remind Later',
        icon: Icons.warning_amber_rounded,
        iconColor: Colors.red.shade700,
        onPrimaryTap: onCanTap,
        onSecondaryTap: () {
          final bool isCancelled = canStatus == 'cancelled';
          notifService?.scheduleReminder(
            id: notifIdCan,
            title: isCancelled
                ? 'CAN Account Cancelled'
                : 'Action Required on Your CAN Account',
            body: isCancelled
                ? 'Your CAN account has been cancelled. Please contact our support team at +91 78508 88522.'
                : 'Please verify your MFU investment account to unlock mutual fund orders.',
            delay: const Duration(hours: 4),
            targetRoute: AppRoutes.personaldetails,
          );
        },
      );
      if (shown) return;
    }

    // ═════════════════════════════════════════════════════════════════════════
    // PHASE 3: INVESTMENT GATEWAYS (SIP MANDATE)
    // ═════════════════════════════════════════════════════════════════════════

    if (!userCtrl.hasApprovedMandate) {
      final bool isDesktop = Get.width > 600;

      final shown = await AppNoticeManager.showNoticeIfEligible(
        noticeId: 'onboarding_mandate',
        frequency: NoticeFrequency.everyOpen,
        condition: () => !userCtrl.hasApprovedMandate,
        title: 'Set Up Auto Pay',
        message:
            'Set up your Auto Pay mandate to enable automated deductions for monthly SIP investments. (You can also invest directly via Lumpsum without a mandate!)',
        primaryButtonText: 'Set Up Auto Pay',
        secondaryButtonText: 'Remind Later',
        icon: Icons.payment_rounded,
        iconColor: Ucolors.primary,
        onPrimaryTap: () => Get.toNamed(
          AppRoutes.paymentScreen,
          arguments: {'isMandate': true, 'amount': '100000'},
          id: isDesktop ? 1 : null,
        ),
        onSecondaryTap: () {
          notifService?.scheduleReminder(
            id: notifIdMandate,
            title: 'Set Up Auto Pay Mandate',
            body:
                'Set up your auto-pay mandate to unlock automated monthly SIP investments.',
            delay: const Duration(hours: 4),
            targetRoute: AppRoutes.paymentScreen,
            extraData: {'isMandate': true, 'amount': '100000'},
          );
        },
      );
      if (shown) return;
    }

    // ═════════════════════════════════════════════════════════════════════════
    // PHASE 4: ENHANCEMENTS (NOMINEE & GOALS)
    // ═════════════════════════════════════════════════════════════════════════

    // ── STEP 6: Nominee (Protect Investments) ───────────────────────────────
    if (!userCtrl.hasNominee.value) {
      final shown = await AppNoticeManager.showNoticeIfEligible(
        noticeId: 'onboarding_nominee',
        frequency: NoticeFrequency.everyOpen,
        condition: () => !userCtrl.hasNominee.value,
        title: 'Add a Nominee',
        message:
            'Protect your investments and secure your family’s financial future by nominating a beneficiary to your portfolio.',
        primaryButtonText: 'Add Nominee',
        secondaryButtonText: 'Remind Later',
        icon: Icons.family_restroom_rounded,
        iconColor: Colors.deepOrange,
        onPrimaryTap: () => Get.toNamed(AppRoutes.nomineeDetail),
        onSecondaryTap: () {
          notifService?.scheduleReminder(
            id: notifIdNominee,
            title: 'Add a Nominee for Your Portfolio',
            body:
                'Ensure financial security for your family by adding a nominee in just 2 minutes.',
            delay: const Duration(hours: 6),
            targetRoute: AppRoutes.nomineeDetail,
          );
        },
      );
      if (shown) return;
    }

    // ── STEP 7: Goal Planning (Targeted Wealth Creation) ─────────────────────
    if (!Get.isRegistered<GoalSipController>()) {
      try {
        GoalBinding().dependencies();
      } catch (_) {}
    }

    if (Get.isRegistered<GoalSipController>()) {
      final goalCtrl = Get.find<GoalSipController>();
      final bool hasAnyCreatedGoal =
          goalCtrl.masterGoals.any((g) => g.isCreated);
      final bool hasUserGoals =
          (goalCtrl.goalResponse.value?.data ?? []).isNotEmpty;

      if (!hasAnyCreatedGoal && !hasUserGoals) {
        final shown = await AppNoticeManager.showNoticeIfEligible(
          noticeId: 'onboarding_goals',
          frequency: NoticeFrequency.everyOpen,
          condition: () {
            if (!Get.isRegistered<GoalSipController>()) return false;
            final gCtrl = Get.find<GoalSipController>();
            return !gCtrl.masterGoals.any((g) => g.isCreated) &&
                (gCtrl.goalResponse.value?.data ?? []).isEmpty;
          },
          title: 'Plan Your Financial Goals',
          message:
              'Map your investments to real-life dreams like Retirement, Child Education, or Dream Home with personalized SIP goals.',
          primaryButtonText: 'Explore Goals',
          secondaryButtonText: 'Remind Later',
          icon: Icons.flag_rounded,
          iconColor: Colors.teal,
          onPrimaryTap: () => Get.toNamed(AppRoutes.masterGoalsPage),
          onSecondaryTap: () {
            notifService?.scheduleReminder(
              id: notifIdGoal,
              title: 'Create Your First Financial Goal',
              body:
                  'Map your mutual fund investments to specific life milestones.',
              delay: const Duration(hours: 12),
              targetRoute: AppRoutes.masterGoalsPage,
            );
          },
        );
        if (shown) return;
      }
    }
  }
}
