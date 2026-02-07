import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/webview/webview.dart';
import 'package:my_sip/features/personalization/presentation/pages/profile.dart';
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
              Listtilecustom(
                title: 'Contact Support',
                // onTap: () {},
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HtmlWebViewPage(
                      title: 'Contact Us',
                      url:
                          'https://sip.londonstreetstore.com/contact-us?mobile=true',
                    ),
                  ),
                ),
              ),
              Listtilecustom(
                title: 'Privacy Policy',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HtmlWebViewPage(
                      title: 'Privacy Policy',
                      url:
                          'https://sip.londonstreetstore.com/privacy-policy?mobile=true',
                    ),
                  ),
                ),
              ),
              Listtilecustom(
                title: 'Terms & Conditions',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HtmlWebViewPage(
                      title: 'Terms & Conditions',
                      url:
                          'https://sip.londonstreetstore.com/terms-and-conditions?mobile=true',
                    ),
                  ),
                ),
              ),
              Listtilecustom(title: 'FAQ', onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
