import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/animated/dialog_button.dart';
import 'package:my_sip/common/widget/animated/popups.dart';
import 'package:my_sip/common/widget/shimmer/shimmer.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/sizes.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/personalization/presentation/controllers/personalisation_controller.dart';
import 'package:my_sip/services/session_manager.dart';
import 'package:url_launcher/url_launcher.dart';

/// Presents the existing seven-step onboarding state using the reference card.
class HomeOnboardingCard extends StatelessWidget {
  const HomeOnboardingCard({
    super.key,
    required this.controller,
    required this.onExplore,
    required this.scale,
  });

  final PersonalisationController controller;
  final VoidCallback onExplore;
  final double scale;

  @override
  Widget build(BuildContext context) => Obx(() {
    if (controller.isProfileLoading.value) {
      return UShimmerEffect(
        width: double.infinity,
        height: 136 * scale,
        radius: USizes.homePanelRadius * scale,
        text: 'Fetching your profile...',
      );
    }
    final state = _status();
    return Semantics(
      button: true,
      label: '${state.title}. ${state.completed}/7 steps complete.',
      child: Container(
        decoration: BoxDecoration(
          gradient: Ucolors.homeOnboardingGradient,
          borderRadius: BorderRadius.circular(USizes.homePanelRadius * scale),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(USizes.homePanelRadius * scale),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: state.onTap,
            child: Padding(
              padding: EdgeInsets.all(16 * scale),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.title,
                    style: UTextStyles.homeText(
                      size: (16 * scale).clamp(14.0, 19.0).toDouble(),
                      weight: FontWeight.w700,
                      color: Ucolors.homeOnboardingText,
                      height: 1.25,
                    ),
                  ),
                  SizedBox(height: 12 * scale),
                  Wrap(
                    spacing: 8 * scale,
                    runSpacing: 6 * scale,
                    children: [
                      _pill(
                        '${state.completed}/7 steps',
                        Ucolors.homeProgress,
                        Ucolors.homeProgressInk,
                      ),
                      _pill(
                        state.issue
                            ? 'Action Required'
                            : state.completed == 7
                            ? 'Ready to Invest'
                            : 'Onboarding Task',
                        Ucolors.homeOnboardingText,
                        Ucolors.homeOnboardingBadgeText,
                      ),
                    ],
                  ),
                  SizedBox(height: 12 * scale),
                  Semantics(
                    label: 'Onboarding progress',
                    value: '${(state.completed / 7 * 100).round()} percent',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3 * scale),
                      child: LinearProgressIndicator(
                        value: state.completed / 7,
                        minHeight: 6 * scale,
                        backgroundColor: Ucolors.homeOnboardingText,
                        valueColor: const AlwaysStoppedAnimation(
                          Ucolors.homeProgress,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12 * scale),
                  Text(
                    state.message,
                    style: UTextStyles.homeText(
                      size: (12 * scale).clamp(11.0, 14.0).toDouble(),
                      color: Ucolors.homeOnboardingText,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  });

  Widget _pill(String label, Color background, Color foreground) => Container(
    padding: EdgeInsets.symmetric(horizontal: 12 * scale, vertical: 6 * scale),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      label,
      style: UTextStyles.homeText(
        size: (12 * scale).clamp(10.0, 14.0).toDouble(),
        weight: FontWeight.w700,
        color: foreground,
        height: 1.2,
      ),
    ),
  );

  _OnboardingStatus _status() {
    final session = SessionManager.instance;
    final user = controller.userData.value;
    final sessionUser = session.getUserData;
    final sessionKyc = (sessionUser?.kycStatus ?? '').trim().toLowerCase();
    final profileKyc = (user?.kycStatus ?? '').trim().toLowerCase();
    final verified =
        controller.isKycVerified.value ||
        session.isKycVerified.value ||
        const ['approved', 'verified'].contains(sessionKyc) ||
        const ['approved', 'verified'].contains(profileKyc);
    const pendingStatuses = [
      'pending',
      'in progress',
      'submitted',
      'under review',
    ];
    final pending =
        !verified &&
        (controller.isKycPending.value ||
            session.isKycPending.value ||
            pendingStatuses.contains(sessionKyc) ||
            pendingStatuses.contains(profileKyc));
    final personal = controller.hasPersonalDetails.value;
    final risk = controller.hasRiskProfile.value;
    final bank = controller.hasBank.value;
    final nominee = controller.hasNominee.value;
    final canNumber = user?.canNumber ?? sessionUser?.canNumber ?? '';
    final canStatus = (user?.canStatus ?? sessionUser?.canStatus ?? '')
        .trim()
        .toLowerCase();
    final can = canNumber.isNotEmpty && canStatus == 'approved';
    final canError = (user?.canErrorMessage ?? '').trim();
    final mandate = controller.hasApprovedMandate;
    final completed = [
      verified,
      personal,
      risk,
      bank,
      nominee,
      can,
      mandate,
    ].where((done) => done).length;

    _OnboardingStatus status(
      String title,
      String message,
      VoidCallback action, {
      bool issue = false,
    }) => _OnboardingStatus(title, message, completed, action, issue: issue);

    void openStep(String route) {
      controller.isContinuousOnboarding.value = true;
      Get.toNamed(route);
    }

    if (!verified && !pending && controller.kycErrorMessage.isNotEmpty) {
      return status(
        'KYC Verification Failed',
        controller.kycErrorMessage,
        () => openStep(AppRoutes.kycScreen),
        issue: true,
      );
    }
    if (!verified && !pending) {
      return status(
        'Complete KYC & Profile',
        'Verify your identity to start investing',
        () => openStep(AppRoutes.kycScreen),
      );
    }
    if (!personal) {
      return status(
        'Complete Profile Details',
        'Add your income and family details',
        () => openStep(AppRoutes.additionalInfo),
      );
    }
    if (!risk) {
      return status(
        'Check Your Risk Profile',
        'Discover your investment style',
        () => openStep(AppRoutes.riskProfile),
      );
    }
    if (!bank) {
      return status(
        'Add Bank Account',
        'Link your bank for fast transactions',
        () => openStep(AppRoutes.addanotherbank),
      );
    }
    if (!nominee) {
      return status(
        'Add a Nominee',
        'Secure your investments for your family',
        () => openStep(AppRoutes.nomineeDetail),
      );
    }
    if (pending) {
      return status(
        'KYC Under Verification',
        'Your KYC verification is in progress',
        () => ULoaders.info(
          title: 'KYC Verification In Progress',
          message:
              'Your KYC documents have been submitted to KRA/CAMS. Verification '
              'typically takes 2–3 business days. You can continue completing '
              'your profile in the meantime.',
        ),
      );
    }
    if (canStatus == 'cancelled' || canStatus == 'rejected') {
      return status(
        canStatus == 'cancelled'
            ? 'CAN Account Cancelled'
            : 'CAN Account Rejected',
        'Contact support at +91 78508 88522 for assistance',
        () => DialogHelper.showPrerequisiteDialog(
          title: 'Investment Account Unavailable',
          message:
              'Please contact our support team for help with your investment account.',
          buttonText: 'Call Support',
          onTap: () async {
            Get.back();
            final uri = Uri(scheme: 'tel', path: '+917850888522');
            if (await canLaunchUrl(uri)) await launchUrl(uri);
          },
        ),
        issue: true,
      );
    }
    if (!can && canError.isNotEmpty) {
      return status(
        'Registration Issue',
        canError,
        () => DialogHelper.showPrerequisiteDialog(
          title: 'Registration Issue',
          message:
              '$canError\n\nPlease update your details to resolve this issue.',
          buttonText: 'Update Details',
          onTap: () {
            Get.back();
            Get.toNamed(AppRoutes.personaldetails);
          },
        ),
        issue: true,
      );
    }
    if (!can) {
      return status(
        'Setting Up Investment Account',
        'Approve the consent link sent to your registered email and SMS',
        () {
          controller.checkAndTriggerCanRegistration(isManualTrigger: true);
          DialogHelper.showPrerequisiteDialog(
            title: 'Account Activation In Progress',
            message:
                'Open the consent link sent to your registered email and SMS by '
                'MF Utility and approve it. If already approved, your account '
                'will be activated once processing is complete.',
            buttonText: 'Okay, Got It',
            onTap: () => Get.back(),
          );
        },
      );
    }
    if (!mandate) {
      return status(
        'Setup Bank Mandate (AutoPay)',
        'Link your bank to enable automatic SIP deductions',
        () => Get.toNamed(AppRoutes.bankDetails),
      );
    }
    return status(
      'Your Account Is Ready',
      'Explore mutual funds and start your investment journey',
      onExplore,
    );
  }
}

class _OnboardingStatus {
  const _OnboardingStatus(
    this.title,
    this.message,
    this.completed,
    this.onTap, {
    this.issue = false,
  });

  final String title;
  final String message;
  final int completed;
  final VoidCallback onTap;
  final bool issue;
}
