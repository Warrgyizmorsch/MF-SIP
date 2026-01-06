import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/common/widget/button/social_button.dart';
import 'package:my_sip/common/widget/text/heading_section.dart';
import 'package:my_sip/common/widget/text/small_heading.dart';
import 'package:my_sip/common/widget/text/subtitle_section.dart';
import 'package:my_sip/common/widget/text_form/text_form_field.dart';
import 'package:my_sip/common/widget/top_bottom_style/top_bottom_style.dart';
import 'package:my_sip/features/authentication/presentation/pages/login/otp_verification.dart';
import 'package:my_sip/features/authentication/presentation/widgets/creat_acc_if_not.dart';
import 'package:my_sip/features/authentication/presentation/widgets/term_policy.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';

import '../signup/register_account.dart';

class LoginPage extends StatelessWidget {
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
                  physics: NeverScrollableScrollPhysics(),
                  padding: UPadding.screenPadding.copyWith(
                    bottom: kBottomNavigationBarHeight,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Top Section – IMF logo , title , subtitle , image
                        LoginTopSection(size: size),

                        // Middle  Section
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: kBottomNavigationBarHeight,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              //Mobile Number textform field
                              UTextFormField(
                                labelText: 'Mobile Number',
                                prefixIcon: Icons.phone_android,
                                hintText: 'Enter the number',
                              ),

                              SizedBox(height: Get.height * 0.019),

                              ///Get otp elevated button
                              SizedBox(
                                width: double.infinity,
                                child: UElevatedBUtton(
                                  onPressed: () =>
                                      Get.to(() => OtpVerificationScreen()),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Get OTP',
                                        style: TextStyle(
                                          color: Ucolors.light,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(height: Get.height * 0.01),

                              //Divider Header ---- or login with
                              SmallHeading(smallheading: 'or login with'),

                              SizedBox(height: Get.height * 0.01),

                              //Google Apple social Button
                              USocialButton(),

                              SizedBox(height: Get.height * 0.02),

                              //Bottom Section ---- Create account, Privacy and term
                              CreataAccountIfNot(
                                firstPart: 'Dont have an account? ',
                                textButton: 'Create Account',
                                voidCallback: () =>
                                    Get.to(() => RegisterAccountScreen()),
                              ),

                              SizedBox(height: Get.height * 0.02),

                              //term & condition
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
