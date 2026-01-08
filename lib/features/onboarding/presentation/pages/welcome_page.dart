import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:my_sip/features/onboarding/presentation/widgets/imp_container.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';

class WelcomePageScreen extends StatelessWidget {
  const WelcomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final w = MediaQuery.of(context).size.width;
    // final h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: UPadding.screenPadding,
          child: Column(
            children: [
              //Top portion
              ImpContainer(),

              //welcome page content
              TitleContent1(),

              //Let’s Get Started Button
              // BottomPortion(),
              SizedBox(height: kBottomNavigationBarHeight),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            16 + MediaQuery.of(context).viewPadding.bottom,
          ),
          child: BottomPortion(),
        ),
      ),
    );
  }
}

class BottomPortion extends StatelessWidget {
  const BottomPortion({super.key});

  @override
  Widget build(BuildContext context) {
    return UElevatedBUtton(
      onPressed: () => Get.to(() => OnboardingPage()),
      // onPressed: () => Get.to(() => OnboardingScreen()),
      child: Center(
        child: Text(
          'Let’s Get Started',
          style: TextStyle(color: Ucolors.light),
        ),
      ),
    );
  }
}

class TitleContent1 extends StatelessWidget {
  TitleContent1({super.key});

  final List<String> text = [
    'Smart Goal Tracking',
    'Auto SIP Calculator',
    'Flexible Investment Control',
    'Real-Time Portfolio Insights',
    'Risk-Based Fund Suggestions',
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final s = MediaQuery.of(context).size;
    log('${Get.width} ${Get.height}');
    log('${s.width} ${s.height}');
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          5,
          (index) => Padding(
            padding: EdgeInsets.symmetric(vertical: w * 0.01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: w * 0.1),
                Icon(Icons.check_circle, color: Ucolors.success, size: 20),
                SizedBox(width: w * 0.03),
                Expanded(
                  child: Text(
                    softWrap: true,
                    text[index],
                    style: UTextStyles.subtitle1.copyWith(color: Ucolors.dark),
                  ),
                ),
                // Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TitleContent2 extends StatelessWidget {
  TitleContent2({super.key});

  final List<String> features = [
    'Smart Goal Tracking',
    'Auto SIP Calculator',
    'Flexible Investment Control',
    'Real-Time Portfolio Insights',
    'Risk-Based Fund Suggestions',
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Expanded(
      child: ListView(
        // physics: const NeverScrollableScrollPhysics(), // optional - if you don't want scrolling
        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
        children: features.map((text) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: width * 0.012),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // better for multi-line
              children: [
                Icon(Icons.check_circle, color: Ucolors.success, size: 22),
                SizedBox(width: width * 0.035),
                Expanded(
                  // ← This is the key!
                  child: Text(
                    text,
                    style: UTextStyles.subtitle1.copyWith(color: Ucolors.dark),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}


// Row(
//   mainAxisAlignment: MainAxisAlignment.start,
//   crossAxisAlignment: CrossAxisAlignment.start,
//   children: [
//     SizedBox(width: w * 0.06),
//     Icon(Icons.check_circle, color: Ucolors.success, size: 22),
//     SizedBox(width: w * 0.04),
//     Expanded(                               // ← Add this!
//       child: Text(
//         text[index],
//         style: UTextStyles.subtitle1.copyWith(color: Ucolors.dark),
//       ),
//     ),
//     // Remove Spacer() completely
//   ],
// )




// ListTile(
//   minLeadingWidth: 0,
//   horizontalTitleGap: 12,
//   leading: Icon(
//     Icons.check_circle,
//     color: Ucolors.success,
//     size: 22,
//   ),
//   title: Text(
//     text[index],
//     style: UTextStyles.subtitle1.copyWith(color: Ucolors.dark),
//   ),
//   dense: true,
//   visualDensity: VisualDensity.compact,
//   contentPadding: EdgeInsets.zero,
// )