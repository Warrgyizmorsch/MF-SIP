// features/mfu/presentation/pages/mandate_waiting_screen.dart

import 'package:flutter/material.dart';
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
    // Register controller using tag or Get.put
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
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: const Text(
            'UPI Mandate Status',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black87),
            onPressed: () {
              if (controller.uiStatus.value.isTerminal) {
                Get.back();
              } else {
                _showExitConfirmation(context);
              }
            },
          ),
        ),
        body: SafeArea(
          child: Obx(() {
            final status = controller.uiStatus.value;
            final isChecking = controller.isChecking.value;
            final hasError = controller.errorMessage.value.isNotEmpty;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Status Header Card
                  _buildStatusCard(context, controller, status, isChecking),

                  const SizedBox(height: 20),

                  // Mandate Summary Details Card
                  _buildSummaryCard(controller),

                  const SizedBox(height: 20),

                  // Network/API Error Banner if present
                  if (hasError) ...[
                    _buildErrorCard(controller),
                    const SizedBox(height: 20),
                  ],

                  // Action Instructions Card
                  if (!status.isTerminal) _buildInstructionsCard(status),

                  const SizedBox(height: 30),

                  // Bottom Action Buttons
                  _buildActionButtons(context, controller, status),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildStatusCard(
    BuildContext context,
    MandateWaitingController controller,
    MandateUiStatus status,
    bool isChecking,
  ) {
    Color cardColor;
    Color iconColor;
    IconData iconData;

    switch (status) {
      case MandateUiStatus.active:
        cardColor = Colors.green.shade50;
        iconColor = Colors.green.shade700;
        iconData = Icons.check_circle_rounded;
        break;
      case MandateUiStatus.rejected:
      case MandateUiStatus.cancelled:
      case MandateUiStatus.expired:
      case MandateUiStatus.revoked:
      case MandateUiStatus.paused:
        cardColor = Colors.red.shade50;
        iconColor = Colors.red.shade700;
        iconData = Icons.error_rounded;
        break;
      case MandateUiStatus.processing:
        cardColor = Colors.blue.shade50;
        iconColor = Colors.blue.shade700;
        iconData = Icons.sync_rounded;
        break;
      case MandateUiStatus.pendingApproval:
      case MandateUiStatus.unknown:
        cardColor = Colors.amber.shade50;
        iconColor = Colors.amber.shade800;
        iconData = Icons.hourglass_top_rounded;
        break;
    }

    return Card(
      elevation: 0,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: iconColor.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Icon(iconData, size: 56, color: iconColor),
                if (isChecking)
                  SizedBox(
                    width: 70,
                    height: 70,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(iconColor),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              status.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: iconColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              status.subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade800,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(MandateWaitingController controller) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mandate Details',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Divider(height: 24),
            _buildDetailRow('UPI ID', controller.maskedUpiId),
            const SizedBox(height: 10),
            _buildDetailRow('Reference No (MUMRN)', mumrn),
            if (maxAmount != null && maxAmount!.isNotEmpty) ...[
              const SizedBox(height: 10),
              _buildDetailRow('Max Amount Limit', '₹$maxAmount'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorCard(MandateWaitingController controller) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.orange.shade800),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              controller.errorMessage.value,
              style: TextStyle(
                fontSize: 13,
                color: Colors.orange.shade900,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionsCard(MandateUiStatus status) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.info_outline, size: 20, color: Ucolors.primary),
                SizedBox(width: 8),
                Text(
                  'How to approve',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildStepRow(
              '1',
              'Open your UPI app (Google Pay, PhonePe, Paytm, BHIM, etc.).',
            ),
            const SizedBox(height: 8),
            _buildStepRow(
              '2',
              'Look for the Autopay / Mandate request notification.',
            ),
            const SizedBox(height: 8),
            _buildStepRow(
              '3',
              'Enter your UPI PIN to approve the AutoPay mandate.',
            ),
            const SizedBox(height: 8),
            _buildStepRow(
              '4',
              'Return to this app. The status will update automatically.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepRow(String step, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 10,
          backgroundColor: Ucolors.primary.withValues(alpha: 0.1),
          child: Text(
            step,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Ucolors.primary,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    MandateWaitingController controller,
    MandateUiStatus status,
  ) {
    if (status == MandateUiStatus.active) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade600,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () => Get.back(result: 'success'),
        child: const Text(
          'Continue',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }

    if (status.isTerminal) {
      return Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Ucolors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Get.back(result: 'retry'),
            child: const Center(
              child: Text(
                'Try Again',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Get.back(result: 'change_upi'),
            child: const Center(
              child: Text(
                'Choose Another UPI ID',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      );
    }

    // Pending / Processing State Buttons
    return Column(
      children: [
        if (deepLink != null && deepLink!.isNotEmpty) ...[
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Ucolors.primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.open_in_new, color: Colors.white),
            label: const Text(
              'Open UPI App',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              final uri = Uri.parse(deepLink!);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
          ),
          const SizedBox(height: 12),
        ],

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: controller.isChecking.value
                ? Colors.grey.shade400
                : Ucolors.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: controller.isChecking.value
              ? null
              : () => controller.checkMandateStatus(),
          child: Center(
            child: controller.isChecking.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Check Status',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),

        if (controller.hasTimedOutPolling.value) ...[
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => controller.retryPolling(),
            child: const Text(
              'Resume Auto Checking',
              style: TextStyle(fontSize: 14, color: Ucolors.primary),
            ),
          ),
        ],
      ],
    );
  }

  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Mandate Check In Progress'),
        content: const Text(
          'Your UPI mandate approval request is active. If you exit now, you can still check your mandate status later from your Profile or Bank Details.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Stay Here'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              Get.back();
            },
            child: const Text('Exit Page', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
