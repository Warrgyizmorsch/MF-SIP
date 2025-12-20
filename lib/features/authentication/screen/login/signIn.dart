import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/utils/constant/colors.dart';
import 'package:my_sip/utils/constant/images.dart';
import 'package:my_sip/utils/constant/text_style.dart';

class SigninScreen extends StatelessWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          //top right decoration
          Align(
            alignment: Alignment.topRight,
            child: Transform.translate(
              offset: Offset(10.w, -10.h),
              child: Opacity(
                opacity: 0.5,
                child: Image.asset(UImages.topright),
              ),
            ),
          ),

          //top left decoration
          Align(
            alignment: Alignment.bottomLeft,
            child: Transform.translate(
              offset: Offset(-10.w, 10.h),
              child: Opacity(
                opacity: 0.5,
                child: Image.asset(UImages.buttomleft),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: UPadding.screenPadding,
              child: SingleChildScrollView(
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: kTextTabBarHeight),
                    //image
                    Center(
                      child: Column(
                        children: [
                          Image.asset(UImages.imp, height: 45.h, width: 54.w),
                          SizedBox(height: 18.h),
                          Text('Login Account', style: UTextStyles.heading2),
                          Text(
                            'Please login into your account',
                            style: UTextStyles.subtitle1,
                          ),
                          SizedBox(height: 8.h),
                          Image.asset(UImages.signIn),

                          SizedBox(
                            width: 0.9.sw,
                            child: UTextFormField(),
                          ),

                          SizedBox(height: 20.h),
                          SizedBox(
                            width: 0.9.sw,
                            child: UElevatedBUtton(
                              onPressed: () {},
                              child: Text(
                                'Get OTP',
                                style: TextStyle(color: Ucolors.light),
                              ),
                            ),
                          ),

                          SizedBox(height: 24.h),
                          Text(
                            'or login with',
                            style: TextStyle(
                              color: Ucolors.darkgrey,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 23.h),

                          USocialButton(),

                          SizedBox(height: 25.h),

                          GestureDetector(
                            onTap: () {},
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(fontSize: 14),
                                children: [
                                  TextSpan(
                                    text: 'Don’t have an account? ',
                                    style: TextStyle(color: Ucolors.dark),
                                  ),
                                  TextSpan(
                                    text: 'Create Account',
                                    style: TextStyle(
                                      color: Ucolors.blue,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 50.h),

                          RichText(
                            textAlign: TextAlign.center,

                            text: TextSpan(
                              style: TextStyle(fontSize: 14),
                              children: [
                                TextSpan(
                                  text: 'By "Login Account", you agree to the ',
                                  style: TextStyle(color: Ucolors.darkgrey),
                                ),
                                TextSpan(
                                  text: 'Terms of Use ',
                                  style: TextStyle(
                                    color: Ucolors.blue,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                TextSpan(
                                  text: 'and',
                                  style: TextStyle(color: Ucolors.darkgrey),
                                ),
                                TextSpan(
                                  text: ' Privacy Policy.',
                                  style: TextStyle(
                                    color: Ucolors.blue,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UTextFormField extends StatelessWidget {
  const UTextFormField({
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // enabled: F,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        labelText: 'Mobile Number',
        prefixIcon: Icon(Icons.phone_android),
      ),
    );
  }
}

class USocialButton extends StatelessWidget {
  const USocialButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //google button
        buildButton(UImages.google, () {}),
        // SizedBox(width: Usizes.spaceBtwItems),

        //apple button
        buildButton(UImages.apple, () {}),
      ],
    );
  }

  Container buildButton(String image, VoidCallback onPressed) {
    return Container(
      height: 52.h,
      width: 180.w,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xffE7E7E7)),
        borderRadius: BorderRadius.circular(14.w),
      ),
      child: IconButton(onPressed: onPressed, icon: Image.asset(image)),
    );
  }
}
