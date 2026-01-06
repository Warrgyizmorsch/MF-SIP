import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/core/utils/constant/images.dart';

class USocialButton extends StatelessWidget {
  const USocialButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _socialButton(UImages.google, () {})),
        SizedBox(width: 15),
        Expanded(child: _socialButton(UImages.apple, () {})),
      ],
    );
  }

  Widget _socialButton(String imagePath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: Get.height * 0.05,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffE7E7E7)),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(child: Image.asset(imagePath, height: 28)),
      ),
    );
  }
}
