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
import 'package:responsive_framework/responsive_framework.dart'; // Import Responsive Framework

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Check if current breakpoint is desktop
    // bool isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: TopBottomDecoration(
        child: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: isDesktop
                      ? const ClampingScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  padding: UPadding.screenPadding.copyWith(
                    bottom: kBottomNavigationBarHeight,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: ResponsiveRowColumn(
                      // SWITCH LAYOUT HERE: Row for Desktop, Column for Mobile
                      layout: isDesktop
                          ? ResponsiveRowColumnType.ROW
                          : ResponsiveRowColumnType.COLUMN,
                      rowMainAxisAlignment: MainAxisAlignment.center,
                      rowCrossAxisAlignment: CrossAxisAlignment.center,
                      columnMainAxisSize:
                          MainAxisSize.min, // Keep mobile behavior
                      rowSpacing:
                          50, // Spacing between Left (Image) and Right (Form) on Desktop

                      children: [
                        // --- LEFT SIDE (Images/Header) ---
                        ResponsiveRowColumnItem(
                          rowFlex: 1,
                          child: LoginTopSection(
                            size: size,
                            isDesktop: isDesktop,
                          ),
                        ),

                        // --- RIGHT SIDE (Form/Inputs) ---
                        ResponsiveRowColumnItem(
                          rowFlex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              bottom: kBottomNavigationBarHeight,
                            ),
                            child: Container(
                              constraints: isDesktop
                                  ? const BoxConstraints(maxWidth: 500)
                                  : null,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,

                                children: [
                                  if (isDesktop) ...[
                                    HeadingText(title: 'Login Account'),
                                    SubtitleText(
                                      subtitle:
                                          'Please login into your account',
                                    ),
                                    SizedBox(height: 20),
                                  ],
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
                                                : Colors.grey.shade300,
                                            onPressed:
                                                controller
                                                        .isPhoneValidForLogin
                                                        .value &&
                                                    !controller
                                                        .isLoginLoading
                                                        .value
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

                                  SizedBox(height: Get.height * 0.01),
                                  SmallHeading(smallheading: 'or login with'),
                                  SizedBox(height: Get.height * 0.01),
                                  USocialButton(),
                                  SizedBox(height: Get.height * 0.02),
                                  CreataAccountIfNot(
                                    firstPart: 'Dont have an account? ',
                                    textButton: 'Create Account',
                                    voidCallback: () {
                                        // Get.toNamed(
                                        //   AppRoutes.registerAccountScreen,
                                        // ),
                                        controller.resetAuthForms(); 
                                        Get.offNamed(
                                          AppRoutes.registerAccountScreen,
                                        );}
                                  ),
                                  SizedBox(height: Get.height * 0.02),
                                  TermAndPolicy(),
                                ],
                              ),
                            ),
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
  const LoginTopSection({
    super.key,
    required this.size,
    this.isDesktop = false,
  });

  final Size size;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Ucolors.primary.withAlpha(20),
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: isDesktop
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.center,
        children: [
          SizedBox(height: size.height * 0.07), // Top spacing
          Image.asset(
            UImages.imp,
            height: isDesktop ? 80 : Get.width * 0.15,
            width: isDesktop ? 100 : Get.width * 0.2,
          ),
          SizedBox(height: size.height * 0.01),

          //title heading
          isDesktop ? SizedBox.shrink() : HeadingText(title: 'Login Account'),

          //Subtile Heading
          isDesktop
              ? SizedBox.shrink()
              : SubtitleText(subtitle: 'Please login into your account'),

          //Image
          Image.asset(
            UImages.signIn,
            // Adjust image size for desktop so it fits nicely in the split view
            height: isDesktop ? 350 : (Get.height * 0.25).clamp(180.0, 280.0),
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
