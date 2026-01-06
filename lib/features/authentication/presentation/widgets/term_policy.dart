import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/core/utils/constant/colors.dart';

class TermAndPolicy extends StatelessWidget {
  const TermAndPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(fontSize: 14, color: Ucolors.darkgrey),
          children: [
            const TextSpan(text: 'By "Login Account", you agree to the '),
            TextSpan(
              text: 'Terms of Use',
              style: const TextStyle(
                color: Ucolors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const TextSpan(text: ' and '),
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
