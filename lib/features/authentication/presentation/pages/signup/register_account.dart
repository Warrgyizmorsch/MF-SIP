import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/common/widget/button/social_button.dart';
import 'package:my_sip/common/widget/text/heading_section.dart';
import 'package:my_sip/common/widget/text/small_heading.dart';
import 'package:my_sip/common/widget/text/subtitle_section.dart';
import 'package:my_sip/common/widget/text_form/text_field_component.dart';
import 'package:my_sip/common/widget/top_bottom_style/top_bottom_style.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/enums/enums.dart';
import 'package:my_sip/features/authentication/presentation/pages/login/login_page.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/sizes.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';

import '../../controllers/auth/auth_controller.dart';
import '../../widgets/creat_acc_if_not.dart';
import '../../widgets/term_policy.dart';

class RegisterAccountScreen extends GetView<AuthController> {
  const RegisterAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is initialized if not already in binding
    // controller is automatically available via GetView if put/found correctly

    return Scaffold(
      backgroundColor: Ucolors.light,
      resizeToAvoidBottomInset: false,
      body: TopBottomDecoration(
        design: true,
        child: SafeArea(
          child: Padding(
            padding: UPadding.screenPadding,
            child: SingleChildScrollView(
              child: Form(
                key: controller.registerFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: USizes.spcaeFromTop),
                    HeadingText(title: 'Registration Account'),
                    SizedBox(height: Get.height * 0.002),
                    SubtitleText(
                      subtitle: 'Let’s create your account first',
                      textAlignCenter: TextAlign.start,
                    ),
                    SizedBox(height: Get.height * 0.01),

                    // --- Name ---
                    CustomTextField(
                      controller: controller.nameController,
                      label: "Name",
                      validationType: ValidationType.required,
                      leading: SvgPicture.asset(
                        UImages.user,
                        height: 5,
                        width: 5,
                        fit: BoxFit.scaleDown,
                        colorFilter: const ColorFilter.mode(
                          Colors.grey,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    SizedBox(height: Get.height * 0.01),

                    // --- Email ---
                    CustomTextField(
                      controller: controller.emailController,
                      label: "Email",
                      validationType: ValidationType.email,
                      leading: SvgPicture.asset(
                        UImages.email,
                        height: 20,
                        fit: BoxFit.scaleDown,
                        colorFilter: const ColorFilter.mode(
                          Colors.grey,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    SizedBox(height: Get.height * 0.01),

                    // --- Mobile ---
                    CustomTextField(
                      maxLength: 10,

                      controller: controller.mobileController,
                      label: "Mobile Number",
                      validationType: ValidationType.phone,
                      keyboardType: TextInputType.phone,
                      leading: SvgPicture.asset(
                        UImages.mobile,
                        height: 20,
                        fit: BoxFit.scaleDown,
                        colorFilter: const ColorFilter.mode(
                          Colors.grey,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),

                    SizedBox(height: Get.height * 0.01),

                    // --- Pan Number ---
                    CustomTextField(
                      controller: controller.panController,
                      label: "Pan Number",
                      keyboardType: TextInputType.text,
                      validationType: ValidationType.custom,
                      customValidator: controller.validatePanCard,

                      inputFormatters: [PanInputFormatter()],

                      leading: SvgPicture.asset(
                        UImages.card,
                        height: 20,
                        fit: BoxFit.scaleDown,
                        colorFilter: const ColorFilter.mode(
                          Colors.grey,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),

                    SizedBox(height: Get.height * 0.01),

                    // --- Password ---
                    CustomTextField(
                      controller: controller.passwordController,
                      label: "Password",
                      obscureText: true,
                      validationType: ValidationType.custom,
                      customValidator: controller.validatePassword,
                      leading: SvgPicture.asset(
                        UImages.key,
                        height: 20,
                        fit: BoxFit.scaleDown,
                        colorFilter: const ColorFilter.mode(
                          Colors.grey,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),

                    SizedBox(height: Get.height * 0.01),

                    SmallHeading(
                      fontsize: Get.width * 0.03,
                      smallheading:
                          'Password must contain: 8+ characters, uppercase, lowercase, and number ',
                    ),

                    // --- Checkbox with Obx ---
                    FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Obx(
                            () => Checkbox(
                              side: BorderSide(color: Ucolors.darkgrey),
                              value: controller.isAgreed.value,
                              onChanged: controller.toggleAgreement,
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'I agree to the ',
                                  style: UTextStyles.subtitle2.copyWith(
                                    color: Ucolors.dark,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Terms of Use',
                                  style: UTextStyles.subtitle2.copyWith(
                                    color: Ucolors.blue,
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                TextSpan(
                                  text: ' and ',
                                  style: UTextStyles.subtitle2,
                                ),
                                TextSpan(
                                  text: 'Privacy Policy.',
                                  style: UTextStyles.subtitle2.copyWith(
                                    color: Ucolors.blue,
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Get.height * 0.01),

                    // --- Submit Button (With Loading State) ---
                    Obx(
                      () => UElevatedBUtton(
                        onPressed: controller.isRegisterLoading.value
                            ? null // Disable while loading
                            : controller.submitRegisterForm,
                        child: Center(
                          child: controller.isRegisterLoading.value
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  'Create Account',
                                  style: UTextStyles.buttonText,
                                ),
                        ),
                      ),
                    ),

                    SizedBox(height: Get.height * 0.01),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SmallHeading(smallheading: 'or register with'),
                      ],
                    ),
                    SizedBox(height: Get.height * 0.01),

                    USocialButton(),
                    SizedBox(height: Get.height * 0.01),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CreataAccountIfNot(
                          firstPart: 'Already have an account?',
                          textButton: ' Login Account',
                          voidCallback: () => Get.to(() => LoginPage()),
                        ),
                      ],
                    ),
                    SizedBox(height: Get.height * 0.01),

                    TermAndPolicy(),
                    SizedBox(height: kBottomNavigationBarHeight),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}

class PanInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.toUpperCase();

    // Max length 10
    if (text.length > 10) {
      text = text.substring(0, 10);
    }

    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      final char = text[i];

      if (i < 5) {
        // First 5 must be letters
        if (RegExp(r'[A-Z]').hasMatch(char)) {
          buffer.write(char);
        }
      } else if (i < 9) {
        // Next 4 must be digits
        if (RegExp(r'[0-9]').hasMatch(char)) {
          buffer.write(char);
        }
      } else {
        // Last must be letter
        if (RegExp(r'[A-Z]').hasMatch(char)) {
          buffer.write(char);
        }
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
