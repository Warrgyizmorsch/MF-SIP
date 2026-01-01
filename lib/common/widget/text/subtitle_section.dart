import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/utils/constant/text_style.dart';

class SubtitleText extends StatelessWidget {
  const SubtitleText({
    super.key,
    required this.subtitle,
    this.textAlignCenter,
    this.textcolor,
    this.fontWeight,
    this.fontSize,
  });

  final String subtitle;

  final TextAlign? textAlignCenter;
  final Color? textcolor;
  final FontWeight? fontWeight;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      subtitle,
      style: UTextStyles.subtitle1.copyWith(
        color: textcolor ?? Colors.grey[600],
        fontWeight: fontWeight,
        fontSize: fontSize ?? (Get.width * 0.035).clamp(12, 14),
      ),
      textAlign: textAlignCenter ?? TextAlign.center,
    );
  }
}
