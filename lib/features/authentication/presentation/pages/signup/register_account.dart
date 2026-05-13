// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:my_sip/common/style/padding.dart';
// import 'package:my_sip/common/widget/button/elevated_button.dart';
// import 'package:my_sip/common/widget/button/social_button.dart';
// import 'package:my_sip/common/widget/text/heading_section.dart';
// import 'package:my_sip/common/widget/text/small_heading.dart';
// import 'package:my_sip/common/widget/text/subtitle_section.dart';
// import 'package:my_sip/common/widget/text_form/text_field_component.dart';
// import 'package:my_sip/common/widget/top_bottom_style/top_bottom_style.dart';
// import 'package:my_sip/core/utils/constant/images.dart';
// import 'package:my_sip/core/utils/enums/enums.dart';
// import 'package:my_sip/features/authentication/presentation/pages/login/login_page.dart';
// import 'package:my_sip/core/utils/constant/colors.dart';
// import 'package:my_sip/core/utils/constant/sizes.dart';
// import 'package:my_sip/core/utils/constant/text_style.dart';

// import '../../controllers/auth/auth_controller.dart';
// import '../../widgets/creat_acc_if_not.dart';
// import '../../widgets/term_policy.dart';

// class RegisterAccountScreen extends GetView<AuthController> {
//   const RegisterAccountScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Ensure controller is initialized if not already in binding
//     // controller is automatically available via GetView if put/found correctly

//     return Scaffold(
//       backgroundColor: Ucolors.light,
//       resizeToAvoidBottomInset: false,
//       body: TopBottomDecoration(
//         design: true,
//         child: SafeArea(
//           child: Padding(
//             padding: UPadding.screenPadding,
//             child: SingleChildScrollView(
//               child: Form(
//                 key: controller.registerFormKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: USizes.spcaeFromTop),
//                     HeadingText(title: 'Registration Account'),
//                     SizedBox(height: Get.height * 0.002),
//                     SubtitleText(
//                       subtitle: 'Let’s create your account first',
//                       textAlignCenter: TextAlign.start,
//                     ),
//                     SizedBox(height: Get.height * 0.01),

//                     // --- Name ---
//                     CustomTextField(
//                       controller: controller.nameController,
//                       label: "Name",
//                       validationType: ValidationType.required,
//                       leading: SvgPicture.asset(
//                         UImages.user,
//                         height: 5,
//                         width: 5,
//                         fit: BoxFit.scaleDown,
//                         colorFilter: const ColorFilter.mode(
//                           Colors.grey,
//                           BlendMode.srcIn,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: Get.height * 0.01),

//                     // --- Email ---
//                     CustomTextField(
//                       controller: controller.emailController,
//                       label: "Email",
//                       validationType: ValidationType.email,
//                       leading: SvgPicture.asset(
//                         UImages.email,
//                         height: 20,
//                         fit: BoxFit.scaleDown,
//                         colorFilter: const ColorFilter.mode(
//                           Colors.grey,
//                           BlendMode.srcIn,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: Get.height * 0.01),

//                     // --- Mobile ---
//                     CustomTextField(
//                       maxLength: 10,

//                       controller: controller.mobileController,
//                       label: "Mobile Number",
//                       validationType: ValidationType.phone,
//                       keyboardType: TextInputType.phone,
//                       leading: SvgPicture.asset(
//                         UImages.mobile,
//                         height: 20,
//                         fit: BoxFit.scaleDown,
//                         colorFilter: const ColorFilter.mode(
//                           Colors.grey,
//                           BlendMode.srcIn,
//                         ),
//                       ),
//                     ),

//                     SizedBox(height: Get.height * 0.01),

//                     // --- Pan Number ---
//                     CustomTextField(
//                       controller: controller.panController,
//                       label: "Pan Number",
//                       keyboardType: TextInputType.text,
//                       validationType: ValidationType.custom,
//                       customValidator: controller.validatePanCard,

//                       inputFormatters: [PanInputFormatter()],

//                       leading: SvgPicture.asset(
//                         UImages.card,
//                         height: 20,
//                         fit: BoxFit.scaleDown,
//                         colorFilter: const ColorFilter.mode(
//                           Colors.grey,
//                           BlendMode.srcIn,
//                         ),
//                       ),
//                     ),

//                     // SizedBox(height: Get.height * 0.01),
//                     //
//                     // // --- Password ---
//                     // CustomTextField(
//                     //   controller: controller.passwordController,
//                     //   label: "Password",
//                     //   obscureText: true,
//                     //   validationType: ValidationType.custom,
//                     //   customValidator: controller.validatePassword,
//                     //   leading: SvgPicture.asset(
//                     //     UImages.key,
//                     //     height: 20,
//                     //     fit: BoxFit.scaleDown,
//                     //     colorFilter: const ColorFilter.mode(
//                     //       Colors.grey,
//                     //       BlendMode.srcIn,
//                     //     ),
//                     //   ),
//                     // ),

//                     SizedBox(height: Get.height * 0.01),

//                     SmallHeading(
//                       fontsize: Get.width * 0.03,
//                       smallheading:
//                           'Password must contain: 8+ characters, uppercase, lowercase, and number ',
//                     ),

//                     // --- Checkbox with Obx ---
//                     FittedBox(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Obx(
//                             () => Checkbox(
//                               side: BorderSide(color: Ucolors.darkgrey),
//                               value: controller.isAgreed.value,
//                               onChanged: controller.toggleAgreement,
//                             ),
//                           ),
//                           RichText(
//                             text: TextSpan(
//                               children: [
//                                 TextSpan(
//                                   text: 'I agree to the ',
//                                   style: UTextStyles.subtitle2.copyWith(
//                                     color: Ucolors.dark,
//                                   ),
//                                 ),
//                                 TextSpan(
//                                   text: 'Terms of Use',
//                                   style: UTextStyles.subtitle2.copyWith(
//                                     color: Ucolors.blue,
//                                     fontWeight: FontWeight.w700,
//                                     decoration: TextDecoration.underline,
//                                   ),
//                                 ),
//                                 TextSpan(
//                                   text: ' and ',
//                                   style: UTextStyles.subtitle2,
//                                 ),
//                                 TextSpan(
//                                   text: 'Privacy Policy.',
//                                   style: UTextStyles.subtitle2.copyWith(
//                                     color: Ucolors.blue,
//                                     fontWeight: FontWeight.w700,
//                                     decoration: TextDecoration.underline,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: Get.height * 0.01),

//                     // --- Submit Button (With Loading State) ---
//                     Obx(
//                       () => UElevatedBUtton(
//                         onPressed: controller.isRegisterLoading.value
//                             ? null // Disable while loading
//                             : controller.submitRegisterForm,
//                         child: Center(
//                           child: controller.isRegisterLoading.value
//                               ? const CircularProgressIndicator(
//                                   color: Colors.white,
//                                 )
//                               : Text(
//                                   'Create Account',
//                                   style: UTextStyles.buttonText,
//                                 ),
//                         ),
//                       ),
//                     ),

//                     SizedBox(height: Get.height * 0.01),

//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         SmallHeading(smallheading: 'or register with'),
//                       ],
//                     ),
//                     SizedBox(height: Get.height * 0.01),

//                     USocialButton(),
//                     SizedBox(height: Get.height * 0.01),

//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         CreataAccountIfNot(
//                           firstPart: 'Already have an account?',
//                           textButton: ' Login Account',
//                           voidCallback: () => Get.to(() => LoginPage()),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: Get.height * 0.01),

//                     TermAndPolicy(),
//                     SizedBox(height: kBottomNavigationBarHeight),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class UpperCaseTextFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//     TextEditingValue oldValue,
//     TextEditingValue newValue,
//   ) {
//     return newValue.copyWith(text: newValue.text.toUpperCase());
//   }
// }

// class PanInputFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//     TextEditingValue oldValue,
//     TextEditingValue newValue,
//   ) {
//     String text = newValue.text.toUpperCase();

//     // Max length 10
//     if (text.length > 10) {
//       text = text.substring(0, 10);
//     }

//     final buffer = StringBuffer();

//     for (int i = 0; i < text.length; i++) {
//       final char = text[i];

//       if (i < 5) {
//         // First 5 must be letters
//         if (RegExp(r'[A-Z]').hasMatch(char)) {
//           buffer.write(char);
//         }
//       } else if (i < 9) {
//         // Next 4 must be digits
//         if (RegExp(r'[0-9]').hasMatch(char)) {
//           buffer.write(char);
//         }
//       } else {
//         // Last must be letter
//         if (RegExp(r'[A-Z]').hasMatch(char)) {
//           buffer.write(char);
//         }
//       }
//     }

//     return TextEditingValue(
//       text: buffer.toString(),
//       selection: TextSelection.collapsed(offset: buffer.length),
//     );
//   }
// }
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
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/enums/enums.dart';
import 'package:my_sip/features/authentication/presentation/pages/login/login_page.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/sizes.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:responsive_framework/responsive_framework.dart'; // 🚀 Added Responsive Framework

import '../../controllers/auth/auth_controller.dart';
import '../../widgets/creat_acc_if_not.dart';
import '../../widgets/term_policy.dart';

class RegisterAccountScreen extends GetView<AuthController> {
  const RegisterAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // bool isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      backgroundColor: Ucolors.light,
      resizeToAvoidBottomInset: false,
      body: TopBottomDecoration(
        design: isDesktop ? false : true,
        child: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: isDesktop
                      ? const NeverScrollableScrollPhysics()
                      : const BouncingScrollPhysics(),
                  padding: UPadding.screenPadding.copyWith(
                    bottom: kBottomNavigationBarHeight,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: ResponsiveRowColumn(
                      layout: isDesktop
                          ? ResponsiveRowColumnType.ROW
                          : ResponsiveRowColumnType.COLUMN,
                      rowMainAxisAlignment: MainAxisAlignment.center,
                      rowCrossAxisAlignment: CrossAxisAlignment.center,
                      columnMainAxisSize: MainAxisSize.min,
                      rowSpacing: 50,
                      children: [
                        ResponsiveRowColumnItem(
                          rowFlex: 1,
                          child: isDesktop
                              ? LoginTopSection(
                                  size: size,
                                  isDesktop: isDesktop,
                                )
                              : const SizedBox.shrink(),
                        ),

                        ResponsiveRowColumnItem(
                          rowFlex: 1,
                          child: Container(
                            constraints: isDesktop
                                ? const BoxConstraints(maxWidth: 450)
                                : null,
                            child: Form(
                              key: controller.registerFormKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // --- Headings ---
                                  if (!isDesktop)
                                    SizedBox(height: USizes.spcaeFromTop),
                                  HeadingText(title: 'Registration Account'),
                                  SizedBox(height: Get.height * 0.002),
                                  SubtitleText(
                                    subtitle: 'Let’s create your account first',
                                    textAlignCenter: TextAlign.start,
                                  ),
                                  SizedBox(height: Get.height * 0.02),

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
                                  SizedBox(height: Get.height * 0.02),

                                  // SmallHeading(
                                  //   fontsize: Get.width * 0.03,
                                  //   smallheading: 'Password must contain: 8+ characters, uppercase, lowercase, and number',
                                  // ),

                                  // --- Checkbox ---
                                  FittedBox(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Obx(
                                          () => Checkbox(
                                            side: BorderSide(
                                              color: Ucolors.darkgrey,
                                            ),
                                            value: controller.isAgreed.value,
                                            onChanged:
                                                controller.toggleAgreement,
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'I agree to the ',
                                                style: UTextStyles.subtitle2
                                                    .copyWith(
                                                      color: Ucolors.dark,
                                                    ),
                                              ),
                                              TextSpan(
                                                text: 'Terms of Use',
                                                style: UTextStyles.subtitle2
                                                    .copyWith(
                                                      color: Ucolors.blue,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),
                                              ),
                                              TextSpan(
                                                text: ' and ',
                                                style: UTextStyles.subtitle2,
                                              ),
                                              TextSpan(
                                                text: 'Privacy Policy.',
                                                style: UTextStyles.subtitle2
                                                    .copyWith(
                                                      color: Ucolors.blue,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: Get.height * 0.02),

                                  Obx(
                                    () => UElevatedBUtton(
                                      onPressed:
                                          controller.isRegisterLoading.value
                                          ? null
                                          : controller.submitRegisterForm,
                                      child: Center(
                                        child:
                                            controller.isRegisterLoading.value
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
                                  SizedBox(height: Get.height * 0.02),

                                  // --- Social & Login ---
                                  Center(
                                    child: SmallHeading(
                                      smallheading: 'or register with',
                                    ),
                                  ),
                                  SizedBox(height: Get.height * 0.01),
                                   USocialButton(),
                                  SizedBox(height: Get.height * 0.02),
                                  Center(
                                    child: CreataAccountIfNot(
                                      firstPart: 'Already have an account?',
                                      textButton: ' Login Account',
                                      voidCallback: () {
                                        // Get.to(() => const LoginPage()),
                                        controller.resetAuthForms();
                                        Get.offNamed(AppRoutes.login);
                                      },
                                    ),
                                  ),
                                  SizedBox(height: Get.height * 0.02),
                                  const TermAndPolicy(),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: size.height * 0.07),
          Image.asset(
            UImages.imp,
            height: isDesktop ? 80 : Get.width * 0.15,
            width: isDesktop ? 100 : Get.width * 0.2,
          ),
          SizedBox(height: size.height * 0.01),

          isDesktop
              ? const SizedBox.shrink()
              : HeadingText(title: 'Registration Account'),
          isDesktop
              ? const SizedBox.shrink()
              : SubtitleText(subtitle: 'Please create an account'),

          Image.asset(
            UImages
                .signIn, // Change this to a registration image if you have one
            height: isDesktop ? 350 : (Get.height * 0.25).clamp(180.0, 280.0),
            fit: BoxFit.contain,
          ),
        ],
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
    if (text.length > 10) {
      text = text.substring(0, 10);
    }
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      if (i < 5) {
        if (RegExp(r'[A-Z]').hasMatch(char)) buffer.write(char);
      } else if (i < 9) {
        if (RegExp(r'[0-9]').hasMatch(char)) buffer.write(char);
      } else {
        if (RegExp(r'[A-Z]').hasMatch(char)) buffer.write(char);
      }
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
