import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/core/utils/constant/images.dart';

import '../../../features/authentication/presentation/controllers/auth/auth_controller.dart';


class USocialButton extends StatelessWidget {

  const USocialButton({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find<AuthController>();
    return Row(
      children: [
        Expanded(
          child: Obx(() {
            return _socialButton(
              UImages.google,
              authController.isGoogleSignInLoading.value
                  ? null
                  : () async {
                await authController.signInWithGoogle();
              },
              isLoading: authController.isGoogleSignInLoading.value,
            );
          }),
        ),
        SizedBox(width: 15),
        Expanded(child: _socialButton(UImages.apple, () {})),
      ],
    );
  }

  Widget _socialButton(
      String imagePath,
      VoidCallback? onTap, {
        bool isLoading = false,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: Get.height * 0.05,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffE7E7E7)),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          )
              : Image.asset(
            imagePath,
            height: 28,
          ),
        ),
      ),
    );
  }
}
