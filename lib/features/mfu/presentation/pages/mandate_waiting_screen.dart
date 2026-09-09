// features/mfu/presentation/pages/mandate_waiting_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/features/mfu/domain/entity/mandate_ui_status.dart';
import 'package:my_sip/features/mfu/domain/usecases/mfu_usecases.dart';
import 'package:my_sip/features/mfu/presentation/controller/mandate_waiting_controller.dart';

class MandateWaitingScreen extends StatelessWidget {
  final int userId;
  final String can;
  final String mumrn;
  final String? upiId;
  final String? maxAmount;
  final String? deepLink;

  const MandateWaitingScreen({
    super.key,
    required this.userId,
    required this.can,
    required this.mumrn,
    this.upiId,
    this.maxAmount,
    this.deepLink,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      MandateWaitingController(
        mfuUseCases: Get.find<MfuUseCases>(),
        userId: userId,
        can: can,
        mumrn: mumrn,
        upiId: upiId,
        maxAmount: maxAmount,
        deepLink: deepLink,
      ),
      tag: "mandate_waiting_$mumrn",
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (controller.uiStatus.value.isTerminal) {
          Get.back();
        } else {
          _showExitConfirmation(context);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        // BEGIN: TopNavigationBar
        appBar: AppBar(
          backgroundColor: Colors.white.withValues(alpha: 0.95),
          elevation: 0,
          scrolledUnderElevation: 1,
          titleSpacing: 0,
          leading: IconButton(
            icon: const Icon(Icons.close_rounded, color: Color(0xFF334155)),
            onPressed: () {
              if (controller.uiStatus.value.isTerminal) {
                Get.back();
              } else {
                _showExitConfirmation(context);
              }
            },
          ),
          title: const Text(
            'Mandate Status',
            style: TextStyle(
              color: Color(0xFF0F172A),
              fontWeight: FontWeight.w600,
              fontSize: 16,
              letterSpacing: -0.2,
            ),
          ),
          actions: [
            Obx(() => _buildTopStatusBadge(controller.uiStatus.value)),
            const SizedBox(width: 14),
          ],
        ),
        // END: TopNavigationBar
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Obx(() {
                final status = controller.uiStatus.value;
                final isChecking = controller.isChecking.value;
                final hasError = controller.errorMessage.value.isNotEmpty;

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 14.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // BEGIN: HeroStatusCard
                      _buildHeroStatusCard(controller, status, isChecking),
                      const SizedBox(height: 14),

                      // BEGIN: NoticeAlertBanner
                      _buildNoticeAlertBanner(
                        controller,
                        status,
                        isChecking,
                        hasError,
                      ),
                      const SizedBox(height: 14),

                      // BEGIN: MandateDetailsCard
                      _buildMandateDetailsCard(context, controller),
                      const SizedBox(height: 14),

                      // BEGIN: GuideSection
                      if (!status.isTerminal) ...[
                        _buildGuideSection(),
                        const SizedBox(height: 14),
                      ],

                      // Bottom spacing to prevent overlap with sticky footer
                      const SizedBox(height: 100),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
        // BEGIN: BottomPersistentActions
        bottomNavigationBar: Obx(() {
          final status = controller.uiStatus.value;
          final isChecking = controller.isChecking.value;
          return _buildBottomActions(context, controller, status, isChecking);
        }),
      ),
    );
  }

  // ==========================================
  // TOP STATUS BADGE
  // ==========================================
  Widget _buildTopStatusBadge(MandateUiStatus status) {
    Color bg;
    Color border;
    Color dotColor;
    String label;
    Color textColor;

    switch (status) {
      case MandateUiStatus.active:
        bg = const Color(0xFFF0FDF4);
        border = const Color(0xFFBBF7D0);
        dotColor = const Color(0xFF16A34A);
        label = 'ACTIVE';
        textColor = const Color(0xFF15803D);
        break;
      case MandateUiStatus.rejected:
      case MandateUiStatus.cancelled:
      case MandateUiStatus.expired:
      case MandateUiStatus.revoked:
      case MandateUiStatus.paused:
        bg = const Color(0xFFFFF1F2);
        border = const Color(0xFFFECDD3);
        dotColor = const Color(0xFFE11D48);
        label = 'FAILED';
        textColor = const Color(0xFFBE123C);
        break;
      case MandateUiStatus.processing:
      case MandateUiStatus.pendingApproval:
      case MandateUiStatus.unknown:
        bg = const Color(0xFFFFFBEB);
        border = const Color(0xFFFDE68A);
        dotColor = const Color(0xFFF59E0B);
        label = 'IN PROGRESS';
        textColor = const Color(0xFFB45309);
        break;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.4,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // HERO STATUS CARD WITH 4-STEP LIVE STEPPER
  // ==========================================
  Widget _buildHeroStatusCard(
    MandateWaitingController controller,
    MandateUiStatus status,
    bool isChecking,
  ) {
    String heading;
    String subtitle;

    switch (status) {
      case MandateUiStatus.active:
        heading = 'Mandate Activated';
        subtitle =
            'We’ve received final confirmation from your bank. Your AutoPay mandate is ready for SIPs.';
        break;
      case MandateUiStatus.rejected:
      case MandateUiStatus.cancelled:
      case MandateUiStatus.expired:
      case MandateUiStatus.revoked:
      case MandateUiStatus.paused:
        heading = 'Mandate Not Approved';
        subtitle =
            'Your mandate request was not confirmed. Please retry or choose another UPI ID.';
        break;
      case MandateUiStatus.processing:
        heading = 'Bank Sync In Progress';
        subtitle =
            'We’ve safely received your mandate authorisation. Awaiting final confirmation from your bank.';
        break;
      case MandateUiStatus.pendingApproval:
      case MandateUiStatus.unknown:
        heading = 'Approval Received';
        subtitle =
            'We’ve safely received your mandate authorisation. Awaiting final confirmation from your bank.';
        break;
    }

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF0F7FF), Colors.white, Colors.white],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE0F2FE), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 18,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 22.0),
      child: Column(
        children: [
          // Center Animated Icon Graphic with Pulse Ring
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2FE).withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE0F2FE)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x08000000),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: isChecking
                        ? const SizedBox(
                            width: 26,
                            height: 26,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF0284C7),
                              ),
                            ),
                          )
                        : Icon(
                            status == MandateUiStatus.active
                                ? Icons.verified_rounded
                                : (status.isTerminal
                                      ? Icons.error_outline_rounded
                                      : Icons.sync_rounded),
                            color: status == MandateUiStatus.active
                                ? const Color(0xFF16A34A)
                                : (status.isTerminal
                                      ? const Color(0xFFE11D48)
                                      : const Color(0xFF0284C7)),
                            size: 28,
                          ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Heading & Reassuring Subtitle
          Text(
            heading,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12.5,
                color: Color(0xFF64748B),
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Stepper Timeline Tracker
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 16),
          _buildLiveStepper(status),
        ],
      ),
    );
  }

  Widget _buildLiveStepper(MandateUiStatus status) {
    // 0: Requested, 1: Approved, 2: Bank Sync, 3: Ready
    int activeIndex = 2; // Default is waiting for Bank Sync
    bool isFailed = false;

    switch (status) {
      case MandateUiStatus.pendingApproval:
      case MandateUiStatus.unknown:
        activeIndex = 1; // Step 1 completed, Step 2 active
        break;
      case MandateUiStatus.processing:
        activeIndex = 2; // Steps 1 & 2 completed, Step 3 active
        break;
      case MandateUiStatus.active:
        activeIndex = 3; // All 4 completed
        break;
      case MandateUiStatus.rejected:
      case MandateUiStatus.cancelled:
      case MandateUiStatus.expired:
      case MandateUiStatus.revoked:
      case MandateUiStatus.paused:
        activeIndex = 1;
        isFailed = true;
        break;
    }

    final stepLabels = ['Requested', 'Approved', 'Bank Sync', 'Ready'];

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            // Background track line
            Positioned(
              top: 13,
              left: 28,
              right: 28,
              child: Container(height: 2.5, color: const Color(0xFFE2E8F0)),
            ),
            // Emerald Fill line for completed steps
            Positioned(
              top: 13,
              left: 28,
              child: Container(
                height: 2.5,
                width:
                    (constraints.maxWidth - 56) *
                    ((status == MandateUiStatus.active
                        ? 3
                        : (activeIndex == 2 ? 0.66 : 0.33))),
                decoration: BoxDecoration(
                  color: isFailed
                      ? const Color(0xFFE11D48)
                      : const Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // 4 Step Nodes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(4, (index) {
                final isDone =
                    index < activeIndex ||
                    (index == 3 && status == MandateUiStatus.active);
                final isCurrent =
                    index == activeIndex && status != MandateUiStatus.active;

                Widget indicator;

                if (isDone) {
                  indicator = Container(
                    width: 26,
                    height: 26,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 14,
                    ),
                  );
                } else if (isCurrent) {
                  if (isFailed) {
                    indicator = Container(
                      width: 26,
                      height: 26,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE11D48),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 14,
                      ),
                    );
                  } else {
                    indicator = Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0284C7),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFE0F2FE),
                          width: 3.5,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  }
                } else {
                  indicator = Container(
                    width: 26,
                    height: 26,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE2E8F0),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: Color(0xFF94A3B8),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    indicator,
                    const SizedBox(height: 6),
                    Text(
                      stepLabels[index],
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: isCurrent || isDone
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: isCurrent
                            ? (isFailed
                                  ? const Color(0xFFE11D48)
                                  : const Color(0xFF0369A1))
                            : (isDone
                                  ? const Color(0xFF334155)
                                  : const Color(0xFF94A3B8)),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        );
      },
    );
  }

  // ==========================================
  // NOTICE ALERT BANNER
  // ==========================================
  Widget _buildNoticeAlertBanner(
    MandateWaitingController controller,
    MandateUiStatus status,
    bool isChecking,
    bool hasError,
  ) {
    if (status == MandateUiStatus.active) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FDF4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFBBF7D0)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Icon(
              Icons.check_circle_outline_rounded,
              color: Color(0xFF16A34A),
              size: 18,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Mandate is active and verified with your bank.',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF15803D),
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFD97706),
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Taking longer than expected?',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF78350F),
                      ),
                    ),
                    Text(
                      isChecking ? 'Checking...' : 'Updated 30s ago',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFB45309),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  hasError
                      ? 'The bank gateway is processing your confirmation. You can safely check again or return later.'
                      : 'Banks typically confirm mandates within 2 minutes. You can safely check again or return later.',
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF92400E),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // MANDATE DETAILS CARD
  // ==========================================
  Widget _buildMandateDetailsCard(
    BuildContext context,
    MandateWaitingController controller,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x060F172A),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Mandate Summary',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFA7F3D0)),
                ),
                child: const Text(
                  'Auto-Pay Authorized',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF059669),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 14),

          // UPI ID Row
          _buildDetailRowWithCopy(
            context,
            label: 'UPI ID',
            displayValue: controller.maskedUpiId,
            copyValue: upiId ?? controller.maskedUpiId,
          ),
          const SizedBox(height: 12),

          // Reference (UMN) Row
          _buildDetailRowWithCopy(
            context,
            label: 'Reference (UMN)',
            displayValue: mumrn,
            copyValue: mumrn,
            isMonospace: true,
          ),
          const SizedBox(height: 12),

          // Max Deductible Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Max Deductible Amount',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Up to ₹${maxAmount ?? '5,000'} ',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const TextSpan(
                      text: '/ cycle',
                      style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Frequency & Validity
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Frequency & Validity',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  'As presented • Until Revoked',
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRowWithCopy(
    BuildContext context, {
    required String label,
    required String displayValue,
    required String copyValue,
    bool isMonospace = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    displayValue,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontFamily: isMonospace ? 'monospace' : null,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: copyValue));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$label copied to clipboard'),
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(4),
                  child: const Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Icon(
                      Icons.copy_rounded,
                      size: 13,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // GUIDE SECTION
  // ==========================================
  Widget _buildGuideSection() {
    final apps = ['Google Pay', 'PhonePe', 'Paytm', 'BHIM'];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x060F172A),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F9FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: Color(0xFF0284C7),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'How Mandate Verification Works',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Supported App Badges
          Row(
            children: [
              const Text(
                'APPS',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: apps.map((app) {
                      return Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          app,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF475569),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 14),

          // Sequential 3-Step Guide
          _buildNumberedGuideStep(
            number: '1',
            text:
                'Keep your UPI app open or check incoming notification alerts for an AutoPay approval request.',
          ),
          const SizedBox(height: 12),
          _buildNumberedGuideStep(
            number: '2',
            text:
                'Enter your secured 4 or 6-digit UPI PIN to confirm the mandate authorization.',
          ),
          const SizedBox(height: 12),
          _buildNumberedGuideStep(
            number: '3',
            text:
                'Switch back to this screen. This page automatically marks complete once the issuer bank acknowledges.',
          ),
        ],
      ),
    );
  }

  Widget _buildNumberedGuideStep({
    required String number,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF475569),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // BOTTOM PERSISTENT ACTIONS
  // ==========================================
  Widget _buildBottomActions(
    BuildContext context,
    MandateWaitingController controller,
    MandateUiStatus status,
    bool isChecking,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        border: const Border(top: BorderSide(color: Color(0xFFE2E8F0))),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (status == MandateUiStatus.active) ...[
                // Success CTA
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF16A34A),
                    elevation: 0,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () => Get.back(result: 'success'),
                  child: const Text(
                    'Continue to Investment',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ] else if (status.isTerminal) ...[
                // Failure CTA
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    elevation: 0,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () => Get.back(result: 'retry'),
                  child: const Text(
                    'Try Again',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Get.back(result: 'change_upi'),
                  child: const Text(
                    'Choose Another UPI ID',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF475569),
                    ),
                  ),
                ),
              ] else ...[
                // Direct UPI DeepLink Button (if present)
                if (deepLink != null && deepLink!.isNotEmpty) ...[
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Ucolors.primary,
                      elevation: 0,
                      minimumSize: const Size(double.infinity, 46),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const Icon(
                      Icons.launch_rounded,
                      color: Colors.white,
                      size: 17,
                    ),
                    label: const Text(
                      'Open UPI App Directly',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      final uri = Uri.parse(deepLink!);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                ],

                // Primary Refresh CTA
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isChecking
                        ? const Color(0xFF334155)
                        : const Color(0xFF0F172A),
                    elevation: 0,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: isChecking
                      ? null
                      : () => controller.checkMandateStatus(),
                  icon: isChecking
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Icon(
                          Icons.sync_rounded,
                          size: 18,
                          color: Color(0xFFCBD5E1),
                        ),
                  label: Text(
                    isChecking ? 'Checking...' : 'Refresh Status',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Secondary Help & Cancel Actions
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => _showHelpBottomSheet(context),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 4,
                        ),
                        child: Text(
                          'Need Help?',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      ' • ',
                      style: TextStyle(color: Color(0xFFCBD5E1)),
                    ),
                    InkWell(
                      onTap: () => _showExitConfirmation(context),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 4,
                        ),
                        child: Text(
                          'Cancel Mandate',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFE11D48),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showHelpBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Mandate Authorization Help',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              '1. Did not receive notification?\nOpen your UPI app (Google Pay, PhonePe, Paytm, etc.) and go to Profile > AutoPay / Mandates.\n\n'
              '2. Is money debited now?\nNo, mandate registration only authorizes future SIP deductions on your chosen dates.\n\n'
              '3. Mandate failed?\nYou can cancel and enter another valid UPI ID or try again later.',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF475569),
                height: 1.45,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F172A),
                minimumSize: const Size(double.infinity, 44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text(
                'Understood',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: const [
            Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFD97706),
              size: 22,
            ),
            SizedBox(width: 8),
            Text(
              'Cancel Mandate?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          'Your UPI mandate check is active. If you exit or cancel now, this mandate request will be terminated and you can start afresh with another UPI ID.',
          style: TextStyle(
            fontSize: 13.5,
            color: Color(0xFF475569),
            height: 1.4,
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        actions: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Stay Here'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE11D48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              Get.back(result: 'change_upi');
            },
            child: const Text(
              'Cancel Mandate',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
