import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/common/widget/button/social_button.dart';
import 'package:my_sip/common/widget/text/heading_section.dart';
import 'package:my_sip/common/widget/text/small_heading.dart';
import 'package:my_sip/common/widget/text/subtitle_section.dart';
import 'package:my_sip/common/widget/text_form/text_field_component.dart';
import 'package:my_sip/common/widget/top_bottom_style/top_bottom_style.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/features/authentication/presentation/controllers/auth/auth_controller.dart';
import 'package:my_sip/features/authentication/presentation/widgets/creat_acc_if_not.dart';
import 'package:my_sip/features/authentication/presentation/widgets/term_policy.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';

import '../../../../../core/utils/enums/enums.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: TopBottomDecoration(
        child: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: UPadding.screenPadding.copyWith(
                    bottom: kBottomNavigationBarHeight,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      children: [
                        LoginTopSection(size: size),

                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: kBottomNavigationBarHeight,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // CustomTextField(
                              //   controller: controller.emailController,
                              //   label: "Email",
                              //   hintColor: Colors.grey.shade600,
                              //   validationType: ValidationType.email,
                              //   keyboardType: TextInputType.emailAddress,
                              //   leading: SvgPicture.asset(
                              //     UImages.email,
                              //     height: 20,
                              //     fit: BoxFit.scaleDown,
                              //     colorFilter: const ColorFilter.mode(
                              //       Colors.grey,
                              //       BlendMode.srcIn,
                              //     ),
                              //   ),
                              // ),
                              Obx(
                                () => CustomTextField(
                                  
                                  minLength: 10,
                                  borderColor:
                                      controller.isPhoneNotRegistered.value
                                      ? Colors.red
                                      : Colors.grey.shade300,
                                  focusedBorderColor:
                                      controller.isPhoneNotRegistered.value
                                      ? Ucolors.red
                                      : Ucolors.textFormEnabled,

                                  maxLength: 10,
                                  errorText:
                                      controller.isPhoneNotRegistered.value
                                      ? 'Not registered. Please create an account'
                                      : '',
                                  hint: 'Enter Register Number',
                                  controller: controller.mobileController,
                                  label: "Phone Number",
                                  hintColor: Colors.grey.shade600,
                                  validationType: ValidationType.phone,
                                  keyboardType: TextInputType.phone,

                                  onChanged: (value) {
                                    controller.isPhoneNotRegistered.value =
                                        false;

                                    controller.isNumberValid.value = true;
                                    controller.isPhoneValidForLogin.value =
                                        value.length == 10;

                                    if (value.length == 10) {
                                      FocusScope.of(Get.context!).unfocus();
                                    }
                                  },
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
                              ),
                              // Obx(
                              //   () => controller.isPhoneNotRegistered.value
                              //       ? CreataAccountIfNot(
                              //           firstPart: '',
                              //           textButton: 'Create Account',
                              //           voidCallback: () => Get.toNamed(
                              //             AppRoutes.registerAccountScreen,
                              //           ),
                              //         )
                              //       : SizedBox.shrink(),
                              // ),

                              // SizedBox(height: Get.height * 0.019),
                              // CustomTextField(
                              //   obscureText: true,
                              //   controller: controller.passwordController,
                              //   label: "Password",
                              //   hintColor: Colors.grey.shade600,
                              //   validationType: ValidationType.required,
                              //   leading: SvgPicture.asset(
                              //     UImages.key,
                              //     height: 20,
                              //     fit: BoxFit.scaleDown,
                              //     colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                              //   ),
                              // ),
                              SizedBox(height: Get.height * 0.019),

                              /// GET OTP BUTTON
                              Obx(
                                () => controller.isLoginLoading.value
                                    ? CircularProgressIndicator(
                                        color: Ucolors.primary,
                                        strokeWidth: 2,
                                      )
                                    : UElevatedBUtton(
                                        color:
                                            controller
                                                .isPhoneValidForLogin
                                                .value
                                            ? null
                                            // enabled
                                            : Colors.grey.shade300,
                                        // onPressed:
                                        //     controller.isLoginLoading.value
                                        //     ? null
                                        //     : () =>
                                        //           //  controller
                                        //           //       .loginWithEmailAndPassword(),
                                        //           controller.sendOtp(),
                                        onPressed:
                                            controller
                                                    .isPhoneValidForLogin
                                                    .value &&
                                                !controller.isLoginLoading.value
                                            ? () => controller.sendOtp()
                                            : null,
                                        child: Center(
                                          child: const Text(
                                            'Login',
                                            style: TextStyle(
                                              color: Ucolors.light,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                              ),

                              // ... Rest of your UI (Social buttons, create account, etc) ...
                              SizedBox(height: Get.height * 0.01),
                              SmallHeading(smallheading: 'or login with'),
                              SizedBox(height: Get.height * 0.01),
                              USocialButton(),
                              SizedBox(height: Get.height * 0.02),
                              CreataAccountIfNot(
                                firstPart: 'Dont have an account? ',
                                textButton: 'Create Account',
                                voidCallback: () => Get.toNamed(
                                  AppRoutes.registerAccountScreen,
                                ),
                              ),
                              SizedBox(height: Get.height * 0.02),
                              TermAndPolicy(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class LoginTopSection extends StatelessWidget {
  const LoginTopSection({super.key, required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: size.height * 0.07), // Top spacing
        Image.asset(
          UImages.imp,
          height: Get.width * 0.15,
          width: Get.width * 0.2,
        ),
        SizedBox(height: size.height * 0.01),

        //title heading
        HeadingText(title: 'Login Account'),

        //Subtile Heading
        SubtitleText(subtitle: 'Please login into your account'),

        // SizedBox(height: size.height * 0.01),
        //Image
        Image.asset(
          UImages.signIn,
          // height: size.height * 0.25,
          height: (Get.height * 0.25).clamp(180.0, 280.0),
          // width: size.width * 0.8,
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}
