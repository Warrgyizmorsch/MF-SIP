import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/core/utils/constant/colors.dart';

class TermAndPolicy extends StatelessWidget {
  const TermAndPolicy({super.key, this.term});

  final String? term;

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
              text: term ?? 'By continuing, you agree to our ',
              style: const TextStyle(fontSize: 13),
            ),
            TextSpan(
              text: 'Terms of Use',
              style: const TextStyle(
                color: Ucolors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const TextSpan(text: ' and ', style: TextStyle(fontSize: 13)),
            TextSpan(
              text: 'Privacy Policy.',
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
