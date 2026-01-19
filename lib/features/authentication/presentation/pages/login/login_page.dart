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
import 'package:my_sip/common/widget/text_form/text_form_field.dart';
import 'package:my_sip/common/widget/top_bottom_style/top_bottom_style.dart';
import 'package:my_sip/config/routes/app_pages.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/features/authentication/presentation/controllers/auth/auth_controller.dart';
import 'package:my_sip/features/authentication/presentation/pages/login/otp_verification.dart';
import 'package:my_sip/features/authentication/presentation/widgets/creat_acc_if_not.dart';
import 'package:my_sip/features/authentication/presentation/widgets/term_policy.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';

import '../../../../../core/utils/enums/enums.dart';
import '../signup/register_account.dart';

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

                              CustomTextField(
                                controller: controller.mobileController,
                                label: "Mobile Number",
                                hintColor: Colors.grey.shade600,
                                validationType: ValidationType.phone,
                                keyboardType: TextInputType.phone,
                                leading: SvgPicture.asset(
                                  UImages.mobile,
                                  height: 20,
                                  fit: BoxFit.scaleDown,
                                  colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                                ),
                              ),

                              SizedBox(height: Get.height * 0.019),

                              /// GET OTP BUTTON
                              Obx(
                                    () => controller.isOtpSendLoading.value
                                        ? CircularProgressIndicator(color: Ucolors.primary, strokeWidth: 2)
                                        : UElevatedBUtton(

                                      onPressed: controller.isOtpSendLoading.value
                                          ? null
                                          : () => controller.sendOtp(),
                                      child:  Center(
                                            child: const Text(
                                                                                  'Get OTP',
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
                                voidCallback: () => Get.toNamed(AppRoutes.registerAccountScreen),
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
