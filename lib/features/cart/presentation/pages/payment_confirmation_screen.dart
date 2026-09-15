import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/animated/custom_toast.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/mfu/presentation/controller/mfu_controller.dart';
import 'package:my_sip/navigation_menu_bar.dart';

class PaymentConfirmationScreen extends StatefulWidget {
  const PaymentConfirmationScreen({super.key});

  @override
  State<PaymentConfirmationScreen> createState() =>
      _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState extends State<PaymentConfirmationScreen> {
  late Map<String, dynamic> args;
  late String gorn;
  late String orderId;
  late String entGroupRefNo;
  late String orderDate;
  late String amount;
  late bool isLumpsum;
  late int fundsCount;

  String _status = '';
  bool _isCheckingStatus = false;

  @override
  void initState() {
    super.initState();
    args = (Get.arguments as Map<String, dynamic>?) ?? {};
    gorn = args['gorn']?.toString() ?? 'N/A';
    orderId = args['orderId']?.toString() ?? '';
    entGroupRefNo = args['entGroupRefNo']?.toString() ?? gorn;
    orderDate = args['orderDate']?.toString() ?? '';
    amount = args['amount'] != null
        ? '₹${NumberFormat('#,##,###').format(args['amount'])}'
        : '₹--';
    isLumpsum = args['isLumpsum'] == true;
    fundsCount = (args['fundsCount'] as int?) ?? 1;
    _status = (args['status']?.toString() ?? 'PROCESSING').toUpperCase();
  }

  void _navigateToDashboard({int targetTab = 0}) {
    Get.offAllNamed(AppRoutes.navMenuBar);
    try {
      if (Get.isRegistered<NavigationBarController>()) {
        final navCtrl = Get.find<NavigationBarController>();
        navCtrl.changePage(2, isDesktop: kIsWeb);
      }
    } catch (_) {}
  }

  Future<void> _checkStatusAgain() async {
    if (entGroupRefNo.isEmpty || entGroupRefNo == 'N/A') return;
    setState(() => _isCheckingStatus = true);

    try {
      final mfuCtrl = Get.find<MfuController>();
      final todayStr = orderDate.isNotEmpty
          ? orderDate
          : DateTime.now().toIso8601String().split('T')[0];

      final res = await mfuCtrl.evaluateOverallTxnStatus(
        entGroupRefNo: entGroupRefNo,
        mfuGorn: gorn,
        orderDate: todayStr,
        stType: isLumpsum ? 'NORMAL-TXN' : 'SYS-TXN',
      );

      if (!mounted) return;
      setState(() {
        _status = res;
        _isCheckingStatus = false;
      });

      if (res == 'CONFIRMED') {
        CustomSnackbar.success(
          title: 'Payment Confirmed! 🎉',
          message: 'Your investment order is confirmed by MFU.',
        );
      } else if (res == 'REJECTED') {
        CustomSnackbar.error(
          title: 'Order Unsuccessful',
          message: 'The transaction was declined by bank or MFU.',
        );
      } else {
        CustomSnackbar.info(
          title: 'Status: Processing',
          message:
              'Payment is still being processed by your bank. Please check again in a moment.',
        );
      }
    } catch (_) {
      if (mounted) setState(() => _isCheckingStatus = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat(
      'dd MMM yyyy, hh:mm a',
    ).format(DateTime.now());

    final bool isConfirmed =
        _status == 'CONFIRMED' || _status == 'AC' || _status == 'OA';
    final bool isFailed =
        _status == 'REJECTED' ||
        _status == 'RJ' ||
        _status == 'OR' ||
        _status == 'CL' ||
        _status == 'FAILED';
    final bool isProcessing = !isConfirmed && !isFailed;

    final Color statusColor = isConfirmed
        ? Colors.green
        : isFailed
        ? Colors.red
        : Colors.orange.shade800;

    final String statusLabel = isConfirmed
        ? 'Confirmed'
        : isFailed
        ? 'Rejected'
        : 'Processing';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _navigateToDashboard();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xffF4F7FB),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              tooltip: 'Close',
              icon: const Icon(Icons.close, color: Colors.black87),
              onPressed: () => _navigateToDashboard(),
            ),
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: UPadding.screenPadding,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 550),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: isFailed
                          ? Colors.red.withValues(alpha: 0.12)
                          : isConfirmed
                          ? const Color(0xffE8F5E9)
                          : Colors.amber.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        isFailed
                            ? Icons.cancel_outlined
                            : isConfirmed
                            ? Icons.check_circle_rounded
                            : Icons.access_time_rounded,
                        size: 56,
                        color: isFailed
                            ? Colors.red
                            : isConfirmed
                            ? Colors.green.shade700
                            : Colors.amber.shade800,
                      ),
                    ),
                  ),
                  const Gap(20),

                  Text(
                    isFailed
                        ? 'Payment or Order Unsuccessful ❌'
                        : isConfirmed
                        ? 'Payment & Order Placed! 🎉'
                        : 'Order Placed & Processing ⏳',
                    textAlign: TextAlign.center,
                    style: UTextStyles.large.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                      color: Ucolors.blue,
                    ),
                  ),
                  const Gap(8),

                  Text(
                    isFailed
                        ? 'We were unable to complete your transaction with MFU. Please try again.'
                        : isConfirmed
                        ? 'Your ${isLumpsum ? "Lumpsum investment" : "SIP order"} has been received and confirmed.'
                        : 'Your transaction was submitted to MFU and is currently being processed by the AMC/Bank.',
                    textAlign: TextAlign.center,
                    style: UTextStyles.small.copyWith(
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                  const Gap(24),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order Summary',
                              style: UTextStyles.medium.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 7,
                                    height: 7,
                                    decoration: BoxDecoration(
                                      color: statusColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const Gap(6),
                                  Text(
                                    statusLabel,
                                    style: UTextStyles.small.copyWith(
                                      color: statusColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),

                        _buildDetailRow(
                          label: 'Investment Type',
                          value: isLumpsum ? 'One-time Lumpsum' : 'Monthly SIP',
                        ),
                        const Gap(12),

                        if (fundsCount > 1) ...[
                          _buildDetailRow(
                            label: 'Funds Count',
                            value: '$fundsCount Mutual Funds',
                          ),
                          const Gap(12),
                        ],

                        _buildDetailRow(
                          label: 'Total Amount',
                          value: amount,
                          isBoldValue: true,
                        ),
                        const Gap(12),

                        if (gorn.isNotEmpty && gorn != 'N/A') ...[
                          _buildDetailRow(label: 'GORN Reference', value: gorn),
                          const Gap(12),
                        ],

                        if (orderId.isNotEmpty) ...[
                          _buildDetailRow(
                            label: 'Order Reference',
                            value: '#$orderId',
                          ),
                          const Gap(12),
                        ],

                        _buildDetailRow(
                          label: 'Date & Time',
                          value: formattedDate,
                        ),
                      ],
                    ),
                  ),
                  const Gap(24),

                  if (isProcessing) ...[
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Ucolors.primary, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _isCheckingStatus ? null : _checkStatusAgain,
                        child: _isCheckingStatus
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.sync_rounded,
                                    color: Ucolors.primary,
                                    size: 20,
                                  ),
                                  const Gap(8),
                                  Text(
                                    'Check Status Again',
                                    style: UTextStyles.buttonText.copyWith(
                                      color: Ucolors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const Gap(12),
                  ],

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: UElevatedBUtton(
                      color: isFailed ? Colors.grey.shade800 : Ucolors.blue,
                      onPressed: () => _navigateToDashboard(),
                      child: Center(
                        child: Text(
                          isFailed ? 'Return to Home' : 'Go to Dashboard',
                          style: UTextStyles.buttonText.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Gap(12),

                  TextButton(
                    onPressed: () => _navigateToDashboard(targetTab: 1),
                    child: Text(
                      'View Portfolio & Investments',
                      style: UTextStyles.medium.copyWith(
                        color: Ucolors.blue,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    bool isBoldValue = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: UTextStyles.small.copyWith(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: UTextStyles.small.copyWith(
            color: Colors.black87,
            fontWeight: isBoldValue ? FontWeight.w700 : FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
