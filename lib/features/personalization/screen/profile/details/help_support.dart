import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/features/personalization/screen/profile/profile.dart';
import 'package:my_sip/core/utils/constant/colors.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarNormal(title: 'Help & Support'),
      body: Padding(
        padding: UPadding.screenPadding,
        child: Container(
          color: Ucolors.light,
          child: Column(
            children: [
              // SizedBox(height: kToolbarHeight - kTextTabBarHeight / 2),
              const Gap(10),

              // Listtilecustom(title: 'About Us', onTap: () {}),
              Listtilecustom(title: 'Contact Support', onTap: () {}),
              Listtilecustom(title: 'Privacy Policy', onTap: () {}),
              Listtilecustom(title: 'Terms & Conditions', onTap: () {}),
              Listtilecustom(title: 'FAQ', onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
