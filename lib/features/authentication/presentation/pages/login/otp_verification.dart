import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/common/widget/text/heading_section.dart';
import 'package:my_sip/common/widget/text/small_heading.dart';
import 'package:my_sip/common/widget/text/subtitle_section.dart';
import 'package:my_sip/common/widget/top_bottom_style/top_bottom_style.dart';
import 'package:my_sip/features/authentication/presentation/controllers/auth/auth_controller.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/sizes.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationScreen extends GetView<AuthController> {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: TopBottomDecoration(
        child: SafeArea(
          child: Padding(
            padding: UPadding.screenPadding,
            child: Column(
              children: [
                SizedBox(height: USizes.spcaeFromTop),
                Center(child: Image.asset(UImages.message)),
                const SizedBox(height: 15),
                const HeadingText(title: 'Verify Your Number'),
                const SizedBox(height: 10),
                const SubtitleText(
                  subtitle:
                      'To verify your account, enter the 6 digit OTP code that we sent to your number.',
                ),
                const SizedBox(height: 25),

                // -- OTP INPUT --
                Obx(
                  () => Pinput(
                    separatorBuilder: (index) => const SizedBox(width: 5),
                    controller: controller.otpController,
                    autofocus: true,
                    showCursor: true,
                    length: 6,
                    keyboardType: TextInputType.number,
                    forceErrorState: controller.isOtpError.value,

                    defaultPinTheme: PinTheme(
                      width: 50,
                      height: 50,
                      textStyle: const TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Ucolors.darkgrey, width: 2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    focusedPinTheme: PinTheme(
                      width: 50,
                      height: 50,
                      textStyle: const TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Ucolors.primary, width: 2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    errorPinTheme: PinTheme(
                      width: 50,
                      height: 50,
                      textStyle: const TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Ucolors.red, width: 2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onTap: () {
                      controller.isOtpError.value = false;
                    },

                    // onChanged: (value) {
                    //   controller.isOtpError.value = false;
                    // },
                    onCompleted: (pin) {
                      controller.verifyOtpAndLogin();
                    },
                  ),
                ),

                const SizedBox(height: 15),
                Obx(
                  () => Text(
                    "00:${controller.remainingSeconds.value.toString().padLeft(2, '0')}",
                    style: UTextStyles.heading2.copyWith(
                      color: controller.remainingSeconds.value > 0
                          ? Ucolors.blue
                          : Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const SmallHeading(smallheading: "Didn't get the code?"),
                const SizedBox(height: 15),

                Obx(
                  () => controller.isOtpSendLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : UElevatedBUtton(
                          height: Get.height * 0.060,

                          // outlined: true,
                          color: controller.isResendEnabled.value
                              ? null
                              : Colors.grey,
                          onPressed:
                              (controller.isResendEnabled.value &&
                                  !controller.isOtpSendLoading.value)
                              ? () => controller.resendOtp()
                              : null,

                          child: Center(
                            child: Text(
                              'Resend Code',
                              style: UTextStyles.buttonText.copyWith(
                                color: Colors.white,

                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                ),

                const Spacer(),

                // -- VERIFY BUTTON --
                Obx(
                  () => controller.isOtpVerifyLoading.value
                      ? const CircularProgressIndicator(color: Ucolors.primary)
                      : UElevatedBUtton(
                          onPressed: controller.isOtpVerifyLoading.value
                              ? null
                              : () => controller.verifyOtpAndLogin(),
                          child: Center(
                            child: Text(
                              "Verify",
                              style: AppTextStyles.bodyLarge(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                ),

                const SizedBox(height: 10),

                // -- BACK BUTTON --
                UElevatedBUtton(
                  onPressed: () => Get.back(),
                  outlined: true,
                  child: Center(
                    child: Text("Back", style: AppTextStyles.bodyLarge()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
