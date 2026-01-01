import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/common/widget/button/social_button.dart';
import 'package:my_sip/common/widget/text/heading_section.dart';
import 'package:my_sip/common/widget/text/small_heading.dart';
import 'package:my_sip/common/widget/text/subtitle_section.dart';
import 'package:my_sip/common/widget/text_form/text_form_field.dart';
import 'package:my_sip/common/widget/top_bottom_style/top_bottom_style.dart';
import 'package:my_sip/features/authentication/screen/login/login_page.dart';
import 'package:my_sip/features/authentication/screen/login/widget/creat_acc_if_not.dart';
import 'package:my_sip/features/authentication/screen/login/widget/term_policy.dart';
import 'package:my_sip/features/authentication/screen/signup/verify_pan_otp.dart';
import 'package:my_sip/utils/constant/colors.dart';
import 'package:my_sip/utils/constant/sizes.dart';
import 'package:my_sip/utils/constant/text_style.dart';

class RegisterAccountScreen extends StatelessWidget {
  const RegisterAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // log('$kBottomNavigationBarHeight');
    return Scaffold(
      backgroundColor: Ucolors.light,
      resizeToAvoidBottomInset: false,
      body: TopBottomDecoration(
        design: true,
        child: SafeArea(
          child: Padding(
            padding: UPadding.screenPadding,
            child: SingleChildScrollView(
              // physics: NeverScrollableScrollPhysics(),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

                  UTextFormField(labelText: 'Name', prefixIcon: Icons.person),
                  SizedBox(height: Get.height * 0.01),

                  UTextFormField(labelText: 'Email', prefixIcon: Icons.email),
                  SizedBox(height: Get.height * 0.01),

                  UTextFormField(
                    labelText: 'Mobile Number',
                    prefixIcon: Icons.phone_android_sharp,
                  ),
                  SizedBox(height: Get.height * 0.01),

                  UTextFormField(
                    labelText: 'Pan Number',
                    prefixIcon: Icons.credit_card,
                  ),
                  SizedBox(height: Get.height * 0.01),

                  UTextFormField(
                    labelText: 'Password',
                    prefixIcon: Icons.lock_outline,
                    sufixIcon: Iconsax.eye_slash,
                  ),
                  SizedBox(height: Get.height * 0.01),

                  SmallHeading(
                    fontsize: Get.width * 0.03,
                    // fontsize: 10,
                    smallheading:
                        'Password must contain: 8+ characters, uppercase. lowercase, and number ',
                  ),
                  FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          side: BorderSide(color: Ucolors.darkgrey),
                          value: true,
                          onChanged: (value) {},
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

                  UElevatedBUtton(
                    onPressed: () => Get.to(() => VerifyPanOtp()),
                    child: Center(
                      child: Text(
                        'Create Account',
                        style: UTextStyles.buttonText,
                      ),
                    ),
                  ),
                  SizedBox(height: Get.height * 0.01),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [SmallHeading(smallheading: 'or register with')],
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
    );
  }
}
