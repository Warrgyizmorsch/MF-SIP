import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/widget/animated/custom_toast.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/dashboard/domain/entity/portfolio_entity.dart';
import 'package:my_sip/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:my_sip/features/mfu/presentation/controller/mfu_controller.dart';

class SipCancelOtpModal extends StatefulWidget {
  final MfuPortfolioItemEntity fund;

  const SipCancelOtpModal({super.key, required this.fund});

  static Future<void> show(
    BuildContext context,
    MfuPortfolioItemEntity fund,
  ) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => SipCancelOtpModal(fund: fund),
    );
  }

  @override
  State<SipCancelOtpModal> createState() => _SipCancelOtpModalState();
}

class _SipCancelOtpModalState extends State<SipCancelOtpModal> {
  int _step = 0; // 0: Confirmation, 1: OTP Input
  final TextEditingController _otpController = TextEditingController();
  String? _maskedMobile;
  Timer? _resendTimer;
  int _resendSeconds = 60;
  bool _canResend = false;

  @override
  void dispose() {
    _otpController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    setState(() {
      _resendSeconds = 60;
      _canResend = false;
    });

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_resendSeconds <= 1) {
        timer.cancel();
        setState(() {
          _canResend = true;
          _resendSeconds = 0;
        });
      } else {
        setState(() {
          _resendSeconds--;
        });
      }
    });
  }

  Future<void> _handleSendOtp() async {
    final mfuController = Get.find<MfuController>();
    final res = await mfuController.sendSipCancelOtp(
      widget.fund.mfuOrderFundId,
    );

    if (!mounted) return;

    if (res != null && res.success == true) {
      showCustomToast(
        title: 'OTP Sent',
        message: res.message ?? 'OTP sent to registered mobile number',
        backgroundColor: Colors.green,
        icon: Icons.check_circle,
      );
      setState(() {
        _maskedMobile = res.mobile;
        _step = 1;
      });
      _startResendTimer();
    }
  }

  Future<void> _handleVerifyOtp() async {
    final otpText = _otpController.text.trim();
    if (otpText.length < 4) {
      showCustomToast(
        title: 'Validation Error',
        message: 'Please enter a valid OTP',
        backgroundColor: Colors.orange,
        icon: Icons.warning_amber_rounded,
      );
      return;
    }

    final mfuController = Get.find<MfuController>();
    final res = await mfuController.verifySipCancelOtp(
      widget.fund.mfuOrderFundId,
      otpText,
    );

    if (!mounted) return;

    if (res != null && res.success == true) {
      Navigator.of(context).pop();
      showCustomToast(
        title: 'Cancellation Submitted',
        message:
            res.message ?? 'SIP cancellation request submitted successfully',
        backgroundColor: Colors.green,
        icon: Icons.check_circle,
      );

      // Refresh portfolio in Dashboard
      try {
        if (Get.isRegistered<DashboardController>()) {
          Get.find<DashboardController>().getPortfolio();
        }
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final mfuController = Get.find<MfuController>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 440),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Iconsax.trash,
                          color: Colors.red.shade600,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _step == 0 ? 'Cancel SIP' : 'Verify Cancellation OTP',
                          style: const TextStyle(
                            fontFamily: FontFamily.medium,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Ucolors.dark,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.grey),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const Divider(height: 28),

            /// Step 0: Confirmation Screen
            if (_step == 0) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.fund.fundName,
                      style: const TextStyle(
                        fontFamily: FontFamily.medium,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Ucolors.dark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          'Folio: ${widget.fund.folioNo}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        if (widget.fund.investedAmount > 0) ...[
                          const Text(' • '),
                          Text(
                            '₹${widget.fund.investedAmount.toStringAsFixed(2)} Invested',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Are you sure you want to cancel your SIP? An OTP will be sent to your registered mobile number to confirm this request.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Obx(() {
                final isLoading = mfuController.isSendingSipCancelOtp.value;
                return ElevatedButton(
                  onPressed: isLoading ? null : _handleSendOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Send OTP to Cancel SIP',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                );
              }),
            ]
            /// Step 1: OTP Input Screen
            else ...[
              Text(
                'We have sent a verification OTP to your registered mobile number ${_maskedMobile != null ? "($_maskedMobile)" : ""}.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),

              /// OTP Input Field
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 8,
                  color: Ucolors.dark,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: '••••••',
                  hintStyle: TextStyle(
                    fontSize: 22,
                    letterSpacing: 8,
                    color: Colors.grey.shade400,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: Colors.red.shade600,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              /// Resend OTP Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _canResend
                        ? 'Didn\'t receive OTP?'
                        : 'Resend code in ${_resendSeconds}s',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  if (_canResend)
                    GestureDetector(
                      onTap: _handleSendOtp,
                      child: Text(
                        'Resend OTP',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.red.shade600,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),

              Obx(() {
                final isLoading = mfuController.isVerifyingSipCancelOtp.value;
                return ElevatedButton(
                  onPressed: isLoading ? null : _handleVerifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Confirm & Cancel SIP',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}
