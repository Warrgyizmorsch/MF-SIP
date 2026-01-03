import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/button/buttom_bar_two_button.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/common/widget/otp/otp_field.dart';
import 'package:my_sip/common/widget/text/heading_section.dart';
import 'package:my_sip/common/widget/text/small_heading.dart';
import 'package:my_sip/common/widget/text/subtitle_section.dart';
import 'package:my_sip/common/widget/top_bottom_style/top_bottom_style.dart';
import 'package:my_sip/navigation_menu_bar.dart';
import 'package:my_sip/utils/constant/colors.dart';
import 'package:my_sip/utils/constant/images.dart';
import 'package:my_sip/utils/constant/sizes.dart';
import 'package:my_sip/utils/constant/text_style.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final h = Get.height;
    // final w = Get.height;
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(),
      resizeToAvoidBottomInset: false,
      body: TopBottomDecoration(
        child: SafeArea(
          child: Padding(
            padding: UPadding.screenPadding,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: USizes.spcaeFromTop),

                ///Message logo
                Center(child: Image.asset(UImages.message)),

                const SizedBox(height: 15),

                //Heading
                const HeadingText(title: 'Verify Your Number'),
                const SizedBox(height: 10),

                //Subtitle
                const SubtitleText(
                  subtitle:
                      'To verify your account, enter the 6 digit OTP code that we sent to your number ***87.',
                ),

                const SizedBox(height: 25),

                SimpleOtpField(length: 6),
                const SizedBox(height: 15),

                //Timer
                Text(
                  '00:59',
                  style: UTextStyles.heading2.copyWith(color: Ucolors.blue),
                ),

                const SizedBox(height: 10),

                //small heading
                const SmallHeading(smallheading: 'Didnt get the email?'),

                const SizedBox(height: 15),

                UElevatedBUtton(
                  height: Get.height * 0.060,
                  outlined: true,
                  onPressed: () {},
                  child: Center(
                    child: Text(
                      'Resend Code',
                      style: UTextStyles.buttonText.copyWith(
                        color: Ucolors.dark,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                // SizedBox(height: Get.height * 0.2),
                Spacer(),

                // Verify button and back button
                PrimaryBackBottomBar(
                  // bottomPadding: kBottomNavigationBarHeight / 2,
                  primaryText: 'Verify',
                  onPrimaryPressed: () => Get.to(() => NavigationMenuBar()),
                  backText: 'Back',
                  onBackPressed: () => Get.back(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
