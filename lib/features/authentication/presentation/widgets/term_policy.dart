import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/colors.dart';

class TermAndPolicy extends StatefulWidget {
  const TermAndPolicy({super.key, this.term});

  final String? term;

  static const String termsUrl =
      'https://sip.londonstreetstore.com/terms-and-conditions?mobile=true';
  static const String privacyUrl =
      'https://sip.londonstreetstore.com/privacy-policy?mobile=true';

  static void openTerms() {
    Get.toNamed(
      AppRoutes.webView,
      arguments: {'title': 'Terms of Use', 'url': termsUrl},
    );
  }

  static void openPrivacy() {
    Get.toNamed(
      AppRoutes.webView,
      arguments: {'title': 'Privacy Policy', 'url': privacyUrl},
    );
  }

  @override
  State<TermAndPolicy> createState() => _TermAndPolicyState();
}

class _TermAndPolicyState extends State<TermAndPolicy> {
  late final TapGestureRecognizer _termsRecognizer;
  late final TapGestureRecognizer _privacyRecognizer;

  @override
  void initState() {
    super.initState();
    _termsRecognizer = TapGestureRecognizer()..onTap = TermAndPolicy.openTerms;
    _privacyRecognizer = TapGestureRecognizer()
      ..onTap = TermAndPolicy.openPrivacy;
  }

  @override
  void dispose() {
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 800;
    return Padding(
      // padding: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 10.0 : Get.width * 0.1,
      ),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(fontSize: 14, color: Ucolors.darkgrey),
          children: [
            TextSpan(
              text: widget.term ?? 'By continuing, you agree to our ',
              style: const TextStyle(fontSize: 13),
            ),
            TextSpan(
              text: 'Terms of Use',
              recognizer: _termsRecognizer,
              style: const TextStyle(
                color: Ucolors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const TextSpan(text: ' and ', style: TextStyle(fontSize: 13)),
            TextSpan(
              text: 'Privacy Policy.',
              recognizer: _privacyRecognizer,
              style: const TextStyle(
                color: Ucolors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
